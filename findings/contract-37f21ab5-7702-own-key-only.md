---
id: contract-37f21ab5-7702-own-key-only
format: 2
title: Delegated accounts lock funds by taking this logic as real code
status: candidate
severity: INFORMATIONAL
justification: Nothing breaks while the accounts stay delegated; it breaks only if a holder replaces the delegation
  with real code.
category: migration-notice
pattern: PQ-20
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x37f21ab551f010353fd071c27d53496aa94763c6'
  label: 'Bitget Wallet: 7702 v0.0.1'
  code: bytecode
  code_url: https://etherscan.io/address/0x37f21ab551f010353fd071c27d53496aa94763c6#code
  copies: 10579
  family: d51eb37435c14be494bdd014dc684fdf
value:
  usd: 133443
  whose: users
  basis: held
activity: {}
impact: funds-locked
action: Warn users to keep this delegation, or move their funds to an account with another key, before giving an
  account real code.
evidence_level: bytecode
checks:
- id: deleg
  code: '0x37f21ab551f010353fd071c27d53496aa94763c6'
  is: delegation
  bytes: 23
  target: '0x4428a93b478fa76a5bd9c7641f54ec6373855433'
  says: the address is an EOA delegated to the account logic
  for:
  - action
  - justification
  - whose
- id: nonce
  nonce: '0x37f21ab551f010353fd071c27d53496aa94763c6'
  is: 23
  says: the account's key has sent 23 transactions, so the account belongs to a key holder
  for:
  - whose
- id: ecself
  bytecode: '0x4428a93b478fa76a5bd9c7641f54ec6373855433'
  has: 6001868287856040515f81526020016040526040516106dd949392919061134d565b6020604051602081039080840390855afa1580156106fd573d5f5f3e3d5ffd5b5050506020604051035173ffffffffffffffffffffffffffffffffffffffff163073ffffffffffffffffffffffffffffffffffffffff1614
  says: the recovery is a static call to the precompile with all gas, and its result is compared with the account's
    own address
  for:
  - action
  - evidence-1
  - justification
  - what
- id: epgate
  bytecode: '0x4428a93b478fa76a5bd9c7641f54ec6373855433'
  has: 7f0000000000000000000000004337084d9e255ff0702461cf8895ce9e3b5ff10873ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff1614
  says: operations are validated only when the EntryPoint calls
  for:
  - what
- id: helpercall
  bytecode: '0x4428a93b478fa76a5bd9c7641f54ec6373855433'
  has: 7f000000000000000000000000e11be20b572a80e1fb9c5ec852595ad65cf09fe073ffffffffffffffffffffffffffffffffffffffff16630db39b93
  says: the batch function calls the helper's check
  for:
  - evidence-2
  - what
- id: helperrevert
  bytecode: '0x4428a93b478fa76a5bd9c7641f54ec6373855433'
  has: 5af1158015610563573d5f5f3e3d5ffd
  says: if the helper's check fails, the batch reverts
  for:
  - evidence-2
  - what
- id: helperself
  bytecode: '0xe11be20b572a80e1fb9c5ec852595ad65cf09fe0'
  has: 5b61043333828787610b80565b
  says: the helper verifies a signature against its caller, the account
  for:
  - action
  - evidence-2
  - what
- id: helpercmp
  bytecode: '0xe11be20b572a80e1fb9c5ec852595ad65cf09fe0'
  has: 5b90508473ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff1614610c3e576040517f8baa579f
  says: the helper reverts unless the recovered address equals the expected one
  for:
  - evidence-2
  - what
- id: helperno1271
  bytecode: '0xe11be20b572a80e1fb9c5ec852595ad65cf09fe0'
  has: 1626ba7e
  absent: true
  says: the helper has no ERC-1271 call
  for:
  - evidence-2
- id: noselfcall1
  bytecode: '0x4428a93b478fa76a5bd9c7641f54ec6373855433'
  has: 3073ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff16
  absent: true
  says: the logic has no address(this)==msg.sender path that skips the signature
  for:
  - what
- id: noselfcall2
  bytecode: '0x4428a93b478fa76a5bd9c7641f54ec6373855433'
  has: 3373ffffffffffffffffffffffffffffffffffffffff163073ffffffffffffffffffffffffffffffffffffffff16
  absent: true
  says: the logic has no msg.sender==address(this) path that skips the signature
  for:
  - what
- id: helpersigner
  call: '0xe11be20b572a80e1fb9c5ec852595ad65cf09fe0'
  fn: signer()(address)
  is: '0xdbea7a7950539f59acf8ffe1980a4e3f65334b14'
  says: the helper's operator key at the block
  for:
  - notes
- id: signernocode
  code: '0xdbea7a7950539f59acf8ffe1980a4e3f65334b14'
  is: empty
  says: the operator key has no code, so its signature still recovers under the change
  for:
  - notes
- id: replaytoday
  replay: '0x766c0146760932b98aff25283530e128e68395af513181aee9e67c7904f8cc99'
  run: today
  ok: true
  says: the replay reproduces the real transaction of a delegated account
  for:
  - evidence-3
- id: replay8151
  replay: '0x766c0146760932b98aff25283530e128e68395af513181aee9e67c7904f8cc99'
  run: eip8151
  ok: true
  says: under EIP-8151 the delegated account's transaction still succeeds
  for:
  - evidence-3
  - justification
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews:
- who: r-37f21ab5, the row's refuter
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: Sent back once (the lock happens only if an account takes this logic as its real code, not any real
    code); the new card says so. A fresh refuter re-read both codes byte by byte and agrees; sheet read by Claude.
    Bitget Wallet 7702 v0.0.1: $621,881 across 10,579 delegated accounts; INFORMATIONAL notice.'
related: []
---

## What happens

This account logic accepts a signature only when it recovers to the account's own address, for its approvals, its operations and its relayed batches. An account that makes this logic its real code can no longer approve anything, so its funds are locked.

## Evidence

- The [deployed code](https://etherscan.io/address/0x4428a93b478fa76a5bd9c7641f54ec6373855433#code) recovers each signature and compares the result with the account's own address.
- Relayed batches run only after a [helper](https://etherscan.io/address/0xe11be20b572a80e1fb9c5ec852595ad65cf09fe0#code) checks the account's own signature, next to an operator key's.
- A real [transaction](https://etherscan.io/tx/0x766c0146760932b98aff25283530e128e68395af513181aee9e67c7904f8cc99) of a delegated account still succeeds when replayed under the change.

## Reviewer notes

### Mechanism

The address is an EIP-7702 delegation to 0x4428...3433 (unverified, 5,249 bytes, judged from its disassembly). Its one ecrecover (real offset 0x06bc-0x0735) is a STATICCALL to 0x01 with all remaining gas, and the result is compared with ADDRESS. That routine backs isValidSignature (0x1626ba7e: magic value only on a match) and validateUserOp (0x19822f7c: callable only by EntryPoint 0x4337...f108, returns 1 on a mismatch). The only function that executes calls, 0x9265bb9d (no caller check), checks a deadline, calls the helper 0xe11be2...9fe0 with 0x0db39b93 and reverts if that call fails, then runs the batch. The helper builds a struct of chainid, CALLER (the account), the arguments and its own address, and requires two ECDSA signatures over it: one recovering to its stored signer (slot 1, signer() = 0xdbea...4b14, settable by the owner) and one recovering to CALLER; a mismatch reverts with InvalidSignature. Neither contract has an ERC-1271 branch for the account. The code holds no stored key of the account. An account with real code cannot send transactions (EIP-3607), so it could only act through these paths, all of which need its own recovered key. As a delegation the account keeps working (EIP-8151 exempts delegations), which the replay of a real transaction under the change confirms.

### Checks

- Header facts: this address alone, at block 26,438,999; 10,579 addresses run this code.
- Ruled out: an ERC-1271 path for the account's own key: the only comparison is with ADDRESS in the account code, and the helper's verifier compares the recovered address with CALLER and has no 1626ba7e selector.
- Ruled out: a signature-free path to move funds: the account code has no SLOAD and no owner; 0x9265bb9d is the only function that executes calls and it requires the helper's check; the fallback only accepts ETH and token-receipt hooks.
- Ruled out: breaks with nobody acting: both recoveries forward all gas, and the dossier's replay under EIP-8151 alone succeeds; the helper's stored signer 0xdbea...4b14 has no code at the block.
- Ruled out: wrong code or unused address: this address is itself a delegation to 0x4428...3433, with 23 transactions sent and funds held at the block.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
