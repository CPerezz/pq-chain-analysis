---
id: gnosissafe-0cb1d4a2-owner-ecdsa-keys
format: 2
title: Two forged ECDSA owner keys could move everything this Safe holds
status: confirmed
severity: MEDIUM
justification: Two forged owner keys take all funds; the fix needs the owners to replace their ECDSA keys with post-quantum
  signers.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0cb1d4a24292bb89862f599ac5b10f42b6de07e4'
  name: GnosisSafe
  code: verified
  code_url: https://etherscan.io/address/0x34cfac646f301356faa8b21e94227e3583fe3f5f#code
  proxy_of: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  copies: 1
  upgradeable: 'yes'
value:
  usd: 41101863
  basis: held
activity:
  txs_90d: 11
impact: funds-loss
action: Replace each owner key, with swapOwner, by a post-quantum signer contract that answers isValidSignature(bytes,bytes).
evidence_level: source
checks:
- id: version
  call: '0x0cb1d4a24292bb89862f599ac5b10f42b6de07e4'
  fn: VERSION()(string)
  is: 1.1.1
  says: the Safe runs version 1.1.1
  for:
  - action
- id: threshold
  call: '0x0cb1d4a24292bb89862f599ac5b10f42b6de07e4'
  fn: getThreshold()(uint256)
  is: 2
  says: 2 owner approvals are needed
  for:
  - evidence-1
  - justification
  - what
- id: owners
  call: '0x0cb1d4a24292bb89862f599ac5b10f42b6de07e4'
  fn: getOwners()(address[])
  is:
  - '0xc1b591fc2d133c410f0a9f5469d9be1b0894e0d1'
  - '0xde5c171ff4443eec57bfbd2124a49637affd535e'
  - '0x10c961e952fec4901f3ba80eec475cf55f169382'
  - '0x9ed07b5db7dad3c9a0baa3e320e68ce779063249'
  says: the Safe has four owners
  for:
  - evidence-1
  - evidence-2
  - what
- id: code-o1
  code: '0xc1b591fc2d133c410f0a9f5469d9be1b0894e0d1'
  is: empty
  says: owner 1 has no code
  for:
  - evidence-2
  - what
- id: code-o2
  code: '0xde5c171ff4443eec57bfbd2124a49637affd535e'
  is: empty
  says: owner 2 has no code
  for:
  - evidence-2
  - what
- id: code-o3
  code: '0x10c961e952fec4901f3ba80eec475cf55f169382'
  is: empty
  says: owner 3 has no code
  for:
  - evidence-2
  - what
- id: code-o4
  code: '0x9ed07b5db7dad3c9a0baa3e320e68ce779063249'
  is: empty
  says: owner 4 has no code
  for:
  - evidence-2
  - what
- id: balance
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x0cb1d4a24292bb89862f599ac5b10f42b6de07e4'
  is: 12131003016522681629265
  says: the Safe holds 12,131 ETH
  for:
  - evidence-2
- id: singleton
  storage: '0x0cb1d4a24292bb89862f599ac5b10f42b6de07e4'
  slot: '0x0'
  is: '0x00000000000000000000000034cfac646f301356faa8b21e94227e3583fe3f5f'
  says: slot 0 holds the Safe 1.1.1 singleton
  for:
  - upgradeable
- id: proxy-slot
  source: '0x0cb1d4a24292bb89862f599ac5b10f42b6de07e4'
  file: Proxy.sol
  line: 28
  has: let masterCopy := and(sload(0), 0xffffffffffffffffffffffffffffffffffffffff)
  says: the proxy reads its singleton from slot 0
  for:
  - upgradeable
- id: proxy-delegate
  source: '0x0cb1d4a24292bb89862f599ac5b10f42b6de07e4'
  file: Proxy.sol
  line: 35
  has: let success := delegatecall(gas, masterCopy, 0, calldatasize(), 0, 0)
  says: the proxy runs every call as the singleton's code
  for:
  - upgradeable
- id: master
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  lines:
  - 27
  - 33
  has: masterCopy = _masterCopy;
  says: changeMasterCopy, authorized, replaces the singleton
  for:
  - upgradeable
- id: authorized
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  line: 7
  has: require(msg.sender == address(this), "Method can only be called from this contract");
  says: authorized functions run only when the Safe calls itself, i.e. in a threshold-approved Safe transaction
  for:
  - action
  - evidence-3
  - upgradeable
- id: exec
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  line: 800
  has: checkSignatures(txHash, txHashData, signatures, true);
  says: execTransaction checks the owners' signatures
  for:
  - justification
  - what
- id: exec-run
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  line: 807
  has: success = execute(to, value, data, operation
  says: execTransaction then executes any call or delegate call the owners signed
  for:
  - what
- id: loop
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  line: 865
  has: for (i = 0; i < _threshold; i++) {
  says: threshold-many owner approvals are checked
  for:
  - evidence-1
  - justification
  - what
- id: ethsign
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  line: 908
  has: currentOwner = ecrecover(keccak256(abi.encodePacked(
  says: v > 30 recovers the owner from an eth_sign signature
  for:
  - what
- id: ecdsa
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  line: 911
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: an owner approval is recovered with ECDSA from the transaction hash
  for:
  - evidence-1
  - justification
  - what
- id: ownercheck
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  line: 914
  has: currentOwner > lastOwner && owners[currentOwner] != address(0)
  says: the recovered address counts if it is an owner, with no check of its code
  for:
  - evidence-1
  - justification
  - what
- id: approved
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  line: 901
  has: require(msg.sender == currentOwner || approvedHashes[currentOwner][dataHash] != 0
  says: an owner can also approve by sending the transaction or calling approveHash
  for:
  - notes
- id: contractsig
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  line: 895
  has: ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE
  says: an owner contract is asked through isValidSignature with the full signature
  for:
  - action
  - evidence-3
  - justification
- id: magic
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  line: 583
  has: bytes4 constant internal EIP1271_MAGIC_VALUE = 0x20c13b0b;
  says: the magic is the legacy isValidSignature(bytes,bytes) value
  for:
  - action
  - evidence-3
- id: sel-legacy
  selector: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  fn: isValidSignature(bytes,bytes)
  says: the singleton carries the legacy ERC-1271 selector 0x20c13b0b
  for:
  - action
- id: sel-final
  selector: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: the final ERC-1271 selector 0x1626ba7e is absent from the singleton
  for:
  - action
- id: swap
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  lines:
  - 392
  - 410
  has: owners[prevOwner] = newOwner;
  says: swapOwner, authorized, puts a new owner in place of an old one
  for:
  - action
  - evidence-3
  - justification
- id: modules
  call: '0x0cb1d4a24292bb89862f599ac5b10f42b6de07e4'
  fn: getModules()(address[])
  is:
  - '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  says: one module is enabled
  for:
  - notes
- id: module-name
  call: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  fn: NAME()(string)
  is: Allowance Module
  says: the module is the Allowance Module
  for:
  - notes
- id: allow-d1
  call: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  fn: getTokenAllowance(address,address,address)(uint256[5])
  args:
  - '0x0cb1d4a24292bb89862f599ac5b10f42b6de07e4'
  - '0x477edb4b2b6c395de3b03ea1a7bb1dc5a059ce9b'
  - '0x0000000000000000000000000000000000000000'
  is:
  - 0
  - 0
  - 0
  - 0
  - 5
  says: delegate 0x477e has an ETH allowance amount of 0
  for:
  - notes
- id: allow-d2
  call: '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  fn: getTokenAllowance(address,address,address)(uint256[5])
  args:
  - '0x0cb1d4a24292bb89862f599ac5b10f42b6de07e4'
  - '0x441c69e61cb0201b8d0ea3cf725d751ce1248f47'
  - '0x0000000000000000000000000000000000000000'
  is:
  - 0
  - 0
  - 0
  - 0
  - 3
  says: delegate 0x441c has an ETH allowance amount of 0
  for:
  - notes
- id: nonce-safe
  call: '0x0cb1d4a24292bb89862f599ac5b10f42b6de07e4'
  fn: nonce()(uint256)
  is: 208
  says: the Safe has executed 208 transactions
  for:
  - notes
- id: tx-own
  tx: '0x689908de2dca435672fdbc188918da941eef2d22ba8db43e78a2767318c7de05'
  to: '0x0cb1d4a24292bb89862f599ac5b10f42b6de07e4'
  ok: true
  says: a Safe transaction on 2026-11-12 succeeded
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
reviews:
- who: r-0cb1d4a2, the row's refuter
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: A Safe 1.1.1 proxy, 2 of 4 owners, all four code-less ECDSA keys; about 12,131 ETH at the block.
    MEDIUM, PQ-12: two forged owner keys move everything; the singleton has only the legacy isValidSignature(bytes,bytes),
    so the fix is swapOwner to a signer contract that answers it. Author A-0cb1d4a2; refuter R-0cb1d4a2 agreed with
    no objection and checked the one enabled module: the Allowance Module''s two delegates have an ETH allowance
    of 0 at the block, so that path moves nothing today. The reader changed nothing. The family replay that fails
    under EIP-8151 alone belongs to another Safe and is not cited.'
related: []
---

## What happens

This Safe moves funds when 2 of its 4 owners approve; all four are plain ECDSA keys. Whoever derives two owner keys with a quantum computer can take all it holds. An owner that moves its own account to post-quantum keys stays forgeable: the Safe still accepts an ECDSA signature for that address.

## Evidence

- [checkSignatures](https://etherscan.io/address/0x34cfac646f301356faa8b21e94227e3583fe3f5f#code) counts an owner when ecrecover of its signature returns its address; 2 of the 4 owners are needed.
- The [four owners](https://etherscan.io/address/0x0cb1d4a24292bb89862f599ac5b10f42b6de07e4#readProxyContract) are accounts without code, and the Safe holds 12,131 ETH.
- Owners are replaced by [swapOwner](https://etherscan.io/address/0x34cfac646f301356faa8b21e94227e3583fe3f5f#code) in a Safe transaction; a contract owner is asked via isValidSignature(bytes,bytes).

## Reviewer notes

### Mechanism

The proxy delegates every call to the singleton in slot 0 (Safe 1.1.1). execTransaction hashes the transaction with the nonce, calls checkSignatures (line 800), then executes it (line 807). checkSignatures walks threshold-many 65-byte slots (threshold 2). Per slot v selects the scheme: v==0 asks the owner contract through legacy isValidSignature(bytes,bytes), magic 0x20c13b0b (lines 583, 895); v==1 accepts an owner sending the transaction or who called approveHash (line 901); v>30 recovers an eth_sign hash (line 908); otherwise ecrecover(dataHash, v, r, s) (line 911). Each recovered or named address must be an owner (line 914), with no check of its code. All four owners have no code at the block. Owners change only through swapOwner and the other owner-management functions, all authorized: callable only by the Safe itself (line 7), i.e. a threshold-approved Safe transaction.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: a contract owner already in place: all four owners are plain accounts with no code (no EIP-7702 delegation either).
- Ruled out: final ERC-1271 for owner contracts: the singleton carries only the legacy selector 0x20c13b0b, not 0x1626ba7e; a signer contract answering only the final interface would not count.
- Ruled out: changeMasterCopy as a fix: swapping the singleton alone leaves the four ECDSA owners untouched.
- Ruled out: an owner upgrading its own account in place: the ECDSA paths (lines 908, 911) recover the address and never ask the account, so it stays forgeable.
- Ruled out: other exits: the only enabled module, the Allowance Module, gives both its delegates an ETH allowance amount of 0.
- Ruled out: an unused proxy: nonce is 208; a Safe transaction on 2026-11-12 succeeded with room to spare for the EIP's extra recovery cost.
- Ruled out: a replay that fails under EIP-8151 alone (0xa6434e8b...): it was sent to a different Safe, not this address.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
