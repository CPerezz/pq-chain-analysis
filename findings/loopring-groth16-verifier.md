---
id: loopring-groth16-verifier
title: "Loopring: the Groth16 BN254 BlockVerifier no longer secures anything; the Loopring 3.x exchange was replaced by an owner-only executor on 2026-06-29 and its deposit contract holds $2k"
project: loopring
status: confirmed
severity: LOW
patterns: [PQ-7]
primitives: [bn254]
trigger: trusted-setup
impact: none
alternative: configurable-verifier
role: core
contracts:
- address: "0x6150343e0f43a17519c0327c41edd9ebe88d01ef"
  implementation: null
  name: BlockVerifier (Loopring 3.x)
  upgradeable: config-only
  admin: "owner (Claimable) Safe 0xdd2a08a1c1a28c1a571e098914ca10f2877d9c97 (2 of 3) registers/disables circuits, read at block 26431597"
  value_usd: 0
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-06-27
  txs_30d: 0
families: []
fix:
  layer: none
  who_acts: "No action needed for this path: Loopring's Safe 0xdd2a08a1c1a28c1a571e098914ca10f2877d9c97 (2 of 3), owner of the exchange proxy 0x0baba1ad5be3a5c0a66e7ac838a129bf948f1ea4, already replaced ExchangeV3 with ProxyAdminExecutor"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/loopring-groth16-verifier/classification.jsonl
  - evidence/loopring-groth16-verifier/onchain.json
  - evidence/loopring-groth16-verifier/activity.json
  - evidence/loopring-groth16-verifier/source-excerpts.md
  - evidence/loopring-groth16-verifier/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: review (Review12)
  ref: findings review 2026-11-17; Sourcify source, cast reads at block 26431597, Blockscout
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

Loopring 3.x checked each L2 block with a Groth16 proof on BN254 in `BlockVerifier` (PQ-7); with the setup trapdoor a
false block would have verified and released funds from the exchange's deposit contract. Since block 25,421,921
(2026-06-29) the exchange proxy runs `ProxyAdminExecutor`, which has no block submission and never calls the verifier,
and the deposit contract holds $2,152. A forged proof now releases nothing. Rated LOW, step 4: nothing can be taken
through the check (also step 5: under $50k).

## Mechanism

- `BlockVerifier.verifyProofs(blockType, blockSize, blockVersion, publicInputs, proofs)` (`BlockVerifier.sol` lines
  1220–1252) loads the owner-registered Groth16 verification key for the circuit and runs `Verifier.Verify` (ethsnarks)
  or `BatchVerifier.BatchVerify` (matter-labs), both ending in the BN254 pairing precompile (lines 656, 516).
- Its consumer was `ExchangeV3` behind proxy `0x0baba1ad…`, whose block submission (through the operator contract
  `LoopringIOExchangeOwner`) required this check before accepting new Merkle roots that withdrawals from
  DepositContract `0x674bdf20…` were proven against.
- The proxy now points at `ProxyAdminExecutor` (`transact`, `sendNfts`, owner-only), so the verifier is unreachable from
  the exchange. Pattern PQ-7.

## Evidence

- CHECKED (Sourcify full source of `0x6150343e…`, read 2026-11-17): `verifyProofs`, `registerCircuit`,
  `disableCircuit` ([`notes.md`](../evidence/loopring-groth16-verifier/notes.md)).
- CHECKED (cast at block 26,431,597): BlockVerifier `owner()` and exchange `proxyOwner()` are Safe `0xdd2a08a1…`,
  threshold 2 of 3 owners.
- CHECKED (cast `eth_getStorageAt`, binary search): exchange implementation `0x26d8ba77…` (`ExchangeV3`) up to block
  25,421,920, `0xb2de2bff…` (`ProxyAdminExecutor`, Blockscout-verified) from block 25,421,921.
- CHECKED (Blockscout, 2026-11-17): DepositContract `0x674bdf20…` (`exchange()` = `0x0baba1ad…`) holds 0 ETH and $2,152
  in ERC-20s; the verifier holds nothing (block 26,431,214, [`onchain.json`](../evidence/loopring-groth16-verifier/onchain.json)).
- CHECKED (Xatu): last call 2026-06-27, none in 2026-10-16 to 2026-11-16
  ([`activity.json`](../evidence/loopring-groth16-verifier/activity.json)); precompile trace, year to March 2026:
  8,450 transactions, $14.7M moved in them (`curated_contracts.csv`, `txs_y1`, `usd_tx_y1`).

## Impact and exposure

| Contract | Upgradeable | Value | Last active | 30-day txs |
|---|---|---|---|---|
| `0x6150343e…` BlockVerifier | config-only | $0 (escrow released by a forged proof) | 2026-06-27 | 0 |

- Escrow: none reachable. The DepositContract's remaining $2,152 can move only through the Safe-controlled executor,
  which is a question of the Safe owners' keys (PQ-12), not of this verifier.
- Other Loopring exchange deployments (Blockscout lists several `ExchangeV3` and `LoopringIOExchangeOwner` contracts)
  were not checked against this verifier.

## Remediation

- None needed for this path while the exchange runs `ProxyAdminExecutor`. If Loopring ever restores a proof-verifying
  exchange, it should use a hash-based (STARK/FRI) verifier rather than registering new Groth16 circuits here.
- Who acts: Loopring's Safe `0xdd2a08a1…` (2 of 3), which owns both the verifier and the exchange proxy. No protocol
  change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review12): MEDIUM -> LOW, step 4: nothing can be taken through the check; the exchange proxy 0x0baba1ad was switched from ExchangeV3 to an owner-only ProxyAdminExecutor at block 25,421,921 and no longer calls the verifier (also step 5: DepositContract holds $2,152). Impact funds-loss -> none; fix.layer onchain-config -> none.
