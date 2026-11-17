---
id: espresso-light-client-plonk
title: "Espresso light client: a quantum attacker who recovers the PLONK setup trapdoor (and the permissioned prover's key) can post a false HotShot state and reward root, minting up to 35.9M ESP a day through RewardClaim"
project: espresso
status: confirmed
severity: MEDIUM
patterns: [PQ-7]
primitives: [bn254, sw_bn254]
trigger: trusted-setup
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0x95ca91cea73239b15e5d2e5a74d02d6b5e0ae458"
  implementation: "0x0177b586a949088309227f1a91951571cf770d8c"
  name: ERC1967Proxy → LightClientV3
  upgradeable: "yes"
  admin: "UUPS owner SafeExitTimelock 0x67861f1ef4db9bcaddd8c5e86db92386dd4ec700 (2-day delay; proposers 3-of-5 Safes 0x5e37b8038615ef3d75cf28b5982c4cbf065401fb and 0x34f5af5158171ffd2475d21db5fc3b311f221982)"
  value_usd: 2627306
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-15
  txs_30d: 367
families: []
fix:
  layer: contract-upgrade
  who_acts: "Espresso: SafeExitTimelock 0x67861f1ef4db9bcaddd8c5e86db92386dd4ec700 (proposals from 3-of-5 Safes 0x5e37b803… / 0x34f5af51…) upgrades LightClient to a hash-based proof; RewardClaim's PAUSER_ROLE holder (not read) can pause claims meanwhile; RewardClaim admin is SafeExitTimelock 0x6e7941fe8f9c751363b5c156419a0c8912dea6b2"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/espresso-light-client-plonk/classification.jsonl
  - evidence/espresso-light-client-plonk/onchain.json
  - evidence/espresso-light-client-plonk/activity.json
  - evidence/espresso-light-client-plonk/source-excerpts.md
  - evidence/espresso-light-client-plonk/escrow.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_3.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review13 (re-read LightClientV3 and RewardClaim source; timelock, prover and RewardClaim reads)
  ref: evidence/espresso-light-client-plonk/escrow.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: []
---

## Summary

Espresso's L1 light client accepts a new HotShot state, next stake table and reward `authRoot` only with a PLONK proof
verified over BN254 (PQ-7). A quantum attacker who recovers the trusted-setup trapdoor can prove a false state; the
contract also requires the sender to be the permissioned prover, an EOA whose key is equally recoverable. The
`authRoot` feeds Espresso's RewardClaim contract, which mints ESP to anyone with a Merkle proof against it, capped at
35.9M ESP per day (about USD 2.6M at USD 0.073), until the pauser stops it; integrated chains reading the light client
would also see false Espresso state. Rated MEDIUM (step 4): the light client is a UUPS proxy that Espresso can upgrade
through its timelock and Safes.

## Mechanism

- `LightClientV3.newFinalizedState(newState, nextStakeTable, newAuthRoot, proof)` (`contracts/src/LightClientV3.sol`
  47-96): reverts unless `msg.sender == permissionedProver` when that mode is on (lines 53-55), checks view/height
  ordering and epoch rules, then calls `verifyProof` (line 82), which runs `PlonkVerifierV3.verify(vk, publicInput,
  proof)` with the verifying key embedded in `LightClientStateUpdateVKV3` (line 157; pairing check in
  `contracts/lib/bn254/src/BN254.sol`). On success it stores `finalizedState` and `authRoot` (lines 83-85) and, at an
  epoch root, the next voting stake table.
- `RewardClaim.claimRewards(lifetimeRewards, authData)` (`0x67c966a0…`, implementation `0xedeb05e2…`,
  `contracts/src/RewardClaim.sol` 241-259) requires `_verifyAuthRoot` (lines 338-363: a 160-level Merkle proof hashed
  with seven inputs must equal `lightClient.authRoot()`) and then calls `espToken.mint(claimer, amount)`, subject to
  `dailyLimitWei`.
- The verifying key is a library constant, so changing the proof system needs an implementation upgrade. Pattern PQ-7.
  Excerpts: [`source-excerpts.md`](../evidence/espresso-light-client-plonk/source-excerpts.md).

## Evidence

- CHECKED (verified source, Sourcify and Blockscout, read 2026-11-17): the two paths above.
- CHECKED (on-chain, block 26,431,581, [`escrow.json`](../evidence/espresso-light-client-plonk/escrow.json)): proxy
  implementation `0x0177b586…` (`getVersion` 3.0.0); `owner()` = SafeExitTimelock `0x67861f1e…`, `getMinDelay` 172,800 s;
  its proposers (RoleGranted logs, block 24,348,349) are two 3-of-5 Safes `0x5e37b803…` and `0x34f5af51…`;
  `permissionedProver()` = `0x4fd0ac6922da5c96b6f94202ece60e8fe3bf3947`, code size 0 (an EOA).
- CHECKED (same block): RewardClaim `0x67c966a0ecdd5c33608be7810414e5b54da878d8` (address from Espresso's docs) has
  `lightClient()` = this proxy, `espToken()` = ESP `0x031de51f…`, `dailyLimitWei` 35.9M ESP, `totalClaimed` 20.35M ESP,
  not paused, `currentAdmin()` = SafeExitTimelock `0x6e7941fe…` (14-day delay). ESP `rewardClaim()` = RewardClaim;
  total supply 3.61B ESP. StakeTable `0xcef474d3…` also references this light client and holds 1.07B ESP.
- CHECKED (Blockscout, 2026-11-17): ESP price USD 0.073184; circulating market cap USD 53.9M.
- CHECKED (precompile trace, 12 months to March 2026, `curated_contracts.csv` `txs_y1`): BN254 precompiles in 774
  transactions. Xatu: 367 transactions 2026-10-16 to 2026-11-16, last 2026-11-15
  ([`activity.json`](../evidence/espresso-light-client-plonk/activity.json)).
- INFERRED: the StakeTable does not release staked ESP on light-client state (withdrawals are by the delegator's own
  transaction); not read in source. Which integrated chains read the light client on mainnet was not established.

## Impact and exposure

| Contract | Upgradeable | Exposed | Last active | 30-day txs |
|---|---|---|---|---|
| `0x95ca91ce…` LightClient (proxy → LightClientV3) | yes (timelock) | USD 2.63M per day (escrow, RewardClaim mint limit) | 2026-11-15 | 367 |

`value_usd` is one day's RewardClaim limit at the ESP price on 2026-11-17 (35.9M ESP × USD 0.073184); the attacker can
repeat daily until RewardClaim is paused, and minting dilutes all ESP holders rather than draining an escrow. The light
client holds nothing itself. The finding has no other mainnet deployments.

## Remediation

- Post-quantum replacement: a hash-based (STARK/FRI) proof of the light-client update, plus post-quantum signatures for
  the HotShot stake table that the circuit checks today with Schnorr/BLS over pairing-friendly curves. That is a
  protocol redesign for Espresso, deployed as a LightClient upgrade through the SafeExitTimelock (2-day delay).
- Until then: keep permissioned-prover mode with the prover moved to a post-quantum contract account; RewardClaim's
  pauser can stop minting, and its admin can lower `dailyLimitWei`.
- No Ethereum protocol change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review13): MEDIUM unchanged, step 4: UUPS upgrade by the Espresso timelock and Safes. Found the consumer: RewardClaim `0x67c966a0…` mints ESP against `authRoot` (35.9M ESP per day cap, about USD 2.63M, set as `escrow`); read timelock roles and the permissioned prover (an EOA).
