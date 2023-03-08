# jito-solana

### What is it good for?

The goal of this ansible playbook is to stand up a jito-solana validator for Solana blockchain. It formats/raids/mounts disks, sets up swap, ramdisk (optional), downloads from snapshot and restarts the software leaving you with a running validator deployed with ansible used for automation and auditability of server configuration. 


---

##  Server Selection:
We're using [Latitude.sh](https://latitude.sh) as an infrastructure provider for the following reasons:
  - the initial state of the machine is cleaner than others that we have tried
  - disks are named consistently (nvme01, nvme0n2)
  - ubuntu installed (preferably ubuntu 20.04, 22.04) - this won't work with centos, etc. since they don't use aptitude by default
  - the login user being ubuntu helps (all the solana operations are done using the solana user that the ansible playbook creates)
  - ubuntu is in the sudoer's list
  - unmounted disks are clean - if your root is on one of partitions and you pass it as an argument, this could be disastrous

The box we're deploying to at [Latitude.sh](https://latitude.sh) is s3.large.x86. The specs for this box are below if you choose to use a different provider.
```
CPU:  AMD EPYC 7413 @ 2.65GHz (24 cores)
RAM: 512 GB
Disk: 2 X 4 TB NVMe + 256 GB NVMe
NICs: 4 X 10 Gbit/s + 1 Gbit/s
```

--- 

## Deploying jito-solana with this ansible playbook:
After creation of the machine in the Latitude UI, you can deploy the jito-solana validator software as so.


### Step 1: Install ansible

```
sudo apt-get update && sudo apt-get install ansible -y
```

### Step 2: Clone the jito-solana-ansible repository

```
git clone https://github.com/AzothZephyr/jito-solana-ansible.git
```

### Step 3: cd into the jito-solana-ansible folder

```
cd jito-solana-ansible
```

### Step 4: configure ansible inventory, manage solana keys, and configuration parameters

#### ansible inventory
the ansible inventory is used to define the remote servers were deploying to. there are two groups: mainnet and testnet. place the ip address of your box in this file under the respective groups.

```
vim inventory/hosts.yaml
```

#### validator identity keys
identity keys for the deployed validator are stored in files/keys/mainnet.json and files/keys/testnet.json. it is recommended to generate them locally and store them for safe keeping in case you need to roll out another validator.

```
  // solana keygen output here
```

#### ~ Parameters explained ~
the parameters passed to ansible are defined in defaults/main.yml and documented in defaults/README.md


### Step 6: Run the ansible command

- this command can take between 10-20 minutes based on the specs of the machine
- it takes long because it does everything necessary to start the validator (format disks, checkout the solana repo and build it, download the latest snapshot, etc.)
- make sure that the solana_version is up to date (see below)
- check the values set in `defaults/main.yml` and update to the values you want

```
time ansible-playbook runner.yaml
```


### Step 7: Once ansible finishes, switch to the solana user:

```
sudo su - solana
```

### Step 8: Check the status

```
source ~/.profile
solana-validator --ledger /mnt/solana-ledger monitor
ledger monitor
Ledger location: /mnt/solana-ledger
⠉ Validator startup: SearchingForRpcService...
```

#### Initially the monitor should just show the below message which will last for a few minutes and is normal:

```
⠉ Validator startup: SearchingForRpcService...
```

#### After a while, the message at the terminal should change to something similar to this:

```
⠐ 00:08:26 | Processed Slot: 156831951 | Confirmed Slot: 156831951 | Finalized Slot: 156831917 | Full Snapshot Slot: 156813730 |
```

#### Check whether the RPC is caught up with the rest of the cluster with:

```
solana catchup --our-localhost
```