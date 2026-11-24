---
id: gnosissafe-a99f29a2-owner-ecdsa-keys
format: 2
title: Five forged owner keys can move all funds held by this 5-of-9 Safe
status: confirmed
severity: MEDIUM
justification: Forged owner keys can move all its funds; the fix needs the owners to swap in post-quantum signer
  contracts.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa99f29a2fbdcafbf057b3d8efc47cfcee670bb43'
  name: GnosisSafe
  code: verified
  code_url: https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code
  proxy_of: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  copies: 1
  upgradeable: 'yes'
value:
  usd: 9025892
  basis: held
activity:
  txs_90d: 13
impact: funds-loss
action: Swap each owner for a post-quantum signer contract answering isValidSignature(bytes,bytes), and remove the
  AllowanceModule delegate.
evidence_level: source
checks:
- id: version
  call: '0xa99f29a2fbdcafbf057b3d8efc47cfcee670bb43'
  fn: VERSION()(string)
  is: 1.3.0
  says: the Safe runs version 1.3.0
  for:
  - evidence-1
- id: singleton
  storage: '0xa99f29a2fbdcafbf057b3d8efc47cfcee670bb43'
  slot: '0x0'
  is: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  says: slot 0 holds the 1.3.0 singleton the proxy runs
  for:
  - evidence-1
  - upgradeable
- id: threshold
  call: '0xa99f29a2fbdcafbf057b3d8efc47cfcee670bb43'
  fn: getThreshold()(uint256)
  is: 5
  says: five owner signatures are needed
  for:
  - evidence-2
  - evidence-3
  - justification
  - what
- id: owners
  call: '0xa99f29a2fbdcafbf057b3d8efc47cfcee670bb43'
  fn: getOwners()(address[])
  is:
  - '0xa1b3b49d539e453adafede608a2ba960b58be057'
  - '0xf5aef65b7e493a5a8725842528d81561ed2cbc6e'
  - '0x1c1b26b373878e6f32ce9a02c1bc8c7eab0876fa'
  - '0x7e982d89f10b60ccd0614ffa0f0e4f93a5b2b102'
  - '0xedd9369a2d8c05c60880b89999b160a815071fdd'
  - '0x15af80290f04ba73edfd912b31452354eb5a4e2a'
  - '0x998c367e519f85e77bf2161c1c38bb9e0f54a79a'
  - '0x08b308c486d7b9a9f9dcac1a0dc80d9d523a6967'
  - '0xc3e7fc60622a8c190132f919a4f3409be2a8f6f2'
  says: the nine owners
  for:
  - evidence-2
  - what
- id: guard
  storage: '0xa99f29a2fbdcafbf057b3d8efc47cfcee670bb43'
  slot: '0x4a204f620c8c5ccdca3fd54d003badd85ba500436a431f0cbda4f558c93c34c8'
  is: 0
  says: no transaction guard is set
  for:
  - what
- id: modules
  call: '0xa99f29a2fbdcafbf057b3d8efc47cfcee670bb43'
  fn: getModulesPaginated(address,uint256)(address[],address)
  args:
  - '0x0000000000000000000000000000000000000001'
  - 10
  is:
  - - '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  - '0x0000000000000000000000000000000000000001'
  says: one module is enabled, the AllowanceModule
  for:
  - notes
- id: code-a1b3
  code: '0xa1b3b49d539e453adafede608a2ba960b58be057'
  is: empty
  says: owner has no code
  for:
  - evidence-2
  - what
- id: code-f5ae
  code: '0xf5aef65b7e493a5a8725842528d81561ed2cbc6e'
  is: empty
  says: owner has no code
  for:
  - evidence-2
  - what
- id: code-1c1b
  code: '0x1c1b26b373878e6f32ce9a02c1bc8c7eab0876fa'
  is: empty
  says: owner has no code
  for:
  - evidence-2
  - what
- id: code-7e98
  code: '0x7e982d89f10b60ccd0614ffa0f0e4f93a5b2b102'
  is: empty
  says: owner has no code
  for:
  - evidence-2
  - what
- id: code-edd9
  code: '0xedd9369a2d8c05c60880b89999b160a815071fdd'
  is: delegation
  target: '0x80296ff8d1ed46f8e3c7992664d13b833504c2bb'
  says: owner is an EOA with an EIP-7702 delegation
  for:
  - evidence-2
  - what
- id: code-15af
  code: '0x15af80290f04ba73edfd912b31452354eb5a4e2a'
  is: empty
  says: owner has no code
  for:
  - evidence-2
  - what
- id: code-998c
  code: '0x998c367e519f85e77bf2161c1c38bb9e0f54a79a'
  is: empty
  says: owner has no code
  for:
  - evidence-2
  - what
- id: code-08b3
  code: '0x08b308c486d7b9a9f9dcac1a0dc80d9d523a6967'
  is: empty
  says: owner has no code
  for:
  - evidence-2
  - what
- id: code-c3e7
  code: '0xc3e7fc60622a8c190132f919a4f3409be2a8f6f2'
  is: empty
  says: owner has no code
  for:
  - evidence-2
  - what
- id: nonce-a1b3
  nonce: '0xa1b3b49d539e453adafede608a2ba960b58be057'
  min: 1
  says: owner has sent transactions
  for:
  - what
- id: nonce-f5ae
  nonce: '0xf5aef65b7e493a5a8725842528d81561ed2cbc6e'
  is: 0
  says: owner has sent no transaction
  for:
  - what
- id: nonce-1c1b
  nonce: '0x1c1b26b373878e6f32ce9a02c1bc8c7eab0876fa'
  min: 1
  says: owner has sent transactions
  for:
  - what
- id: nonce-7e98
  nonce: '0x7e982d89f10b60ccd0614ffa0f0e4f93a5b2b102'
  min: 1
  says: owner has sent transactions
  for:
  - what
- id: nonce-edd9
  nonce: '0xedd9369a2d8c05c60880b89999b160a815071fdd'
  min: 1
  says: owner has sent transactions
  for:
  - what
- id: nonce-15af
  nonce: '0x15af80290f04ba73edfd912b31452354eb5a4e2a'
  min: 1
  says: owner has sent transactions
  for:
  - what
- id: nonce-998c
  nonce: '0x998c367e519f85e77bf2161c1c38bb9e0f54a79a'
  min: 1
  says: owner has sent transactions
  for:
  - what
- id: nonce-08b3
  nonce: '0x08b308c486d7b9a9f9dcac1a0dc80d9d523a6967'
  min: 1
  says: owner has sent transactions
  for:
  - what
- id: nonce-c3e7
  nonce: '0xc3e7fc60622a8c190132f919a4f3409be2a8f6f2'
  min: 1
  says: owner has sent transactions
  for:
  - what
- id: exec
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 145
  has: checkSignatures(txHash, txHashData, signatures);
  says: execTransaction checks the owners' signatures before it executes
  for:
  - evidence-3
  - upgradeable
  - what
- id: execute
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 176
  has: success = execute(to, value, data, operation
  says: then it executes the signed call or delegatecall
  for:
  - justification
  - upgradeable
  - what
- id: split
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 256
  has: (v, r, s) = signatureSplit(signatures, i);
  says: the scheme byte v comes from the submitted signature data
  for:
  - notes
- id: legacy1271
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 285
  has: require(ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE,
    "GS024");
  says: a contract signature (v == 0) is checked by the owner's isValidSignature(bytes,bytes)
  for:
  - action
  - evidence-1
  - justification
- id: magic
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/interfaces/ISignatureValidator.sol
  line: 6
  has: bytes4 internal constant EIP1271_MAGIC_VALUE = 0x20c13b0b;
  says: the magic value is the legacy one of isValidSignature(bytes,bytes)
  for:
  - action
  - evidence-1
- id: approved
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 291
  has: require(msg.sender == currentOwner || approvedHashes[currentOwner][dataHash] != 0, "GS025");
  says: v == 1 accepts an owner that sends the transaction or approved the hash on-chain
  for:
  - notes
- id: ethsign
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 295
  has: currentOwner = ecrecover(keccak256(abi.encodePacked(
  says: v > 30 recovers an eth_sign signature with ecrecover
  for:
  - evidence-1
- id: ecdsa
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 299
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: otherwise the owner is recovered with ecrecover from the transaction hash
  for:
  - evidence-1
  - justification
  - what
- id: member
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 301
  has: require(currentOwner > lastOwner && owners[currentOwner] != address(0) && currentOwner != SENTINEL_OWNERS,
    "GS026");
  says: the recovered or named address only has to be an owner
  for:
  - evidence-1
  - justification
  - what
- id: sel-legacy
  selector: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  fn: isValidSignature(bytes,bytes)
  says: the singleton's code holds the legacy selector 0x20c13b0b
  for:
  - action
  - evidence-1
- id: sel-final
  selector: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: the final ERC-1271 selector 0x1626ba7e is not in the singleton's code
  for:
  - evidence-1
- id: swap
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/base/OwnerManager.sol
  lines:
  - 94
  - 98
  has: function swapOwner( address prevOwner, address oldOwner, address newOwner ) public authorized {
  says: swapOwner replaces an owner and is authorized only
  for:
  - action
  - evidence-3
  - justification
- id: selfauth
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/common/SelfAuthorized.sol
  line: 8
  has: require(msg.sender == address(this), "GS031");
  says: authorized means a call from the Safe itself
  for:
  - action
  - evidence-3
  - justification
- id: delegatecall
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/base/Executor.sol
  line: 18
  has: success := delegatecall(txGas, to, add(data, 0x20), mload(data), 0, 0)
  says: a Safe transaction can be a delegatecall, which can rewrite slot 0, the singleton
  for:
  - upgradeable
- id: recent
  tx: '0x9c922b14f38d8d7ce164719be68a024aa130d7b00049d9108468a3a7b365b93b'
  to: '0xa99f29a2fbdcafbf057b3d8efc47cfcee670bb43'
  ok: true
  says: a recent transaction to this Safe succeeded
  for:
  - notes
- id: eth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0xa99f29a2fbdcafbf057b3d8efc47cfcee670bb43'
  is: 139125109232651278204
  says: the Safe holds 139.13 ETH
  for:
  - notes
- id: usdc
  call: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  fn: balanceOf(address)(uint256)
  args:
  - '0xa99f29a2fbdcafbf057b3d8efc47cfcee670bb43'
  is: 851656494388
  says: the Safe holds 851,656.49 USDC
  for:
  - notes
- id: delegates
  call: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  fn: getDelegates(address,uint48,uint8)(address[],uint48)
  args:
  - '0xa99f29a2fbdcafbf057b3d8efc47cfcee670bb43'
  - 0
  - 50
  is:
  - - '0x65eca235e51a71c850f91af2852c00596073f649'
  - 0
  says: the AllowanceModule has one delegate for this Safe
  for:
  - notes
- id: allowance
  call: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  fn: getTokenAllowance(address,address,address)(uint256[5])
  args:
  - '0xa99f29a2fbdcafbf057b3d8efc47cfcee670bb43'
  - '0x65eca235e51a71c850f91af2852c00596073f649'
  - '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  is:
  - 650000000000
  - 624757032640
  - 0
  - 28941987
  - 2
  says: the delegate's USDC allowance is 650,000 with 624,757.03 spent and no reset period
  for:
  - notes
- id: delegate-code
  code: '0x65eca235e51a71c850f91af2852c00596073f649'
  is: empty
  says: the delegate has no code
  for:
  - notes
- id: delegate-nonce
  nonce: '0x65eca235e51a71c850f91af2852c00596073f649'
  min: 1
  says: the delegate has sent transactions
  for:
  - notes
- id: module-ecdsa
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: AlowanceModule.sol
  line: 270
  has: owner = ecrecover(keccak256(transferHashData), v, r, s);
  says: the module recovers the delegate's signature with ecrecover
  for:
  - notes
- id: module-cap
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: AlowanceModule.sol
  line: 168
  has: require(newSpent > allowance.spent && newSpent <= allowance.amount,
  says: a delegate transfer is capped by its allowance
  for:
  - notes
- id: mod-only
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/base/ModuleManager.sol
  line: 68
  has: require(msg.sender != SENTINEL_MODULES && modules[msg.sender] != address(0), "GS104");
  says: only an enabled module executes without owner signatures
  for:
  - notes
- id: m-delegates
  call: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  fn: getDelegates(address,uint48,uint8)(address[],uint48)
  args:
  - '0xa99f29a2fbdcafbf057b3d8efc47cfcee670bb43'
  - 0
  - 50
  is:
  - - '0x65eca235e51a71c850f91af2852c00596073f649'
  - 0
  says: the AllowanceModule has one delegate for this Safe
  for:
  - action
- id: m-tokens
  call: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  fn: getTokens(address,address)(address[])
  args:
  - '0xa99f29a2fbdcafbf057b3d8efc47cfcee670bb43'
  - '0x65eca235e51a71c850f91af2852c00596073f649'
  is:
  - '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  says: the delegate has an allowance in USDC only
  for:
  - notes
- id: m-allow
  call: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  fn: getTokenAllowance(address,address,address)(uint256[5])
  args:
  - '0xa99f29a2fbdcafbf057b3d8efc47cfcee670bb43'
  - '0x65eca235e51a71c850f91af2852c00596073f649'
  - '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  is:
  - 650000000000
  - 624757032640
  - 0
  - 28941987
  - 2
  says: '650,000 USDC allowed, 624,757.03 spent, no reset: 25,242.97 USDC left'
  for:
  - action
- id: d-code
  code: '0x65eca235e51a71c850f91af2852c00596073f649'
  is: empty
  says: the delegate is a key without code
  for:
  - action
- id: d-nonce
  nonce: '0x65eca235e51a71c850f91af2852c00596073f649'
  min: 1
  says: the delegate has sent transactions, so its public key is exposed
  for:
  - action
- id: m-ecdsa
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: AlowanceModule.sol
  line: 270
  has: owner = ecrecover(keccak256(transferHashData), v, r, s);
  says: the module recovers the delegate's signature with ecrecover
  for:
  - action
- id: m-direct
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: AlowanceModule.sol
  line: 252
  has: if (signature.length == 0) return msg.sender;
  says: or the delegate calls the module itself
  for:
  - notes
- id: m-no1271
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: AlowanceModule.sol
  line: 261
  has: Contract signatures are not supported by this module
  says: the module takes no contract signature
  for:
  - action
- id: m-cap
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: AlowanceModule.sol
  line: 168
  has: newSpent <= allowance.amount
  says: a delegate transfer is capped by the allowance
  for:
  - notes
- id: m-transfer
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: AlowanceModule.sol
  line: 281
  has: abi.encodeWithSignature("transfer(address,uint256)", to, amount);
  says: the module only makes the Safe call transfer on the allowed token
  for:
  - notes
- id: m-remove
  source: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  file: AlowanceModule.sol
  line: 323
  has: function removeDelegate(address delegate, bool removeAllowances) public {
  says: the Safe can remove the delegate and its allowances
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
- who: r-a99f29a2, the row's refuter
  date: 2026-11-22
  by: ai-assisted
  verdict: refuted
  note: 'disagree: action: swapping the owners leaves the AllowanceModule delegate 0x65eca235e51a71c850f91af2852c00596073f649,
    one exposed ECDSA key, able to take the remaining 25,242.97 USDC (650,000 allowance, no reset). The action should
    also have the Safe remove that delegate, e.g. ''Swap each owner for a post-quantum signer contract answering
    isValidSignature(bytes,bytes), and remove the AllowanceModule delegate.'' (the card was edited after this answer)'
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: A Safe 1.3.0 proxy, 5 of 9 owners: eight code-less keys that have sent transactions and one with
    an EIP-7702 delegation. MEDIUM, PQ-12: five forged owner keys move all its funds; the fix is swapOwner to signer
    contracts answering the legacy isValidSignature(bytes,bytes). Author A-a99f29a2. Refuter R-a99f29a2 found the
    mechanism, the rating and the evidence to hold and disagreed on the action, rightly: swapping the owners leaves
    the AllowanceModule''s one delegate, an exposed ECDSA key, able to take the 25,242.97 USDC left of its allowance.
    The reader corrected the action (it now also removes that delegate) and the ruled_out note, with the refuter''s
    checks. The amount is bounded by the allowance and does not change the rating.'
related: []
---

## What happens

This 5-of-9 Safe runs any transaction that five of its owners sign. All nine owners are ECDSA keys, one of them with an EIP-7702 delegation; eight have sent transactions, which reveals their public keys. Recovering five of those keys lets a quantum attacker take its funds.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) recovers each owner signature with ecrecover; a contract owner is asked through the legacy isValidSignature(bytes,bytes).
- [This Safe](https://etherscan.io/address/0xa99f29a2fbdcafbf057b3d8efc47cfcee670bb43) has nine owners and a threshold of five; eight owners have no code and one holds an EIP-7702 delegation.
- [swapOwner](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) replaces an owner, but only in a transaction of the Safe itself, which needs five owner signatures.

## Reviewer notes

### Mechanism

execTransaction (GnosisSafe.sol 1.3.0, line 145) calls checkSignatures, which needs threshold-many signatures (5 at the block). checkNSignatures (lines 240-304) takes v from each 65-byte slot the submitter provides (line 256): v == 0 asks the owner contract isValidSignature(bytes,bytes) and wants the legacy magic 0x20c13b0b (lines 285, ISignatureValidator line 6); v == 1 accepts an owner that is msg.sender or called approveHash (line 291); v > 30 recovers the eth_sign hash (line 295); otherwise ecrecover(dataHash, v, r, s) (line 299). Each address must be an owner, in ascending order (line 301). The scheme is picked per signature, so an owner address that gains code is still satisfied by an ECDSA signature for that address. No guard is set, so a passing set executes any call or delegatecall (line 176; Executor line 18), including swapOwner, addOwnerWithThreshold, removeOwner and changeThreshold (authorized: self-call only, SelfAuthorized line 8) and a singleton change by delegatecall into slot 0. The singleton has no isValidSignature(bytes32,bytes) selector, so a replacement owner contract must answer the bytes form.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: a contract owner asked through isValidSignature: none; all nine owners are ECDSA keys, one with an EIP-7702 delegation.
- Ruled out: a guard that could vet transactions: the guard slot is empty at the block.
- Ruled out: a direct path without ECDSA: approveHash and sending the transaction still need the owner's own ECDSA key; no post-quantum path exists today.
- Ruled out: the wrong code: slot 0 holds the 1.3.0 singleton 0xd9db270c...9552 and VERSION() answers 1.3.0.
- Ruled out: the old row's $42.4M: this address alone holds $9,025,892 (139.13 ETH, 851,656.49 USDC among 8 priced tokens) at the block.
- Ruled out: whose funds: the Safe keeps no per-user accounting; whose is left empty.
- Ruled out: the AllowanceModule's one delegate, 0x65eca235…f649, an exposed ECDSA key: it can take the 25,242.97 USDC left of its allowance (650,000, no reset) by signature or by a direct call, without the owners; the module takes no contract signature. Bounded by the allowance, so it does not change the rating; the action removes the delegate.
- Ruled out: replays: the family's three replays belong to other Safes (0x16a1d468..., 0x5b42f691..., 0xd34b6a89...), not this address; two fail under EIP-8151 alone there. No replay of this Safe's own transactions exists, so sender gas margins are not measured.
- Ruled out: EIP-8151 is not assumed here; an owner whose account takes real code loses only its off-chain ECDSA signature and keeps approveHash, a separate migration notice.
- Ruled out: use: tx 0x9c922b14...b93b succeeded recently; 13 transactions called this Safe in the 90 days to the block.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
