---
id: chainlink-vrf-secp256k1
title: "Chainlink VRF: a quantum attacker who recovers an oracle's secp256k1 VRF key can predict the randomness of pending requests on VRF coordinators v2 and v2.5 and win the games and draws that consume it"
project: chainlink
status: confirmed
severity: MEDIUM
patterns: [PQ-11]
primitives: [ecrecover, sw_secp256k1]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0xd7f86b4b8cae7d942340ff628f82735b7a20893a"
  implementation: null
  name: VRFCoordinatorV2_5
  upgradeable: config-only
  admin: "owner Safe 0xcc4b5b07316be81ed6edb44ca61e4cab28a1950d (4 of 12; registerProvingKey/deregisterProvingKey); subscription owners can migrate(subId, newCoordinator); read at block 26,431,454"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 31623
- address: "0x271682deb8c4e0901d1a1550ad2e64d568e69909"
  implementation: null
  name: VRFCoordinatorV2
  upgradeable: config-only
  admin: "owner 0x463219821e151c0c44364c27833e39386c48e64f (unverified owner contract, likely VRFOwner), whose owner is Safe 0xcc4b5b07316be81ed6edb44ca61e4cab28a1950d (4 of 12); read at block 26,431,454"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-05
  txs_30d: 13
families: []
fix:
  layer: new-deployment
  who_acts: "Chainlink (Safe 0xcc4b5b07316be81ed6edb44ca61e4cab28a1950d, 4 of 12) deploys a coordinator with a post-quantum VRF; each subscription owner and consumer contract moves to it"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/chainlink-vrf-secp256k1/classification.jsonl
  - evidence/chainlink-vrf-secp256k1/onchain.json
  - evidence/chainlink-vrf-secp256k1/activity.json
  - evidence/chainlink-vrf-secp256k1/source-excerpts.md
  - evidence/chainlink-vrf-secp256k1/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_0.jsonl,out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review11 (Claude), finding review
  ref: evidence/chainlink-vrf-secp256k1/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: [chainlink-ocr-don-ecdsa-signers]
---

## Summary

Chainlink VRF v2 and v2.5 prove each random value with an ECVRF proof on secp256k1 against an oracle's registered
proving key (PQ-11). The public key is on-chain, so a quantum attacker can recover the secret key and compute the random
words of every pending request as soon as the request block is mined, before the oracle answers; consumers that let
users act between request and fulfilment (bets, mints, draws) can be beaten. The coordinators' own LINK and ETH
($1.1M of subscription balances) are not exposed, and what the consumers hold is not measured. Rated MEDIUM (step 4):
the fix is a new coordinator with a post-quantum VRF that subscriptions and consumers move to.

## Mechanism

- `VRFCoordinatorV2_5.fulfillRandomWords(proof, rc, onlyPremium)` (line 445) → `_getRandomnessFromProof` (line 369):
  the proving key must be registered by the owner (`s_provingKeys`), the request commitment must match, the seed is
  mixed with the request block's hash, and `VRF._randomValueFromVRFProof` checks the ECVRF proof (VRF.sol uses
  `ecrecover` as a scalar-multiplication gadget and `modexp` for secp256k1 square roots). V2's `fulfillRandomWords`
  (line 556) does the same with `getRandomnessFromProof`.
- Neither function restricts the caller; payment goes to the subscription's accounting, not to the caller.
- ECVRF output is unique for a key and seed: the key holder learns the output early but cannot pick it. The proving key
  is set by `registerProvingKey` (owner); rotating to another secp256k1 key does not help.

## Evidence

- CHECKED (verified source, Sourcify): `fulfillRandomWords` and `_getRandomnessFromProof` in VRFCoordinatorV2_5 and
  VRFCoordinatorV2; VRF.sol ([`source-excerpts.md`](../evidence/chainlink-vrf-secp256k1/source-excerpts.md),
  [`notes.md`](../evidence/chainlink-vrf-secp256k1/notes.md)).
- CHECKED (on-chain read, block 26,431,454): V2.5 `owner()` = Safe `0xcc4b5b07…` (4 of 12); V2 `owner()` =
  `0x46321982…`, an unverified contract whose `owner()` is the same Safe. Neither coordinator is a proxy.
- CHECKED (on-chain read, block 26,431,214): subscription balances held, V2.5 $519k and V2 $571k
  ([`onchain.json`](../evidence/chainlink-vrf-secp256k1/onchain.json)); not the exposure.
- CHECKED (Xatu, any function): V2.5 31,623 transactions 2026-10-16 to 2026-11-16, last 2026-11-16; V2 13, last
  2026-11-05 ([`activity.json`](../evidence/chainlink-vrf-secp256k1/activity.json)).
- INFERRED: `0x46321982…` is Chainlink's VRFOwner wrapper (selectors only).

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0xd7f86b4b…` VRFCoordinatorV2_5 | config-only | not measured (consumers' prizes) | 2026-11-16 | 31,623 |
| `0x271682de…` VRFCoordinatorV2 | config-only | not measured (consumers' prizes) | 2026-11-05 | 13 |

The `held` values from the draft ($519k and $571k) were removed: they are subscription balances that a forged proof
cannot redirect. What an attacker gains is what the consumer contracts pay out on random outcomes, spread over every
consumer and not measured here. Yearly pre-quantum counts from the census: V2.5 14,154 transactions, V2 308 (`txs_y1`).

## Remediation

- Chainlink (Safe `0xcc4b5b07…`, 4 of 12) deploys a coordinator that verifies a post-quantum VRF (for example a
  hash-based VRF proved with a STARK) and registers keys there. V2.5 subscription owners call
  `migrate(subId, newCoordinator)` and consumers repoint (`setCoordinator` in VRFConsumerBaseV2Plus); V2 consumers have
  to move to a new coordinator.
- No protocol change is needed. Consumers can reduce the window by not letting users act between request and
  fulfilment.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review11): MEDIUM unchanged (step 4: new coordinator that subscriptions and consumers move to). Removed the held values ($519k, $571k: subscription balances a forged proof cannot take); the attacker predicts, not chooses, the randomness. V2 owner traced to the same 4-of-12 Safe through 0x46321982….
