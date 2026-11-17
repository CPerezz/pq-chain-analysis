---
id: aztec-governance-proposer-sig
title: "Aztec GovernanceProposer: a quantum attacker who recovers enough validators' ECDSA keys can signal any payload to Aztec Governance, have the rollup vote its stake for it, and move up to about USD 6.8M of staked and reward AZTEC"
project: aztec
status: confirmed
severity: MEDIUM
patterns: [PQ-5]
primitives: [ecrecover]
trigger: committee-keys
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x06ef1dcf87e419c48b94a331b252819fadbd63ef"
  implementation: null
  name: GovernanceProposer
  upgradeable: "no"
  admin: none; Governance 0x1102471eb3378fee427121c9efcea452e4b6b75e can replace it with updateGovernanceProposer (a vote)
  value_usd: 6799736
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-13
  txs_30d: 2341
families: []
fix:
  layer: new-deployment
  who_acts: Aztec Governance 0x1102471eb3378fee427121c9efcea452e4b6b75e votes in a GovernanceProposer and rollup version whose proposers sign with post-quantum keys; validators generate those keys
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/aztec-governance-proposer-sig/classification.jsonl
  - evidence/aztec-governance-proposer-sig/onchain.json
  - evidence/aztec-governance-proposer-sig/activity.json
  - evidence/aztec-governance-proposer-sig/source-excerpts.md
  - evidence/aztec-governance-proposer-sig/aztec-system.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_3.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review00 (GovernanceProposer, Governance, GSE, RewardDistributor and rollup v3 source; configuration and voting power reads)
  ref: evidence/aztec-governance-proposer-sig/aztec-system.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: [aztec-committee-attestations, aztec-honk-verifier]
---

## Summary

Aztec Governance takes proposals from the GovernanceProposer, where each slot's block proposer on the canonical
rollup signals a payload, by ECDSA signature or by calling from the proposer's own address; a payload with 600
signals in a 1,000-slot round is proposed, and the rollup then votes all validator stake that follows it in favour
(99.8% of Governance voting power). A quantum attacker who recovers the keys of the proposers of 600 slots (every
validator has signed on-chain) can therefore pass any payload, for example register a rollup that withdraws the
608.9M AZTEC of following stake, and take the RewardDistributor's 62.0M AZTEC: about USD 6.8M on 2026-11-17.
Governance can replace the proposer contract and the rollup by vote. Rated MEDIUM (step 4: a governance vote and a
new rollup version with post-quantum proposer keys).

## Mechanism

- `EmpireBase._internalSignal` (GovernanceProposer source lines 275–312): `signaler =
  selection.getCurrentProposer()` of `getInstance()` = Registry's canonical rollup (line 290); an empty signature
  requires `msg.sender == signaler`, otherwise `getSignalSignatureDigest(payload, slot)` must verify against the
  signaler through `SignatureLib.verify` (`ECDSA.recover`, lines 294–299). Entry points `signal` (line 153) and
  `signalWithSig` (line 165).
- Either way the authority is the proposer's secp256k1 key: attesters must be ECDSA addresses because their block
  attestations are recovered with `ecrecover` ([aztec-committee-attestations](aztec-committee-attestations.md)).
- `submitRoundWinner` (line 178) requires `QUORUM_SIZE` signals (600 of `ROUND_SIZE` 1,000) and calls
  `Governance.propose` (`GovernanceProposer.sol` line 91).
- Anyone can call `Rollup.vote(proposalId)`: `StakingLib.vote` (v3 source) checks the proposal came from the
  GovernanceProposer while this rollup was canonical and votes the rollup's power and the following ("bonus")
  stake in favour with `GSE.vote` and `GSE.voteWithBonus`.
- After `Governance.execute` the payload runs as Governance (any target except the AZTEC token, `Governance.sol`
  line 494). Governance owns the Registry, GSE and RewardDistributor: `GSE.addRollup` makes a new rollup the latest,
  `GSE.withdraw` lets the latest rollup withdraw following stake to itself, and
  `RewardDistributor.recoverFrom` pays out reward AZTEC to the Registry owner's chosen address.
- Pattern PQ-5 (a set of ECDSA signers counted to a quorum). Excerpts:
  [`source-excerpts.md`](../evidence/aztec-governance-proposer-sig/source-excerpts.md).

## Evidence

- CHECKED (verified source: Sourcify for `0x06ef1dcf…`, Blockscout for rollup v3 and RewardDistributor
  `0x555baac4…`, read 2026-11-17): the path above.
- CHECKED (`eth_call`, block 26,431,459): Governance `governanceProposer()` = `0x06ef1dcf…`; `getInstance()` =
  Rollup v3 `0xe37a2663…`; `QUORUM_SIZE` 600, `ROUND_SIZE` 1,000; Governance configuration: voting delay 3 days,
  voting 7 days, execution delay 2 days, quorum 20%, yea margin 33%, minimum 100M AZTEC; GSE `owner()` and Registry
  `owner()` = Governance; RewardDistributor `REGISTRY()` = Registry `0x35b22e09…`
  ([`aztec-system.json`](../evidence/aztec-governance-proposer-sig/aztec-system.json)).
- CHECKED (latest block): Governance `totalPowerNow()` 619.75M AZTEC, of which the GSE holds 618.32M; 7 proposals
  so far; rollup v3 exit delay 4 days.
- CHECKED (Xatu, any function): 2,341 transactions called the GovernanceProposer in 2026-10-16 to 2026-11-16, last
  on 2026-11-13 ([`activity.json`](../evidence/aztec-governance-proposer-sig/activity.json)).
- INFERRED (from source, not executed): a payload calling `Registry.addRollup` and `GSE.addRollup` for an attacker
  rollup lets that rollup call `GSE.withdraw` for every following attester and collect the stake after the
  Governance withdrawal delay.

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0x06ef1dcf…` GovernanceProposer | no | $6.80M escrow (what a captured Governance can move) | 2026-11-13 | 2,341 |

Escrow on 2026-11-17 (AZTEC at USD 0.010135): stake following the latest rollup, 608.9M AZTEC (USD 6.17M), held by
Governance `0x1102471e…` through the GSE; RewardDistributor `0x555baac4…`, 62.0M AZTEC (USD 0.63M). Not counted:
the 10M AZTEC staked directly in rollup v2 (withdrawable only by v2), AZTEC deposited in Governance directly
(Governance cannot call the token), and the rollups' own owed rewards. The 12 days between proposal and execution,
against a 4-day exit delay, let validators who notice exit first, if their withdrawer keys are not also forged.

## Remediation

- Aztec Governance `0x1102471eb3378fee427121c9efcea452e4b6b75e` votes in (`updateGovernanceProposer`, and a new
  rollup version through the Registry and GSE) a proposer contract and rollup whose block proposers sign with
  post-quantum keys; a signature-only fix to the GovernanceProposer is not enough while the proposer's address is
  itself an ECDSA key.
- Validators generate post-quantum keys; withdrawers should move to post-quantum accounts.
- The vote has to pass before a CRQC exists, because the same keys can block or redirect it afterwards.
- No Ethereum protocol change is needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by a new deployment that the operator and users move to).
- 2026-11-17 review (Review00): MEDIUM kept, step 4 (Governance replaces the proposer contract and rollup by
  vote). Corrected the mechanism: the signers are the rotating block proposers counted to a 600-of-1,000 quorum, not
  one operator key (PQ-4 -> PQ-5, `trigger` operator-key -> committee-keys, `alternative` alternative-exists ->
  key-rotation-only since the direct-call path is the same ECDSA key, `role` auxiliary -> core); traced the
  automatic stake vote and measured what a captured Governance controls (USD 6.80M escrow).
