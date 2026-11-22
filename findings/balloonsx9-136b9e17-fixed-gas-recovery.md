---
id: balloonsx9-136b9e17-fixed-gas-recovery
format: 2
title: BalloonsX9 draws cannot pass their proof check under EIP-8151
status: confirmed
severity: CRITICAL
justification: 'No update path: the fixed gas makes the check fail for good under EIP-8151, whatever the contract
  holds then.'
category: breaks-at-activation
pattern: PQ-14
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x136b9e17e56ba927884e92661a850f2d1a621ee6'
  name: BalloonsX9
  code: verified
  code_url: https://etherscan.io/address/0x136b9e17e56ba927884e92661a850f2d1a621ee6#code
  copies: 1
  upgradeable: 'no'
  admin: '0x6e47a3c07811e3f5f142c9e7b172af5e76f98ab4'
value:
  usd: 84
  whose: operator
  basis: held
activity:
  txs_90d: 0
impact: liveness
evidence_level: source
checks:
- id: fixed-gas
  bytecode: '0x136b9e17e56ba927884e92661a850f2d1a621ee6'
  has: 60006001610bb8f1
  says: the deployed code calls address 0x01 with a constant 3,000 gas (PUSH1 0 PUSH1 1 PUSH2 0x0bb8 CALL); it is
    the only 0x0bb8 in the code
  for:
  - evidence-1
  - what
- id: src-gas
  source: '0x136b9e17e56ba927884e92661a850f2d1a621ee6'
  file: BalloonsX9.sol
  line: 1166
  has: ret := call(3000, 1, 0, size, 128, size, 32)
  says: safer_ecrecover gives the precompile a fixed 3,000 gas
  for:
  - evidence-1
  - what
- id: src-cmp
  source: '0x136b9e17e56ba927884e92661a850f2d1a621ee6'
  file: BalloonsX9.sol
  line: 1005
  has: if (address(keccak256(pubkey)) == signer) return true;
  says: verifySig ignores the call's success flag and compares the output buffer with the address of the expected
    public key
  for:
  - evidence-1
  - what
- id: src-fail
  source: '0x136b9e17e56ba927884e92661a850f2d1a621ee6'
  file: BalloonsX9.sol
  line: 1111
  has: if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
  says: a failed session-key signature check makes the whole Ledger proof fail
  for:
  - what
- id: no-proxy
  storage: '0x136b9e17e56ba927884e92661a850f2d1a621ee6'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: 0
  says: the EIP-1967 implementation slot is empty; the address is not a proxy
  for:
  - justification
- id: can-play
  call: '0x136b9e17e56ba927884e92661a850f2d1a621ee6'
  fn: canPlay()(bool)
  is: true
  says: buying balloons is open at the block
  for:
  - evidence-2
- id: sold
  call: '0x136b9e17e56ba927884e92661a850f2d1a621ee6'
  fn: sold()(uint256)
  is: 80
  says: 80 balloons sold
  for:
  - evidence-2
- id: no-upgrade
  selector: '0x136b9e17e56ba927884e92661a850f2d1a621ee6'
  fn: upgradeTo(address)
  absent: true
  says: the code has no upgrade function
  for:
  - justification
- id: setters
  source: '0x136b9e17e56ba927884e92661a850f2d1a621ee6'
  file: BalloonsX9.sol
  lines:
  - 1487
  - 1522
  has: function changeStatusGame() public onlyOwner {
  says: the owner functions set the price, the oracle gas limit and price, and reopen play; none touches the proof
    check or moves the balance
  for:
  - justification
- id: draw
  source: '0x136b9e17e56ba927884e92661a850f2d1a621ee6'
  file: BalloonsX9.sol
  lines:
  - 1424
  - 1437
  has: if(totalBalloons == winnerDetectionTime) {
  says: each tenth sale opens a draw for the last ten balloons and sends an oracle query
  for:
  - what
- id: balance
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x136b9e17e56ba927884e92661a850f2d1a621ee6'
  is: 46373227832479850
  says: the contract holds 0.0464 ETH
  for:
  - evidence-2
  - what
- id: price
  call: '0x136b9e17e56ba927884e92661a850f2d1a621ee6'
  fn: price()(uint256)
  is: 50000000000000000
  says: a balloon costs 0.05 ETH
  for:
  - evidence-2
  - what
- id: cb1-12m
  nonce: '0x26588a9301b0428d95e6fc3a5024fce8bec12d51'
  at: 12000000
  is: 584553
  says: Oraclize's older callback sender had sent 584,553 transactions by block 12,000,000
  for:
  - what
- id: cb1-now
  nonce: '0x26588a9301b0428d95e6fc3a5024fce8bec12d51'
  is: 584553
  says: it has sent none since
  for:
  - what
- id: cb2-13m
  nonce: '0x000042425e06b0b1e8e20a811c91d6864608324b'
  at: 13000000
  is: 63418
  says: the newer callback sender had sent 63,418 transactions by block 13,000,000
  for:
  - what
- id: cb2-14m
  nonce: '0x000042425e06b0b1e8e20a811c91d6864608324b'
  at: 14000000
  is: 63426
  says: 63,426 by block 14,000,000 (January 2022)
  for:
  - what
- id: cb2-now
  nonce: '0x000042425e06b0b1e8e20a811c91d6864608324b'
  is: 63426
  says: and none since
  for:
  - what
- id: src-win
  source: '0x136b9e17e56ba927884e92661a850f2d1a621ee6'
  file: BalloonsX9.sol
  lines:
  - 1463
  - 1468
  has: revealWinner(randomNumber, attempts, min, max, data);
  says: the winner is paid only when the proof check passes
  for:
  - what
- id: owner-b9
  storage: '0x136b9e17e56ba927884e92661a850f2d1a621ee6'
  slot: '0xa0b0e2ce393b3cb020be6594ea5b4ae50c04441acc1180b842c6a8cafc063ccc'
  is: '0x6e47a3c07811e3f5f142c9e7b172af5e76f98ab4'
  says: ownerOfBalloon[9] (mapping at slot 29, key 9) is the contract owner
  for:
  - evidence-2
  - justification
  - what
  - whose
- id: owner
  call: '0x136b9e17e56ba927884e92661a850f2d1a621ee6'
  fn: owner()(address)
  is: '0x6e47a3c07811e3f5f142c9e7b172af5e76f98ab4'
  says: the contract owner
  for:
  - evidence-2
  - justification
  - what
  - whose
- id: owner-eoa
  code: '0x6e47a3c07811e3f5f142c9e7b172af5e76f98ab4'
  is: empty
  says: the owner is an account without code
  for:
  - whose
- id: refund9
  call: '0x136b9e17e56ba927884e92661a850f2d1a621ee6'
  fn: canRefund(uint256)(bool)
  args:
  - 9
  is: true
  says: balloon 9 of the undrawn first round is still unrefunded
  for:
  - evidence-2
  - justification
  - what
  - whose
- id: refund8
  call: '0x136b9e17e56ba927884e92661a850f2d1a621ee6'
  fn: canRefund(uint256)(bool)
  args:
  - 8
  is: false
  says: balloon 8 of the same undrawn round cannot be refunded again (already returned)
  for:
  - justification
  - what
  - whose
- id: undrawn0
  call: '0x136b9e17e56ba927884e92661a850f2d1a621ee6'
  fn: participatedID(uint256)(bool)
  args:
  - 0
  is: false
  says: the first round (balloons 0-9) was never drawn
  for:
  - justification
  - what
  - whose
- id: drawn70
  call: '0x136b9e17e56ba927884e92661a850f2d1a621ee6'
  fn: participatedID(uint256)(bool)
  args:
  - 70
  is: true
  says: the last full round (70-79) was drawn and paid
  for:
  - justification
  - what
  - whose
- id: src-send
  source: '0x136b9e17e56ba927884e92661a850f2d1a621ee6'
  file: BalloonsX9.sol
  line: 1508
  has: if(ownerOfBalloon[_id].send(price)) {
  says: a refund sends a full balloon price and only logs a failure when the send fails
  for:
  - notes
- id: drawn10
  call: '0x136b9e17e56ba927884e92661a850f2d1a621ee6'
  fn: participatedID(uint256)(bool)
  args:
  - 10
  is: true
  says: round 10-19 was drawn and paid
  for:
  - justification
  - what
  - whose
- id: drawn20
  call: '0x136b9e17e56ba927884e92661a850f2d1a621ee6'
  fn: participatedID(uint256)(bool)
  args:
  - 20
  is: true
  says: round 20-29 was drawn and paid
  for:
  - justification
  - what
  - whose
- id: drawn30
  call: '0x136b9e17e56ba927884e92661a850f2d1a621ee6'
  fn: participatedID(uint256)(bool)
  args:
  - 30
  is: true
  says: round 30-39 was drawn and paid
  for:
  - justification
  - what
  - whose
- id: drawn40
  call: '0x136b9e17e56ba927884e92661a850f2d1a621ee6'
  fn: participatedID(uint256)(bool)
  args:
  - 40
  is: true
  says: round 40-49 was drawn and paid
  for:
  - justification
  - what
  - whose
- id: drawn50
  call: '0x136b9e17e56ba927884e92661a850f2d1a621ee6'
  fn: participatedID(uint256)(bool)
  args:
  - 50
  is: true
  says: round 50-59 was drawn and paid
  for:
  - justification
  - what
  - whose
- id: drawn60
  call: '0x136b9e17e56ba927884e92661a850f2d1a621ee6'
  fn: participatedID(uint256)(bool)
  args:
  - 60
  is: true
  says: round 60-69 was drawn and paid
  for:
  - justification
  - what
  - whose
- id: refund0
  call: '0x136b9e17e56ba927884e92661a850f2d1a621ee6'
  fn: canRefund(uint256)(bool)
  args:
  - 0
  is: false
  says: balloon 0 of the undrawn round was already returned
  for:
  - justification
  - what
  - whose
- id: refund1
  call: '0x136b9e17e56ba927884e92661a850f2d1a621ee6'
  fn: canRefund(uint256)(bool)
  args:
  - 1
  is: false
  says: balloon 1 of the undrawn round was already returned
  for:
  - justification
  - what
  - whose
- id: refund2
  call: '0x136b9e17e56ba927884e92661a850f2d1a621ee6'
  fn: canRefund(uint256)(bool)
  args:
  - 2
  is: false
  says: balloon 2 of the undrawn round was already returned
  for:
  - justification
  - what
  - whose
- id: refund3
  call: '0x136b9e17e56ba927884e92661a850f2d1a621ee6'
  fn: canRefund(uint256)(bool)
  args:
  - 3
  is: false
  says: balloon 3 of the undrawn round was already returned
  for:
  - justification
  - what
  - whose
- id: refund4
  call: '0x136b9e17e56ba927884e92661a850f2d1a621ee6'
  fn: canRefund(uint256)(bool)
  args:
  - 4
  is: false
  says: balloon 4 of the undrawn round was already returned
  for:
  - justification
  - what
  - whose
- id: refund5
  call: '0x136b9e17e56ba927884e92661a850f2d1a621ee6'
  fn: canRefund(uint256)(bool)
  args:
  - 5
  is: false
  says: balloon 5 of the undrawn round was already returned
  for:
  - justification
  - what
  - whose
- id: refund6
  call: '0x136b9e17e56ba927884e92661a850f2d1a621ee6'
  fn: canRefund(uint256)(bool)
  args:
  - 6
  is: false
  says: balloon 6 of the undrawn round was already returned
  for:
  - justification
  - what
  - whose
- id: refund7
  call: '0x136b9e17e56ba927884e92661a850f2d1a621ee6'
  fn: canRefund(uint256)(bool)
  args:
  - 7
  is: false
  says: balloon 7 of the undrawn round was already returned
  for:
  - justification
  - what
  - whose
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

Every tenth sale starts a random draw whose oracle proof is checked with a fixed 3,000 gas recovery. Under EIP-8151 every proof fails, so no draw pays out. The oracle's two known callback senders have sent nothing since January 2022. Its 0.0464 ETH is the owner's.

## Evidence

- [safer_ecrecover](https://etherscan.io/address/0x136b9e17e56ba927884e92661a850f2d1a621ee6#code) calls the precompile with 3,000 gas; the proof check drops the call's success flag.
- [The game](https://etherscan.io/address/0x136b9e17e56ba927884e92661a850f2d1a621ee6#code) is open with 80 sold; the one unrefunded stake is the owner's 0.05 ETH, above the 0.0464 ETH balance.

## Reviewer notes

### Mechanism

_buyBalloon opens a draw when totalBalloons reaches winnerDetectionTime (1424-1437) and calls pingOracle, a Ledger-proof random query paid from the balance. __callback (1460-1479) runs oraclize_randomDS_proofVerify__returnCode; verifySig (1005) compares the output of safer_ecrecover, which gives precompile 0x01 a constant 3,000 gas (1166), with the expected key, ignoring the success flag. Under EIP-8151 the call fails out of gas, the comparison fails, the proof fails (1111), revealWinner is never reached and __callback re-queries until the balance cannot pay. At the block: rounds 10-79 were drawn and paid; round 0-9 was never drawn; balloons 0-8 were refunded; balloon 9 (ownerOfBalloon slot keccak(9,29)) is the owner's EOA, and its refund sends 0.05 ETH, more than the 0.0464 ETH balance, so send fails silently (1508). No owner function moves the balance or stops sales: setPrice only stops play inside a draw, changeStatusGame only reopens it.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size branch: the proof check has none (1000-1008).
- Ruled out: an owner rescue: no withdraw or selfdestruct; owner functions do not touch verification or balance (1487-1522).
- Ruled out: a proxy: EIP-1967 slot empty, no upgradeTo.
- Ruled out: buyers' money at stake today: every round from 10 to 79 was drawn and paid, and 0-8 were refunded. New buyers can still buy; a stuck round's stakes come back through refundPendingId (send) after another full round sells.
- Ruled out: an owner action to stop sales: none exists (canPlay is cleared only inside a draw on a price change), so the action is left empty.
- Ruled out: the second root issue of the Oraclize helper (fixed Ledger key) is a separate row; not folded here.
- Ruled out: Rating: Anon's rule: a gas amount fixed in the code with no update path is CRITICAL whatever the contract holds or locks today. It was MEDIUM under the older rubric row for nothing locked or the operator's own money.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
