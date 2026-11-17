---
id: eigenda-operator-bls-bn254
title: "EigenDA: EigenDAServiceManager.confirmBatch records data-availability certificates on a BN254 BLS quorum signature; a quantum attacker who recovers operator BLS keys and a batch-confirmer key can certify data nobody stored, for rollups that read these certificates"
project: eigenda
status: confirmed
severity: MEDIUM
patterns: [PQ-6]
primitives: [bn254, sw_bn254]
trigger: committee-keys
impact: funds-locked
alternative: sole
role: core
contracts:
- address: "0x870679e138bcdf293b7ff14dd44b70fc97e12fc0"
  implementation: "0xae448d008b6f69033afda361b46b36c472b6fee0"
  name: TransparentUpgradeableProxy → EigenDAServiceManager
  upgradeable: "yes"
  admin: "ProxyAdmin 0x8247ef5705d3345516286b72bfe6d690197c2e99 and contract owner(), both Safe 0x002721b4790d97dc140a049936aa710152ba92d5 (2 of 4), read at block 26431570"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-03
  txs_30d: 2
families: []
fix:
  layer: contract-upgrade
  who_acts: "EigenDA Safe 0x002721b4790d97dc140a049936aa710152ba92d5 (2 of 4), owner of ProxyAdmin 0x8247ef5705d3345516286b72bfe6d690197c2e99 and of the ServiceManager, upgrades the implementation; consuming rollups move to the replacement certificate"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/eigenda-operator-bls-bn254/classification.jsonl
  - evidence/eigenda-operator-bls-bn254/onchain.json
  - evidence/eigenda-operator-bls-bn254/activity.json
  - evidence/eigenda-operator-bls-bn254/source-excerpts.md
  - evidence/eigenda-operator-bls-bn254/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: review (Review12)
  ref: findings review 2026-11-17; Sourcify source of 0xae448d00, cast reads at block 26431570
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: []
---

## Summary

EigenDA's ServiceManager confirms data-availability batches only if an aggregate BLS signature on BN254 from its
restaked operators reaches each quorum's threshold (PQ-6). BLS secret keys follow from the registered public keys, so a
quantum attacker can sign for any quorum; with an allow-listed batch-confirmer key (an EOA by construction, also
recoverable) they can record a certificate for data no operator stores. Rollups that accept such certificates lose
their data: withheld state, and for optimistic rollups no data to prove fraud with. The value behind these certificates
sits in the consuming rollups and was not measured; the contract holds nothing. Rated MEDIUM, step 4: a 2-of-4 Safe can
upgrade the implementation.

## Mechanism

- `confirmBatch(batchHeader, nonSignerStakesAndSignature)` (`EigenDAServiceManager.sol` lines 88–140) is
  `onlyBatchConfirmer` and requires `tx.origin == msg.sender`. It hashes the reduced batch header and calls
  `BLSSignatureChecker.checkSignatures`, which subtracts non-signer keys from the stored quorum aggregate keys (`ecadd`,
  `ecmul`) and checks the aggregate signature with the BN254 pairing precompile (`BLSSignatureChecker.sol` lines
  96–283 in the excerpt, "pairing precompile call failed" / "signature is invalid").
- If each quorum's signed stake meets `signedStakeForQuorums`, it stores `batchIdToBatchMetadataHash[batchId]` and emits
  `BatchConfirmed`. EigenDA V1 blob certificates are verified against this stored hash.
- Operator BLS public keys are registered on-chain (`BLSApkRegistry.registerBLSPublicKey`), so the secret keys are
  recoverable with a quantum computer. Pattern PQ-6.

## Evidence

- CHECKED (Sourcify full source of implementation `0xae448d008b6f69033afda361b46b36c472b6fee0`, read 2026-11-17):
  `confirmBatch`, `onlyBatchConfirmer` (lines 40–43, `isBatchConfirmer[msg.sender]`), `setBatchConfirmer` (`onlyOwner`,
  line 143) ([`source-excerpts.md`](../evidence/eigenda-operator-bls-bn254/source-excerpts.md)).
- CHECKED (cast at block 26,431,570): EIP-1967 implementation `0xae448d00…`; ProxyAdmin `0x8247ef57…` `owner()` and
  ServiceManager `owner()` are both Safe `0x002721b4…`, threshold 2 of 4 owners; `paused()` = 0; `taskNumber()`
  (next batch id) = 153,155 ([`notes.md`](../evidence/eigenda-operator-bls-bn254/notes.md)).
- CHECKED (on-chain read at block 26,431,214): holds nothing ([`onchain.json`](../evidence/eigenda-operator-bls-bn254/onchain.json)).
- CHECKED (Xatu, any function): 2 transactions 2026-10-16 to 2026-11-16, none sent to it directly; last 2026-11-03
  ([`activity.json`](../evidence/eigenda-operator-bls-bn254/activity.json)); precompile trace, year to March 2026:
  73,222 transactions with BN254 pairing calls (`curated_contracts.csv`, `txs_y1`).
- INFERRED: V1 batch confirmation has mostly stopped (no direct calls in the window); EigenDA V2 certificates are
  verified by separate certificate-verifier contracts, not part of this finding and not checked here.

## Impact and exposure

| Contract | Upgradeable | Value | Last active | 30-day txs |
|---|---|---|---|---|
| `0x870679e1…` TransparentUpgradeableProxy → EigenDAServiceManager | yes | not measured | 2026-11-03 | 2 |

- Escrow: the funds rely on EigenDA certificates in the consuming rollups' bridges; which mainnet rollups still verify
  V1 certificates against this contract was not established, so `value_usd` stays null and the value step lowers
  nothing.
- Worst effect if nobody acts: rollups accept batches whose data is unavailable (funds locked); stake in EigenLayer is
  not released by this path.
- The draft's family entry (3 instances, code `0xae448d00…`) grouped contracts by proxy bytecode (this proxy,
  `0x00a5fd09…` and `0x0baac79a…`), not by EigenDA logic; the other two were not checked, and the entry was removed.

## Remediation

- Replacement: certificates signed with a post-quantum aggregate (for example hash-based signatures aggregated in a
  STARK/WHIR proof) and verified by an upgraded ServiceManager; operators register post-quantum keys; the batch
  confirmer moves from an EOA (`tx.origin` check) to a post-quantum account, which needs that check changed.
- Who acts: EigenDA Safe `0x002721b4…` (2 of 4) through ProxyAdmin `0x8247ef57…`; operators re-register keys;
  consuming rollups adopt the new certificate format. No protocol change needed.
- Rollup users cannot act here beyond withdrawing from rollups that rely on EigenDA.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review12): MEDIUM -> MEDIUM, step 4: upgrade by Safe 0x002721b4 (2 of 4). Impact funds-loss -> funds-locked (a forged certificate makes unavailable data look available; consumers' value not established). Owner and ProxyAdmin owner read at block 26,431,570; removed the family entry.
