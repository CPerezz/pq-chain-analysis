---
id: unidentified-807cf9a7-signer-key
title: "Unidentified 1inch maker vault: a recovered executor ECDSA key lets a quantum attacker sign orders through isValidSignature that sell the vault's tokens; it holds USD 152"
project: unidentified-807cf9a7
status: candidate
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x807cf9a772d5a3f9cefbc1192e939d62f0d9bd38"
  implementation: "0xbe4e645caaae7c1d0874bb8d1c8d337f31d79dd8"
  name: TransparentUpgradeableProxy → unverified maker vault (isValidSignature, executorSigner, operators, withdraw)
  upgradeable: "yes"
  admin: ProxyAdmin 0x291baf88f60e8f83de7568ae56280a3e29ac725e, owner MultiSigWalletWithDailyLimit 0xbc33a1f908612640f2849b56b67a4de4d179c151 (2 of 3)
  value_usd: 152
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2025-12-09
  txs_30d: 0
families: []
fix:
  layer: contract-upgrade
  who_acts: "Operator: multisig 0xbc33a1f908612640f2849b56b67a4de4d179c151 (2 of 3) upgrades through ProxyAdmin 0x291baf88f60e8f83de7568ae56280a3e29ac725e, or withdraws the remaining tokens"
  protocol_change: not-needed
evidence:
  level: bytecode
  links:
  - evidence/unidentified-807cf9a7-signer-key/classification.jsonl
  - evidence/unidentified-807cf9a7-signer-key/onchain.json
  - evidence/unidentified-807cf9a7-signer-key/activity.json
  - evidence/unidentified-807cf9a7-signer-key/source-excerpts.md
  - evidence/unidentified-807cf9a7-signer-key/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review14 (selectors, trace of the last ecrecover call, admin reads)
  ref: evidence/unidentified-807cf9a7-signer-key/notes.md
  date: 2026-11-17
  verdict: reported
  rating: LOW
related: []
---

## Summary

This unverified proxy acts as an ERC-1271 maker for 1inch limit orders: 1inch's router asks its `isValidSignature`,
which answers with `ecrecover` against an operator key (`executorSigner` / operators). A quantum attacker who recovers
that key can sign orders that sell whatever the vault holds. It holds USD 152 and has not been called since 2025-12-09.
Rated LOW (step 5: a MEDIUM upgrade fix, lowered because under USD 50k is exposed).

## Mechanism

- Implementation `0xbe4e…9dd8` (unverified) exposes `isValidSignature(bytes32,bytes)`, `executorSigner()`, operator-list
  setters, `nonces(address)`, `withdraw(address,uint256,address)` and `(uint256,bytes)` execute-style entry points.
- The last `ecrecover` from this contract (block 23,974,448) was inside a `staticcall` to `isValidSignature` from 1inch
  AggregationRouterV6 `0x1111…2a65`: the vault's tokens move when the router accepts an order the vault "signs".
- INFERRED (bytecode, no source): `isValidSignature` recovers the signer with `ecrecover` and accepts it if it is the
  executor or an operator; the operator keys can only be replaced by other ECDSA keys. Pattern PQ-4.

## Evidence

- CHECKED (cast, 2026-11-17): EIP-1967 implementation and admin slots; ProxyAdmin `owner()` = `0xbc33…c151`
  (`required()` = 2, 3 owners); `executorSigner()` = EOA `0xe9f1…a31a`; implementation selectors
  ([`notes.md`](../evidence/unidentified-807cf9a7-signer-key/notes.md)).
- CHECKED (`trace_filter` at block 23,974,448): 1inch router → `isValidSignature` on this contract.
- CHECKED (precompile trace): 707,291 `ecrecover` calls, 2022-10-11 to 2025-12-09; 97,704 transactions in the trace
  year.
- CHECKED (on-chain read at block 26,431,214): USD 152 held
  ([`onchain.json`](../evidence/unidentified-807cf9a7-signer-key/onchain.json)); no transactions since 2026-03-18
  ([`activity.json`](../evidence/unidentified-807cf9a7-signer-key/activity.json)).
- INFERRED: the signer comparison inside `isValidSignature` (no verified source); status stays candidate.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x807cf9a7…` maker vault | yes (2-of-3 multisig) | USD 152 | 2025-12-09 | 0 |

The vault's own tokens are what a forged order can sell. The operators withdrew its funds in April 2025 (`withdraw`,
`WithdrawFunds` events at block 22,326,545). Sibling checked: `0xd198885a…c0c2` (same implementation and deployer,
different executor key) holds USD 240 and last called `ecrecover` on 2024-09-25; not in the registry.

## Remediation

- Have the executor authorise through a post-quantum signer (ERC-1271 / ERC-7913 verifier contract) via an upgrade by
  multisig `0xbc33…c151`, or withdraw the remaining tokens and retire the vault. No protocol change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review14): MEDIUM -> LOW, step 5: the vault holds USD 152 (measured), under USD 50k. Mechanism refined: the check answers 1inch's `isValidSignature` calls; the proxy admin is a 2-of-3 multisig.
