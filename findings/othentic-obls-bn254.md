---
id: othentic-obls-bn254
title: "Othentic: a quantum attacker who recovers the operators' BN254 BLS keys can pass any task through the OBLS quorum check, and on Ditto Network's AVS run arbitrary user operations on Ditto-automated accounts (about USD 5 held)"
project: othentic
status: confirmed
severity: LOW
patterns: [PQ-6]
primitives: [bn254, sw_bn254]
trigger: committee-keys
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x08525854f4974054efd772d0f203abd77a199a95"
  implementation: "0xc7172c5dc062dedfaed4a91be7ae2f7c96b4b9aa"
  name: BeaconProxy → OBLS (Ditto Network AVS)
  upgradeable: "yes"
  admin: beacon 0x8f13034feab511161b833dadc8e23c6892e07ea4, owner() Safe 0x74d9fb2b522cf886872ac333480dc4779a4bb214 (2 of 4), read at block 26431568
  value_usd: 5
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-10-16
  txs_30d: 0
families:
- code: "0xc7172c5dc062dedfaed4a91be7ae2f7c96b4b9aa"
  name: BeaconProxy → OBLS (beacon 0x8f13034feab511161b833dadc8e23c6892e07ea4)
  instances: 3
  list: 0x08525854f4974054efd772d0f203abd77a199a95, 0x002311b5d8d215df93996da50206578b83c85cbe, 0xfc041081057fff29b0c375b8b04579006f0519a0
  upgradeable: "yes"
  value_usd: 0
  value_basis: escrow
  value_as_of: 2026-11-17
fix:
  layer: contract-upgrade
  who_acts: Othentic, through beacon 0x8f13034feab511161b833dadc8e23c6892e07ea4 owned by Safe 0x74d9fb2b522cf886872ac333480dc4779a4bb214 (2 of 4), which upgrades all three OBLS instances at once; operators then register post-quantum keys
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/othentic-obls-bn254/classification.jsonl
  - evidence/othentic-obls-bn254/onchain.json
  - evidence/othentic-obls-bn254/activity.json
  - evidence/othentic-obls-bn254/source-excerpts.md
  - evidence/othentic-obls-bn254/consumers.json
  - evidence/othentic-obls-bn254/ditto-accounts.json
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

Othentic's `OBLS` contract (BN254 BLS, PQ-6) checks that a task attestation carries an aggregate signature from
operators holding enough voting power; Othentic's `AttestationCenter` then accepts the task, runs the AVS's hook and
books operator rewards. Operators' BLS public keys are stored on-chain, so a quantum attacker who recovers enough of
them can approve any task. In the active instance (`0x08525854…9a95`, Ditto Network's AVS) an approved task makes
`DittoOthenticHook` submit an arbitrary ERC-4337 user operation for Ditto-automated Kernel accounts; the four such
accounts hold USD 5.28 and the reward treasury is empty. Rated LOW: MEDIUM by step 4 (one beacon upgrade by
Othentic's Safe fixes all instances), lowered by step 5 (under USD 50k measured).

## Mechanism

- `OBLS.verifySignature(message, signature, indexes, requiredVotingPower, minimumVotingPower)` (source lines 71–84):
  sums the voting power and aggregates the BN254 G2 public keys of the signing operators (`_calculateAggregatePK`) and
  checks the signature with `BLS.verifySingle` (pairing precompile, `BLS.sol`). `verifyAuthSignature` and
  `validateOperatorSignature` check single-operator BLS signatures for key registration and task performers.
- Caller: `AttestationCenter._verifyAggregatedSignature` (`0xd343d5e9…6fbd`, Sourcify `exact_match`, line 699) in
  `submitTask(TaskInfo, …)`; on approval the task's `avsLogic.beforeTaskSubmission` runs and operator payments are
  booked against `avsTreasury` (`_withdrawL2Rewards`, line 641).
- Ditto's hook `DittoOthenticHook` (`0xee9eb9bc…8df9`, implementation `0x6aa27afa…68a9`, Blockscout verified):
  `_beforeTaskSubmissionLogic` requires attesters 1 and 2 among the signers (`dittoAttestersMask` = 6), decodes
  `taskInfo.data` as a `PackedUserOperation`, marks its hash in `isApprovedUserOpHash` and calls
  `EntryPoint.handleOps`.
- Pattern PQ-6. Excerpts: [`source-excerpts.md`](../evidence/othentic-obls-bn254/source-excerpts.md).

## Evidence

- CHECKED (verified source, Sourcify `exact_match` for OBLS `0xc7172c5d…` and AttestationCenter `0xd343d5e9…`;
  Blockscout for DittoOthenticHook; read 2026-11-17): the functions above.
- CHECKED (on-chain read at block 26,431,568): the OBLS beacon `0x8f13034f…` points at `0xc7172c5d…` and its `owner()`
  is Safe `0x74d9fb2b…b214` (2 of 4), which also owns AttestationCenter beacon `0x0c294861…4142`; AttestationCenter
  `0x9969f9eb…afa8` has `obls()` = this proxy, `taskNumber()` = 1,575, 4 active operators, `avsTreasury()` =
  `0xc679a237…de5a` (0 ETH, no tokens), `avsLogic()` = Ditto hook (owner Safe `0x8560c667…1f6b`, 2 of 4)
  ([`consumers.json`](../evidence/othentic-obls-bn254/consumers.json)).
- CHECKED (EntryPoint `UserOperationEvent` logs in all 1,497 blocks with hook logs, 2026-01-29 to 2026-10-16): four
  senders, all Kernel accounts, holding USD 5.28 together on 2026-11-17
  ([`ditto-accounts.json`](../evidence/othentic-obls-bn254/ditto-accounts.json)).
- CHECKED (family): the same beacon serves `0x002311b5…5cbe` and `0xfc041081…19a0`; their AttestationCenters
  (`0xe73322ef…2750`, `VennAvsLogic` hook; `0x2ead6eb0…fa46`) processed 4 tasks each, last transactions 2025-04-29 and
  2025-08-11, and their treasuries hold nothing.
- CHECKED (precompile trace and Xatu): 838 BN254 calls in the year to March 2026 (`txs_y1`); last call 2026-10-16, none
  in 2026-10-16 to 2026-11-16 ([`activity.json`](../evidence/othentic-obls-bn254/activity.json)).
- INFERRED: Ditto's Kernel validator accepts an operation while the hook has its hash in `isApprovedUserOpHash`; the
  account-side validator was not read.

## Impact and exposure

| Contract | Upgradeable | Escrow | Last active | 30-day txs |
|---|---|---|---|---|
| `0x08525854…` BeaconProxy → OBLS (Ditto) | yes (beacon, Safe 2 of 4) | USD 5 | 2026-10-16 | 0 |
| family: `0x002311b5…`, `0xfc041081…` | yes (same beacon) | USD 0 | 2025 | — |

- Escrow: the Ditto-automated accounts (USD 5.28, four Kernel accounts) and the AVS reward treasury (empty). OBLS
  holds nothing.
- Attribution: Othentic wrote and upgrades OBLS and AttestationCenter; Ditto Network runs the active AVS and owns its
  hook.

## Remediation

- Post-quantum replacement: operators register post-quantum keys (for example hash-based signatures aggregated in a
  STARK, or ML-DSA signatures counted against voting power) in a new OBLS implementation.
- Who must act: Othentic, by upgrading beacon `0x8f13034f…` from Safe `0x74d9fb2b…b214` (all three instances move
  together) and the AttestationCenter beacon to pass the new signatures; operators register new keys. Ditto can also
  stop routing user operations through the hook (`setAttestationCenter`, owner Safe `0x8560c667…1f6b`). No protocol
  change needed.
- Users of Ditto automation: remove the Ditto validator from accounts that hold value.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review21): MEDIUM -> LOW, step 5: the funds a forged quorum reaches are Ditto's automated Kernel
  accounts (USD 5.28) and an empty reward treasury; the other two instances on the same beacon are dormant with empty
  treasuries. Escrow measured and the family listed.
