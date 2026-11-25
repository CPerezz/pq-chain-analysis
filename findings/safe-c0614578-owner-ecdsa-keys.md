---
id: safe-c0614578-owner-ecdsa-keys
format: 2
title: This 4-of-7 Safe pays out on any four forged ECDSA owner signatures
status: confirmed
severity: MEDIUM
justification: Four forged owner keys move everything; the owners can fix it by swapping in post-quantum signers.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc06145782f31030db1c40b203be6b0fd53410b6d'
  name: Safe
  code: verified
  code_url: https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code
  proxy_of: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  copies: 1
value:
  usd: 123287565
  basis: held
activity: {}
impact: funds-loss
action: Swap owner keys with swapOwner for post-quantum signer contracts answering the legacy isValidSignature(bytes,bytes).
evidence_level: source
checks:
- id: singleton
  storage: '0xc06145782f31030db1c40b203be6b0fd53410b6d'
  slot: '0x0'
  is: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  says: the proxy runs the Safe 1.4.1 singleton
  for:
  - what
- id: exec
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 172
  has: checkSignatures(txHash, txHashData, signatures);
  says: execTransaction runs any call once the signatures pass
  for:
  - justification
  - what
- id: ecdsa
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 329
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: a signature with v 27 or 28 is recovered with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: owner-check
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 331
  has: owners[currentOwner] != address(0)
  says: the recovered address only has to be in the owner list; the owner's account is not asked
  for:
  - evidence-1
  - justification
  - what
- id: erc1271
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 315
  has: ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE
  says: a contract owner signs through ERC-1271 (v = 0)
  for:
  - action
  - justification
- id: swap
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/base/OwnerManager.sol
  lines:
  - 99
  - 109
  has: function swapOwner(address prevOwner, address oldOwner, address newOwner) public authorized
  says: swapOwner replaces one owner by another address, callable by the Safe itself
  for:
  - action
  - justification
- id: self
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/common/SelfAuthorized.sol
  line: 10
  has: require(msg.sender == address(this), "GS031");
  says: authorized functions are reached only through the Safe's own execTransaction
  for:
  - action
  - justification
- id: threshold
  call: '0xc06145782f31030db1c40b203be6b0fd53410b6d'
  fn: getThreshold()(uint256)
  is: 4
  says: four owner signatures are needed
  for:
  - evidence-2
  - justification
  - what
- id: owners
  call: '0xc06145782f31030db1c40b203be6b0fd53410b6d'
  fn: getOwners()(address[])
  is:
  - '0x5ed8cee6b63b1c6afce3ad7c92f4fd7e1b8fad9f'
  - '0xa0988fafe56f4e103c8a592257c1af3f17890597'
  - '0x6d288a7299838ca5ffe759cf4ca320e05a832f59'
  - '0x3644220f89edf06ff8ae85d2652d985c831e6ff4'
  - '0xd3b6160001a6e1941f077ec7a1dd8c05e35d2f68'
  - '0x46df87617f7bc93371c6d969bdbee8c998fc0555'
  - '0xba6be667fc0045f15535f576533fc0cf436905b9'
  says: the Safe has seven owners
  for:
  - evidence-2
  - what
- id: balance
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0xc06145782f31030db1c40b203be6b0fd53410b6d'
  is: 68320014468835518465696
  says: the Safe holds 68,320 ETH
  for:
  - what
- id: eoa-1
  code: '0x5ed8cee6b63b1c6afce3ad7c92f4fd7e1b8fad9f'
  is: empty
  says: this owner is a plain key with no code
  for:
  - what
- id: eoa-2
  code: '0xa0988fafe56f4e103c8a592257c1af3f17890597'
  is: empty
  says: this owner is a plain key with no code
  for:
  - what
- id: eoa-3
  code: '0x6d288a7299838ca5ffe759cf4ca320e05a832f59'
  is: empty
  says: this owner is a plain key with no code
  for:
  - what
- id: eoa-4
  code: '0x3644220f89edf06ff8ae85d2652d985c831e6ff4'
  is: empty
  says: this owner is a plain key with no code
  for:
  - what
- id: eoa-5
  code: '0xd3b6160001a6e1941f077ec7a1dd8c05e35d2f68'
  is: empty
  says: this owner is a plain key with no code
  for:
  - what
- id: eoa-6
  code: '0x46df87617f7bc93371c6d969bdbee8c998fc0555'
  is: empty
  says: this owner is a plain key with no code
  for:
  - what
- id: eoa-7
  code: '0xba6be667fc0045f15535f576533fc0cf436905b9'
  is: empty
  says: this owner is a plain key with no code
  for:
  - what
- id: sent-1
  nonce: '0x5ed8cee6b63b1c6afce3ad7c92f4fd7e1b8fad9f'
  min: 927
  says: this owner has sent transactions, so its public key is on-chain
  for:
  - evidence-2
  - what
- id: sent-2
  nonce: '0xa0988fafe56f4e103c8a592257c1af3f17890597'
  min: 6
  says: this owner has sent transactions, so its public key is on-chain
  for:
  - evidence-2
  - what
- id: sent-3
  nonce: '0x3644220f89edf06ff8ae85d2652d985c831e6ff4'
  min: 4
  says: this owner has sent transactions, so its public key is on-chain
  for:
  - evidence-2
  - what
- id: sent-4
  nonce: '0x46df87617f7bc93371c6d969bdbee8c998fc0555'
  min: 1
  says: this owner has sent transactions, so its public key is on-chain
  for:
  - evidence-2
  - what
- id: sent-5
  nonce: '0xba6be667fc0045f15535f576533fc0cf436905b9'
  min: 3
  says: this owner has sent transactions, so its public key is on-chain
  for:
  - evidence-2
  - what
- id: legacy
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/interfaces/ISignatureValidator.sol
  lines:
  - 5
  - 19
  has: function isValidSignature(bytes memory _data, bytes memory _signature) public view virtual returns (bytes4);
  says: the interface asked is the legacy isValidSignature(bytes,bytes), magic value 0x20c13b0b
  for:
  - action
- id: sel-legacy
  bytecode: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  has: '0x20c13b0b'
  says: the singleton's code holds the legacy magic value 0x20c13b0b
  for:
  - action
- id: sel-final
  bytecode: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  has: '0x1626ba7e'
  absent: true
  says: the final ERC-1271 selector 0x1626ba7e is absent from the singleton, so an owner contract that answers only
    that one does not count
  for:
  - action
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: review (Review04)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (source of 1.3.0 read, two real transactions replayed four ways; not reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: confirmed
  rating: ''
  pattern: PQ-12
reviews:
- who: r-c0614578, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Kev''s first-study finding, MEDIUM (PQ-12): a 4-of-7 Safe 1.4.1 (68,320 ETH); owners are plain ECDSA
    keys, five exposed; checkNSignatures never asks the owner''s account; fix: swapOwner to post-quantum signer
    contracts answering the legacy isValidSignature(bytes,bytes) (Claude named the interface after settling; a fresh
    refuter agrees, as two did before on the rest). The Allowance Module''s one delegate has a 0 ETH allowance.
    Claude read the sheet.'
related: []
---

## What happens

This Safe, a 4-of-7 multisig holding about 68,320 ETH, executes any transaction that four of its owners sign. All seven owners are plain keys that sign with ECDSA. A quantum attacker who recovers four owner keys can move everything it holds.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) accepts an owner's ECDSA signature and never asks the owner's account.
- [The Safe](https://etherscan.io/address/0xc06145782f31030db1c40b203be6b0fd53410b6d) needs 4 of its 7 owners; five owners have sent transactions, so their public keys are on-chain.

## Reviewer notes

### Mechanism

The SafeProxy delegates to the Safe 1.4.1 singleton (slot 0). execTransaction hashes the Safe transaction, increments the nonce and calls checkSignatures, which needs threshold (4) signatures in checkNSignatures. For v = 27/28 (and v > 30, eth_sign) the signer is ecrecover's result; it only has to be in the owners list and in ascending order (line 331). v = 0 asks a contract owner through ERC-1271; v = 1 accepts an approved hash or msg.sender == owner, both from the owner's own key. Nothing asks an EOA owner's account, so an owner that moves its account to post-quantum authorisation at the same address is still forgeable here. All seven owners have no code at the block; five have nonce >= 1 (927, 6, 4, 1, 3), at least the threshold. The fix is swapOwner (self-call via execTransaction with 4 signatures) to contract owners that verify post-quantum signatures through ERC-1271; this needs at least four of the seven owners replaced and the owners acting together, hence MEDIUM (fix by owners migrating / several parties).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: erc1271: the Safe has an ERC-1271 path (v = 0), but none of the seven owners has code at the block, so they sign with ECDSA.
- Ruled out: key-state: all seven owners are EOAs with empty code; five have sent transactions (nonces 927, 6, 4, 1, 3), so four keys are exposed even ignoring signatures posted in Safe calldata.
- Ruled out: direct-path: an enabled module, 0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134 (NAME 'Allowance Module', VERSION 0.1.0, one delegate 0x0a194847ec1164fe51ddabf19dd65b5d4333687b), can spend allowances the Safe set, on the delegate's ECDSA signature. It is a separate contract with its own exposure and only reaches what the allowances allow; it does not change this card. No guard is set (guard slot 0x4a20...34c8 is zero).
- Ruled out: unused-implementation / wrong-code: the address is an initialized proxy (threshold 4, seven owners, nonce 18) whose slot 0 holds the 1.4.1 singleton whose source is read here.
- Ruled out: EIP-8151: if an owner's address took real code, its ECDSA signature would stop counting under EIP-8151 (a 7702 delegation still recovers); the quantum-exposure rubric does not assume that change.
- Ruled out: replay 0x09827fd946d676f0c1ed2123efc82c8a9e8ee00cfbee153ea8160453e8391328 (family replays, signer 0x033ac28073bccc6c1486c99d00d683f2f265dcdd, multiSend root) fails under EIP-8151 alone; it belongs to another Safe of the same code, not this address, and is not cited.
- Ruled out: whose: the Safe's 68,320 ETH could be the owners' own or held for others; nothing on chain shows which, so whose is left empty.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
