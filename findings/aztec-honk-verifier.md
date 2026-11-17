---
id: aztec-honk-verifier
title: "Aztec rollup: a quantum attacker who recovers the BN254 setup trapdoor can forge UltraHonk epoch proofs and, as the escape hatch's bonded proposer (no attester keys needed), release about USD 81k held in L1 portals of the live rollup versions"
project: aztec
status: confirmed
severity: MEDIUM
patterns: [PQ-7]
primitives: [bn254, sw_bn254]
trigger: trusted-setup
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0x09ae3b0362bcce6e447ce4130c4963630b5a67db"
  implementation: null
  name: HonkVerifier (epoch proof verifier of canonical Rollup 0xe37a2663)
  upgradeable: "no"
  admin: none; fixed as EPOCH_PROOF_VERIFIER in Rollup 0xe37a2663cc9c119ba41572c40fab0bbb23a5402f; replacement = new rollup version registered by Governance 0x1102471eb3378fee427121c9efcea452e4b6b75e
  value_usd: 62247
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 17156
- address: "0x098f47c00f4df22a8030746eb11378236c24b4bc"
  implementation: null
  name: HonkVerifier (epoch proof verifier of Rollup 0x91ff8bbd)
  upgradeable: "no"
  admin: none; fixed in Rollup 0x91ff8bbd8ebb07893010d50a48a1609e5ebd8e34
  value_usd: 18970
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 8569
- address: "0x77e3ba096355510e0e9f60d292010b42d662d2b5"
  implementation: null
  name: HonkVerifier (epoch proof verifier of halted Rollup 0x603bb2c0)
  upgradeable: "no"
  admin: none; fixed in Rollup 0x603bb2c05d474794ea97805e8de69bccfb3bca12
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-03-30
  txs_30d: 0
families: []
fix:
  layer: new-deployment
  who_acts: Aztec Governance 0x1102471eb3378fee427121c9efcea452e4b6b75e registers a rollup version with a hash-based final verifier (Registry 0x35b22e09ee0390539439e24f06da43d83f90e298, GSE 0xa92ecfd0e70c9cd5e5cd76c50af0f7da93567a4f); portal operators and L2 users move to it
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/aztec-honk-verifier/classification.jsonl
  - evidence/aztec-honk-verifier/onchain.json
  - evidence/aztec-honk-verifier/activity.json
  - evidence/aztec-honk-verifier/source-excerpts.md
  - evidence/aztec-honk-verifier/aztec-system.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review00 (verified source of the three verifiers and their rollups; Registry, GSE and portal reads; Xatu activity)
  ref: evidence/aztec-honk-verifier/aztec-system.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: [aztec-committee-attestations, aztec-governance-proposer-sig, aztec-blob-kzg]
---

## Summary

Each Aztec rollup version proves its epochs on L1 with an UltraHonk proof checked by a HonkVerifier over BN254 KZG
(pairing precompile). A quantum attacker who recovers the trusted-setup trapdoor can make a false epoch proof verify.
No attester keys are needed: the rollups' escape hatch lets one bonded, randomly designated proposer propose
checkpoints without committee attestations for 2 of every 112 epochs, and the epoch proof then skips the attestation
check. Bonding 332M AZTEC (USD 3.4M, returned if the checkpoint is proven) into a hatch with no other candidates
makes the attacker the designated proposer; a forged proof then finalizes invented L2-to-L1 withdrawals and fees and
drains the L1 portals and fee portal of the live versions: about USD 81k on 2026-11-17 (USD 62.2k behind the
canonical rollup, USD 19.0k behind the previous one). The verifier of each rollup is fixed at construction, but Aztec
Governance has registered three new rollup versions since launch. Rated MEDIUM (step 4: a governance vote and a new
rollup version that portals and users move to; USD 81k exposed, so step 5 does not lower it).

## Mechanism

- `Rollup.submitEpochRootProof` → `EpochProofLib`: builds the public inputs (start and end archive roots, out hashes,
  fees, blob commitments) and requires `epochProofVerifier.verify(proof, publicInputs)` (v3 `EpochProofLib.sol`
  line 607; v2 line 441; version 0 line 370). On success it marks the epoch proven, inserts each block's L2-to-L1
  message root into the Outbox and pays fees from the FeeJuicePortal.
- `HonkVerifier.verify` (v3 `0x09ae3b03…` line 1515, pairing `staticcall(gas(), 8, …)` line 5706; v2 `0x098f47c0…`
  line 1512, pairing line 5654; version 0 `HonkVerifier.sol` lines 1872–2240): Shplemini batch opening checked with
  one BN254 pairing against the fixed SRS point in G2.
- The verifier is set only in the rollup constructor: `IVerifier internal immutable EPOCH_PROOF_VERIFIER` (v3
  `RollupCore.sol` line 201); version 0 stores it once in the constructor (line 289); no setter in any version.
- Escape hatch (v3 `0x613ff7d1…`, verified `EscapeHatch.sol`; v2 `0xf4593489…` same parameters on-chain, source not read): anyone can `joinCandidateSet` by
  bonding `BOND_SIZE` AZTEC (lines 149–168); `selectCandidates` picks one designated proposer per hatch from the
  snapshotted set (lines 596–670); `isHatchOpen` is true for the first `ACTIVE_DURATION` (2) epochs of every
  `FREQUENCY` (112) when a proposer was designated (lines 357–366). During an open hatch `ProposeLib` skips committee
  setup and requires only `msg.sender == escapeHatchProposer` (v3 `ProposeLib.sol` lines 216–256), and
  `EpochProofLib` returns an empty committee instead of verifying attestations (lines 258–268). The bond is kept if
  the proposed checkpoint is proven, else `FAILED_HATCH_PUNISHMENT` (9.6M AZTEC) is taken (lines 284–350). So the
  proof is the only cryptographic gate on that path.
- Pattern PQ-7. Excerpts: [`source-excerpts.md`](../evidence/aztec-honk-verifier/source-excerpts.md).

## Evidence

- CHECKED (verified source: Sourcify for version 0, Blockscout for the v2 and v3 verifiers and rollups, read
  2026-11-17): the lines above.
- CHECKED (`eth_call`, block 26,431,459): `getEpochProofVerifier()` of Rollup v3 `0xe37a2663…` = `0x09ae3b03…`, of
  Rollup v2 `0x91ff8bbd…` = `0x098f47c0…`; v2 constructor argument `_epochProofVerifier` = `0x098f47c0…`
  (Blockscout); Registry `0x35b22e09…` lists 4 versions with `0xe37a2663…` canonical; Registry, GSE and rollups
  owned by Governance `0x1102471e…` ([`aztec-system.json`](../evidence/aztec-honk-verifier/aztec-system.json)).
- CHECKED (same block): version 0 has proven = pending block 139,350 and no attesters, so nothing is left to prove.
- CHECKED (`eth_call`, latest block, and Blockscout constructor arguments): v3 `getEscapeHatch()` = `0x613ff7d1…`
  (rollup `0xe37a2663…`, bond 332M AZTEC, frequency 112, active duration 2, punishment 9.6M AZTEC, 0 candidates,
  current hatch 12); v2 `getEscapeHatch()` = `0xf4593489…` with the same parameters and 0 candidates.
- CHECKED (Xatu call frames, blocks 26,208,000–26,423,999): the v3 verifier was called in 17,156 transactions and
  v2's in 8,569; portal contracts identified from calls to each version's Inbox and Outbox; holdings from Blockscout
  on 2026-11-17.
- INFERRED: the two live verifiers were deployed after the March 2026 precompile corpus, so they were not in the
  census.

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0x09ae3b03…` HonkVerifier (Rollup v3, canonical) | no | $62.2k escrow | 2026-11-16 | 17,156 |
| `0x098f47c0…` HonkVerifier (Rollup v2) | no | $19.0k escrow | 2026-11-16 | 8,569 |
| `0x77e3ba09…` HonkVerifier (Rollup v0, halted) | no | — | 2026-03-30 | 0 |

Escrow on 2026-11-17 (AZTEC at USD 0.010135):
- Rollup v3 `0xe37a2663…`: portals seen using its Inbox `0x603b06ce…`/Outbox `0xfd2a1265…` hold USD 62.0k
  (OxidePortal `0xcb99c58f…` USD 44.7k DAI, OxidePortal `0x2ebfee28…` USD 16.8k sUSDS, TokenPortals USD 0.5k);
  FeeJuicePortal `0x534361be…` 22,592 AZTEC (USD 229).
- Rollup v2 `0x91ff8bbd…`: portals hold USD 17.1k (OxidePortal `0xdf410ad4…` USD 14.7k DAI, others USD 2.4k);
  FeeJuicePortal `0xaf73dd51…` 181,593 AZTEC (USD 1.8k).
- Lower bound: portals were found from 30-day activity only.

A forged proof does not reach the rollups' own AZTEC (owed sequencer and prover rewards) or validator stake
(618.9M AZTEC in Governance through the GSE). Block rewards from RewardDistributor `0x555baac4…` (62.0M AZTEC) are
paid per checkpoint at a configured rate, so forged epochs earn only that rate. Rollup version 0 is halted; its
FeeJuicePortal `0xe05dc9d5…` holds nothing.

## Remediation

- Aztec Governance `0x1102471eb3378fee427121c9efcea452e4b6b75e` deploys a rollup version whose epoch proof is
  checked by a hash-based verifier (the STARK/FRI or WHIR proof directly, without the UltraHonk BN254 wrapper) and
  registers it with `Registry.addRollup` and `GSE.addRollup`, as it did on 2026-03-04, 2026-06-30 and 2026-10-10.
  Stake that follows the latest rollup moves automatically.
- Portal operators (OxidePortal, TokenPortal deployers) and L2 users must move their funds to the new version; the
  old versions' portals stay exposed while they hold funds.
- The vote is signalled with ECDSA attester keys ([aztec-governance-proposer-sig](aztec-governance-proposer-sig.md)),
  so it must happen before a CRQC exists.
- No Ethereum protocol change is needed; the replacement verifier costs more gas per epoch.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated CRITICAL (step 4: pooled funds released by a forged proof or attestation, and the verification cannot change).
- 2026-11-17 review (Review00): CRITICAL -> MEDIUM, step 4: each rollup's verifier is immutable, but Governance
  replaces whole rollup versions through the Registry and GSE (three times since launch, stake following
  automatically), so the fix is a vote plus a new version that portals and users move to; measured escrow USD 81k,
  so step 5 does not lower it. The draft verifier belongs to the halted version 0; added the live verifiers of v3
  `0x09ae3b03…` and v2 `0x098f47c0…` (not in the March 2026 census) with their portal escrow.
- 2026-11-17 review (Review00, follow-up): MEDIUM kept, step 4. Traced the v3 escape hatch `0x613ff7d1…`: during an
  open hatch the designated proposer (anyone who bonds 332M AZTEC; no candidates today) proposes without
  attestations and the epoch proof skips the attestation check, so a forged proof alone releases the portal escrow.
  This widens who can exploit it (no attester keys needed) but not the fix, which is still a governance vote and a
  new rollup version, so the rating stays MEDIUM; summary, title and mechanism updated.
