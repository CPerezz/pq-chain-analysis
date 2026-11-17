# Review reads (Review15, 2026-11-17)

## Who called it

`data/agg/y1_tx_caller.parquet`: 936 distinct transactions with pre-quantum calls from `0xfb3ca570…`, blocks
22,679,611–22,986,441. Pre-quantum callers in those transactions: `0xfb3ca570…` (3,741 rows),
`0x73ee496da20e5c65340c040b0d8c3c891c1f74ae` (935), `0x7e6409e9b6c5e2064064a6cc994f9a2e95680782` (935).

Last transaction `0x1135dd3c77cdbd2f8b6a4a00f5e3038f1919be8255e9d0336b34e16d305210d7` (block 22,986,441):
`proveBatches(bytes,bytes)` from `0xa5cb34b7…` to `0x68d30f47f19c07bccef4ac7fae2dc12fca3e0dc9` (`ERC1967Proxy` ->
`ProverSet` `0xb8826b14…`). Blockscout internal calls: ProverSet -> inbox `0x06a9ab27c7e2255df1815e6cc0168d7755feb19a`
-> `0xb16931e7…` -> `0x73ee496d…` (delegate `0xb1c6ff8d…`) -> `staticcall 0xfb3ca570…`; then `0x7e6409e9…`.

ProverSet reads (eth.drpc.org): `inbox()` = `0x06a9ab27…`, `owner()` = `0x0f026a3e…`, `bondToken()` =
`0x10dea674…` (TAIKO).

## Current state (block 26,431,705)

| Read | Result |
|---|---|
| `0x73ee496d…` EIP-1967 implementation | `0xdf6327caafc5feb8910777ac811e0b1d27dcdf36` (Blockscout/Sourcify: `Risc0Verifier`, `address public immutable riscoGroth16Verifier`) |
| `0x73ee496d…` `riscoGroth16Verifier()` | `0x7cca385bdc790c25924333f5adb7f4967f5d1599` (Blockscout: `RiscZeroGroth16Verifier`, creator `0xcdcebd75…`) |
| `0x73ee496d…` `owner()` | `0x75ba76403b13b26ad1bec70d6ee937314eeacd0a` |
| implementation runtime code contains `fb3ca570…` | no |
