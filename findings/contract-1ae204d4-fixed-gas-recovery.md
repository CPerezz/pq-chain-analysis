---
id: contract-1ae204d4-fixed-gas-recovery
format: 2
title: Lottery's oracle proof check runs out of gas once EIP-8151 is live
status: candidate
severity: MEDIUM
justification: The code cannot change, so draws die; it holds no ETH and only the owner can take what comes in.
category: breaks-at-activation
pattern: PQ-14
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1ae204d4e7e2d39dd93c3fcf7cb43b5389688106'
  code: decompiled
  code_url: code/0x348937025e7041174b85b7a5421a9fa6b44e6c85de9588e36c99a6b8ff1d546d.sol
  copies: 2
  family: 84ff6843d70b8ad5f6b9b273cea3e8f0
  upgradeable: 'no'
  admin: '0x67decb8b210254841fa74b51a0367cbcaf168589'
value:
  usd: 0
  basis: held
activity: {}
impact: liveness
action: Move players to a new lottery before EIP-8151 activates; this one cannot be changed and its draws will fail.
evidence_level: bytecode
checks:
- id: fixed-gas
  bytecode: '0x1ae204d4e7e2d39dd93c3fcf7cb43b5389688106'
  has: 60208160808360006001610bb8f1
  says: the recovery is a CALL to 0x01 with a constant 3,000 gas
  for:
  - action
  - evidence-1
  - justification
  - what
- id: verify-27
  bytecode: '0x1ae204d4e7e2d39dd93c3fcf7cb43b5389688106'
  has: 601b8787613c77
  says: the signature step calls the 3,000-gas routine with v=27
  for:
  - evidence-1
  - what
- id: verify-28
  bytecode: '0x1ae204d4e7e2d39dd93c3fcf7cb43b5389688106'
  has: 601c8787613c77
  says: and again with v=28
  for:
  - evidence-1
  - what
- id: session-key
  selector: '0x1ae204d4e7e2d39dd93c3fcf7cb43b5389688106'
  fn: randomDS_getSessionPubKeyHash()
  says: the code reads Oraclize's random-data session key, used by the proof check
  for:
  - what
- id: winner-event
  bytecode: '0x1ae204d4e7e2d39dd93c3fcf7cb43b5389688106'
  has: debf20cc3076b61eb4f3c15975aab71e4d1a8e8bcb8d4060d313b032cc836fa4
  says: the code emits a Winner event when it pays a winner
  for:
  - what
- id: retry
  bytecode: '0x1ae204d4e7e2d39dd93c3fcf7cb43b5389688106'
  has: 52657175657374696e67206e6577
  says: the failure branch logs "Requesting new"
  for:
  - evidence-2
  - what
- id: stop
  bytecode: '0x1ae204d4e7e2d39dd93c3fcf7cb43b5389688106'
  has: 53746f7070696e67
  says: the failure branch logs "Stopping"
  for:
  - evidence-2
  - what
- id: pool
  storage: '0x1ae204d4e7e2d39dd93c3fcf7cb43b5389688106'
  slot: '0x6'
  is: 25
  says: the ticket pool is 25
  for:
  - what
- id: sold
  storage: '0x1ae204d4e7e2d39dd93c3fcf7cb43b5389688106'
  slot: '0x7'
  is: 3
  says: 3 tickets are sold
  for:
  - what
- id: owner
  call: '0x1ae204d4e7e2d39dd93c3fcf7cb43b5389688106'
  fn: owner()(address)
  is: '0x67decb8b210254841fa74b51a0367cbcaf168589'
  says: the owner is 0x67de…8589
  for:
  - justification
- id: takeall-owner
  call: '0x1ae204d4e7e2d39dd93c3fcf7cb43b5389688106'
  fn: takeAll()()
  from: '0x67decb8b210254841fa74b51a0367cbcaf168589'
  is: null
  says: the owner can call takeAll
  for:
  - justification
- id: takeall-other
  call: '0x1ae204d4e7e2d39dd93c3fcf7cb43b5389688106'
  fn: takeAll()
  from: '0x000000000000000000000000000000000000dEaD'
  reverts: true
  says: anyone else cannot
  for:
  - justification
- id: no-proxy
  storage: '0x1ae204d4e7e2d39dd93c3fcf7cb43b5389688106'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: 0
  says: the EIP-1967 implementation slot is empty
  for:
  - action
  - justification
- id: no-upgrade
  selector: '0x1ae204d4e7e2d39dd93c3fcf7cb43b5389688106'
  fn: upgradeTo(address)
  absent: true
  says: the code has no upgrade function
  for:
  - action
  - justification
- id: balance
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x1ae204d4e7e2d39dd93c3fcf7cb43b5389688106'
  is: 0
  says: the lottery holds no ETH
  for:
  - justification
  - what
- id: jackpot
  call: '0x1ae204d4e7e2d39dd93c3fcf7cb43b5389688106'
  fn: jackpot()(uint256)
  is: 1050400000000000000
  says: the booked jackpot is 1.0504 ETH
  for:
  - what
- id: prize
  call: '0x1ae204d4e7e2d39dd93c3fcf7cb43b5389688106'
  data: '0x2017aa2f'
  is: '0x0000000000000000000000000000000000000000000000000de0b6b3a7640000'
  says: the prize paid to each winner is 1 ETH
  for:
  - what
- id: price
  call: '0x1ae204d4e7e2d39dd93c3fcf7cb43b5389688106'
  fn: ticketPrice()(uint256)
  is: 50000000000000000
  says: a ticket costs 0.05 ETH
  for:
  - what
- id: resolver
  call: '0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed'
  fn: getAddress()(address)
  is: '0x3dbdc81a6edc94c720b0b88fb65dbd7e395fdcf6'
  says: Oraclize's resolver names the connector 0x3dbd…dcf6
  for:
  - what
- id: sender-unregistered
  call: '0x3dbdc81a6edc94c720b0b88fb65dbd7e395fdcf6'
  fn: cbAddress()(address)
  from: '0x26588a9301b0428d95e6fc3a5024fce8bec12d51'
  is: '0x0000000000000000000000000000000000000000'
  says: Oraclize's historical callback sender 0x2658…2d51 is not a registered callback address
  for:
  - what
- id: sender-nonce-14m
  nonce: '0x26588a9301b0428d95e6fc3a5024fce8bec12d51'
  is: 584553
  at: 14000000
  says: that sender had sent 584,553 transactions by block 14,000,000 (early 2022)
  for:
  - what
- id: sender-nonce
  nonce: '0x26588a9301b0428d95e6fc3a5024fce8bec12d51'
  is: 584553
  says: and has sent none since
  for:
  - what
- id: copy-sold
  storage: '0x89ddbf934890b6dfe6205f4ff93f4bbe678c4160'
  slot: '0x7'
  is: 0
  says: the copy 0x89dd…4160 has no tickets sold
  for:
  - notes
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

This lottery picks a winner from an Oraclize random number whose signed proof it checks. That check gets a fixed 3,000 gas, too little under EIP-8151, so every draw fails. The oracle looks silent since early 2022. With no ETH but a 1.05 ETH jackpot booked, draws already fail unless buyers overpay.

## Evidence

- The [deployed code](https://etherscan.io/address/0x1ae204d4e7e2d39dd93c3fcf7cb43b5389688106#code) checks the proof's signature with a fixed 3,000 gas.
- When a proof fails, the [code](https://etherscan.io/address/0x1ae204d4e7e2d39dd93c3fcf7cb43b5389688106#code) logs "Requesting new" and asks again, then logs "Stopping"; no winner is paid.

## Reviewer notes

### Mechanism

Unverified code built on Oraclize's usingOraclize library. __callback(bytes32,string,bytes) (0x38bbfa50) verifies the random-data proof; its signature step (the verifySig shape) jumps twice to the routine at 0x3c77, with v=27 (0x2f11) and v=28 (0x2fc9). That routine calls address 0x01 with a constant 3,000 gas (0x3c9e: PUSH1 0x01 PUSH2 0x0bb8 CALL) and returns the success flag and the output word. Under EIP-8151 a successful recovery costs 3,200 or 6,100, so the call fails, the output word stays the input hash, and it never matches the session key: the proof fails for every honest answer. On failure the callback (0x06b5) reads a retry counter (slot 0x15, 0 now): at 2 or below it logs LedgerFailed("Requesting new"), increments it and sends a new query; above 2 it logs LedgerFailed("Stopping"). No winner is paid and the tickets are not reset. takeAll() (0xde3bcb97) lets the owner (slot 5, an EOA with nonce 501) take the whole balance; others revert. No DELEGATECALL, upgrade function or EIP-1967 slot. State: pool 25 (slot 6), 3 sold (slot 7), price 0.05 ETH (slot 9), prize 1 ETH (slot 10), balance 0. The copy 0x89ddbf93... has the same owner and pool, with 0 tickets sold. Payout today: the 22 unsold tickets bring 1.1 ETH; the draw pays the 1 ETH prize and then requires jackpot+bonus (1.0504+0.1 ETH, slots 11 and 15) to be backed by the balance, or pays prize plus 60% of the jackpot (1.63 ETH): both exceed 1.1 ETH, so a draw reverts unless buyers send more than the ticket price.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: gas: the 3,000 is a PUSH2 constant right before CALL to 0x01, not GAS or a computed amount; it is the only recovery site the scan found (n_ec 1).
- Ruled out: path-closed: buyTicket(1) and buyTicket(22) with ticket value succeed in an eth_call from the owner, so sales are open; neither can be stored as a check because checks carry no ETH value.
- Ruled out: erc1271 / direct-path: no other path completes a draw; the winner is paid only inside the callback after the proof passes.
- Ruled out: wrong-code: the two call sites push v=27 and v=28 before jumping to the 3,000-gas routine, the shape of Oraclize's verifySig and safer_ecrecover.
- Ruled out: funds-locked: the lottery holds 0 ETH, so the at least 0.15 ETH paid for the 3 tickets has already left; takeAll lets the owner move what is paid in later, others revert.
- Ruled out: copies: the copy 0x89ddbf934890b6dfe6205f4ff93f4bbe678c4160 runs the same code with 0 tickets sold; it is not described by this card.
- Ruled out: oracle: a second Oraclize sender stopped between blocks 13M and 14M; I could not cite its full address, so the card rests on 0x2658…2d51 and the connector. A later unlisted sender is not excluded, so the card stays a finding.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
