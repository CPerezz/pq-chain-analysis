---
id: gamma-satoris-executor-signer
title: "gamma.satoris.eth flash-loan arbitrage executors: a forged signature on a trade instruction can direct the executors, which hold about USD 1"
project: gamma-satoris
status: confirmed
severity: MEDIUM
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
  txs_90d: 0
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
  txs_90d: 11201
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
  txs_90d: 0
families: []
fix:
  layer: new-deployment
  who_acts: "operator EOA 0xef482680be137edba1f6fea4516d314282318819 (gamma.satoris.eth): stop using these executors or redeploy with a post-quantum or msg.sender check"
  protocol_change: not-needed
evidence:
  level: bytecode
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/gamma-satoris-executor-signer
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_0.jsonl,out_2.jsonl,out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review08 (bytecode selectors, sampled trace, on-chain reads)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/gamma-satoris-executor-signer/notes.md
  date: 2026-11-17
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "Step 4 MEDIUM: the signature scheme sits in code that nobody can change; removing it needs a new deployment by the one operator. Value is ~$1 (HEX, not re-read), and value does not change the rating. Who signs (owner or a whitelisted bot) is still unestablished; I did not decompile the library 0x878978b5 (full address not given in the finding)."
related: []
---

## Summary

Three unverified flash-loan arbitrage executors, all deployed and owned by the EOA `gamma.satoris.eth`, take trade
instructions that carry a signature and run them inside a Morpho flash loan. In `0x00c21ca8…` the ECDSA recovery
sits in a library it delegatecalls (PQ-4, from bytecode); the other two were seen calling `ecrecover` in the trace. A
quantum attacker who recovers the signing key could direct the
executors' trades, but they hold about USD 1 in total and nobody is known to approve tokens to them, so almost
nothing can be taken. Rated MEDIUM (step 4): the fix needs a new deployment by one operator.

## Mechanism

- Entry points such as `0xc8512104(address,(bytes,uint256,address,address,uint256,uint256)[],uint256,uint256,uint256,bytes,uint256,uint256,uint256)`
  start a Morpho flash loan. The callback runs in the delegatecalled library `0x878978b5…`
  (`onMorphoFlashLoan`, `0x677e86e2((address,uint256,address,bytes,uint256,uint256,bytes),bool)`), which contains
  OpenZeppelin `ECDSA` (the secp256k1 `n/2` constant). INFERRED: the struct's trailing `bytes` is a signature,
  checked against a per-address nonce (`getNonce(address)`).
- Profit goes to the owner; loans are repaid in the same transaction. The owner EOA can `sweep` and `transferToken`.
- Who must sign (the owner, or whitelisted bot addresses) is not established from bytecode, so the trigger
  `operator-key` is INFERRED.

Pattern PQ-4. No verified source exists ([`source-excerpts.md`](#source-excerpts-gamma-satoris-executor-signer)).

## Evidence

- CHECKED (Blockscout): all three contracts and the library were created by `0xef482680…` (ENS `gamma.satoris.eth`,
  an EOA) ([`notes.md`](#review-notes-review08-2026-11-17)).
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

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review08): MEDIUM -> LOW, step 5: the executors hold about USD 1 in total (measured), below USD 50k; owner of all three read as EOA 0xef482680… (gamma.satoris.eth); 0x2d53a516… is config-only, not immutable; ECDSA located in delegatecalled library 0x878978b5….
- 2026-11-19: LOW -> MEDIUM, step 5 removed (value no longer lowers a rating); step 4 gives MEDIUM.
- 2026-11-20: moved to triage with the rest of the pool and reviewed (D-025); state re-read at block 26,438,999; filed confirmed, MEDIUM; fixed the stale LOW/step-5 wording in the Summary.

# Source excerpts: gamma-satoris-executor-signer

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x00c21ca82d94dade0d5d1ed420a4728f58427d21`

No verified source on Sourcify or Blockscout.


## Contract `0x2d53a516ead19f9ff340bf30428a5a7abac7fa49`

No verified source on Sourcify or Blockscout.


## Contract `0x32d96667be9986bea89dcef0aab29b3d1959f5a5`

No verified source on Sourcify or Blockscout.

# Review notes (Review08, 2026-11-17)

All three contracts are unverified. Reads at block 26,431,454 unless noted.

| Contract | Creator (Blockscout) | `getOwner()` | `getFee()` | ETH | Priced tokens |
|---|---|---|---|---|---|
| `0x00c21ca8…` | `0xef482680…` (ENS `gamma.satoris.eth`, EOA) | `0xef482680…` | 1e17 | 0 | HEX ~USD 0.88 |
| `0x2d53a516…` | `0xef482680…` | `0xef482680…` | 9.5e17 | 0 | ~0 |
| `0x32d96667…` | `0xef482680…` | `0xef482680…` | 9.5e17 | 0 | 0 |

Bytecode (`cast selectors`): `setOwner`, `getOwner`, `whitelistAddress`, `blacklistAddress`, `setFee`, `getFee`,
`sweep(address[],address)`, `transferToken`, `transferETH`, `getFlashToken(address)`, `getNonce(address)` /
`getNonce()`, and unresolved entry points taking arrays of
`(bytes,uint256,address,address,uint256,uint256)` (swap legs) and structs
`(address,uint256,address,bytes,uint256,uint256,bytes)` ending in a `bytes` field (INFERRED: a signature).
None contains the secp256k1 `n/2` constant. In a sampled transaction
(`0x6cada0dab77513939dae56481c9585c0da691062e0df865796069a857a1ea221`, 2026-06-21, entry `0xc8512104`), `0x00c21ca8…`
takes a Morpho flash loan of 31,089 USDC, trades USDC/USDT through `0x634826fb…` (same creator), repays, and sends
USD 0.23 profit to `0xef482680…`. During the loan it delegatecalls `0x878978b5…` (same creator), whose selectors are
`onMorphoFlashLoan`, `MORPHO()` and `0x677e86e2((address,uint256,address,bytes,uint256,uint256,bytes),bool)`, and
whose bytecode contains the secp256k1 `n/2` constant (OpenZeppelin `ECDSA`). INFERRED: the signature on the trade
instruction is recovered there, in the executor's context; who must sign it (owner or whitelisted address) was not
established.

Activity: `0x00c21ca8…` last direct calls on 2026-07-06 (`0x092b25e9` from `0xce43e83d…`) and on 2026-06-21
(`0xc8512104` from several EOAs). `0x2d53a516…` is now only read: on 2026-11-04, `0xcb0151ac…` (a newer executor by
the same creator, same selector family plus `arbitraryCall`, with library `0x765b6826…` that also contains the `n/2`
constant) staticcalls it.

Sibling not in the census: `0xcb0151ac9479a6a0261622baa63ae843c9793d45` (owner `0xef482680…`, ETH 0.00002, no priced
tokens; active 2026-11-04; Morpho flash-loan arbitrage, profit to `0xef482680…`).
