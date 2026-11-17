# Reads for the fb3ca570 merge (Review16, 2026-11-17)

## On-chain (block 26,431,723, publicnode)

| Read | Result |
|---|---|
| live wrapper `0x059daf31…` `riscoGroth16Verifier()` | `0x8eab2d97dfce405a1692a21b3ff3a172d593d319` (RiscZeroVerifierRouter) |
| Pacaya wrapper proxy `0x73ee496d…` `riscoGroth16Verifier()` | `0x7cca385bdc790c25924333f5adb7f4967f5d1599` |
| `0x73ee496d…` EIP-1967 implementation | `0xdf6327caafc5feb8910777ac811e0b1d27dcdf36` |
| `0x7cca385b…` `VERSION()` / `SELECTOR()` | `3.0.0` / `0x73c457ba` |
| router `getVerifier(0x73c457ba)` | `0x9f9994eb4cb5200198fefb470f8b50301662e696` (emergency-stop wrapper; not `0x7cca385b…`) |
| `0x7cca385b…` ETH balance | 0 |

Blockscout: `0x7cca385b…` created by `0xcdcebd75…` in tx `0x7aa251b9…` (block 23,472,891).

## Precompile corpus (`data/agg/y1_tx_caller.parquet`, to block 24,683,719)

| Caller | rows | first block | last block |
|---|---|---|---|
| `0x7cca385b…` | 1 (`sha256`, its creation tx) | 23,472,891 | 23,472,891 |
| `0x73ee496d…` (Pacaya Risc0Verifier) | 2,965 | 22,530,964 | 23,483,499 |
| `0xfb3ca570…` | 3,741 | 22,679,611 | 22,986,441 |

## Xatu `canonical_execution_traces` (remote box)

Call frames with `action_to` in {`0x7cca385b…`, `0x73ee496d…`, `0xfb3ca570…`}, partitions 24,683–26,423
(blocks 24,683,000–26,423,999; 26,424+ not yet published): none.
