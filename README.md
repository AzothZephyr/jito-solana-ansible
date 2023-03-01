# jito-solana

### What is it good for?

The goal of the jito-solana ansible playbook is to stand up a jito-solana validator for Solana blockchain. It formats/raids/mounts disks, sets up swap, ramdisk (optional), downloads from snapshot and restarts the software leaving you with a running validator deployed with used ansible for automation and auditability of server configuratoin. 


---

##  Server Selection:
At the time of writing, the below specs are sufficient for each given role. We're using Latitude.sh

 - the initial state of the machine is cleaner than others that we have tried
  - disks are named consistently (nvme01, nvme0n2)
  - ubuntu installed (preferably ubuntu 20.04, 22.04) - this won't work with centos, etc. since they don't use aptitude by default
  - the login user being ubuntu helps (all the solana operations are done using the solana user that the ansible playbook creates)
  - ubuntu is in the sudoer's list
  - unmounted disks are clean - if your root is on one of partitions and you pass it as an argument, this could be disastrous

### Validator (c3.large.x86):
For a jito-solana validator, it is currently built specifically for a Latitude.sh a c3.large.x86 machine.

Server specs:
- CPU: AMD EPYC 7443P @ 2.85GHz (24 cores)
- RAM: 256 GB
- Disk: 2 X 2 TB NVMe
- NICs: 10 Gbit/s + 1 Gbit/s

-- 
### RPC node (s3.large.x86):
For an RPC, it's built specifically for a Latitude.sh s3.large.x86 machine.

--

### RPC node with full indexing (m3.large.x86):

For an RPC with full indexing, it's built specifically for a Latitude.sh m3.large.x86 machine. 


--- 

## Deploying jito-solana with this ansible playbook:
After creation of the machine in the Latitude UI, you can deploy the jito-solana validator software as so.


### Step 1: Deploy and SSH into your machine

### Step 2: Start a screen session

```
screen -S sol
```

### Step 3: Install ansible

```
sudo apt-get update && sudo apt-get install ansible -y
```

### Step 4: Clone the jito-solana-ansible repository

```
git clone https://github.com/AzothZephyr/jito-solana-ansible.git
```

### Step 5: cd into the jito-solana-ansible folder

```
cd jito-solana-ansible
```


#### ~ Parameters explained ~
at this point, you've got your ansible playbook on the server you are deploying to. below is a description of the ansible parameters that can be modified for your specific set up, they are found in `defaults/main.yml`.

```
# defaults file for Solana RPC
# solana_version: version of solana that we want to run. Check the Solana Tech discord’s mb-announcements channel for the recommended version.
solana_version: "v1.13.5"

# jito-solana values, 
use_jito_solana: true
jito_solana_version: "v1.13.6-jito"

# jito-solana requires 3 environmental variables
jito_block_engine_url: 
jito_relayer_url:
jito_shred_receiver_url:

# shared values between solana and jito-solana
# --
# raw_disk_list: the list of currently unmounted disks that will be used by the validator software
raw_disk_list: ["/dev/nvme1n1", "/dev/nvme2n1"]

# sets up the disks by wiping, raiding, formatting with ext4, and mounting to /mnt
setup_disks: "true"
# toggles whether snapshots or downloaded or not
download_snapshot: "true"


# ramdisk_size: this is optional and only necessary if you want to use ramdisk for the validator - carves out a large portion of the RAM to store the accountsdb. On a 512 GB RAM instance, this can be set to 300 GB (variable value is in GB so 300)
ramdisk_size: 300

# megabytes of swap. This can be set this to 50% of RAM or even lower. 100 GB is fine on a 512 GB RAM machine (variable value is in MB so 100000)
swap_mb: "100000"

# UFW
enable_ufw: true
allowed_networks: # networks and ips allowed by UFW to access RPC for private methods such as get program accounts on 8899 and 8900, does not impact validator to validator communication.
  - 89.147.111.25
```



### Step 6: Run the ansible command

- this command can take between 10-20 minutes based on the specs of the machine
- it takes long because it does everything necessary to start the validator (format disks, checkout the solana repo and build it, download the latest snapshot, etc.)
- make sure that the solana_version is up to date (see below)
- check the values set in `defaults/main.yml` and update to the values you want

```
time ansible-playbook runner.yaml
```


### Step 7: Once ansible finishes, switch to the solana user with:

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

If you see the message above, then everything is working fine! Gratz. You have a new RPC server and you can visit the URL at http://xx.xx.xx.xx:8899/



## TODO:
- adapt deployment steps and documentation away from using the server we're deploying to as a client, and follow a model where you deploy keys to a remote server and use a hosts file to execute the playbook 