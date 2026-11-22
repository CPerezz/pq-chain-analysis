---
id: game-52d757cb-fixed-gas-recovery
format: 2
title: Dice game refunds every bet instead of playing it once EIP-8151 is live
status: candidate
severity: CRITICAL
justification: 'No update path: the fixed gas makes the check fail for good under EIP-8151, whatever the contract
  holds then.'
category: breaks-at-activation
pattern: PQ-14
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x52d757cb8be2ebd32af051b26898bce28ec19f13'
  name: Game
  code: verified
  code_url: https://etherscan.io/address/0x52d757cb8be2ebd32af051b26898bce28ec19f13#code
  copies: 1
  upgradeable: 'no'
  admin: '0xa0cb1378459c42c9765c53038d0d619991d56fd4'
value:
  usd: 15
  whose: operator
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Retire this game before EIP-8151 activates and withdraw its balance with getFund; its proof check cannot
  be changed.
evidence_level: source
checks:
- id: gas3000
  source: '0x52d757cb8be2ebd32af051b26898bce28ec19f13'
  file: Game.sol
  line: 1230
  has: ret := call(3000, 1, 0, size, 128, size, 32)
  says: the recovery is called with a constant 3,000 gas and its output is read from the input buffer
  for:
  - evidence-1
  - justification
  - what
- id: bytecode-gas
  bytecode: '0x52d757cb8be2ebd32af051b26898bce28ec19f13'
  has: 6001610bb8f1
  says: the deployed code calls address 0x01 with a constant 3,000 gas
  for:
  - evidence-1
- id: compare
  source: '0x52d757cb8be2ebd32af051b26898bce28ec19f13'
  file: Game.sol
  lines:
  - 1068
  - 1072
  has: if (address(keccak256(pubkey)) == signer) return true;
  says: the recovered address must equal the address of the oracle's key, otherwise the signature is rejected
  for:
  - evidence-1
  - justification
  - what
- id: refund
  source: '0x52d757cb8be2ebd32af051b26898bce28ec19f13'
  file: Game.sol
  lines:
  - 2422
  - 2428
  has: if (oraclize_randomDS_proofVerify__returnCode(myId, result, proof) != 0) {
  says: a bet whose proof fails is refunded its amount instead of being played
  for:
  - evidence-2
  - justification
  - what
- id: lottery
  source: '0x52d757cb8be2ebd32af051b26898bce28ec19f13'
  file: Game.sol
  line: 2462
  has: require(oraclize_randomDS_proofVerify__returnCode(myId, result, proof) == 0);
  says: a lottery draw reverts when the proof fails
  for:
  - notes
- id: getfund
  source: '0x52d757cb8be2ebd32af051b26898bce28ec19f13'
  file: Game.sol
  lines:
  - 2403
  - 2405
  has: function getFund(uint weiAmount) external onlyOwner {
  says: the owner can withdraw any amount of ETH from the game
  for:
  - action
  - justification
- id: owner
  call: '0x52d757cb8be2ebd32af051b26898bce28ec19f13'
  fn: owner()(address)
  is: '0xa0cb1378459c42c9765c53038d0d619991d56fd4'
  says: the owner at the block
  for:
  - action
  - what
  - whose
- id: owner-nonce
  nonce: '0xa0cb1378459c42c9765c53038d0d619991d56fd4'
  min: 1
  says: the owner account has sent transactions
  for:
  - action
- id: no-upgrade
  selector: '0x52d757cb8be2ebd32af051b26898bce28ec19f13'
  fn: upgradeTo(address)
  absent: true
  says: the code has no upgrade function
  for:
  - action
  - justification
- id: player0
  call: '0x52d757cb8be2ebd32af051b26898bce28ec19f13'
  fn: players(uint256)(address)
  args:
  - 0
  is: '0xa0cb1378459c42c9765c53038d0d619991d56fd4'
  says: the first address that ever bet is the owner
  for:
  - what
  - whose
- id: player1
  call: '0x52d757cb8be2ebd32af051b26898bce28ec19f13'
  fn: players(uint256)(address)
  args:
  - 1
  reverts: true
  says: no second address ever bet
  for:
  - what
  - whose
- id: bonus
  call: '0x52d757cb8be2ebd32af051b26898bce28ec19f13'
  fn: bonusToken()(address)
  is: '0x0000000000000000000000000000000000000000'
  says: no bonus token is set, so no lottery can start
  for:
  - notes
- id: lottery-start
  source: '0x52d757cb8be2ebd32af051b26898bce28ec19f13'
  file: Game.sol
  line: 2299
  has: require(bonusToken.ethLotteryBank() > 0);
  says: starting an ETH lottery first calls the bonus token
  for:
  - notes
- id: oracle-slot
  storage: '0x52d757cb8be2ebd32af051b26898bce28ec19f13'
  slot: '0x1'
  is: '0x0000000000000000000000003dbdc81a6edc94c720b0b88fb65dbd7e395fdcf6'
  says: the game's oracle connector
  for:
  - what
- id: resolver
  call: '0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed'
  fn: getAddress()(address)
  is: '0x3dbdc81a6edc94c720b0b88fb65dbd7e395fdcf6'
  says: the standard Oraclize resolver names this connector
  for:
  - what
- id: sender-nonce-14m
  nonce: '0x26588a9301b0428d95e6fc3a5024fce8bec12d51'
  is: 584553
  at: 14000000
  says: the oracle's long-time callback sender had sent 584,553 transactions by early 2022
  for:
  - what
- id: sender-nonce
  nonce: '0x26588a9301b0428d95e6fc3a5024fce8bec12d51'
  is: 584553
  says: and has sent none since
  for:
  - what
- id: sender-unreg
  call: '0x3dbdc81a6edc94c720b0b88fb65dbd7e395fdcf6'
  fn: cbAddress()(address)
  from: '0x26588a9301b0428d95e6fc3a5024fce8bec12d51'
  is: '0x0000000000000000000000000000000000000000'
  says: that sender is not registered to answer callbacks
  for:
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: HIGH
reviews: []
related: []
---

## What happens

The game checks each random number from its oracle by recovering a signature with a fixed 3,000 gas. Once a recovery costs more, every check fails and each bet is refunded instead of played. The oracle has looked silent since early 2022, and the owner is the only address that ever bet.

## Evidence

- The [proof check](https://etherscan.io/address/0x52d757cb8be2ebd32af051b26898bce28ec19f13#code) calls the signature precompile with a constant 3,000 gas and compares what it reads back with the oracle's key.
- In the [callback](https://etherscan.io/address/0x52d757cb8be2ebd32af051b26898bce28ec19f13#code), a failed proof sends the stake back instead of playing the bet.

## Reviewer notes

### Mechanism

placeBet asks Oraclize for a random number (oraclize_newRandomDSQuery). __callback checks the Ledger proof through oraclize_randomDS_proofVerify__returnCode -> verifySig -> safer_ecrecover, which does call(3000, 1, ...), ignores the success flag and reads the output from the input buffer. Under EIP-8151 a successful recovery costs 3,200 (warm) or 6,100 (cold), so the call runs out of gas, the buffer still holds the hash, the comparison with keccak(pubkey) fails and the return code is non-zero. For a bet the callback then calls sendEthWin(gamer, query.amount): the stake goes back (or is booked in waitingEthPrizes), the bet is never played. getFund lets the owner withdraw any ETH, so nothing is locked; not a proxy, no upgrade function. At the block: bonusToken and investToken are unset, so token bets and lotteries revert today; ETH bets are open. The game's oracle is the connector 0x3dbd...dcf6 named by the standard resolver. The long-time callback sender 0x2658...2d51 has the same nonce (584,553) at blocks 14,000,000 and 26,438,999 and is not registered in the connector (cbAddress() with it as origin returns zero). decisions.md records a second known sender deregistered by block 14,000,000. Rated as if the oracle answered (D-028).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: gas: the 3,000 is a literal in the call (source line 1230; bytecode 6001610bb8f1), below 3,200 and 6,100; the call is not retried and its flag is ignored.
- Ruled out: erc1271 / second path: the oracle key is compared only in verifySig (lines 1068-1072); no other way settles a bet with a random number.
- Ruled out: proxy / unused implementation: no EIP-1967 proxy, no upgradeTo, no copies; this address is the one in use.
- Ruled out: lottery: no lottery can start at the block, since bonusToken() is zero and ethLottery calls it first (line 2299); if the owner set one, a draw would revert on a failed proof (line 2462).
- Ruled out: funds-locked: owner getFund (lines 2403-2405) withdraws any ETH; the owner is an EOA with 17 transactions.
- Ruled out: funds-loss: a failed proof refunds the player's own stake (query.amount); it cannot pay a prize.
- Ruled out: Rating: Anon's rule (D-029): a gas amount fixed in the code with no update path is CRITICAL whatever the contract holds or locks today. It was MEDIUM under the older rubric row for nothing locked or the operator's own money.

### Questions

- Whether Provable registered a new callback sender after early 2022 is not shown: the connector's sender list needs its logs. If none exists, no bet resolves today and nothing changes at activation.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
