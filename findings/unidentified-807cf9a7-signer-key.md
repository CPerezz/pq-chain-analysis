---
id: unidentified-807cf9a7-signer-key
title: "Unidentified 1inch maker vault: a recovered executor ECDSA key lets a quantum attacker sign orders through isValidSignature that sell the vault's tokens; it holds USD 152"
status: confirmed
severity: MEDIUM
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
  txs_90d: 0
families: []
fix:
  layer: contract-upgrade
  who_acts: "Operator: multisig 0xbc33a1f908612640f2849b56b67a4de4d179c151 (2 of 3) upgrades through ProxyAdmin 0x291baf88f60e8f83de7568ae56280a3e29ac725e, or withdraws the remaining tokens"
  protocol_change: not-needed
evidence:
  level: bytecode
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-807cf9a7-signer-key
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review14 (selectors, trace of the last ecrecover call, admin reads)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-807cf9a7-signer-key/notes.md
  date: 2026-11-17
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "The fix is an upgrade by a 2-of-3 multisig (several parties acting) → MEDIUM. Value null: I did not price the token holdings (the finding says USD 152). Still a candidate (bytecode only)."
related: []
---

## Summary

This unverified proxy acts as an ERC-1271 maker for 1inch limit orders: 1inch's router asks its `isValidSignature`,
which answers with `ecrecover` against an operator key (`executorSigner` / operators). A quantum attacker who recovers
that key can sign orders that sell whatever the vault holds. It holds USD 152 and has not been called since 2025-12-09.
Rated MEDIUM (step 4: an upgrade fix by a 2-of-3 multisig).

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
  ([`notes.md`](#review-notes-unidentified-807cf9a7-signer-key-2026-11-17-review14)).
- CHECKED (`trace_filter` at block 23,974,448): 1inch router → `isValidSignature` on this contract.
- CHECKED (precompile trace): 707,291 `ecrecover` calls, 2022-10-11 to 2025-12-09; 97,704 transactions in the trace
  year.
- CHECKED (on-chain read at block 26,431,214): USD 152 held
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-807cf9a7-signer-key/onchain.json)); no transactions since 2026-03-18
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-807cf9a7-signer-key/activity.json)).
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

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review14): MEDIUM -> LOW, step 5: the vault holds USD 152 (measured), under USD 50k. Mechanism refined: the check answers 1inch's `isValidSignature` calls; the proxy admin is a 2-of-3 multisig.
- 2026-11-19: LOW -> MEDIUM, step 5 removed (value no longer lowers a rating); step 4 gives MEDIUM.
- 2026-11-20: moved to triage with the rest of the pool and reviewed (D-025); state re-read at block 26,438,999; filed confirmed, MEDIUM; fixed the stale LOW/step-5 wording in the Summary.

# Source excerpts: unidentified-807cf9a7-signer-key

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x807cf9a772d5a3f9cefbc1192e939d62f0d9bd38` — TransparentUpgradeableProxy (verified source via blockscout)

## Implementation `0xbe4e645caaae7c1d0874bb8d1c8d337f31d79dd8`

No verified source on Sourcify or Blockscout.

# Review notes: unidentified-807cf9a7-signer-key (2026-11-17, Review14)

All reads via eth.drpc.org (latest, 2026-11-17) and Blockscout unless stated.

## Proxy and admin

- `0x807cf9a7…` TransparentUpgradeableProxy (verified); EIP-1967 implementation `0xbe4e645caaae7c1d0874bb8d1c8d337f31d79dd8`
  (unverified), admin slot ProxyAdmin `0x291baf88f60e8f83de7568ae56280a3e29ac725e`, `owner()` =
  `0xbc33a1f908612640f2849b56b67a4de4d179c151` (Blockscout: MultiSigWalletWithDailyLimit; `required()` = 2,
  `getOwners()` = 3 owners). The proxy's own `owner()` is the same multisig.
- `executorSigner()` = `0xe9f191c09679a745a1d7a7f20658681b18d9a31a` (EOA).
- Implementation selectors (`cast selectors`): `isValidSignature(bytes32,bytes)` 0x1626ba7e, `nonces(address)`
  0x7ecebe00, `owner()`, `transferOwnership`, `renounceOwnership`, `withdraw(address,uint256,address)` 0x69328dec, several
  `(address[])` operator-list setters, `(uint256,bytes)` payable/nonpayable entry points (0x4cf3fe9c, 0x8594ac40,
  0x7507bd7a), `(address,bytes)` payable 0xab06e403. Names other than standard ones are not resolved.

## Who calls the check

- `data/agg/alltime_caller.parquet`: `ecrecover` 707,291 calls, blocks 15,724,490–23,974,448 (last 2025-12-09);
  trace year 97,704 transactions.
- `trace_filter` (eth.drpc.org) at block 23,974,448: tx `0xee0c8998…4567`, 1inch AggregationRouterV6
  `0x111111125421ca6dc452d289314280a0f8842a65` staticcalls `isValidSignature` (0x1626ba7e) on this contract. The
  contract acts as an ERC-1271 maker for 1inch limit orders; its `isValidSignature` is answered with `ecrecover`
  (INFERRED from the trace pairing; the exact comparison against `executorSigner`/operators is not read from source).
- Direct transactions: last ones are `withdraw` (0x69328dec, `WithdrawFunds` events) from EOA
  `0xf3d872b9e8d314820dc8e99dafbe1a3feedc27d5` at block 22,326,545 (2025-04-22). Later token transfers in are unsolicited
  tokens. `activity.json`: no transaction since 2026-03-18.

## Holdings (onchain.json, block 26,431,214)

USD 152 (RENDER, ETHFI, LOOM, … ; 0.00006 ETH).

## Sibling

Deployer `0xfc68e9b0d3497db6dc1ce68d25d45315b8cc3076` also operates `0xd198885a138d3b1810a7363dd055c540d521c0c2`: same
implementation `0xbe4e…9dd8`, ProxyAdmin `0xfe71ca5f6c9c4bac61c25e38bfa4258de7ab272c`, `executorSigner()` =
`0xdd41094fc512b96ee0c92d08c35fd67d52fd0fb5`; holds USD 240 (Blockscout, 2026-11-17); 33 `ecrecover` calls, last at block
20,828,948 (2024-09). Not in the registry.

## Identity

Not identified: deployer, executor and withdrawer are unlabelled EOAs; the owner is an unlabelled 2-of-3 multisig.
