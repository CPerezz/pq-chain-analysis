---
id: gamma-satoris-executor-signer
title: "gamma.satoris.eth flash-loan arbitrage executors: a forged signature on a trade instruction can direct the executors, which hold about USD 1"
project: gamma-satoris
status: candidate
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0x00c21ca82d94dade0d5d1ed420a4728f58427d21"
  implementation: null
  name: unverified arbitrage executor (ECDSA in delegatecalled library 0x878978b5…)
  upgradeable: config-only
  admin: "getOwner() = EOA 0xef482680be137edba1f6fea4516d314282318819 (gamma.satoris.eth): setOwner, whitelist/blacklist, setFee, sweep; read at block 26,431,454"
  value_usd: 1
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-07-06
  txs_30d: 0
- address: "0x2d53a516ead19f9ff340bf30428a5a7abac7fa49"
  implementation: null
  name: unverified arbitrage executor
  upgradeable: config-only
  admin: "getOwner() = EOA 0xef482680be137edba1f6fea4516d314282318819 (gamma.satoris.eth); read at block 26,431,454"
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-04
  txs_30d: 341
- address: "0x32d96667be9986bea89dcef0aab29b3d1959f5a5"
  implementation: null
  name: unverified arbitrage executor
  upgradeable: config-only
  admin: "getOwner() = EOA 0xef482680be137edba1f6fea4516d314282318819 (gamma.satoris.eth); read at block 26,431,454"
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2025-10-07
  txs_30d: 0
families: []
fix:
  layer: new-deployment
  who_acts: "operator EOA 0xef482680be137edba1f6fea4516d314282318819 (gamma.satoris.eth): stop using these executors or redeploy with a post-quantum or msg.sender check"
  protocol_change: not-needed
evidence:
  level: bytecode
  links:
  - evidence/gamma-satoris-executor-signer/classification.jsonl
  - evidence/gamma-satoris-executor-signer/onchain.json
  - evidence/gamma-satoris-executor-signer/activity.json
  - evidence/gamma-satoris-executor-signer/source-excerpts.md
  - evidence/gamma-satoris-executor-signer/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_0.jsonl,out_2.jsonl,out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review08 (bytecode selectors, sampled trace, on-chain reads)
  ref: evidence/gamma-satoris-executor-signer/notes.md
  date: 2026-11-17
  verdict: reported
  rating: LOW
related: []
---

## Summary

Three unverified flash-loan arbitrage executors, all deployed and owned by the EOA `gamma.satoris.eth`, take trade
instructions that carry a signature and run them inside a Morpho flash loan. In `0x00c21ca8…` the ECDSA recovery
sits in a library it delegatecalls (PQ-4, from bytecode); the other two were seen calling `ecrecover` in the trace. A
quantum attacker who recovers the signing key could direct the
executors' trades, but they hold about USD 1 in total and nobody is known to approve tokens to them, so almost
nothing can be taken. Rated LOW (step 5): a fix needs a new deployment by one operator (MEDIUM at step 4), and less
than USD 50k is held.

## Mechanism

- Entry points such as `0xc8512104(address,(bytes,uint256,address,address,uint256,uint256)[],uint256,uint256,uint256,bytes,uint256,uint256,uint256)`
  start a Morpho flash loan. The callback runs in the delegatecalled library `0x878978b5…`
  (`onMorphoFlashLoan`, `0x677e86e2((address,uint256,address,bytes,uint256,uint256,bytes),bool)`), which contains
  OpenZeppelin `ECDSA` (the secp256k1 `n/2` constant). INFERRED: the struct's trailing `bytes` is a signature,
  checked against a per-address nonce (`getNonce(address)`).
- Profit goes to the owner; loans are repaid in the same transaction. The owner EOA can `sweep` and `transferToken`.
- Who must sign (the owner, or whitelisted bot addresses) is not established from bytecode, so the trigger
  `operator-key` is INFERRED.

Pattern PQ-4. No verified source exists ([`source-excerpts.md`](../evidence/gamma-satoris-executor-signer/source-excerpts.md)).

## Evidence

- CHECKED (Blockscout): all three contracts and the library were created by `0xef482680…` (ENS `gamma.satoris.eth`,
  an EOA) ([`notes.md`](../evidence/gamma-satoris-executor-signer/notes.md)).
- CHECKED (`cast`, block 26,431,454): `getOwner()` is `0xef482680…` on all three; none is a proxy.
- CHECKED (Blockscout, sampled transaction `0x6cada0da…`, 2026-06-21): flash loan of 31,089 USDC, USDC/USDT trade,
  repayment, and USD 0.23 to the owner. Internal calls show the delegatecall into `0x878978b5…`.
- CHECKED (bytecode): the `n/2` constant is present in `0x878978b5…` and absent from the three executors.
- CHECKED (precompile trace, year to March 2026, `curated_contracts.csv`): 23,414 / 9,134 / 4,139 transactions with
  `ecrecover` attributed to the three executors. Their summed transfers of USD 8.0B / 1.2B / 0.45B are flash-loan
  flow, not holdings.
- CHECKED (on-chain read, block 26,431,214, and Blockscout tokens): holdings are HEX worth about USD 0.88, then about
  0 and 0.
- CHECKED (Xatu, 2026-10-16 to 2026-11-16): 341 transactions touched `0x2d53a516…`. In the samples these are
  staticcalls from the newer executor `0xcb0151ac…`; the other two had none.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x00c21ca8…` executor | config-only | $1 | 2026-07-06 | 0 |
| `0x2d53a516…` executor | config-only | $0 | 2026-11-04 | 341 |
| `0x32d96667…` executor | config-only | $0 | 2025-10-07 | 0 |

Held value is the exposure: nothing stays in the executors between transactions, and the flash-loaned funds must be
repaid within the transaction. Sibling not in the census: the active executor `0xcb0151ac…` (same owner, same design,
its library `0x765b6826…` also contains `ECDSA`) holds about USD 0. It belongs in this finding if the census adds it.

## Remediation

- Operator `0xef482680…`: retire these executors, or redeploy with authorisation by `msg.sender` from a post-quantum
  account or by a post-quantum signature. The owner key is itself an ECDSA EOA and should move too.
- No protocol change is needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review08): MEDIUM -> LOW, step 5: the executors hold about USD 1 in total (measured), below USD 50k; owner of all three read as EOA 0xef482680… (gamma.satoris.eth); 0x2d53a516… is config-only, not immutable; ECDSA located in delegatecalled library 0x878978b5….
