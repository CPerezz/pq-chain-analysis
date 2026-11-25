---
id: gnosissafe-29065a4c-owner-ecdsa-keys
format: 2
title: A quantum computer recovering three ECDSA owner keys could empty this Safe
status: confirmed
severity: MEDIUM
justification: Three recovered owner keys move everything; the fix is the owners swapping each key for a post-quantum
  signer contract.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x29065a4c1f2f20d1e263930088890d6f49fe715a'
  name: GnosisSafe
  code: verified
  code_url: https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code
  proxy_of: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  copies: 1
  upgradeable: 'yes'
value:
  usd: 25720796
  basis: held
activity:
  txs_90d: 948
impact: funds-loss
action: Swap each owner via swapOwner for a post-quantum signer contract answering isValidSignature(bytes,bytes);
  in-place upgrades stay forgeable.
evidence_level: source
checks:
- id: vsplit
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 256
  has: (v, r, s) = signatureSplit(signatures, i);
  says: each slot's scheme is picked by the v byte of the submitted signature, not by the owner
  for:
  - action
- id: contract-sig
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 285
  has: require(ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE,
    "GS024");
  says: with v = 0 a contract owner is asked through isValidSignature with the full data and signature
  for:
  - action
  - evidence-1
  - justification
- id: magic
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/interfaces/ISignatureValidator.sol
  line: 6
  has: bytes4 internal constant EIP1271_MAGIC_VALUE = 0x20c13b0b;
  says: the magic value asked is the legacy isValidSignature(bytes,bytes) one
  for:
  - action
  - evidence-1
- id: approved
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 291
  has: require(msg.sender == currentOwner || approvedHashes[currentOwner][dataHash] != 0, "GS025");
  says: with v = 1 an owner counts if it sends the transaction or approved the hash on-chain
  for:
  - what
- id: ecrecover
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  lines:
  - 292
  - 300
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: any other v is an ECDSA signature recovered with ecrecover (eth_sign form for v > 30)
  for:
  - action
  - evidence-1
  - justification
  - what
- id: owner-match
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 301
  has: require(currentOwner > lastOwner && owners[currentOwner] != address(0) && currentOwner != SENTINEL_OWNERS,
    "GS026");
  says: the recovered or named address must be an owner, in ascending order
  for:
  - evidence-1
  - justification
  - what
- id: exec-check
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 145
  has: checkSignatures(txHash, txHashData, signatures);
  says: execTransaction checks threshold-many owner signatures on the transaction hash
  for:
  - evidence-3
  - upgradeable
  - what
- id: exec-run
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 176
  has: 'success = execute(to, value, data, operation, gasPrice == 0 ? (gasleft() - 2500) : safeTxGas);'
  says: then runs whatever call or delegate call the owners signed
  for:
  - justification
  - upgradeable
  - what
- id: delegatecall
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/base/Executor.sol
  lines:
  - 15
  - 18
  has: success := delegatecall(txGas, to, add(data, 0x20), mload(data), 0, 0)
  says: a signed transaction can be a delegate call, which can rewrite the Safe's storage including its singleton
  for:
  - upgradeable
- id: swap
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/base/OwnerManager.sol
  lines:
  - 94
  - 98
  has: address newOwner ) public authorized {
  says: swapOwner is open only to an authorized call
  for:
  - action
  - evidence-3
  - justification
- id: swap-set
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/base/OwnerManager.sol
  lines:
  - 106
  - 108
  has: owners[newOwner] = owners[oldOwner]; owners[prevOwner] = newOwner; owners[oldOwner] = address(0);
  says: swapOwner puts the new address in the old owner's place
  for:
  - action
  - evidence-3
  - justification
- id: self
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/common/SelfAuthorized.sol
  line: 8
  has: require(msg.sender == address(this), "GS031");
  says: authorized means a call from the Safe itself, that is a Safe transaction
  for:
  - action
  - evidence-3
  - justification
- id: module-exec
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/base/ModuleManager.sol
  line: 68
  has: require(msg.sender != SENTINEL_MODULES && modules[msg.sender] != address(0), "GS104");
  says: only an enabled module can execute without owner signatures
  for:
  - evidence-2
  - what
- id: sel-legacy
  selector: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  fn: isValidSignature(bytes,bytes)
  says: the singleton calls the legacy isValidSignature(bytes,bytes) selector 0x20c13b0b
  for:
  - action
  - evidence-1
- id: sel-final
  selector: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: the final ERC-1271 selector 0x1626ba7e is not in the singleton
  for:
  - action
  - evidence-1
- id: version
  call: '0x29065a4c1f2f20d1e263930088890d6f49fe715a'
  fn: VERSION()(string)
  is: 1.3.0
  says: the Safe runs version 1.3.0
  for:
  - evidence-2
- id: threshold
  call: '0x29065a4c1f2f20d1e263930088890d6f49fe715a'
  fn: getThreshold()(uint256)
  is: 3
  says: three owner approvals execute a transaction
  for:
  - evidence-2
  - justification
  - what
- id: owners
  call: '0x29065a4c1f2f20d1e263930088890d6f49fe715a'
  fn: getOwners()(address[])
  is:
  - '0x6681dea3dd94bb180c28f15549b5abdba2c36907'
  - '0xb3210148232278fd771524f7a405d75c49b3a2e4'
  - '0x2c573180816adad0c8ecd9248fd6f9cb94a1cb8d'
  - '0x176f3dab24a159341c0509bb36b833e7fdd0a132'
  - '0x96e06fe977740ed4827df980c0bdb39235d0a9d3'
  - '0x8ffba55dc041675cbf8e5d5a0ba08df5dc3ac6da'
  says: the Safe has these six owners
  for:
  - evidence-2
  - justification
  - what
- id: modules
  call: '0x29065a4c1f2f20d1e263930088890d6f49fe715a'
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
  - what
- id: guard
  storage: '0x29065a4c1f2f20d1e263930088890d6f49fe715a'
  slot: '0x4a204f620c8c5ccdca3fd54d003badd85ba500436a431f0cbda4f558c93c34c8'
  is: 0
  says: no transaction guard is set
  for:
  - evidence-2
  - what
- id: safe-nonce
  call: '0x29065a4c1f2f20d1e263930088890d6f49fe715a'
  fn: nonce()(uint256)
  is: 6152
  says: the Safe has executed 6,152 transactions, so it is in use
  for:
  - notes
- id: gas-tx
  tx: '0x5d9cb224266b6782b63a6529a2bb765f4b993fa7833cf9ef51bd761cf263ebea'
  to: '0x29065a4c1f2f20d1e263930088890d6f49fe715a'
  ok: true
  says: an execTransaction of this Safe that succeeded with 895 gas left under its limit
  for:
  - notes
- id: code-o1
  code: '0x6681dea3dd94bb180c28f15549b5abdba2c36907'
  is: empty
  says: 'owner 0x6681dea3 has no code: a plain account with an ECDSA key'
  for:
  - evidence-2
  - justification
  - what
- id: code-o2
  code: '0xb3210148232278fd771524f7a405d75c49b3a2e4'
  is: empty
  says: 'owner 0xb3210148 has no code: a plain account with an ECDSA key'
  for:
  - evidence-2
  - justification
  - what
- id: code-o3
  code: '0x2c573180816adad0c8ecd9248fd6f9cb94a1cb8d'
  is: empty
  says: 'owner 0x2c573180 has no code: a plain account with an ECDSA key'
  for:
  - evidence-2
  - justification
  - what
- id: code-o4
  code: '0x176f3dab24a159341c0509bb36b833e7fdd0a132'
  is: empty
  says: 'owner 0x176f3dab has no code: a plain account with an ECDSA key'
  for:
  - evidence-2
  - justification
  - what
- id: code-o5
  code: '0x96e06fe977740ed4827df980c0bdb39235d0a9d3'
  is: empty
  says: 'owner 0x96e06fe9 has no code: a plain account with an ECDSA key'
  for:
  - evidence-2
  - justification
  - what
- id: code-o6
  code: '0x8ffba55dc041675cbf8e5d5a0ba08df5dc3ac6da'
  is: empty
  says: 'owner 0x8ffba55d has no code: a plain account with an ECDSA key'
  for:
  - evidence-2
  - justification
  - what
- id: nonce-o1
  nonce: '0x6681dea3dd94bb180c28f15549b5abdba2c36907'
  min: 1
  says: owner 0x6681dea3 has sent transactions, so its public key is public
  for:
  - what
- id: nonce-o2
  nonce: '0xb3210148232278fd771524f7a405d75c49b3a2e4'
  min: 1
  says: owner 0xb3210148 has sent transactions, so its public key is public
  for:
  - what
- id: nonce-o4
  nonce: '0x176f3dab24a159341c0509bb36b833e7fdd0a132'
  min: 1
  says: owner 0x176f3dab has sent transactions, so its public key is public
  for:
  - what
- id: nonce-o5
  nonce: '0x96e06fe977740ed4827df980c0bdb39235d0a9d3'
  min: 1
  says: owner 0x96e06fe9 has sent transactions, so its public key is public
  for:
  - what
- id: nonce-o6
  nonce: '0x8ffba55dc041675cbf8e5d5a0ba08df5dc3ac6da'
  min: 1
  says: owner 0x8ffba55d has sent transactions, so its public key is public
  for:
  - what
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
- who: r-29065a4c, the row's refuter
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  note: 'agree: whose (not blocking): the card cannot say whose the $25.7M is; nothing read at the block names the
    holder, so ''not established'' is the honest entry'
- who: claude-main, the reader who settled the row
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: A Safe 1.3.0 proxy, 3 of 6 owners, all code-less ECDSA accounts; no module, no guard. MEDIUM, PQ-12:
    three forged owner keys empty it; the owners can replace each key with swapOwner by a signer contract answering
    the legacy isValidSignature(bytes,bytes). Author A-29065a4c; refuter R-29065a4c agreed with no objection; the
    reader changed nothing. Whose funds stay not established. The author''s lead, one transaction of this Safe that
    left 895 gas under its limit, gets a gas-limit row.'
related: []
---

## What happens

This Safe moves its funds once three of its six owners approve, and all six owners are plain accounts that sign with ECDSA keys. Five have sent transactions, so their public keys are public; a quantum computer that recovers three keys could move everything the Safe holds.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) recovers ECDSA signatures with ecrecover and asks contract owners via isValidSignature(bytes,bytes).
- The [Safe](https://etherscan.io/address/0x29065a4c1f2f20d1e263930088890d6f49fe715a#readProxyContract) runs version 1.3.0 and needs 3 of its 6 owners; none has code, and no module or guard is set.
- With [swapOwner](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code), a Safe transaction signed by three owners replaces an owner with any new address.

## Reviewer notes

### Mechanism

execTransaction (lines 111-194) hashes the Safe transaction with the Safe's nonce, calls checkSignatures, then runs the call or delegate call the owners signed. checkNSignatures (lines 240-304) reads threshold-many 65-byte slots; the v byte of each slot, set by whoever submits the signatures, picks the scheme: v = 0 asks the contract named in r through isValidSignature(bytes,bytes) with the full data and signature (magic 0x20c13b0b); v = 1 accepts an owner that is msg.sender or called approveHash; v > 30 recovers the eth_sign hash with ecrecover; any other v recovers the transaction hash with ecrecover. Each named or recovered address must be an owner, in ascending order (line 301). This Safe has threshold 3 and six owners, none with code, so each approves through an ECDSA signature or a transaction signed by its own key. No module is enabled and the guard slot is zero. Owners change through swapOwner, addOwnerWithThreshold, removeOwner and changeThreshold, each allowed only for a call from the Safe itself, a Safe transaction signed by three owners. A quantum computer that derives three private keys from public keys (five owners have sent transactions) can sign any Safe transaction. The fix in place: swap each owner for a contract verifying a post-quantum signature through isValidSignature(bytes,bytes), or for a post-quantum account that uses approveHash. As v picks ecrecover whatever the owner's code, an owner that upgrades its own account in place stays forgeable.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: ERC-1271 for owners with code: a contract owner is asked via isValidSignature(bytes,bytes) (0x1626ba7e absent from the singleton), but no owner has code.
- Ruled out: another way to execute: no module enabled, guard slot zero.
- Ruled out: a direct path: an owner can approve by sending the transaction or by approveHash (v = 1); both are signed by the same ECDSA key.
- Ruled out: unused address: a proxy in use (Safe nonce 6,152; 948 calls in 90 days), not the singleton.
- Ruled out: singleton swap as fix: 1.3.0 has no changeMasterCopy; a delegate-call swap leaves the ECDSA owners.
- Ruled out: dossier replays 0x16a1d468, 0x5b42f691, 0xd34b6a89 went to other Safes, not this one.
- Ruled out: beside this card, for the main reviewer: this Safe's execTransaction 0x5d9cb224 (two ECDSA owner signatures) used 78,689 of its 79,584 gas limit; two cold recoveries under EIP-8151 cost 6,200 more. Arithmetic, not replayed: a possible sender-gas-limits row.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
