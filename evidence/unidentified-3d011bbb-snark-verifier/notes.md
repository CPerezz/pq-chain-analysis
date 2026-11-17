# Review notes: unidentified-3d011bbb-snark-verifier (Review02, 2026-11-17)

`data/agg/y1_tx_caller.parquet` rows for caller `0x3d011bbbceef340d8c9c0f44ef7b84a06da1fc9c` (11 transactions, blocks
24,128,228–24,160,772): sha256 ×5, ecmul ×4, ecadd ×1, ripemd160 ×1; no ecpairing.

Transactions read with `cast tx` / `cast receipt` (publicnode, 2026-11-17):

| Tx | From | To | Value (wei) | Calldata | Gas used |
|---|---|---|---|---|---|
| `0x3aab5b53…` | `0x3d011bbb…` | `0x…07` (ecmul) | 1e15 | empty | 27,000 |
| `0x0bf12083…` | `0x3d011bbb…` | `0x…06` (ecadd) | 3e14 | empty | 21,150 |
| `0x29397360…` | `0x3d011bbb…` | `0x…02` (sha256) | 1e15 | empty | 21,060 |
| `0xe0a08f7c…` | `0x3d011bbb…` | `0x…03` (ripemd160) | 3e14 | empty | 21,600 |

The other rows have the same gas pattern (21,060 for sha256, 27,000 for ecmul): top-level ETH transfers from the EOA
to precompile addresses with empty input. The trace attributes the precompile execution to the sender because the
precompile was the transaction's `to`.

State at the latest block on 2026-11-17: no code, nonce 9000, balance 2.7992 ETH.
