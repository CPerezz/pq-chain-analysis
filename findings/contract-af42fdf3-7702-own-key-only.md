---
id: contract-af42fdf3-7702-own-key-only
format: 2
title: This account's signed messages fail if it takes real code
status: candidate
severity: INFORMATIONAL
justification: Breaks only if this account takes real code; its EIP-7702 delegation keeps working.
category: migration-notice
pattern: PQ-20
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xaf42fdf3f98a90b1e442b7b3fd7729504bead435'
  code: decompiled
  code_url: code/0xd151ac470a829c62199bab9a29f40e5f3e4b0e685ccf7f8092236ba7602ac0d8.sol
  copies: 2
  family: 66247e8a50731d8f2982cdf98ab92e73
  admin: '0xaf42fdf3f98a90b1e442b7b3fd7729504bead435'
value:
  usd: 6298
  whose: users
  basis: held
activity: {}
impact: liveness
action: Keep the EIP-7702 delegation, or move to account logic that checks another key, before this account takes
  real code.
evidence_level: bytecode
checks:
- id: dlg
  code: '0xaf42fdf3f98a90b1e442b7b3fd7729504bead435'
  is: delegation
  target: '0x4daadb76ce569802a0494594e0561274b617f024'
  says: the account holds an EIP-7702 delegation to the wallet code
  for:
  - action
  - evidence-2
  - justification
  - what
  - whose
- id: nonce
  nonce: '0xaf42fdf3f98a90b1e442b7b3fd7729504bead435'
  is: 103
  says: the account has sent its own transactions at the block, so it is a key holder's account
  for:
  - notes
- id: owner
  call: '0xaf42fdf3f98a90b1e442b7b3fd7729504bead435'
  fn: owner()(address)
  is: '0xaf42fdf3f98a90b1e442b7b3fd7729504bead435'
  says: the account's owner is the account itself
  for:
  - evidence-2
  - whose
- id: sel1271
  selector: '0x4daadb76ce569802a0494594e0561274b617f024'
  fn: isValidSignature(bytes32,bytes)
  says: the wallet code answers ERC-1271 signature checks
  for:
  - evidence-1
  - what
- id: ecrec
  bytecode: '0x4daadb76ce569802a0494594e0561274b617f024'
  has: 82805260015afa15
  says: the signature is recovered by the precompile at address 1 with all remaining gas
  for:
  - evidence-1
  - what
- id: selfcmp
  bytecode: '0x4daadb76ce569802a0494594e0561274b617f024'
  has: 5b7f1626ba7e0000000000000000000000000000000000000000000000000000000090565b73ffffffffffffffffffffffffffffffffffffffff163014
  says: the valid answer 0x1626ba7e is given when the recovered address equals the account's own address
  for:
  - action
  - evidence-1
  - justification
  - what
- id: noxfer
  selector: '0x4daadb76ce569802a0494594e0561274b617f024'
  fn: transferOwnership(address)
  absent: true
  says: the wallet code has no function to hand the account to another key
  for:
  - action
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews:
- who: r-af42fdf3, the row's refuter
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: Author and refuter agree; sheet read by Claude. A 7702-delegated account whose wallet code accepts
    only its own key; signed messages to other contracts stop if it takes this logic as real code. Stays a candidate
    (bytecode). Wording pass: say that the second copy is the unused wallet code.'
related: []
---

## What happens

This account delegates to wallet code that confirms its signed messages for other contracts by recovering the signer and accepting it only if it is the account itself. An EIP-7702 delegation keeps working; if the account takes real code, its signed messages are refused.

## Evidence

- [The delegate code](https://etherscan.io/address/0x4daadb76ce569802a0494594e0561274b617f024#code) answers isValidSignature as valid only when the recovered signer is the account's own address.
- [The account](https://etherscan.io/address/0xaf42fdf3f98a90b1e442b7b3fd7729504bead435) holds an EIP-7702 delegation to that code, and its owner is the account itself.

## Reviewer notes

### Mechanism

The address is an EOA (nonce 103) with an EIP-7702 delegation to 0x4daadb76ce569802a0494594e0561274b617f024 (unverified, 6,590 bytes, judged from the disassembly). isValidSignature (0x1626ba7e) decodes a 65- or 64-byte signature, rejects high s, and calls precompile 0x01 with all remaining gas (PUSH1 1, GAS, STATICCALL). If recovery succeeds and the recovered address equals ADDRESS (the account itself), it returns 0x1626ba7e, otherwise 0xffffffff. No stored key and no other signer is consulted there. The other functions (execute, executeBatch, batchApprove, operator add/remove) require msg.sender == owner; owner sits in an ERC-7201 slot set once by initialize(), which requires the caller to be the account itself and stores ADDRESS. At the block owner() returns the account itself. Operators can call one swap function only when tx.origin is the account itself. With the delegation, EIP-8151 still recovers the account, so nothing changes today. If the account held real code instead, recovery would return nothing for it, and every ERC-1271 check against it (permits, off-chain orders) would fail.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: another key or ERC-1271 path: isValidSignature compares the recovered signer with ADDRESS only; owner is written once by initialize to the account itself and the code has no transferOwnership selector.
- Ruled out: breaks by itself on gas: the recovery call passes all remaining gas, not a constant, so the higher price does not break it with nobody migrating.
- Ruled out: the second copy 0x4daadb76ce569802a0494594e0561274b617f024 is the delegate code itself: its owner() is zero and initialize needs a call from itself, so it serves no account; this address is the one in use.
- Ruled out: funds locked: the account's own functions need a transaction from the account itself (msg.sender == owner, tx.origin for operators); an account with real code cannot send one (EIP-3607), a lock that comes from that rule, not from EIP-8151, so impact is liveness of its signed messages.
- Ruled out: replays and real recoveries: the dossier has none (scan.window null, no replays), so evidence stays bytecode.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
