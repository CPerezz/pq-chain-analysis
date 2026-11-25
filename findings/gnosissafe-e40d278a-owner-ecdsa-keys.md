---
id: gnosissafe-e40d278a-owner-ecdsa-keys
format: 2
title: Two forged owner keys can move everything this Safe holds
status: confirmed
severity: MEDIUM
justification: Two forged owner keys move the funds; the fix needs two of the five owners to replace the keys.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe40d278afd00e6187db21ff8c96d572359ef03bf'
  name: GnosisSafe
  code: verified
  code_url: https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code
  proxy_of: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  copies: 1
value:
  usd: 2002040
  basis: held
activity:
  txs_90d: 45
impact: funds-loss
action: Replace each owner key, with swapOwner, by a post-quantum signer contract that answers isValidSignature(bytes,bytes).
evidence_level: source
checks:
- id: singleton
  storage: '0xe40d278afd00e6187db21ff8c96d572359ef03bf'
  slot: 0
  is: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  says: the proxy's slot 0 holds the singleton whose code it runs
  for:
  - what
- id: version
  call: '0xe40d278afd00e6187db21ff8c96d572359ef03bf'
  fn: VERSION()(string)
  is: 1.3.0
  says: the Safe runs version 1.3.0
  for:
  - action
  - what
- id: threshold
  call: '0xe40d278afd00e6187db21ff8c96d572359ef03bf'
  fn: getThreshold()(uint256)
  is: 2
  says: two owner approvals are required
  for:
  - evidence-2
  - justification
  - what
- id: owners
  call: '0xe40d278afd00e6187db21ff8c96d572359ef03bf'
  fn: getOwners()(address[])
  is:
  - '0x93a53Ff6F963cD2bF69aC57ED7bdaBB897668d6F'
  - '0x2FCE55E9f3D2bc1DaffC2CddAb4CF7593e9A3424'
  - '0x0fc4b69958CB2Fa320a96d54168b89953a953FBF'
  - '0x69E8372Ed157e9b93145ae6AD189dEbB1689B6b1'
  - '0x200768d3F9c819f3430827c291c399Ab9509f061'
  says: the Safe has these five owners
  for:
  - evidence-2
  - what
- id: o1-code
  code: '0x93a53ff6f963cd2bf69ac57ed7bdabb897668d6f'
  is: empty
  says: owner 1 has no code
  for:
  - evidence-2
  - what
- id: o2-code
  code: '0x2fce55e9f3d2bc1daffc2cddab4cf7593e9a3424'
  is: empty
  says: owner 2 has no code
  for:
  - evidence-2
  - what
- id: o3-code
  code: '0x0fc4b69958cb2fa320a96d54168b89953a953fbf'
  is: empty
  says: owner 3 has no code
  for:
  - evidence-2
  - what
- id: o4-code
  code: '0x69e8372ed157e9b93145ae6ad189debb1689b6b1'
  is: empty
  says: owner 4 has no code
  for:
  - evidence-2
  - what
- id: o5-code
  code: '0x200768d3f9c819f3430827c291c399ab9509f061'
  is: empty
  says: owner 5 has no code
  for:
  - evidence-2
  - what
- id: o1-nonce
  nonce: '0x93a53ff6f963cd2bf69ac57ed7bdabb897668d6f'
  is: 544
  says: owner 1 has sent transactions, which publish its public key
  for:
  - what
- id: o2-nonce
  nonce: '0x2fce55e9f3d2bc1daffc2cddab4cf7593e9a3424'
  is: 169
  says: owner 2 has sent transactions, which publish its public key
  for:
  - what
- id: o3-nonce
  nonce: '0x0fc4b69958cb2fa320a96d54168b89953a953fbf'
  is: 2093
  says: owner 3 has sent transactions, which publish its public key
  for:
  - what
- id: o4-nonce
  nonce: '0x69e8372ed157e9b93145ae6ad189debb1689b6b1'
  is: 436
  says: owner 4 has sent transactions, which publish its public key
  for:
  - what
- id: o5-nonce
  nonce: '0x200768d3f9c819f3430827c291c399ab9509f061'
  is: 2
  says: owner 5 has sent transactions, which publish its public key
  for:
  - what
- id: modules
  call: '0xe40d278afd00e6187db21ff8c96d572359ef03bf'
  fn: getModulesPaginated(address,uint256)(address[],address)
  args:
  - '0x0000000000000000000000000000000000000001'
  - 10
  is:
  - []
  - '0x0000000000000000000000000000000000000001'
  says: no module is enabled
  for:
  - evidence-2
- id: guard
  storage: '0xe40d278afd00e6187db21ff8c96d572359ef03bf'
  slot: '0x4a204f620c8c5ccdca3fd54d003badd85ba500436a431f0cbda4f558c93c34c8'
  is: 0
  says: no transaction guard is set
  for:
  - evidence-2
- id: link
  call: '0x514910771af9ca656af840dff83e8264ecf986ca'
  fn: balanceOf(address)(uint256)
  args:
  - '0xe40d278afd00e6187db21ff8c96d572359ef03bf'
  is: '218293982578338345984429'
  says: the Safe holds about 218,294 LINK
  for:
  - what
- id: exec
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 145
  has: checkSignatures(txHash, txHashData, signatures);
  says: execTransaction checks the owners' signatures over the transaction hash before executing
  for:
  - justification
  - what
- id: run
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 176
  has: success = execute(to, value, data, operation,
  says: after the signature check execTransaction runs the given call to any target
  for:
  - what
- id: ecdsa
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 299
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: a signature is recovered with ECDSA; the owner's account is not called
  for:
  - evidence-1
  - justification
  - what
- id: owner-set
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 301
  has: owners[currentOwner] != address(0)
  says: the recovered address only has to be in the stored owner set
  for:
  - evidence-1
  - justification
  - what
- id: legacy-call
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 285
  has: ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE
  says: a contract owner is asked through isValidSignature with the data bytes and its signature
  for:
  - action
  - evidence-3
- id: legacy-magic
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/interfaces/ISignatureValidator.sol
  line: 6
  has: EIP1271_MAGIC_VALUE = 0x20c13b0b;
  says: the expected answer is the legacy value of isValidSignature(bytes,bytes)
  for:
  - action
  - evidence-3
- id: legacy-selector
  selector: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  fn: isValidSignature(bytes,bytes)
  says: the singleton's code carries the legacy selector 0x20c13b0b
  for:
  - action
  - evidence-3
- id: final-absent
  selector: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: the final ERC-1271 selector 0x1626ba7e is not in the singleton's code
  for:
  - action
  - evidence-3
- id: swap
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/base/OwnerManager.sol
  lines:
  - 94
  - 108
  has: owners[newOwner] = owners[oldOwner];
  says: swapOwner replaces one owner address with another
  for:
  - action
  - justification
- id: self-only
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/common/SelfAuthorized.sol
  line: 8
  has: require(msg.sender == address(this), "GS031");
  says: owner changes are accepted only as a call from the Safe itself, that is, a transaction its owners approved
  for:
  - action
  - justification
- id: no-mastercopy
  selector: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  fn: changeMasterCopy(address)
  absent: true
  says: the 1.3.0 singleton has no changeMasterCopy function
  for:
  - notes
- id: safe-tx
  tx: '0x85d58d1d83658816a49c98e9c6075f95a925caee34514fc22a0236b375677e65'
  to: '0xe40d278afd00e6187db21ff8c96d572359ef03bf'
  ok: true
  says: a recent transaction to this Safe succeeded, so it is in use
  for:
  - notes
- id: replay-a
  tx: '0x16a1d468122d1a5ae05007fb587fdefc8ef631d4fc6ee7f4c714340835a16208'
  to: '0x237dee529a47750becdfa8a59a1d766e3e7b5f91'
  says: this family replay went to another Safe, not this address
  for:
  - notes
- id: replay-b
  tx: '0x5b42f691ac82b8a12e4cc736e5bfc85fa9d46fd1e34ce373948d334cd697acf9'
  to: '0x61a2c600081bf0d5c4c4d7b4a9240ec0a9093cb2'
  says: this family replay went to another Safe, not this address
  for:
  - notes
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
- who: r-e40d278a, the row's refuter
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: A Safe 1.3.0 proxy, 2 of 5 owners, all five code-less keys that have sent transactions; no module,
    no guard; about 218,294 LINK at the block (the old row''s 65.3M USD was stale, the card states the tool''s read).
    MEDIUM, PQ-12: two forged owner keys move everything; the owners can replace each key with swapOwner by a signer
    contract answering the legacy isValidSignature(bytes,bytes). Author A-e40d278a, refuter R-e40d278a agreed with
    no objection; the reader checked the 29 checks and changed nothing.'
related: []
---

## What happens

This Safe 1.3.0 wallet executes any transaction that two of its five owners sign with ECDSA. A quantum attacker who recovers two owner keys can move everything it holds, including about 218,294 LINK. All five owners are plain keys that have sent transactions, so their public keys are public.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code), line 299, recovers an owner by ECDSA and never calls the owner's account.
- The [Safe](https://etherscan.io/address/0xe40d278afd00e6187db21ff8c96d572359ef03bf) needs 2 of its 5 owners, none of which has code; it has no module and no guard.
- The [code](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) asks a contract owner through isValidSignature(bytes,bytes), line 285; the final ERC-1271 selector is absent.

## Reviewer notes

### Mechanism

The proxy delegates every call to the singleton in slot 0, Safe 1.3.0. execTransaction (GnosisSafe.sol 111-194) hashes the transaction with the nonce, calls checkSignatures (145), which requires `threshold` signatures (227-230; threshold is 2 at the block), then runs the call or delegatecall (176). checkNSignatures (240-304) reads each signature's v, chosen by whoever submits: v=0 calls the owner contract's legacy isValidSignature(bytes,bytes) and wants 0x20c13b0b (285); v=1 takes an approved hash, set by a call from the owner's own address or by the owner sending the transaction (291, 333-335); any other v goes to ecrecover (295, 299). Line 301 only requires the resulting address to be an owner, in ascending order. The ecrecover branch never looks at the owner's code, so an owner that moves its own account to post-quantum authorisation at the same address stays forgeable here; only swapping the owner address for a contract removes its ECDSA path. Owner changes (swapOwner, OwnerManager 94-112; addOwnerWithThreshold, removeOwner, changeThreshold) are `authorized`, a call from the Safe itself (SelfAuthorized 8), so they need the same two owner approvals.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Owners asked through ERC-1271: only when the submitted signature has v=0 (lines 257-285); the ECDSA branch (299) stays open for every owner address, and none of the five owners has code at the block.
- Ruled out: Approved hashes and owner-sent transactions (v=1): both need a transaction from the owner's own address, so they rest on the same ECDSA key.
- Ruled out: A module or guard that moves funds without owner signatures or blocks forged ones: getModulesPaginated returns none and the guard slot is zero at the block.
- Ruled out: Unused implementation: this address is a proxy with its own state (nonce 582, threshold 2, five owners, LINK held); its execTransaction 0x85d58d1d… (block 26,428,203) sent by owner 0x93a53ff6… succeeded.
- Ruled out: changeMasterCopy as an upgrade path, named in the old finding: its selector 0x7de7edef is not in the 1.3.0 singleton's code; I did not state upgradeable or admin.
- Ruled out: Whose money it is and which team runs this Safe: nothing in the source or the chain reads I made shows it; whose and project are left empty. The old card's USD 65.3M (2026-11-17) is not the holding at this block; the tool's figure stands.
- Ruled out: The family's replays that fail under EIP-8151 (0x16a1d468…, 0x5b42f691…) were sent to other Safes (0x237dee52…, 0x61a2c600…), not to this address; not cited. They belong to the EIP-8151 study, not to this quantum-exposure row.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
