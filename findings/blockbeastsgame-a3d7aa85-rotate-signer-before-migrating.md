---
id: blockbeastsgame-a3d7aa85-rotate-signer-before-migrating
format: 2
title: Reward claims stop if the reward signer moves its account to real code
status: confirmed
severity: INFORMATIONAL
justification: A reward signer with real code is refused; the owner can set a new signer before that account moves.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa3d7aa85ac01a085d6838845abefc64f28636b4a'
  name: BlockBeastsGame
  code: verified
  code_url: https://etherscan.io/address/0xa3d7aa85ac01a085d6838845abefc64f28636b4a#code
  copies: 1
  upgradeable: 'no'
  admin: '0x8a332ae28897374d04d80c9617dd99e46e8fea5a'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 16
  last: 2026-11-17
impact: liveness
action: Call setRewardSigner with a new key before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xa3d7aa85ac01a085d6838845abefc64f28636b4a'
  file: project/contracts/BlockBeastsGame.sol
  line: 79
  has: if (ECDSA.recover(digest, signature) != rewardSigner) revert InvalidSignature();
  says: claimReward reverts unless the ECDSA-recovered address is the stored rewardSigner
  for:
  - evidence-1
  - justification
  - what
- id: ecrecover
  source: '0xa3d7aa85ac01a085d6838845abefc64f28636b4a'
  file: npm/@openzeppelin/contracts@5.6.1/utils/cryptography/ECDSA.sol
  line: 190
  has: address signer = ecrecover(hash, v, r, s);
  says: ECDSA.recover is a plain ecrecover, with no path for a signer that has code
  for:
  - evidence-1
  - justification
  - what
- id: mint
  source: '0xa3d7aa85ac01a085d6838845abefc64f28636b4a'
  file: project/contracts/BlockBeastsGame.sol
  line: 82
  has: token.mint(msg.sender, amount);
  says: a valid claim mints the reward tokens to the caller
  for:
  - what
- id: minter
  call: '0xdbec2a27f306c28a7c5ae0ef05d7a83b8b456292'
  fn: minter()(address)
  is: '0xa3d7aa85ac01a085d6838845abefc64f28636b4a'
  says: the game is the reward token's minter
  for:
  - what
- id: setter
  source: '0xa3d7aa85ac01a085d6838845abefc64f28636b4a'
  file: project/contracts/BlockBeastsGame.sol
  lines:
  - 121
  - 125
  has: rewardSigner = newSigner;
  says: setRewardSigner, onlyOwner, stores a new reward signer
  for:
  - action
  - evidence-3
  - justification
  - what
- id: setter-owner
  source: '0xa3d7aa85ac01a085d6838845abefc64f28636b4a'
  file: project/contracts/BlockBeastsGame.sol
  line: 121
  has: function setRewardSigner(address newSigner) external onlyOwner {
  says: only the owner can call setRewardSigner
  for:
  - notes
- id: owner
  call: '0xa3d7aa85ac01a085d6838845abefc64f28636b4a'
  fn: owner()(address)
  is: '0x8a332ae28897374d04d80c9617dd99e46e8fea5a'
  says: the owner that can set a new signer
  for:
  - action
  - evidence-2
  - evidence-3
  - justification
  - what
- id: signer
  call: '0xa3d7aa85ac01a085d6838845abefc64f28636b4a'
  fn: rewardSigner()(address)
  is: '0x8a332ae28897374d04d80c9617dd99e46e8fea5a'
  says: the stored reward signer, the same account as the owner
  for:
  - action
  - evidence-2
  - what
- id: signer-code
  code: '0x8a332ae28897374d04d80c9617dd99e46e8fea5a'
  is: delegation
  target: '0x63c0c19a282a1b52b07dd5a65b58948a07dae32b'
  says: the signer's account holds an EIP-7702 delegation, not real code
  for:
  - evidence-2
  - what
- id: not-paused
  call: '0xa3d7aa85ac01a085d6838845abefc64f28636b4a'
  fn: paused()(bool)
  is: false
  says: the contract is not paused
  for:
  - notes
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews:
- who: r-a3d7aa85, the row's refuter
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  note: 'disagree: breaks-by-itself: the dossier''s own replay of a real claim (0xf48860ab...ea1c) fails under ''eip8151''
    while it succeeds under ''today'', with the signer unmigrated. The card is silent on this; it should at least
    flag that claims break at activation independent of any migration, or route it to a rated finding if the study''s
    rules call for one. I could not run an ''eip8151_more_gas'' replay (not in the dossier) to say why it fails,
    only that it does.; what-3 / evidence-2: the only dossier replay with a'
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: Wording pass (''real code''). The fresh refuter held the mechanism but objected that a real claim
    (tx 0xf48860ab…, block 26,373,884, index 18) fails under EIP-8151 alone and that the delegated run fails too.
    Claude replayed it on the fork engine: as sent it reverts (75,644 of 75,838 gas); with 300,000 more gas it succeeds
    (78,058); with a delegation at the signer and more gas it succeeds; with real code at the signer and more gas
    it reverts (38,140). So the activation-day failure is the sender''s gas limit, which belongs to the row sender-gas-limits|0xa3d7aa85…
    (wave 1; these replays go to it), and the card''s claims hold. Kept.'
related: []
---

## What happens

This game mints reward tokens to a player who presents a claim signed by its stored reward signer. If that signer's account takes real code, claims are refused until the owner sets a new signer. The signer is the owner's own account, today an EIP-7702 delegation, which still counts.

## Evidence

- [claimReward](https://etherscan.io/address/0xa3d7aa85ac01a085d6838845abefc64f28636b4a#code) recovers the claim's signature with ECDSA and reverts unless it comes from the stored reward signer.
- The [reward signer](https://etherscan.io/address/0x8a332ae28897374d04d80c9617dd99e46e8fea5a) is also the owner. Its account holds an EIP-7702 delegation, not real code.
- [setRewardSigner](https://etherscan.io/address/0xa3d7aa85ac01a085d6838845abefc64f28636b4a#code) lets the owner store a new reward signer.

## Reviewer notes

### Mechanism

claimReward (BlockBeastsGame.sol, lines 68-84; not paused at the block) builds an EIP-712 digest over the caller, runId, amount and deadline, and at line 79 reverts with InvalidSignature unless ECDSA.recover returns rewardSigner. ECDSA.recover (OpenZeppelin 5.6.1) is a plain ecrecover (ECDSA.sol line 190); there is no ERC-1271 branch. On a match the run is marked claimed and token.mint mints up to 60 tokens to the caller; the game is the token's minter. rewardSigner is set in the constructor and replaced by setRewardSigner (lines 121-125, onlyOwner). At the block rewardSigner and owner are the same account, 0x8a33...ea5a, whose code is an EIP-7702 delegation to 0x63c0...e32b; EIP-8151 still recovers a delegated account. If that account takes real code, every claim reverts until the owner calls setRewardSigner; since the owner is that same account, its new code has to be able to make that call (or the key is rotated first). The game holds no ETH and no priced tokens; nothing is locked, players' already minted tokens are unaffected.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size path for a signer with code: none; line 79 uses ECDSA.recover and ECDSA.sol line 190 is ecrecover.
- Ruled out: the key being unset or already real code: rewardSigner() returns 0x8a33...ea5a, whose code is a 23-byte delegation indicator; 11 recoveries of it in the trace window.
- Ruled out: the setter being dead: owner() is 0x8a33...ea5a, not zero; setRewardSigner is onlyOwner and writes rewardSigner (line 124).
- Ruled out: a permanent pause: paused() is false; the owner can pause and unpause.
- Ruled out: a direct path to the same mint without a signature: BeastToken.mint accepts only its minter, which is this game, and the game calls it only in claimReward. The token's owner (the same account) could name another minter with setMinter.
- Ruled out: a later recheck of a signature others relied on: the signature is checked once, in the claim itself; an unclaimed voucher is a promise of the operator's own signer, not something a third party acted on.
- Ruled out: breaking by itself: the replay of 0xf48860ab under EIP-8151 alone reverts, but that transaction was sent with gas limit 75,838 and used 74,958; the 3,100 extra gas does not fit. The contract passes no fixed gas to the precompile (scan: ec_gas_const null). That is the sender's gas limit, the separate row sender-gas-limits for this address, not this notice. Because of it the signer-with-code replay is not clean evidence, so the evidence level is source.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
