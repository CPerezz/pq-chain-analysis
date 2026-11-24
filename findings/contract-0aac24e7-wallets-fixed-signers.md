---
id: contract-0aac24e7-wallets-fixed-signers
format: 2
title: Single-owner wallet locks if its owner's account takes real code
status: candidate
severity: INFORMATIONAL
justification: Breaks only if the owner moves to real code; the owner cannot be replaced, so funds must move out
  first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0aac24e7cb56ad3f4078b047af106d8bfb201faf'
  code: bytecode
  code_url: https://etherscan.io/address/0x0aac24e7cb56ad3f4078b047af106d8bfb201faf#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-locked
action: Move all funds and assets out of this wallet before the owner's account takes real code; the owner cannot
  be replaced.
evidence_level: bytecode
checks:
- id: precompile
  bytecode: '0x0aac24e7cb56ad3f4078b047af106d8bfb201faf'
  has: 60006001848e8481518110
  says: the recovery loop pushes address 0x01, the ecrecover precompile, as the call target
  for:
  - evidence-1
  - what
- id: recover
  bytecode: '0x0aac24e7cb56ad3f4078b047af106d8bfb201faf'
  has: 855afa158015610af1
  says: the precompile is called by STATICCALL with all remaining gas, and a failed call reverts
  for:
  - action
  - evidence-1
  - justification
  - what
- id: isowner
  bytecode: '0x0aac24e7cb56ad3f4078b047af106d8bfb201faf'
  has: 826001600160a01b0316816001600160a01b0316118015610b3657
  says: the recovered address must be above the previous one and marked in the owner mapping at slot 2
  for:
  - action
  - evidence-1
  - justification
  - what
- id: wrongsig
  bytecode: '0x0aac24e7cb56ad3f4078b047af106d8bfb201faf'
  has: 6e57524f4e47205349474e4154555245
  says: a recovered address that fails the owner check reverts with WRONG SIGNATURE
  for:
  - evidence-1
  - what
- id: loop
  bytecode: '0x0aac24e7cb56ad3f4078b047af106d8bfb201faf'
  has: 5b600154811015
  says: the loop runs once per unit of the threshold stored in slot 1
  for:
  - what
- id: onlywrite
  bytecode: '0x0aac24e7cb56ad3f4078b047af106d8bfb201faf'
  has: '600080546001019055'
  says: the runtime code's one storage write increments the nonce in slot 0; the other SSTORE byte is in the metadata
  for:
  - action
  - evidence-3
  - justification
  - what
- id: threshold
  call: '0x0aac24e7cb56ad3f4078b047af106d8bfb201faf'
  fn: threshold()(uint256)
  is: 1
  says: one owner signature is required
  for:
  - evidence-1
  - what
- id: owners
  storage: '0x0aac24e7cb56ad3f4078b047af106d8bfb201faf'
  slot: '0x3'
  is: '0x0000000000000000000000000000000000000000000000000000000000000001'
  says: the owner list has one entry
  for:
  - evidence-2
  - what
- id: isowner-call
  call: '0x0aac24e7cb56ad3f4078b047af106d8bfb201faf'
  fn: isOwner(address)(bool)
  args:
  - '0x028ce9793123344cde592f393b96a8368c1b0abb'
  is: true
  says: 0x028ce979 is the owner
  for:
  - evidence-2
- id: ownercode
  code: '0x028ce9793123344cde592f393b96a8368c1b0abb'
  is: empty
  says: the owner is an account without code at the block
  for:
  - evidence-2
- id: wnonce
  call: '0x0aac24e7cb56ad3f4078b047af106d8bfb201faf'
  fn: nonce()(uint256)
  is: 2
  says: the wallet has executed two signed transactions
  for:
  - evidence-2
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: HIGH
reviews:
- who: r-0aac24e7, the row's refuter
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: Author and refuter agree (refuter disassembled the runtime: one owner at slot 3, threshold 1, only
    the nonce is written, the only CALL follows the signature loop). Sheet read by Claude. Single-owner wallet,
    no setter, holds about $0; INFORMATIONAL (was HIGH). Stays a candidate (unverified).'
related: []
---

## What happens

This wallet runs a transfer or call when a signature recovers to its single owner. The owner is set at deployment and the code has no way to replace it. If the owner's account takes real code, the wallet refuses its signature and its funds stay locked; an EIP-7702 delegation keeps working.

## Evidence

- [The wallet](https://etherscan.io/address/0x0aac24e7cb56ad3f4078b047af106d8bfb201faf#code) recovers each signature and rejects it unless it comes from an owner; one signature is required.
- [Its one owner](https://etherscan.io/address/0x028ce9793123344cde592f393b96a8368c1b0abb) has no code today; the wallet has run two signed transactions.
- [The code](https://etherscan.io/address/0x0aac24e7cb56ad3f4078b047af106d8bfb201faf#code) writes storage only to count its transactions, so the owner never changes.

## Reviewer notes

### Mechanism

Unverified code (4,141 bytes, no DELEGATECALL, no proxy). The disassembly matches SimpleMultiSig with an executor and gas-limit argument: execute (0xa0ab9653) builds an EIP-712 digest with the domain separator in slot 4, then loops i < threshold (slot 1, value 1). Each step pushes 0x01 and STATICCALLs the precompile with all remaining gas (GAS opcode, not a constant), then requires recovered > last recovered and isOwner[recovered] (mapping in slot 2), else reverts WRONG SIGNATURE. After the loop it increments the nonce in slot 0 and makes the call. The runtime code has two SSTORE bytes: the nonce increment at 0xbc0 and one at 0xfe0 inside the trailing metadata after the INVALID that ends the code; so no function writes the owner set or threshold, which the constructor set. Owner 0x028ce979... is an EOA (no code, nonce 22) at the block. Under EIP-8151 a recovery of an owner with real code returns nothing, the isOwner check fails and execute reverts; no other function moves funds out.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size path for the owner: the only other external call is the executed CALL; the one EXTCODESIZE (0xfcb) checks the call's destination (FUNCTION CALL TO NORMAL ACCOUNT), not the signer.
- Ruled out: a fixed gas amount to the precompile: the STATICCALL gets GAS (all remaining gas), so the change breaks nothing by itself.
- Ruled out: a proxy or upgrade: no DELEGATECALL, EIP-1967 slots empty; unused implementation: the wallet has its own owner and nonce 2, so it was used directly.
- Ruled out: a direct path for the owner: the caller is not counted as a signer; msg.sender is only compared with the signed executor field (WRONG EXECUTOR).

### Questions

- Whose funds these are (the owner's own or a service's) is not established; the wallet holds about 0.000042 ETH and no priced tokens; unpriced tokens or roles held were not checked (no wide log scans).

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
