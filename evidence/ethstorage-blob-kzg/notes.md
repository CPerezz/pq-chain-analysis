# Reads (Review15, 2026-11-17)

Proxy `0xf0193d6e8fc186e77b6e63af4151db07524f6a7a`; admin reads are in
`evidence/ethstorage-mining-groth16/onchain-review.md` (block 26,431,543): ProxyAdmin
`0x654dd56444856e928917549263aac6f9d6a96372`, owner Safe `0xa10d87502a0d8fce45610c6028f0756383649f3c` (1 of 2,
both owners EOAs), Safe holds `DEFAULT_ADMIN_ROLE`.

## RPC (eth.drpc.org, block 26,431,725)

| Read | Result |
|---|---|
| EIP-1967 implementation | `0x99f5cc6ad111584c88891b4c6fff5784a46adf33` |
| ETH balance | 0.177249 ETH (USD 321 at USD 1,811.62, the `onchain.json` price) |
| `kvEntryCount()` | 3,338 |
| `shardEntryBits()` (block ~26,431,608) | 22 |
| `randomChecks()` / `sampleLenBits()` | 2 / 12 |
| `enforceMinerRole()` | true |

## Source (Sourcify, implementation above)

- Data enters only through `putBlob` / `putBlobs` (`EthStorageContract.sol` 175–215), which store
  `blobhash(i)` (the EIP-4844 versioned hash of a KZG commitment) as the entry's `hash`. There is no calldata put
  path in the implementation.
- `checkInclusive` (132–156): for an entry with `hash != 0`, calls `_pointEvaluation` (108–124, `STATICCALL` to
  `0x0a`) and accepts the sample if the opened value equals `mask ^ encodedSample`; for `hash == 0` it requires the
  decoded value to be 0 and calls no precompile.
- Called from `EthStorageContractM2._checkSample` (76–95) inside `verifySamples`, from `mine` (whitelisted miners
  only), which pays `minerReward` from the contract balance.

## Precompile trace (`data/agg/alltime_caller.parquet`)

Caller `0xf0193d6e…`, all time: `ecmul` 1,560, `ecadd` 1,560, `modexp` 520, `ecpairing` 260 (blocks
23,335,287–24,683,694). No `pointEval` row: every sample so far fell on an empty entry.
