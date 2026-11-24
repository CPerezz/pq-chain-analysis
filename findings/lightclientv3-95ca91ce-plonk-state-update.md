---
id: lightclientv3-95ca91ce-plonk-state-update
format: 2
title: Quantum attacker could post false Espresso states and mint ESP rewards
status: confirmed
severity: MEDIUM
justification: A quantum computer can forge the proof and the prover's key; the fix needs the timelock owner to
  upgrade or reconfigure.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x95ca91cea73239b15e5d2e5a74d02d6b5e0ae458'
  name: LightClientV3
  project: espresso
  code: verified
  code_url: https://etherscan.io/address/0x0177b586a949088309227f1a91951571cf770d8c#code
  proxy_of: '0x0177b586a949088309227f1a91951571cf770d8c'
  copies: 1
  upgradeable: 'yes'
  admin: '0x67861f1ef4db9bcaddd8c5e86db92386dd4ec700'
value:
  usd: 0
  whose: users
  basis: held
activity: {}
impact: funds-loss
action: Upgrade to a post-quantum proof and post-quantum state signatures; meanwhile set the permissioned prover
  to a post-quantum account.
evidence_level: source
checks:
- id: gate
  source: '0x0177b586a949088309227f1a91951571cf770d8c'
  file: contracts/src/LightClientV3.sol
  line: 53
  has: if (isPermissionedProverEnabled() && msg.sender != permissionedProver) {
  says: newFinalizedState reverts unless the sender is the permissioned prover while that mode is on
  for:
  - evidence-1
  - what
- id: prover-on
  call: '0x95ca91cea73239b15e5d2e5a74d02d6b5e0ae458'
  fn: permissionedProver()(address)
  is: '0x4fd0ac6922da5c96b6f94202ece60e8fe3bf3947'
  says: the permissioned prover is set, so the mode is on
  for:
  - evidence-1
  - what
- id: prover-code
  code: '0x4fd0ac6922da5c96b6f94202ece60e8fe3bf3947'
  is: empty
  says: the prover is an account without code
  for:
  - evidence-1
  - justification
  - what
- id: prover-nonce
  nonce: '0x4fd0ac6922da5c96b6f94202ece60e8fe3bf3947'
  min: 2643
  says: the prover has sent at least 2,643 transactions, so its public key is on-chain
  for:
  - evidence-1
  - justification
  - what
- id: verify
  source: '0x0177b586a949088309227f1a91951571cf770d8c'
  file: contracts/src/LightClientV3.sol
  line: 157
  has: if (!PlonkVerifierV3.verify(vk, publicInput, proof)) {
  says: the update is accepted only if the PLONK proof verifies
  for:
  - evidence-1
  - justification
  - what
- id: pairing
  source: '0x0177b586a949088309227f1a91951571cf770d8c'
  file: contracts/lib/bn254/src/BN254.sol
  line: 257
  has: success := staticcall(gas(), 8, mPtr, 0x180, 0x00, 0x20)
  says: the PLONK check ends in a BN254 pairing through precompile 8
  for:
  - evidence-1
  - justification
  - what
- id: store
  source: '0x0177b586a949088309227f1a91951571cf770d8c'
  file: contracts/src/LightClientV3.sol
  lines:
  - 82
  - 85
  has: authRoot = newAuthRoot;
  says: after the proof verifies, the new state and authRoot are stored
  for:
  - what
- id: rc-lc
  call: '0x67c966a0ecdd5c33608be7810414e5b54da878d8'
  fn: lightClient()(address)
  is: '0x95ca91cea73239b15e5d2e5a74d02d6b5e0ae458'
  says: RewardClaim reads this light client
  for:
  - evidence-2
  - what
- id: rc-root
  source: '0xedeb05e2014bee6163e6354ce2a2ec54509f11da'
  file: contracts/src/RewardClaim.sol
  line: 363
  has: return uint256(authRoot) == lightClient.authRoot();
  says: a claim is valid when its Merkle-derived root equals the light client's authRoot
  for:
  - evidence-2
  - what
- id: rc-mint
  source: '0xedeb05e2014bee6163e6354ce2a2ec54509f11da'
  file: contracts/src/RewardClaim.sol
  lines:
  - 254
  - 259
  has: espToken.mint(claimer, amountToClaim);
  says: after the root check, claimRewards mints ESP to the claimer
  for:
  - evidence-2
  - what
  - whose
- id: rc-limit
  call: '0x67c966a0ecdd5c33608be7810414e5b54da878d8'
  fn: dailyLimitWei()(uint256)
  is: '35900000000000000000000000'
  says: claims are capped at 35.9M ESP a day
  for:
  - evidence-2
  - what
- id: rc-paused
  call: '0x67c966a0ecdd5c33608be7810414e5b54da878d8'
  fn: paused()(bool)
  is: false
  says: RewardClaim is not paused
  for:
  - evidence-2
- id: upgrade
  source: '0x0177b586a949088309227f1a91951571cf770d8c'
  file: contracts/src/LightClient.sol
  line: 184
  has: function _authorizeUpgrade(address newImplementation) internal virtual override onlyOwner {
  says: the owner can upgrade the light client
  for:
  - action
  - evidence-3
  - justification
- id: setprover
  source: '0x0177b586a949088309227f1a91951571cf770d8c'
  file: contracts/src/LightClient.sol
  lines:
  - 305
  - 313
  has: function setPermissionedProver(address prover) public virtual onlyOwner {
  says: the owner can replace the permissioned prover
  for:
  - action
  - evidence-3
  - justification
- id: owner
  call: '0x95ca91cea73239b15e5d2e5a74d02d6b5e0ae458'
  fn: owner()(address)
  is: '0x67861f1ef4db9bcaddd8c5e86db92386dd4ec700'
  says: the owner of the light client
  for:
  - action
  - evidence-3
  - justification
- id: delay
  call: '0x67861f1ef4db9bcaddd8c5e86db92386dd4ec700'
  fn: getMinDelay()(uint256)
  is: 172800
  says: the owner is a timelock with a 172,800-second (two-day) minimum delay
  for:
  - evidence-3
  - justification
- id: rc-esp
  call: '0x67c966a0ecdd5c33608be7810414e5b54da878d8'
  fn: espToken()(address)
  is: '0x031de51f3e8016514bd0963d0b2ab825a591db9a'
  says: RewardClaim mints the Espresso (ESP) token, so forged claims create new ESP that dilutes its holders
  for:
  - what
  - whose
- id: daily-reset
  source: '0xedeb05e2014bee6163e6354ce2a2ec54509f11da'
  file: contracts/src/RewardClaim.sol
  line: 278
  has: _claimedToday = 0;
  says: the mint cap resets every day
  for:
  - what
- id: rc-max
  source: '0xedeb05e2014bee6163e6354ce2a2ec54509f11da'
  file: contracts/src/RewardClaim.sol
  line: 77
  has: uint256 public constant MAX_DAILY_LIMIT_BASIS_POINTS = 500; // 5%
  says: the daily cap can be set up to 5% of total supply
  for:
  - what
- id: rc-setlimit
  source: '0xedeb05e2014bee6163e6354ce2a2ec54509f11da'
  file: contracts/src/RewardClaim.sol
  lines:
  - 208
  - 225
  has: require(basisPoints <= MAX_DAILY_LIMIT_BASIS_POINTS, DailyLimitTooHigh());
  says: setDailyLimit, callable by the admin role, sets the cap to up to 5% of current supply
  for:
  - what
- id: rc-admin
  call: '0x67c966a0ecdd5c33608be7810414e5b54da878d8'
  fn: currentAdmin()(address)
  is: '0x6e7941fe8f9c751363b5c156419a0c8912dea6b2'
  says: RewardClaim's admin at the block
  for:
  - what
- id: rc-admin-delay
  call: '0x6e7941fe8f9c751363b5c156419a0c8912dea6b2'
  fn: getMinDelay()(uint256)
  is: 1209600
  says: RewardClaim's admin is a timelock with a 14-day minimum delay
  for:
  - what
- id: circuit-sig
  source: '0x0177b586a949088309227f1a91951571cf770d8c'
  file: contracts/src/LightClientV3.sol
  lines:
  - 127
  - 131
  has: so that circuit will verify signature over msg_signed
  says: the circuit verifies a signature over the hash of the new state, stake table and authRoot
  for:
  - action
  - what
- id: schnorr-input
  source: '0x0177b586a949088309227f1a91951571cf770d8c'
  file: contracts/src/LightClientV3.sol
  line: 139
  has: publicInput[1] = BN254.ScalarField.unwrap(votingStakeTableState.schnorrKeyComm);
  says: the proof's public inputs commit to the stake table's Schnorr keys, which sign the state
  for:
  - action
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review13 (re-read LightClientV3 and RewardClaim source; timelock, prover and RewardClaim reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews:
- who: r-95ca91ce, the row's refuter
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Second refuter (D-028) agrees on every part. Both refuters agree; Claude read the sheet. MEDIUM,
    kept as before.'
related: []
---

## What happens

Espresso's light client takes reward roots on a BN254 PLONK proof from its permissioned prover. A quantum attacker with the prover key and either the trapdoor or the stake table's Schnorr keys could mint ESP via a false root. The cap is 35.9M ESP a day; the admin can raise it to 5% of supply.

## Evidence

- [newFinalizedState](https://etherscan.io/address/0x0177b586a949088309227f1a91951571cf770d8c#code) requires the prover, an account without code that has sent 2,643 transactions, then checks a pairing proof.
- [RewardClaim](https://etherscan.io/address/0xedeb05e2014bee6163e6354ce2a2ec54509f11da#code) mints ESP to a claimer whose Merkle proof matches this light client's root, up to 35.9M ESP a day; it is not paused.
- The [owner](https://etherscan.io/address/0x67861f1ef4db9bcaddd8c5e86db92386dd4ec700), a timelock with a two-day delay, can upgrade the light client or replace its prover.

## Reviewer notes

### Mechanism

Proxy 0x95ca91ce (EIP-1967 slot -> LightClientV3 0x0177b586, getVersion 3.0.0). newFinalizedState(newState, nextStakeTable, newAuthRoot, proof) (LightClientV3.sol 47-96) reverts unless msg.sender == permissionedProver while that mode is on (53-55; on at the block, prover 0x4fd0ac69 has no code and nonce 2643, so its public key is on-chain). It checks view/height ordering and epoch rules, then verifyProof (110-160) hashes the state, next stake table and authRoot into one public input and runs PlonkVerifierV3.verify with the verifying key from a pure library (105); the final check is a BN254 pairing through precompile 8 (PlonkVerifierV3 163, BN254.sol 257). On success it stores finalizedState and authRoot (83-85). Public input also commits to the stake table's Schnorr keys (schnorrKeyComm, 139), which the circuit checks signed the state (127-131); a quantum attacker recovering those keys proves a false state with no trapdoor, so a new prover alone does not close this. RewardClaim (proxy 0x67c966a0 -> 0xedeb05e2) holds lightClient = this proxy; claimRewards (241-262) checks the daily limit, requires a 160-level Merkle root hashed with seven inputs to equal lightClient.authRoot() (338-363) and calls espToken.mint (259). dailyLimitWei is 35.9M ESP; not paused. Fix paths: _authorizeUpgrade is onlyOwner (LightClient.sol 184); setPermissionedProver and disablePermissionedProverMode are onlyOwner (305-325). Owner is a TimelockController-like contract with getMinDelay 172,800 s.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: unused implementation: this is the proxy users call; its implementation slot holds 0x0177b586 and finalizedState and authRoot are set at the block.
- Ruled out: key-state: permissioned-prover mode is on and the prover is an account without code with nonce 2,643, so a quantum computer can derive its key from its signatures.
- Ruled out: path closed: the light client has no pause and RewardClaim's paused() is false at the block.
- Ruled out: LOW rating: setting a post-quantum prover account removes outside forgery, but needs the prover's operator to move to such an account and the timelock to act; the pairing verification itself changes only by upgrade, so MEDIUM.
- Ruled out: who holds the timelock's proposer roles (Safes in the old finding) was not re-read: no wide log scan; not needed for the card.
- Ruled out: the dollar value is the row's escrow figure: one day's 35.9M ESP mint cap at the ESP price of 2026-11-17. The light client itself holds nothing; the cap is re-read here, the price is not.
- Ruled out: that only RewardClaim can mint ESP: the ESP token proxy 0x031de51f runs implementation 0x0500e355, whose source is not in hand, so the card does not claim it; rewardClaim() on the token returns this RewardClaim.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
