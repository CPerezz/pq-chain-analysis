---
id: aztec-committee-attestations
title: "Aztec rollup: a quantum attacker who recovers the validators' ECDSA attester keys can sign block proposals and slashing votes; with a forged epoch proof this releases about USD 81k in L1 portals of the live rollup versions"
project: aztec
status: confirmed
severity: MEDIUM
patterns: [PQ-5]
primitives: [ecrecover, kzg]
trigger: committee-keys
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0xe37a2663cc9c119ba41572c40fab0bbb23a5402f"
  implementation: null
  name: Rollup (version 2070860440, canonical since 2026-10-10)
  upgradeable: "no"
  admin: owner Governance 0x1102471eb3378fee427121c9efcea452e4b6b75e (settings only; the attestation check is fixed); replacement = new rollup version via Registry 0x35b22e09ee0390539439e24f06da43d83f90e298 and GSE 0xa92ecfd0e70c9cd5e5cd76c50af0f7da93567a4f, both owned by Governance
  value_usd: 62247
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 44053
- address: "0xa2ff1bf784d6b1d7ba1bfd67c3538b85f9f85295"
  implementation: null
  name: SlashingProposer (of Rollup 0xe37a2663)
  upgradeable: "no"
  admin: none; the Rollup owner (Governance 0x1102471e) can queue a new slasher; Slasher 0x08b364720b6e4c2089fbdd8a6a722f474013a2b7 vetoer is Safe 0xbbb4af368d02827945748b28cd4b2d42e4a37480 (5 of 9)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 7807
- address: "0x91ff8bbd8ebb07893010d50a48a1609e5ebd8e34"
  implementation: null
  name: Rollup (version 4248422647, deployed 2026-06-30, still producing blocks)
  upgradeable: "no"
  admin: owner Governance 0x1102471eb3378fee427121c9efcea452e4b6b75e (settings only)
  value_usd: 18970
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 44350
- address: "0x8a36b8f2ca71d8d8bd98e03ebf8b4d0939daf0ba"
  implementation: null
  name: SlashingProposer (of Rollup 0x91ff8bbd)
  upgradeable: "no"
  admin: none; the Rollup owner (Governance 0x1102471e) can replace the slasher
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-10-29
  txs_30d: 4903
- address: "0x603bb2c05d474794ea97805e8de69bccfb3bca12"
  implementation: null
  name: Rollup (version 0, first mainnet version; halted, no attesters)
  upgradeable: "no"
  admin: owner Governance 0x1102471eb3378fee427121c9efcea452e4b6b75e (settings only)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-13
  txs_30d: 28
- address: "0x7a318c3daa9f21f8fc8238c65755eb0394fbf189"
  implementation: null
  name: TallySlashingProposer (of Rollup 0x603bb2c0; dormant)
  upgradeable: "no"
  admin: none (one instance per rollup version)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-03-30
  txs_30d: 0
families: []
fix:
  layer: new-deployment
  who_acts: Aztec Governance 0x1102471eb3378fee427121c9efcea452e4b6b75e registers a new rollup version with post-quantum attester keys (Registry 0x35b22e09ee0390539439e24f06da43d83f90e298, GSE 0xa92ecfd0e70c9cd5e5cd76c50af0f7da93567a4f); validators move (automatic for stake that follows the latest rollup); portal operators and L2 users move to the new version
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/aztec-committee-attestations/classification.jsonl
  - evidence/aztec-committee-attestations/onchain.json
  - evidence/aztec-committee-attestations/activity.json
  - evidence/aztec-committee-attestations/source-excerpts.md
  - evidence/aztec-committee-attestations/aztec-system.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_4.jsonl,out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review00 (Sourcify/Blockscout source of rollup versions 0, 2 and 3; Registry, GSE, Governance and portal reads; Xatu activity of the new contracts)
  ref: evidence/aztec-committee-attestations/aztec-system.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: [aztec-honk-verifier, aztec-governance-proposer-sig, aztec-validator-bls-pop-bn254, aztec-blob-kzg]
---

## Summary

Every Aztec block is proposed on L1 with ECDSA signatures: the slot's proposer signs the proposal, and committee
members' attestations are checked by recovering their addresses with `ecrecover`. A quantum attacker who derives the
attester keys (each has signed on-chain) can propose and attest any block on the live rollup versions; together with
a forged epoch proof ([aztec-honk-verifier](aztec-honk-verifier.md)) that releases what the L1 portals hold for those
versions (about USD 81k on 2026-11-17: USD 62.2k for the canonical rollup, USD 19.0k for the previous one), and the
same keys sign slashing votes against honest validators. Each rollup's check is fixed, but Aztec Governance has
registered three new rollup versions since launch, and stake that follows the latest rollup moves without
validators acting. Rated MEDIUM (step 4: fixed by a governance vote and a new rollup version that portals and users
move to; USD 81k exposed, so step 5 does not lower it).

## Mechanism

- `Rollup.propose` → `ValidatorSelectionLib.verifyProposer` (v3 source, `ValidatorSelectionLib.sol` lines 291 and
  296): the proposer's signature over the block digest and over the attestation list, each through
  `SignatureLib.verify` (`ECDSA.recover`, `SignatureLib.sol` line 25). Committee members who signed are recovered
  with `ECDSA.recover` (line 375) to rebuild the committee and match its stored commitment. Bad or too few
  attestations can be challenged afterwards with `InvalidateLib` (`ECDSA.tryRecover`, line 108). Version 0 has the
  same code (lines 250, 256, 339 of its `ValidatorSelectionLib.sol`, excerpted).
- What an attested block can release: once its epoch is proven, `submitEpochRootProof` pays fees out of the version's
  FeeJuicePortal and inserts the block's L2-to-L1 message root into the version's Outbox, from which portals release
  tokens. The proof check is the second gate (PQ-7, separate finding).
- `SlashingProposer.vote` (v3 line 402; v2 line 399; `TallySlashingProposer.vote` line 399 in version 0): the slot's
  proposer signs a slashing vote with EIP-712 over ECDSA; a quorum (65 of 128 slots on v3) executes the slash through
  the Slasher, which a 5-of-9 Safe can veto. Slashed stake leaves the validator; it is not paid to the voters.
- Escape hatch (v3 `0x613ff7d1…`): for 2 of every 112 epochs a bonded, designated proposer proposes by sending the
  transaction itself, without attestations, and proofs of those epochs skip the attestation check
  ([aztec-honk-verifier](aztec-honk-verifier.md)). So the escrow can also be taken with a forged proof alone; the
  attester keys add the other 110 epochs and the slashing votes.
- Pattern PQ-5. The proposal also opens EIP-4844 blob commitments with the point-evaluation precompile (`BlobLib`
  line 150 in v3); that PQ-8 dependency is [aztec-blob-kzg](aztec-blob-kzg.md). Excerpts:
  [`source-excerpts.md`](../evidence/aztec-committee-attestations/source-excerpts.md).

## Evidence

- CHECKED (verified source: Sourcify for version 0, Blockscout for versions 2 and 3, read 2026-11-17): the checks
  above; no function changes the attestation scheme or the verifier (`EPOCH_PROOF_VERIFIER` immutable in v3).
- CHECKED (`eth_call`, block 26,431,459): Registry `0x35b22e09…` lists 4 versions, canonical `0xe37a2663…`;
  Registry, GSE and all live rollups are owned by Governance `0x1102471e…`; GSE `getLatestRollup()` = `0xe37a2663…`;
  active attesters: v3 3,049 (stake that follows the latest rollup, 608.9M AZTEC), v2 50 (10M AZTEC), versions 0
  and 1 none ([`aztec-system.json`](../evidence/aztec-committee-attestations/aztec-system.json)).
- CHECKED (same block): version 0 has proven = pending block 139,350 and no attesters, so no committee can be sampled
  and it can no longer propose; v2 and v3 have pending checkpoints beyond the proven ones (still running).
- CHECKED (Xatu call frames, blocks 26,208,000–26,423,999): contracts calling each version's Inbox or Outbox (the
  portals) and their ERC-20 holdings from Blockscout on 2026-11-17; activity of the added contracts.
- CHECKED (Blockscout): v3 deployed 2026-10-10 (block 26,160,102), v2 2026-06-30, version 1 2026-03-04.
- INFERRED: the precompile trace (to March 2026) predates versions 2 and 3, so they were not in the census.

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0xe37a2663…` Rollup v3 (canonical) | no | $62.2k escrow | 2026-11-16 | 44,053 |
| `0xa2ff1bf7…` SlashingProposer v3 | no | — | 2026-11-16 | 7,807 |
| `0x91ff8bbd…` Rollup v2 | no | $19.0k escrow | 2026-11-16 | 44,350 |
| `0x8a36b8f2…` SlashingProposer v2 | no | — | 2026-10-29 | 4,903 |
| `0x603bb2c0…` Rollup v0 (halted) | no | — | 2026-11-13 | 28 |
| `0x7a318c3d…` TallySlashingProposer v0 | no | — | 2026-03-30 | 0 |

Escrow (2026-11-17, AZTEC at USD 0.010135):
- v3: portals seen using its Inbox/Outbox hold USD 62.0k (OxidePortal `0xcb99c58f…` USD 44.7k DAI, OxidePortal
  `0x2ebfee28…` USD 16.8k sUSDS, four TokenPortals USD 0.5k, four more with nothing); FeeJuicePortal `0x534361be…`
  holds 22,592 AZTEC (USD 229).
- v2: portals hold USD 17.1k (OxidePortal `0xdf410ad4…` USD 14.7k DAI, others USD 2.4k); FeeJuicePortal `0xaf73dd51…`
  holds 181,593 AZTEC (USD 1.8k).
- Portals found only through 30-day activity: the totals are a lower bound.

Not counted: each rollup's own AZTEC (v3 7.26M, v2 11.70M, v0 7.05M, v1 7.50M; USD 71k–119k each) are rewards
already owed to sequencers and provers, which forged blocks do not unlock. Validator stake (618.9M AZTEC, USD 6.27M,
deposited in Governance through the GSE) can be slashed by forged votes, subject to the Safe's veto, but slashed
stake is not paid to the attacker. Version 0 lost its draft `held` value (USD 71k): it is that rollup's owed rewards,
and with no attesters the rollup cannot propose blocks. Version 1 `0xae2001f7…` (halted, owner renounced, no
attesters) checked and left out.

## Remediation

- Aztec Governance `0x1102471eb3378fee427121c9efcea452e4b6b75e` deploys a rollup version whose attestations use
  post-quantum signatures (hash-based or lattice keys, or a STARK proof aggregating them) and registers it with
  `Registry.addRollup` and `GSE.addRollup`. Done three times so far; stake with `moveWithLatestRollup` follows
  automatically, and RewardDistributor rewards go only to the canonical rollup.
- Validators must generate post-quantum attester keys; rotating ECDSA attesters does not help.
- Portal operators (OxidePortal, TokenPortal deployers) and L2 users must move to the new version. Old versions'
  portals stay exposed while they hold funds.
- The governance vote itself is signalled with the same attester keys
  ([aztec-governance-proposer-sig](aztec-governance-proposer-sig.md)), so it has to happen before a CRQC exists.
- No Ethereum protocol change is needed for the attestations. The blob opening is rated separately
  ([aztec-blob-kzg](aztec-blob-kzg.md)).

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated CRITICAL (step 4: pooled funds released by a forged proof or attestation, and the verification cannot change).
- 2026-11-17 review (Review00): CRITICAL -> MEDIUM, step 4: Governance can replace the rollup (it registered versions
  on 2026-03-04, 2026-06-30 and 2026-10-10, and the latest-following stake moved with it), so the fix is a vote plus
  a new version that portals and users move to; exposure USD 81k, so step 5 does not lower it. The draft rollup
  `0x603bb2c0…` is halted; added the live versions v3 `0xe37a2663…` and v2 `0x91ff8bbd…` with their
  SlashingProposers (not in the March 2026 census); escrow measured from their portals; removed the v0 `held` value
  (owed rewards, not releasable); `alternative` sole -> key-rotation-only.
- 2026-11-17 review (Review00, follow-up): MEDIUM kept. Noted the escape-hatch path (proposals without attestations
  during open hatches) and linked the blob opening, now rated in aztec-blob-kzg.
