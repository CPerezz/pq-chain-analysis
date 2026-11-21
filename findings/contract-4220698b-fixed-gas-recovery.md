---
id: contract-4220698b-fixed-gas-recovery
format: 2
title: Betting rounds can never draw a winner once oracle proofs fail
status: candidate
severity: HIGH
justification: No round can draw a winner, so a filled round's pot never reaches a player; there is no owner, upgrade
  or refund path.
category: breaks-at-activation
pattern: PQ-14
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4220698be33a9738898f430018f28aeceecaa6ff'
  code: decompiled
  code_url: code/0x9545fee6670e7246046859b9144dd66a456e20db921451a423683efb8c43c05b.sol
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  whose: users
  basis: held
activity:
  txs_90d: 0
impact: funds-locked
evidence_level: bytecode
checks:
- id: fixed-gas
  bytecode: '0x4220698be33a9738898f430018f28aeceecaa6ff'
  has: 8360006001610bb8f1
  says: the call to the recovery precompile (address 1) gets a constant 3,000 gas
  for:
  - evidence-1
  - justification
  - what
- id: ledger-key
  bytecode: '0x4220698be33a9738898f430018f28aeceecaa6ff'
  has: 7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8
  says: the code embeds the Oraclize Ledger proof key
  for:
  - evidence-2
  - what
- id: callback
  selector: '0x4220698be33a9738898f430018f28aeceecaa6ff'
  fn: __callback(bytes32,string,bytes)
  says: the code has the oracle's result-with-proof callback
  for:
  - evidence-2
  - what
- id: no-proxy
  storage: '0x4220698be33a9738898f430018f28aeceecaa6ff'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: '0'
  says: the EIP-1967 implementation slot is empty
  for:
  - justification
- id: no-upgrade
  selector: '0x4220698be33a9738898f430018f28aeceecaa6ff'
  fn: upgradeTo(address)
  absent: true
  says: the code has no upgrade function
  for:
  - justification
- id: no-winner
  call: '0x4220698be33a9738898f430018f28aeceecaa6ff'
  fn: numberWinner()(uint256)
  is: '0'
  says: no winning number is set at the block
  for:
  - justification
  - what
- id: player-zero
  storage: '0x4220698be33a9738898f430018f28aeceecaa6ff'
  slot: '0x13649b2456f1b42fef0f0040b3aaeabcd21a76a0f3f5defd4f583839455116e8'
  is: '0'
  says: number 0 (mapping slot 12, key 0) belongs to the zero address
  for:
  - notes
- id: resolver
  storage: '0x4220698be33a9738898f430018f28aeceecaa6ff'
  slot: '0x0'
  is: '0x0000000000000000000000001d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed'
  says: the contract relies on the Oraclize address resolver
  for:
  - notes
- id: bet
  selector: '0x4220698be33a9738898f430018f28aeceecaa6ff'
  fn: bet(uint256)
  says: the code has the payable betting function
  for:
  - what
  - whose
- id: no-bets
  call: '0x4220698be33a9738898f430018f28aeceecaa6ff'
  fn: numberOfBets()(uint256)
  is: '0'
  says: no bets are open at the block
  for:
  - what
- id: balance
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x4220698be33a9738898f430018f28aeceecaa6ff'
  is: '0'
  says: the contract holds no ETH at the block
  for:
  - what
- id: oz1-a
  nonce: '0x26588a9301b0428d95e6fc3a5024fce8bec12d51'
  at: 12000000
  is: 584553
  says: first known oracle sender's count in 2021
  for:
  - what
- id: oz1-b
  nonce: '0x26588a9301b0428d95e6fc3a5024fce8bec12d51'
  is: 584553
  says: unchanged at the block
  for:
  - what
- id: oz2-a
  nonce: '0x000042425e06b0b1e8e20a811c91d6864608324b'
  at: 13000000
  is: 63418
  says: second known sender's count in August 2021
  for:
  - what
- id: oz2-b
  nonce: '0x000042425e06b0b1e8e20a811c91d6864608324b'
  at: 14000000
  is: 63426
  says: its count in January 2022
  for:
  - what
- id: oz2-c
  nonce: '0x000042425e06b0b1e8e20a811c91d6864608324b'
  is: 63426
  says: unchanged at the block
  for:
  - what
- id: proof-revert
  bytecode: '0x4220698be33a9738898f430018f28aeceecaa6ff'
  has: 5b90506000151581151514156106205760006000fd
  says: the callback reverts when the proof check returns false
  for:
  - justification
  - what
- id: payout
  selector: '0x4220698be33a9738898f430018f28aeceecaa6ff'
  fn: distributePrizes()
  says: the code has the public payout function
  for:
  - notes
- id: connector
  call: '0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed'
  fn: getAddress()(address)
  is: '0x3dBDc81a6edc94c720B0B88FB65dBD7e395fDcf6'
  says: the resolver points to the oracle connector
  for:
  - what
- id: cb-then
  call: '0x3dbdc81a6edc94c720b0b88fb65dbd7e395fdcf6'
  fn: cbAddresses(address)(bytes32)
  args:
  - '0x000042425e06b0b1e8e20a811c91d6864608324b'
  at: 13000000
  is: '0x0100000000000000000000000000000000000000000000000000000000000000'
  says: the connector listed the second known sender as a callback address in August 2021
  for:
  - what
- id: cb-now
  call: '0x3dbdc81a6edc94c720b0b88fb65dbd7e395fdcf6'
  fn: cbAddresses(address)(bytes32)
  args:
  - '0x000042425e06b0b1e8e20a811c91d6864608324b'
  is: '0x0000000000000000000000000000000000000000000000000000000000000000'
  says: the connector no longer lists it at the block
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

Bettors pay in; an oracle's signed random number picks the winner. Recovery gets a fixed 3,000 gas, so under the new price no proof verifies and no round draws a winner. It holds no ETH or bets today; the oracle's known senders are silent since January 2022, and its connector dropped the one used.

## Evidence

- The [runtime code](https://etherscan.io/address/0x4220698be33a9738898f430018f28aeceecaa6ff#code) calls the recovery precompile with a constant 3,000 gas.
- The [runtime code](https://etherscan.io/address/0x4220698be33a9738898f430018f28aeceecaa6ff#code) embeds the oracle's fixed proof key and has the oracle's result callback.

## Reviewer notes

### Mechanism

Unverified code built on the Oraclize random-number API (resolver 0x1d3b2638... in slot 0; Ledger root key embedded). bet() takes 100 wei per number for 11 numbers (1..11); once full, generateNumberWinner queries the oracle. The result callback (0x38bbfa50) verifies the Ledger proof; the recovery helper does CALL(3000, 0x01, ...) and reads the output from the memory holding the hash, so a failed call yields the hash and the proof fails. Under EIP-8151 recovery costs more than 3,000 gas, so the callback never sets numberWinner (slot 10, now 0). distributePrizes() is public and pays the holder of numberWinner once 11 bets are in; with no winner drawn that is the zero address (a fault that exists today, not caused by the change).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: fixed-signer (the row's old issue): the fixed key is the oracle's Ledger hardware key, not an Ethereum account that can take real code; the break comes from the fixed gas.
- Ruled out: proxy or upgrade: EIP-1967 slot empty, no upgradeTo selector, owner() does not answer.
- Ruled out: Not caused by the change: distributePrizes() (0x7ce52eb6) checks only numberOfBets >= 11 and pays the holder of numberWinner; number 0 is the zero address, so anyone can already send a full pot to the zero address today. Under EIP-8151 that pre-existing fault stays the only way a filled pot leaves.

### Questions

- Rating for Anon: HIGH as rated (no update path; a filled round's pot can never reach a player), or an INFORMATIONAL dormancy notice, since at the block the contract holds 0 ETH, has no open round and the loss falls only on someone who bets after activation.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
