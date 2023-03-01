#!/bin/bash
export SOLANA_METRICS_CONFIG="host=https://metrics.solana.com:8086,db=mainnet-beta,u=mainnet-beta_write,p=password"
{% if use_jito_solana %}
BLOCK_ENGINE_URL= { jito_block_engine_url }
RELAYER_URL= {jito_relayer_url }
SHRED_RECEIVER_ADDR={ jito_shred_receiver_url}
exec /mnt/solana/target/release/jito-solana-validator \
--tip-payment-program-pubkey T1pyyaTNZsKv2WcRAB8oVnk93mLJw2XzjtVYqCsaHqt \
--tip-distribution-program-pubkey 4R3gSG8BpU4t19KYj8CfnbtRpnT8gtk4dvTHxVRwc2r7 \
--merkle-root-upload-authority GZctHpWXmsZC1YHACTGGcHhYxjdRqQvTpYkb9LMvxDib \
--commission-bps 800 \
--relayer-url ${RELAYER_URL}:8100 \
--block-engine-url ${BLOCK_ENGINE_URL} \
--shred-receiver-address ${SHRED_RECEIVER_ADDR}
{% else %}
exec /mnt/solana/target/release/solana-validator \
{% fi %}
--identity /home/solana/rpc_node.json \
--entrypoint entrypoint.mainnet-beta.solana.com:8001 \
--entrypoint entrypoint2.mainnet-beta.solana.com:8001 \
--entrypoint entrypoint3.mainnet-beta.solana.com:8001 \
--entrypoint entrypoint4.mainnet-beta.solana.com:8001 \
--entrypoint entrypoint5.mainnet-beta.solana.com:8001 \
--rpc-port 8899 \
--dynamic-port-range 8002-8099 \
--no-port-check \
--gossip-port 8001 \
--no-untrusted-rpc \
--no-voting \
--private-rpc \
--rpc-bind-address 0.0.0.0 \
--enable-cpi-and-log-storage \
--account-index program-id \
--enable-rpc-transaction-history \
--no-duplicate-instance-check \
--wal-recovery-mode skip_any_corrupted_record \
--log /mnt/logs/solana-validator.log \
--accounts /mnt/solana-accounts \
--ledger /mnt/solana-ledger \
--snapshots /mnt/solana-snapshots \
--no-snapshot-fetch \
--limit-ledger-size 400000000 \
--rpc-send-default-max-retries 3 \
--rpc-send-service-max-retries 3 \
--rpc-send-retry-ms 2000 \
--full-rpc-api \
--accounts-index-memory-limit-mb 350 \
--account-index-exclude-key kinXdEcpDQeHPEuQnqmUgtYykqKGVFq6CeVX5iAHJq6 \
--tpu-use-quic \
--known-validator PUmpKiNnSVAZ3w4KaFX6jKSjXUNHFShGkXbERo54xjb \
--known-validator Ninja1spj6n9t5hVYgF3PdnYz2PLnkt7rvaw3firmjs \
--known-validator CXPeim1wQMkcTvEHx9QdhgKREYYJD8bnaCCqPRwJ1to1 \
--known-validator A4hyMd3FyvUJSRafDUSwtLLaQcxRP4r1BRC9w2AJ1to2 \
--known-validator 23U4mgK9DMCxsv2StC4y2qAptP25Xv5b2cybKCeJ1to3 \
--known-validator Ei8VLKR3chZAhJzWwj8PopeuedpQiths2ovVCQ2BCvK7 \
--known-validator DiGifdKABxzru2KsjN3YkZZmWP9mVMYK8HWadjtPtJit
