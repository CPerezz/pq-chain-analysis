# Review reads (Review15, 2026-11-17)

RPC eth.drpc.org / publicnode, block ~26,431,608.

| Read | Result |
|---|---|
| `0x82eace5d…` runtime size | 1,694 bytes; PUSH4 selectors `0x1626ba7e` isValidSignature(bytes32,bytes), `0x521e47b9` getVerifyingSigner(), `0x21175b4a` setMode(uint8), `0x4b4fd03b` getMode(), `0x295a5212` mode(), `0x8da5cb5b` owner(), `0xf2fde38b`, `0x715018a6`, two unresolved (`0x05b1737e`, `0x441f7f5f`) |
| `owner()` | `0x0000000000000000000000000000000000000000` |
| `getVerifyingSigner()` | `0x5e028b8ce6397e8a81f94d80931ee02a8a854cdd` (code size 0, nonce 0) |
| `getMode()` | 0 |
| Blockscout creator | `0x4e59b44847b379578588920ca78fbf26c0b4956c` (CREATE2 deployer), tx `0x38d84e16e6ff3b4f3e74194106e088789b0c73ec79655bb2b59b5db89403fc53`, sent by `0xac6a87c681a5ed4cb58bc4fa7bf81a83b928c83c`, block 20,718,955 (2024-09-10) |
| Module `0xba418fa699622de824b258c61eb150ed7a13967b` `NAME()` / `VERSION()` | "Multichain PassKeys Ownership Registry Module" / "0.2.0" |
| Module runtime code | contains `7f00000000000000000000000082eace5d23ef8fc5e825a05e8eacd908289ee4dc` (immutable) |
| Module `getOwner(0x92def945bb59b524953fd01375ee896bbd5a2b81)` | `0x7c200643bdd88701a2142bf423af1e070fb95224` |

EntryPoint v0.6 tx `0x6535749db982ac198ba450f763d3805d65bc9522e84ee539fccc2b712f3d4755`: `handleOps` from bundler
`0x7f0fa0ba…`, sender `0x92def945…` (Biconomy `Proxy`), paymaster `0xf7bb387e…`; signature = `abi.encode(module
0xba418fa6…, moduleSig)` whose payload holds two 65-byte ECDSA signatures and a validity window. `data/agg/y1_tx_caller`
shows `ecrecover` calls from `0x82eace5d…` and `0xba418fa6…` in this transaction.
