---
id: predicate-avs-ecdsa-signers
title: "Predicate ServiceManager: one ECDSA attester key (policy threshold 1) approves compliance checks, so a quantum attacker who recovers it can pass any policy and deposit into gated vaults; nothing can be taken"
project: predicate
status: confirmed
severity: LOW
patterns: [PQ-5, PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: none
alternative: key-rotation-only
role: core
contracts:
- address: "0xf6f4a30eef7cf51ed4ee1415fb3bfdaf3694b0d2"
  implementation: "0x7fc138988d13ded38fa22abc4e15e855c92b092e"
  name: TransparentUpgradeableProxy → ServiceManager
  upgradeable: "yes"
  admin: ProxyAdmin 0x7153803c06d6a36d6d91aeb3c1ed8e5b934df601 and ServiceManager owner() both Safe 0x8a3c2193521cf895d77c8dedb290fc5e19126fde (2 of 4, read at block 26,431,567)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-15
  txs_30d: 131
families: []
fix:
  layer: contract-upgrade
  who_acts: Safe 0x8a3c2193521cf895d77c8dedb290fc5e19126fde (2 of 4) upgrades the ServiceManager through ProxyAdmin 0x7153803c06d6a36d6d91aeb3c1ed8e5b934df601; each client can also repoint with setPredicateManager
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/predicate-avs-ecdsa-signers/classification.jsonl
  - evidence/predicate-avs-ecdsa-signers/onchain.json
  - evidence/predicate-avs-ecdsa-signers/activity.json
  - evidence/predicate-avs-ecdsa-signers/source-excerpts.md
  - evidence/predicate-avs-ecdsa-signers/tasks-and-admin.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_3.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
related: []
---

## Summary

Predicate's ServiceManager (`0xf6f4a30e…`) is a compliance attestation service: client contracts ask
`validateSignatures` whether registered operators signed a task approving a given sender, target and call. Each signature
is checked with `ecrecover`; the contract supports m-of-n, but both live policies require one signature and every
attestation in the sample came from one key, `0x5f936c12…`. A CRQC holder who recovers that key can approve any task,
so a user the policy would refuse can deposit into or mint from the gated vaults. The gated calls move only the caller's
own funds, so nothing can be taken. Rated LOW, step 4: the check guards an access policy through which no funds can be
taken; the ServiceManager is upgradeable by a 2-of-4 Safe.

## Mechanism

- Client contracts inherit `PredicateClient._authorizeTransaction`, which builds a `Task` (taskId, msgSender, target,
  value, encodedSigAndArgs, policyID, quorumThresholdCount, expireByTime) and calls
  `serviceManager.validateSignatures(task, signerAddresses, signatures)`.
- `ServiceManager.validateSignatures` requires an unexpired, unspent task whose `quorumThresholdCount` equals
  `policyIdToThreshold[policyID]`, then for each required signature `ECDSA.recover(hashTaskSafe(task), signature)` must
  equal the sorted `signerAddresses[i]`, whose operator (`signingKeyToOperator`) is `REGISTERED`.
- Operators rotate keys with `rotatePredicateSigningKey`; the scheme stays ECDSA.
- Pattern PQ-5 (threshold signer set), configured as PQ-4 (a single key). Excerpts:
  [`source-excerpts.md`](../evidence/predicate-avs-ecdsa-signers/source-excerpts.md).

## Evidence

- CHECKED (Sourcify, implementation `0x7fc13898…`, fetched 2026-11-17): `src/ServiceManager.sol` `validateSignatures`,
  `hashTaskSafe`, `deployPolicy`, `rotatePredicateSigningKey`.
- CHECKED (Blockscout logs): 399 `TaskValidated` events, blocks 26,056,551–26,425,053; policies `x-nest-prod-006`
  (361) and `x-aleo-6a52de9724a6e8f2` (38), each with threshold 1; all signed by `0x5f936c12…`; targets
  `0xfc0c4222…` (219), `0x6104fe10…` (142), `0x053f202a…` (38)
  ([`tasks-and-admin.json`](../evidence/predicate-avs-ecdsa-signers/tasks-and-admin.json)).
- CHECKED (on-chain read at block 26,431,567): `policyIdToThreshold` 1 for both policies; `signingKeyToOperator(0x5f93…)`
  is itself, status `REGISTERED`; EIP-1967 admin `0x7153803c…` and `owner()` both Safe `0x8a3c2193…` (2 of 4); each
  client's `getPredicateManager()` is this ServiceManager.
- CHECKED (Sourcify and Blockscout): `0xfc0c4222…` is a proxy to `NestVaultPredicateProxy`, which gates `deposit`,
  `depositWithPermit2` and `mint` and lets an authorised role call `setPredicateManager`; `0x6104fe10…` is
  `TellerWithMultiAssetSupportPredicateProxy`; `0x053f202a…` is `PredicateService` (`handleMessage`).
- CHECKED (Xatu, any function): 131 transactions reached the ServiceManager 2026-10-16 to 2026-11-16, none directly;
  last on 2026-11-15 ([`activity.json`](../evidence/predicate-avs-ecdsa-signers/activity.json)); 101,310 transactions
  with an `ecrecover` call in the year to March 2026 (`txs_y1`, `data/report/curated_contracts.csv`).
- INFERRED: the Teller proxy and `PredicateService` gate the caller's own deposits like the Nest proxy (names and the
  `msgSender`/`msgValue` task fields; their gated functions were not read).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xf6f4a30e…` TransparentUpgradeableProxy → ServiceManager | yes | — | 2026-11-15 | 131 |

No escrow: a forged attestation authorises a call that spends the caller's own assets (vault deposits and mints). The
effect is a compliance bypass (a sanctioned or non-allowlisted address gets in), not a loss of pooled funds. A future
client that gates a withdrawal or payout on a Predicate attestation alone would change this rating.

## Remediation

- Predicate: upgrade the ServiceManager (Safe `0x8a3c2193…` through ProxyAdmin `0x7153803c…`) to accept post-quantum
  operator signatures (ML-DSA, SLH-DSA or an ERC-7913 verifier per operator), and raise policy thresholds above one.
- Clients can repoint to a new manager with `setPredicateManager`. No protocol change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review19): MEDIUM -> LOW, step 4: the attestation gates only the caller's own deposits and mints (compliance bypass, nothing can be taken); live policies use threshold 1 with a single key, so trigger set to operator-key and impact to none; title corrected (not oracle/keeper reports).
