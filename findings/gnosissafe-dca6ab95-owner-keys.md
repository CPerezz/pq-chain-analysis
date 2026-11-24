---
id: gnosissafe-dca6ab95-owner-keys
format: 2
title: Two forged owner keys can move everything this Safe holds
status: confirmed
severity: MEDIUM
justification: Two forged owner keys move all funds; the fix is two of the three owners replacing their keys with
  signer contracts.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xdca6ab9508d28c0eb7b120b8252041edcb56753f'
  name: GnosisSafe
  code: verified
  code_url: https://etherscan.io/address/0x34cfac646f301356faa8b21e94227e3583fe3f5f#code
  proxy_of: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  copies: 1
  upgradeable: 'yes'
value:
  usd: 86171349
  basis: held
activity: {}
impact: funds-loss
action: Swap owner keys for signer contracts that answer isValidSignature(bytes,bytes), and remove the spending-limit
  delegate key.
evidence_level: source
checks:
- id: singleton
  storage: '0xdca6ab9508d28c0eb7b120b8252041edcb56753f'
  slot: '0x0'
  is: '0x00000000000000000000000034cfac646f301356faa8b21e94227e3583fe3f5f'
  says: slot 0 of the proxy holds the singleton whose code runs here
  for:
  - upgradeable
  - what
- id: version
  call: '0xdca6ab9508d28c0eb7b120b8252041edcb56753f'
  fn: VERSION()(string)
  is: 1.1.1
  says: the code that runs is Safe 1.1.1
  for:
  - what
- id: owners
  call: '0xdca6ab9508d28c0eb7b120b8252041edcb56753f'
  fn: getOwners()(address[])
  is:
  - '0x6fbdecf45442977e9b7d15f80613edb596400144'
  - '0x7a7033d0b3177e4c71b5cae48247e4c3ba9b9cee'
  - '0x92df32b7684173727c6b7e1a84da7875dc2ecdef'
  says: the Safe has these three owners
  for:
  - evidence-1
  - evidence-2
  - what
- id: threshold
  call: '0xdca6ab9508d28c0eb7b120b8252041edcb56753f'
  fn: getThreshold()(uint256)
  is: 2
  says: two owner approvals are required
  for:
  - evidence-1
  - justification
  - what
- id: in-use
  call: '0xdca6ab9508d28c0eb7b120b8252041edcb56753f'
  fn: nonce()(uint256)
  is: 29
  says: the Safe has executed 29 owner transactions
  for:
  - notes
- id: owner1-plain
  code: '0x6fbdecf45442977e9b7d15f80613edb596400144'
  is: empty
  says: owner 0x6fbd…0144 has no code
  for:
  - evidence-1
  - what
- id: owner2-plain
  code: '0x7a7033d0b3177e4c71b5cae48247e4c3ba9b9cee'
  is: empty
  says: owner 0x7a70…9cee has no code
  for:
  - evidence-1
  - what
- id: owner3-plain
  code: '0x92df32b7684173727c6b7e1a84da7875dc2ecdef'
  is: empty
  says: owner 0x92df…cdef has no code
  for:
  - evidence-1
  - what
- id: exec
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  has: checkSignatures(txHash, txHashData, signatures, true);
  says: execTransaction checks the owners' signatures before it executes anything
  line: 800
  for:
  - justification
  - what
- id: exec-call
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  has: success = execute(to, value, data, operation,
  says: after the check execTransaction runs the call or delegatecall the signers chose
  line: 807
  for:
  - what
- id: loop
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  has: for (i = 0; i < _threshold; i++) {
  says: checkSignatures reads exactly threshold-many signatures
  line: 865
  for:
  - evidence-1
  - what
- id: ecdsa
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: a signature that is neither a contract signature nor an approved hash is recovered with ecrecover
  lines:
  - 906
  - 911
  for:
  - evidence-1
  - justification
  - what
- id: is-owner
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  has: owners[currentOwner] != address(0)
  says: the recovered address only has to be in the owner list; an owner account is never asked unless the signature
    says so
  lines:
  - 913
  - 916
  for:
  - evidence-1
  - justification
  - what
- id: contract-sig
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  has: require(ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE
  says: an owner named in a v=0 signature is asked through isValidSignature with the full signature
  line: 895
  for:
  - action
  - justification
- id: magic
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  has: bytes4 constant internal EIP1271_MAGIC_VALUE = 0x20c13b0b;
  says: the expected answer is the legacy magic value of isValidSignature(bytes,bytes)
  lines:
  - 582
  - 583
  for:
  - action
- id: validator-iface
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  has: bytes memory _data,
  says: the interface asked takes (bytes,bytes), not (bytes32,bytes)
  lines:
  - 597
  - 602
  for:
  - action
- id: no-final-1271
  selector: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: the final ERC-1271 selector 0x1626ba7e is not in the singleton
  for:
  - action
- id: approved-hash
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  has: require(msg.sender == currentOwner || approvedHashes[currentOwner][dataHash] != 0
  says: an owner also counts when it sends the transaction or has approved the hash
  line: 901
  for:
  - notes
- id: approve-hash
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  has: approvedHashes[msg.sender][hashToApprove] = 1;
  says: approveHash lets an owner approve by a direct call, with no signature
  lines:
  - 950
  - 954
  for:
  - notes
- id: self-only
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  has: require(msg.sender == address(this)
  says: authorized functions run only as a transaction of the Safe itself
  line: 7
  for:
  - action
  - justification
  - upgradeable
  - what
- id: swap-owner
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  has: owners[prevOwner] = newOwner;
  says: swapOwner, authorized, replaces one owner with another address
  lines:
  - 392
  - 404
  for:
  - action
  - justification
  - what
- id: swap-auth
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  has: authorized
  says: swapOwner carries the authorized modifier
  lines:
  - 392
  - 394
  for:
  - action
  - justification
  - what
- id: master-copy
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  has: masterCopy = _masterCopy;
  says: changeMasterCopy, authorized, replaces the singleton
  lines:
  - 27
  - 33
  for:
  - upgradeable
- id: master-auth
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  has: authorized
  says: changeMasterCopy carries the authorized modifier
  lines:
  - 27
  - 29
  for:
  - upgradeable
- id: signed-tx
  tx: '0x867eeec43b811b8bab1da5a0616674f943fa5fc82ce7a9190659fd7c940d58a3'
  to: '0xdca6ab9508d28c0eb7b120b8252041edcb56753f'
  ok: true
  says: a successful execTransaction on this Safe (block 26,415,262)
  for:
  - evidence-2
- id: tx-hash
  call: '0xdca6ab9508d28c0eb7b120b8252041edcb56753f'
  fn: getTransactionHash(address,uint256,bytes,uint8,uint256,uint256,uint256,address,address,uint256)(bytes32)
  args:
  - '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2'
  - 0
  - '0xa9059cbb0000000000000000000000003e4c3c772c1e1c576b7171b4b8e409364191487400000000000000000000000000000000000000000000006c6b935ba305b6e800'
  - 0
  - 69025
  - 0
  - 0
  - '0x0000000000000000000000000000000000000000'
  - '0x0000000000000000000000000000000000000000'
  - 28
  is: '0xec80c33bcd80bdce411afdd1f06436380b3f659d95e2504b1e8f674b49f48075'
  says: the hash the owners signed for that transaction (its calldata, Safe nonce 28)
  for:
  - evidence-2
- id: sig1
  call: '0x0000000000000000000000000000000000000001'
  data: '0xec80c33bcd80bdce411afdd1f06436380b3f659d95e2504b1e8f674b49f48075000000000000000000000000000000000000000000000000000000000000001c51153956a08933eb721481fb319434af79c8643f808381e3b8126150dd47b6df5284ddcad04361e246d169846eff164432ff293820f3d57fa5fd9e9c68b4e937'
  is: '0x0000000000000000000000006fbdecf45442977e9b7d15f80613edb596400144'
  says: the first signature in that transaction recovers owner 0x6fbd…0144
  for:
  - evidence-2
- id: sig2
  call: '0x0000000000000000000000000000000000000001'
  data: '0xec80c33bcd80bdce411afdd1f06436380b3f659d95e2504b1e8f674b49f48075000000000000000000000000000000000000000000000000000000000000001c71a6562d7ca2a7b832030d2c3f48e5b8d6689f91b86236dd90b2f84e6f331500338ede8b6cb121f57227ef01eb20e8505860e4def1d0261f8df1a9b93d06b07f'
  is: '0x00000000000000000000000092df32b7684173727c6b7e1a84da7875dc2ecdef'
  says: the second signature recovers owner 0x92df…cdef
  for:
  - evidence-2
- id: eth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0xdca6ab9508d28c0eb7b120b8252041edcb56753f'
  is: '47752000057011000000000'
  says: the Safe holds 47,752 ETH
  for:
  - what
- id: modules
  call: '0xdca6ab9508d28c0eb7b120b8252041edcb56753f'
  fn: getModules()(address[])
  is:
  - '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  says: 'one module is enabled: 0xcfbf…3134'
  for:
  - evidence-3
- id: module-exec
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  has: modules[msg.sender] != address(0)
  says: an enabled module executes from the Safe without owner signatures
  lines:
  - 218
  - 225
  for:
  - evidence-3
- id: module-name
  call: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  fn: NAME()(string)
  is: Allowance Module
  says: the module calls itself Allowance Module
  for:
  - notes
- id: delegates
  call: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  fn: getDelegates(address,uint48,uint8)(address[],uint48)
  args:
  - '0xdca6ab9508d28c0eb7b120b8252041edcb56753f'
  - 0
  - 50
  is:
  - - '0x1578ed833d986c1188d1a998aa5fecd418bef5da'
  - 0
  says: the module lists one delegate for this Safe
  for:
  - action
  - evidence-3
- id: allowance
  call: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  fn: getTokenAllowance(address,address,address)(uint256[5])
  args:
  - '0xdca6ab9508d28c0eb7b120b8252041edcb56753f'
  - '0x1578ed833d986c1188d1a998aa5fecd418bef5da'
  - '0x0000000000000000000000000000000000000000'
  is:
  - '500000000000000000000'
  - 0
  - 1440
  - 29916133
  - 1
  says: the delegate's ETH allowance is 500 ETH, none spent, reset every 1,440 minutes
  for:
  - evidence-3
- id: allowance-order
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: AlowanceModule.sol
  has: uint256(allowance.resetTimeMin),
  says: getTokenAllowance returns amount, spent, reset time in minutes, last reset, nonce
  lines:
  - 290
  - 298
  for:
  - evidence-3
- id: allowance-reset
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: AlowanceModule.sol
  has: allowance.spent = 0;
  says: the spent amount returns to zero after each reset period
  lines:
  - 104
  - 105
  for:
  - evidence-3
- id: module-ecdsa
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: AlowanceModule.sol
  has: owner = ecrecover(keccak256(transferHashData), v, r, s);
  says: the module takes the delegate's ECDSA signature, or the caller itself
  lines:
  - 262
  - 270
  for:
  - action
  - evidence-3
- id: module-match
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: AlowanceModule.sol
  has: expectedDelegate == signer && delegates[address(safe)][uint48(signer)].delegate == signer
  says: the recovered address or caller must be a delegate of the Safe
  lines:
  - 243
  - 244
  for:
  - evidence-3
- id: module-nocontract
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: AlowanceModule.sol
  has: revert("Contract signatures are not supported by this module");
  says: the module never asks a delegate contract for a signature
  lines:
  - 260
  - 261
  for:
  - action
- id: module-pay
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: AlowanceModule.sol
  has: safe.execTransactionFromModule(to, amount, "", Enum.Operation.Call)
  says: the module pays ETH out of the Safe
  lines:
  - 276
  - 279
  for:
  - evidence-3
- id: delegate-code
  code: '0x1578ed833d986c1188d1a998aa5fecd418bef5da'
  is: delegation
  target: '0x63c0c19a282a1b52b07dd5a65b58948a07dae32b'
  says: the delegate is a key-controlled account with an EIP-7702 delegation
  for:
  - evidence-3
- id: delegate-nonce
  nonce: '0x1578ed833d986c1188d1a998aa5fecd418bef5da'
  min: 1
  says: the delegate has sent transactions, so its public key is on-chain
  for:
  - notes
- id: handler
  storage: '0xdca6ab9508d28c0eb7b120b8252041edcb56753f'
  slot: '0x6c9a6c4a39284e37ed1cf53d337577d14212a4870fb976a4366c693b939918d5'
  is: '0x000000000000000000000000d5d82b6addc9027b22dca772aa68d5d74cdbdf44'
  says: the fallback handler slot names 0xd5d8…df44
  for:
  - notes
- id: handler-name
  call: '0xd5d82b6addc9027b22dca772aa68d5d74cdbdf44'
  fn: NAME()(string)
  is: Default Callback Handler
  says: the handler calls itself Default Callback Handler
  for:
  - notes
- id: handler-call
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  has: let success := call(gas, handler, 0, 0, calldatasize(), 0, 0)
  says: the fallback forwards unknown calls to the handler with a plain call, so the handler does not run as the
    Safe
  lines:
  - 507
  - 511
  for:
  - notes
- id: remove-delegate
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: AlowanceModule.sol
  has: delete delegates[msg.sender][uint48(delegate)];
  says: removeDelegate, called by the Safe, deletes its delegate
  lines:
  - 323
  - 349
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
reviews:
- who: r-dca6ab95, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Kev''s first-study finding, MEDIUM (PQ-12): a 2-of-3 Safe 1.1.1 ($86.17M) whose three owners are
    plain ECDSA keys; checkNSignatures never asks the owner''s account; fix: swapOwner to post-quantum signer contracts
    answering the legacy isValidSignature(bytes,bytes), and remove the spending-limit delegate key. Two refuters
    agree; Claude read the sheet.'
related: []
---

## What happens

This Safe 1.1.1 wallet runs any transaction that two of its three owners approve, and it accepts their ECDSA signatures. All three owners are accounts without code. A quantum attacker who forges two owner keys can move everything it holds or replace the owners.

## Evidence

- [checkSignatures](https://etherscan.io/address/0x34cfac646f301356faa8b21e94227e3583fe3f5f#code) recovers each signature with ecrecover and accepts any listed owner; 2 of 3 are needed, none has code.
- In [this transfer](https://etherscan.io/tx/0x867eeec43b811b8bab1da5a0616674f943fa5fc82ce7a9190659fd7c940d58a3) two owners signed with ECDSA, so two owner public keys are already on-chain.
- A [spending-limit module](https://etherscan.io/address/0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134#code) lets one more ECDSA key move up to 500 ETH per day without the owners.

## Reviewer notes

### Mechanism

The proxy delegates to the Safe 1.1.1 singleton (slot 0). execTransaction (lines 774-817) hashes the transaction with the Safe nonce, calls checkSignatures (849-919), then executes a call or delegatecall. checkSignatures reads threshold-many (2) signatures: v=0 asks the named owner contract isValidSignature(bytes,bytes) and expects 0x20c13b0b; v=1 accepts an owner that is msg.sender or called approveHash; any other v goes to ecrecover (908, 911). The result only has to be a listed owner. The signature picks the branch, so an owner account is never asked unless the signature says so. Owner changes (swapOwner 392-408) and changeMasterCopy are `authorized`: a Safe transaction, 2 of 3. Second path: the enabled Allowance Module 0xcfbf…3134 pays through execTransactionFromModule on the ECDSA signature of delegate 0x1578…f5da (or the delegate as caller; contract signatures revert), up to 500 ETH per 1,440 minutes.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: erc1271: the contract-signature branch (line 895) is chosen by the signature; a plain ECDSA signature for a listed owner never reaches the owner account (906-916).
- Ruled out: key-state: three owners, all with empty code; threshold 2. 0x7a70…9cee has account nonce 4; the other two have nonce 0 but both signed Safe transaction 0x867e…58a3 (hash and recoveries recomputed).
- Ruled out: unused-implementation, wrong-code: a proxy with its own state (Safe nonce 29); slot 0 names 0x34cf…3f5f, VERSION 1.1.1.
- Ruled out: final ERC-1271: selector 0x1626ba7e is absent from the singleton; a signer contract must answer isValidSignature(bytes,bytes) with 0x20c13b0b, or approve hashes by direct call.
- Ruled out: changeMasterCopy alone replaces the code, not the owners.
- Ruled out: direct-path: the Allowance Module needs no owner signature, capped at 500 ETH per day for one delegate (an EIP-7702 key account, nonce 1,836). Replacing owner keys does not close it; the owners must also remove the delegate or the module. The module has its own rows.
- Ruled out: breaks-by-itself: the family's replay 0xa643…88a4 fails under EIP-8151 alone but calls 0xd3621b7e…d2ea, another Safe; not cited. The main reviewer may replay it with more gas for that row.
- Ruled out: value-whose: 47,752 ETH; WETH balanceOf is 0. Whose money it is was not shown.
- Ruled out: admin left empty: owner changes and changeMasterCopy are open only to the Safe itself (2 of 3 owners); no single address holds that right.
- Ruled out: fallback handler 0xd5d8…df44 (Default Callback Handler): reached by a plain call (line 511), so it cannot act as the Safe.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
