---
id: bitlagio-fa65bb26-fixed-gas-recovery
format: 2
title: Bitlagio dice bets can no longer settle once EIP-8151 raises the signature cost
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
  address: '0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec'
  name: Bitlagio
  code: verified
  code_url: https://etherscan.io/address/0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec#code
  copies: 1
  upgradeable: 'no'
  admin: '0x9a9236dabd08652c140e8931849c79f9c4d78607'
value:
  usd: 4782
  whose: operator
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Stop new bets with setMinBet and empty the pot with withdrawFromPot before EIP-8151 activates; the code
  cannot change.
evidence_level: source
checks:
- id: cbguard
  source: '0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec'
  file: Bitlagio.sol
  line: 1070
  has: if (msg.sender != oraclize_cbAddress()) throw;
  says: __callback accepts only the callback address the Provable connector names
  for:
  - what
- id: cbconn
  source: '0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec'
  file: Bitlagio.sol
  lines:
  - 123
  - 124
  has: oraclize = OraclizeI(OAR.getAddress());
  says: the connector is the one the Provable resolver names at call time
  for:
  - what
- id: resolver
  call: '0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed'
  fn: getAddress()(address)
  is: '0x3dbdc81a6edc94c720b0b88fb65dbd7e395fdcf6'
  says: the mainnet Provable resolver names connector 0x3dbd...fcf6
  for:
  - evidence-3
  - what
- id: unreg
  call: '0x3dbdc81a6edc94c720b0b88fb65dbd7e395fdcf6'
  fn: cbAddress()(address)
  from: '0x26588a9301b0428d95e6fc3a5024fce8bec12d51'
  is: '0x0000000000000000000000000000000000000000'
  says: Provable's historical callback sender is not a registered callback address at the block
  for:
  - evidence-3
  - what
- id: unreg14m
  call: '0x3dbdc81a6edc94c720b0b88fb65dbd7e395fdcf6'
  fn: cbAddress()(address)
  from: '0x26588a9301b0428d95e6fc3a5024fce8bec12d51'
  is: '0x0000000000000000000000000000000000000000'
  at: 14000000
  says: nor was it at block 14,000,000 (January 2022)
  for:
  - evidence-3
  - what
- id: s2unreg
  call: '0x3dbdc81a6edc94c720b0b88fb65dbd7e395fdcf6'
  fn: cbAddress()(address)
  from: '0x000042425e06b0b1e8e20a811c91d6864608324b'
  is: '0x0000000000000000000000000000000000000000'
  says: the second known sender is also not a registered callback address at the block
  for:
  - evidence-3
  - what
- id: s2unreg14m
  call: '0x3dbdc81a6edc94c720b0b88fb65dbd7e395fdcf6'
  fn: cbAddress()(address)
  from: '0x000042425e06b0b1e8e20a811c91d6864608324b'
  is: '0x0000000000000000000000000000000000000000'
  at: 14000000
  says: nor was it at block 14,000,000
  for:
  - evidence-3
  - what
- id: s2nonce
  nonce: '0x000042425e06b0b1e8e20a811c91d6864608324b'
  is: 63426
  says: the second sender's transaction count at the block
  for:
  - evidence-3
  - what
- id: s2nonce14m
  nonce: '0x000042425e06b0b1e8e20a811c91d6864608324b'
  is: 63426
  at: 14000000
  says: 'the same count at block 14,000,000: it has sent nothing since'
  for:
  - evidence-3
  - what
- id: snonce
  nonce: '0x26588a9301b0428d95e6fc3a5024fce8bec12d51'
  is: 584553
  says: the sender's transaction count at the block
  for:
  - evidence-3
  - what
- id: snonce14m
  nonce: '0x26588a9301b0428d95e6fc3a5024fce8bec12d51'
  is: 584553
  at: 14000000
  says: 'the same count at block 14,000,000: it has sent nothing since'
  for:
  - evidence-3
  - what
- id: gas
  source: '0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec'
  file: Bitlagio.sol
  line: 995
  has: ret := call(3000, 1, 0, size, 128, size, 32)
  says: safer_ecrecover calls precompile 0x01 with a constant 3,000 gas
  for:
  - evidence-1
  - justification
  - what
- id: gasbyte
  bytecode: '0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec'
  has: 6001610bb8f1
  says: the deployed code calls address 1 with a constant 3,000 gas (PUSH1 1 PUSH2 0x0bb8 CALL)
  for:
  - evidence-1
  - what
- id: eip
  ref: https://github.com/ethereum/EIPs/blob/8194528a2ee9a4893a398a5871c470ab0ac3b09a/EIPS/eip-8151.md
  says: 'EIP-8151 at the study''s pinned commit: a successful recovery costs 3,200 gas (warm) or 6,100 (cold)'
  for:
  - justification
  - what
- id: sigcmp
  source: '0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec'
  file: Bitlagio.sol
  line: 836
  has: if (address(sha3(pubkey)) == signer) return true;
  says: verifySig accepts only when the recovered address equals the address of the expected public key
  for:
  - evidence-1
  - what
- id: step5
  source: '0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec'
  file: Bitlagio.sol
  line: 944
  has: checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
  says: every proof verifies the session key's signature over the result, a recovery on every callback
  for:
  - what
- id: proofthrow
  source: '0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec'
  file: Bitlagio.sol
  line: 882
  has: if (proofVerified == false) throw;
  says: a proof that fails verification makes the callback revert
  for:
  - evidence-1
  - justification
  - what
- id: callback
  source: '0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec'
  file: Bitlagio.sol
  lines:
  - 1103
  - 1107
  has: oraclize_randomDS_proofVerify(betId, result, proof)
  says: __callback, the only function that settles a bet, runs the proof check first
  for:
  - justification
  - what
- id: payout
  source: '0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec'
  file: Bitlagio.sol
  lines:
  - 1108
  - 1117
  has: thisBet.playerAddress.send(thisBet.amountBet.mul(2));
  says: the callback is what pays a winning bet
  for:
  - what
- id: bet
  source: '0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec'
  file: Bitlagio.sol
  lines:
  - 1082
  - 1100
  has: bets[betId] = Bet(msg.sender, betSize, 0);
  says: ETH sent by anyone other than the owner places a bet that waits for the callback
  for:
  - justification
  - what
- id: withdraw
  source: '0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec'
  file: Bitlagio.sol
  lines:
  - 1125
  - 1128
  has: owner.send(amount);
  says: withdrawFromPot lets the owner take any amount from the contract, with no signature
  for:
  - action
  - evidence-2
  - justification
  - what
- id: minbet
  source: '0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec'
  file: Bitlagio.sol
  line: 1058
  has: if (msg.value <= minBet) throw;
  says: a bet at or below minBet is refused
  for:
  - action
- id: setminbet
  source: '0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec'
  file: Bitlagio.sol
  lines:
  - 1129
  - 1131
  has: minBet = _minBet;
  says: the owner can set minBet to any value
  for:
  - action
- id: owner
  call: '0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec'
  fn: owner()(address)
  is: '0x9a9236dabd08652c140e8931849c79f9c4d78607'
  says: the owner at the block
  for:
  - action
- id: ownercode
  code: '0x9a9236dabd08652c140e8931849c79f9c4d78607'
  is: empty
  says: the owner is an account without code
  for:
  - action
- id: ownernonce
  nonce: '0x9a9236dabd08652c140e8931849c79f9c4d78607'
  is: 6
  says: the owner key has sent transactions
  for:
  - action
- id: noproxy
  storage: '0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: 0
  says: the EIP-1967 implementation slot is empty
  for:
  - action
  - justification
- id: noupgrade
  selector: '0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec'
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
  - '0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec'
  is: 2650011553986961996
  says: the contract holds 2.65 ETH
  for:
  - evidence-2
  - whose
- id: nbets
  call: '0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec'
  fn: betsKeys(uint256)(bytes32)
  args:
  - 6
  reverts: true
  says: only six bets were ever placed (betsKeys has six entries)
  for:
  - evidence-2
  - whose
- id: key0
  call: '0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec'
  fn: betsKeys(uint256)(bytes32)
  args:
  - 0
  is: '0x0f99162116328ac92b276b137a4760c98f00b176ff7c2545c0acb9ad0547237f'
  says: bet 1 of 6
  for:
  - evidence-2
  - whose
- id: bet0
  call: '0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec'
  fn: bets(bytes32)(address,uint256,uint256)
  args:
  - '0x0f99162116328ac92b276b137a4760c98f00b176ff7c2545c0acb9ad0547237f'
  is:
  - '0xfbb1b73c4f0bda4f67dca266ce6ef42f520fbb98'
  - 500020000000000000
  - 80
  says: 'bet 1 is settled: numberRolled is 80, not 0'
  for:
  - evidence-2
  - whose
- id: key1
  call: '0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec'
  fn: betsKeys(uint256)(bytes32)
  args:
  - 1
  is: '0x2dbb03956f8e1f60611f19925a43dbb900d620cb7a81f1bb284bea18accea310'
  says: bet 2 of 6
  for:
  - evidence-2
  - whose
- id: bet1
  call: '0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec'
  fn: bets(bytes32)(address,uint256,uint256)
  args:
  - '0x2dbb03956f8e1f60611f19925a43dbb900d620cb7a81f1bb284bea18accea310'
  is:
  - '0x80eced4fb8c3d8bc3444ef217c94980adbb70edb'
  - 25000000000000000
  - 57
  says: 'bet 2 is settled: numberRolled is 57, not 0'
  for:
  - evidence-2
  - whose
- id: key2
  call: '0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec'
  fn: betsKeys(uint256)(bytes32)
  args:
  - 2
  is: '0x6fa9bc28567fa63f395166c90c58726b6d061af8db8384f8d97c6dbb9a2960ff'
  says: bet 3 of 6
  for:
  - evidence-2
  - whose
- id: bet2
  call: '0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec'
  fn: bets(bytes32)(address,uint256,uint256)
  args:
  - '0x6fa9bc28567fa63f395166c90c58726b6d061af8db8384f8d97c6dbb9a2960ff'
  is:
  - '0xa2acb143d0005ae30589cf549de8c8f4e38d342d'
  - 50000000000000000
  - 60
  says: 'bet 3 is settled: numberRolled is 60, not 0'
  for:
  - evidence-2
  - whose
- id: key3
  call: '0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec'
  fn: betsKeys(uint256)(bytes32)
  args:
  - 3
  is: '0xc7d25cc7f7aabe0bf08f937578bde55f6830601a2a8ec19d84ae1865f005f2f3'
  says: bet 4 of 6
  for:
  - evidence-2
  - whose
- id: bet3
  call: '0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec'
  fn: bets(bytes32)(address,uint256,uint256)
  args:
  - '0xc7d25cc7f7aabe0bf08f937578bde55f6830601a2a8ec19d84ae1865f005f2f3'
  is:
  - '0xdfd3b3e32836c27a61fb452e67d83ae8efaef4bb'
  - 50000000000000000
  - 32
  says: 'bet 4 is settled: numberRolled is 32, not 0'
  for:
  - evidence-2
  - whose
- id: key4
  call: '0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec'
  fn: betsKeys(uint256)(bytes32)
  args:
  - 4
  is: '0xd22939e37bacaa9b846121ff79ce41e46cc82f74e51b0052b8e7872b0dbbb3c7'
  says: bet 5 of 6
  for:
  - evidence-2
  - whose
- id: bet4
  call: '0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec'
  fn: bets(bytes32)(address,uint256,uint256)
  args:
  - '0xd22939e37bacaa9b846121ff79ce41e46cc82f74e51b0052b8e7872b0dbbb3c7'
  is:
  - '0xdfd3b3e32836c27a61fb452e67d83ae8efaef4bb'
  - 100000000000000000
  - 44
  says: 'bet 5 is settled: numberRolled is 44, not 0'
  for:
  - evidence-2
  - whose
- id: key5
  call: '0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec'
  fn: betsKeys(uint256)(bytes32)
  args:
  - 5
  is: '0x243fef3c36c802cc533de60f839c21eefdff9850c687043e4576d65e6e7ce60b'
  says: bet 6 of 6
  for:
  - evidence-2
  - whose
- id: bet5
  call: '0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec'
  fn: bets(bytes32)(address,uint256,uint256)
  args:
  - '0x243fef3c36c802cc533de60f839c21eefdff9850c687043e4576d65e6e7ce60b'
  is:
  - '0xdfd3b3e32836c27a61fb452e67d83ae8efaef4bb'
  - 50000000000000000
  - 75
  says: 'bet 6 is settled: numberRolled is 75, not 0'
  for:
  - evidence-2
  - whose
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: HIGH
reviews:
- who: r-fa65bb26, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection (the card was edited after this answer)
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: CRITICAL
  note: 're-rated: CRITICAL (PQ-14): Bitlagio dice bets can no longer settle once EIP-8151 raises the signature
    cost. No update path: the fixed gas makes the check fail for good under EIP-8151, whatever the contract holds
    then. Re-rated MEDIUM -> CRITICAL by Anon''s rule (D-029): a gas amount fixed in the code with no update path
    is CRITICAL whatever the contract holds today. The facts are those the refuters checked. Waits for Anon''s sign-off.
    Claude read the card and the answers.'
related: []
---

## What happens

Bitlagio settles dice bets in a Provable oracle callback carrying a signed randomness proof. The proof's signature check gets a fixed 3,000 gas, below EIP-8151's price, so callbacks revert and bets stay unpaid. Both known oracle callback senders are unregistered and silent since January 2022.

## Evidence

- [safer_ecrecover](https://etherscan.io/address/0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec#code) gives the signature check a fixed 3,000 gas; a failed check rejects the proof and the callback reverts.
- [withdrawFromPot](https://etherscan.io/address/0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec#code) lets the owner take any amount; the contract holds 2.65 ETH and all six bets ever placed are settled.
- [Provable's connector](https://etherscan.io/address/0x3dbdc81a6edc94c720b0b88fb65dbd7e395fdcf6) accepts neither of its two known callback senders, both silent since January 2022.

## Reviewer notes

### Mechanism

A non-owner's ETH to the fallback calls makeBet, which records the bet and asks Provable for Ledger-proven randomness. __callback accepts only msg.sender == oraclize_cbAddress() and runs oraclize_randomDS_proofVerify. Step 5 verifies the session key's signature (sig1) on every callback; verifySig calls safer_ecrecover, which CALLs 0x01 with a literal 3,000 gas (line 995; bytecode 6001610bb8f1). Under EIP-8151 a valid recovery costs 3,200 or 6,100, so the CALL fails, the output word keeps the input hash, the address never matches sha3(pubkey), verifySig returns false and the modifier throws. The callback reverts, numberRolled stays 0 and the bet is never paid; no function refunds it, so the stake stays in the pot. withdrawFromPot (onlyOwner) moves any amount to the owner; setMinBet can make every new bet throw. No proxy slot, no upgrade function. The connector returns 0 for cbAddress() from both of its two known senders, 0x2658...2d51 (584,553 txs) and 0x0000...324b (63,426 txs), at blocks 14,000,000 and 26,438,999, and neither sender's nonce moved between those blocks: both went silent by January 2022. The sender mapping cannot be listed without logs, so a later sender is not excluded (card stays a finding and states this).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: a handled failure: safer_ecrecover returns the CALL flag but verifySig ignores it and compares the stale output word, so a failure is a rejection (lines 816-840).
- Ruled out: an alternative settlement or refund path: only __callback writes numberRolled and pays (lines 1037-1131); the only other ETH sends are the over-limit refund in makeBet and withdrawFromPot (onlyOwner); nothing refunds a stuck bet.
- Ruled out: open bets whose stakes would be players' money: betsKeys has six entries and every bet has numberRolled > 0, so the 2.65 ETH is the house pot.
- Ruled out: a closed path: bets are still accepted at the block (an eth_call from an unrelated address to the fallback succeeded, paid from the pot); not a card check, the check kinds cannot send value.
- Ruled out: an owner that cannot act: owner() is an account without code that has sent 6 transactions.
- Ruled out: Rating: Anon's rule: a gas amount fixed in the code with no update path is CRITICAL whatever the contract holds or locks today. It was MEDIUM under the older rubric row for nothing locked or the operator's own money.

### Questions

- Whether any Provable callback sender is registered at the block is not established: the sender mapping cannot be listed without logs, only individual addresses can be checked. Both known senders are unregistered and silent since January 2022. If none exists, bets already never settle and the change adds nothing; the card keeps the finding and states the silence.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
