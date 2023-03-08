# Parameters explained
The below comments are intended to explain the parameters defined in main.yml

```
---
# defaults file for Solana validator

# list of disks raided and mounted to store the ledger
raw_disk_list: ["/dev/nvme1n1", "/dev/nvme2n1"]
setup_disks: "true"
download_snapshot: "true"
# size of ramdisk for accounts in GB
ramdisk_size: 128
swap_mb: "100000"

# version of jito-solana to install
# you can find the latest version here: https://github.com/jito-foundation/jito-solana/releases
jito_solana_version: "v1.13.6-jito"

# environmental variables required by jito-solana
# these should be configured according to where you've deployed your server, and a list of available infra can be found here:
# https://jito-labs.gitbook.io/mev/searcher-resources/block-engine/mainnet-addresses
jito_block_engine_url: https://ny.mainnet.block-engine.jito.wtf
jito_relayer_url: http://ny.mainnet.relayer.jito.wtf:8100
jito_shred_receiver_url: 141.98.216.96:1002

# enables rpc listening on 0.0.0.0
enable_rpc: false

# UFW is configured to avoid opening rpc access to unauthorized users.
enable_ufw: false
# this list may contain networks, or individual ip addresses
ufw_access_list:
  - 192.168.0.0/24
  - 192.168.1.69
```