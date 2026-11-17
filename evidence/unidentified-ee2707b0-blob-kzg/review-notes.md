# Review reads: unidentified-ee2707b0-blob-kzg (2026-11-17, Review17)

No verified source on Sourcify or Blockscout for any of the three contracts or their verifiers.

Bytecode (latest block, 2026-11-17, publicnode):

- `0xf49c2c07…` and `0xee2707b0…` have identical runtime code (md5 28045a02…); `0x6666db78…` differs (older build).
- Selectors resolved with the openchain signature database: `postBatch((uint64,uint32,uint64,uint64,uint32,bytes32,
  bytes32,uint256,bytes),(uint64,uint64,uint32,uint64,uint64,uint32,bytes32,bytes32,uint256,bytes32))`,
  `proveBatch(…,bytes)`, `settleBatch(…,bytes)`, `revokeBatches`, `exitWithProof(uint32,uint8,uint64,bytes)`,
  `triggerForceExit()`, `forceExitMode()`, `canForceExit()`, `freeze()`, `unfreeze()`, `frozen()`,
  `deposit(address)`, `depositToken(address,…)`, `reclaimDeposits`, `claimWithdrawal(uint8,…)`,
  `swapVerifier(address)`, `swapExitVerifier(address)`, `batchVerifier()`, `exitVerifier()`,
  `transferOperator(address)`, `operator()`, `setRateLimit(uint256)`, `addCurrency`, `modifyCurrency`, `merkleRoot()`.

State reads (latest block):

| Contract | operator | batchVerifier | exitVerifier | nPosted | nProven | nSettled | totalDeposits | frozen / forceExitMode | lastPostTime |
|---|---|---|---|---|---|---|---|---|---|
| `0xf49c2c07…` | `0xd5c648ba…` | `0x599c0891…` | `0x599c0891…` | 1 | 0 | 0 | 1 | false / false | 1772700239 (2026-03-05) |
| `0x6666db78…` | `0xd5c648ba…` | `0xe4bdeb4a…` | `0xbb7ebc1b…` | 1 | 0 | 0 | 1 | false / false | 1772593379 (2026-03-04) |
| `0xee2707b0…` | `0xd5c648ba…` | `0x599c0891…` | `0x599c0891…` | 1 | 0 | 0 | 1 | false / false | 1772698163 (2026-03-05) |

- `eth_call postBatch(…)` from `0x…dead` reverts `Unauthorized`; from the operator it reverts `BatchChainBroken`
  (passes the caller check): only the operator posts batches and their blob commitments.
- Verifiers `0x599c0891…` and `0xe4bdeb4a…` (unverified): one external selector `Verify(bytes,uint256[])` and the
  BN254 scalar and base field moduli in bytecode: a pairing-based SNARK verifier (PQ-7), a separate mechanism.
- Operator `0xd5c648ba92b758220333f8cb5438f408efa86638`: code `0xef0100868f2d39…` (EIP-7702 delegation to
  `0x868f2d39449bdc83c9aa92620b182a8affc049f1`, unverified), nonce 267. Blockscout: creator of all three contracts;
  last own transactions in April 2026 (a `bridge` call to MetaBridge `0x0439e60f…`); no name, tag or ENS.
- Holdings (onchain.json, block 26,431,214): USDT ~$1 per contract.
- `data/report/curated_contracts.csv`: one point-evaluation (`kzg`) transaction per contract.
