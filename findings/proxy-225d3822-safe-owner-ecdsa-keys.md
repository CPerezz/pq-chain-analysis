---
id: proxy-225d3822-safe-owner-ecdsa-keys
format: 2
title: Three forged owner keys would let a quantum attacker empty this Safe
status: confirmed
severity: MEDIUM
justification: 'Fixable without a protocol change, but only if the owners act: 3 of 4 sign to swap each key for
  a post-quantum signer.'
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x225d3822de44e58ee935440e0c0b829c4232086e'
  name: Proxy
  code: verified
  code_url: https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code
  proxy_of: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  copies: 1
  upgradeable: 'yes'
value:
  usd: 44952513
  basis: held
activity: {}
impact: funds-loss
action: Swap each owner key with swapOwner for a post-quantum signer contract that answers the legacy isValidSignature(bytes,bytes).
evidence_level: source
checks:
- id: singleton
  storage: '0x225d3822de44e58ee935440e0c0b829c4232086e'
  slot: '0x0'
  is: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  says: slot 0 of the proxy holds the Safe 1.4.1 singleton, the code every call runs
  for:
  - proxy_of
  - upgradeable
- id: proxycode
  source: '0x225d3822de44e58ee935440e0c0b829c4232086e'
  file: Proxy.sol
  line: 35
  has: let success := delegatecall(gas, masterCopy, 0, calldatasize(), 0, 0)
  says: the proxy forwards every call to the singleton in slot 0
  for:
  - proxy_of
- id: version
  call: '0x225d3822de44e58ee935440e0c0b829c4232086e'
  fn: VERSION()(string)
  is: 1.4.1
  says: the Safe answers version 1.4.1
  for:
  - proxy_of
- id: threshold
  call: '0x225d3822de44e58ee935440e0c0b829c4232086e'
  fn: getThreshold()(uint256)
  is: 3
  says: three owner approvals are needed
  for:
  - evidence-2
  - justification
  - what
- id: owners
  call: '0x225d3822de44e58ee935440e0c0b829c4232086e'
  fn: getOwners()(address[])
  is:
  - '0xd8a6a3ca1739423de5f634dfaa8ba224eaf16d0e'
  - '0x223c0ef36fee905a40175d92704b1d3624218ee7'
  - '0xd6970196ff8cef3cdd61256c1841a085eecd3ae8'
  - '0x18b7ff0370456db6b7710714d9dcc25a0a3b3016'
  says: the Safe has four owners
  for:
  - evidence-2
  - what
- id: code1
  code: '0xd8a6a3ca1739423de5f634dfaa8ba224eaf16d0e'
  is: empty
  says: 'owner 1 has no code: an ordinary ECDSA account, no EIP-7702 delegation'
  for:
  - evidence-2
  - what
- id: code2
  code: '0x223c0ef36fee905a40175d92704b1d3624218ee7'
  is: empty
  says: 'owner 2 has no code: an ordinary ECDSA account, no EIP-7702 delegation'
  for:
  - evidence-2
  - what
- id: code3
  code: '0xd6970196ff8cef3cdd61256c1841a085eecd3ae8'
  is: empty
  says: 'owner 3 has no code: an ordinary ECDSA account, no EIP-7702 delegation'
  for:
  - evidence-2
  - what
- id: code4
  code: '0x18b7ff0370456db6b7710714d9dcc25a0a3b3016'
  is: empty
  says: 'owner 4 has no code: an ordinary ECDSA account, no EIP-7702 delegation'
  for:
  - evidence-2
  - what
- id: nonce1
  nonce: '0xd8a6a3ca1739423de5f634dfaa8ba224eaf16d0e'
  min: 1
  says: owner 1 has sent transactions, so its public key is on-chain
  for:
  - evidence-2
  - what
- id: nonce3
  nonce: '0xd6970196ff8cef3cdd61256c1841a085eecd3ae8'
  min: 1
  says: owner 3 has sent transactions, so its public key is on-chain
  for:
  - evidence-2
  - what
- id: nonce4
  nonce: '0x18b7ff0370456db6b7710714d9dcc25a0a3b3016'
  min: 1
  says: owner 4 has sent transactions, so its public key is on-chain
  for:
  - evidence-2
  - what
- id: ecdsa
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  lines:
  - 322
  - 331
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: a signature slot with v other than 0 or 1 is recovered with ecrecover and must be an owner
  for:
  - evidence-1
  - what
- id: isowner
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 331
  has: require(currentOwner > lastOwner && owners[currentOwner] != address(0) && currentOwner != SENTINEL_OWNERS,
    "GS026");
  says: each recovered or named address must be a distinct owner
  for:
  - evidence-1
  - what
- id: erc1271
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  lines:
  - 286
  - 315
  has: require(ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE,
    "GS024");
  says: 'v == 0: a contract owner is asked through legacy ERC-1271 with a signature of any length'
  for:
  - action
  - evidence-1
  - evidence-3
  - justification
- id: approved
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  lines:
  - 316
  - 321
  has: require(msg.sender == currentOwner || approvedHashes[currentOwner][dataHash] != 0, "GS025");
  says: 'v == 1: an owner that is the sender or approved the hash on-chain counts'
  for:
  - evidence-1
- id: exec
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  lines:
  - 170
  - 203
  has: 'success = execute(to, value, data, operation, gasPrice == 0 ? (gasleft() - 2500) : safeTxGas);'
  says: execTransaction checks the signatures, then runs the call the owners signed
  for:
  - evidence-1
  - upgradeable
  - what
- id: checksig
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 172
  has: checkSignatures(txHash, txHashData, signatures);
  says: execTransaction checks threshold-many signatures over the transaction hash
  for:
  - what
- id: anycall
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/base/Executor.sol
  lines:
  - 28
  - 37
  has: success := call(txGas, to, value, add(data, 0x20), mload(data), 0, 0)
  says: the signed transaction is any call with value, or a delegatecall
  for:
  - evidence-1
  - what
- id: delegate
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/base/Executor.sol
  line: 31
  has: success := delegatecall(txGas, to, add(data, 0x20), mload(data), 0, 0)
  says: a signed delegatecall can rewrite any storage, including the singleton in slot 0
  for:
  - upgradeable
- id: swap
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/base/OwnerManager.sol
  lines:
  - 99
  - 109
  has: function swapOwner(address prevOwner, address oldOwner, address newOwner) public authorized {
  says: swapOwner replaces one owner with another address
  for:
  - action
  - evidence-3
  - justification
  - what
- id: self
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/common/SelfAuthorized.sol
  line: 10
  has: require(msg.sender == address(this), "GS031");
  says: owner changes run only as a call from the Safe itself, that is a signed execTransaction
  for:
  - action
  - evidence-3
  - justification
  - what
- id: noguard
  storage: '0x225d3822de44e58ee935440e0c0b829c4232086e'
  slot: '0x4a204f620c8c5ccdca3fd54d003badd85ba500436a431f0cbda4f558c93c34c8'
  is: 0
  says: no guard is set
  for:
  - what
- id: nomodules
  call: '0x225d3822de44e58ee935440e0c0b829c4232086e'
  fn: getModulesPaginated(address,uint256)(address[],address)
  args:
  - '0x0000000000000000000000000000000000000001'
  - 10
  is:
  - []
  - '0x0000000000000000000000000000000000000001'
  says: no module is enabled, so nothing executes without owner signatures
  for:
  - what
- id: eth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x225d3822de44e58ee935440e0c0b829c4232086e'
  is: 9563536991836684259073
  says: the Safe holds 9,563.5 ETH
  for:
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
  - evidence-1
- id: sel-legacy
  bytecode: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  has: '0x20c13b0b'
  says: the singleton's code holds the legacy magic value 0x20c13b0b
  for:
  - action
  - evidence-1
- id: sel-final
  bytecode: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  has: '0x1626ba7e'
  absent: true
  says: the final ERC-1271 selector 0x1626ba7e is absent from the singleton, so an owner contract that answers only
    that one does not count
  for:
  - action
  - evidence-1
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
reviews: []
related: []
---

## What happens

This Safe runs any transfer or call, including owner changes, once 3 of its 4 owners sign it. All four owners are ordinary ECDSA accounts, and three have sent transactions, so their public keys are public. A quantum computer that derives those three keys can sign for the Safe and take what it holds.

## Evidence

- [The Safe's code](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) counts owners' ECDSA signatures, contract owners' legacy isValidSignature(bytes,bytes) answers or approved hashes.
- [This Safe](https://etherscan.io/address/0x225d3822de44e58ee935440e0c0b829c4232086e#readProxyContract) needs 3 of 4 owners; all four are accounts without code, three have sent transactions.
- [swapOwner](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) replaces an owner through a signed transaction of the Safe, so owners can move to contract signers.

## Reviewer notes

### Mechanism

The 170-byte proxy delegates every call to the singleton in slot 0, Safe 1.4.1 (VERSION 1.4.1). execTransaction hashes the transaction with the nonce and calls checkSignatures, which needs the threshold (3) of 65-byte slots in ascending owner order. v == 0 asks a contract owner through legacy ERC-1271 isValidSignature(bytes,bytes) with a signature of any length; v == 1 accepts the sender or an on-chain approveHash; v > 30 recovers the eth_sign hash; other v recover the hash with ecrecover. Each address must be an owner (GS026). Then execute runs the signed call or delegatecall with any value. No guard and no module are set, so owner signatures are the only way in. The four owners are EOAs with no code; three have nonces 211, 51 and 25, so a CRQC can take their keys from their transaction signatures and meet the threshold. Owner changes (swapOwner, addOwnerWithThreshold, removeOwner, changeThreshold) are authorized only as a self-call, i.e. a signed execTransaction; a contract owner verifying a post-quantum signature through ERC-1271 closes that owner's ECDSA path. An EIP-7702 delegation would keep the ECDSA key and does not help. A signed delegatecall can rewrite slot 0, so the Safe can change its own code.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or approved-hash path that would shield these owners: it exists (v == 0, v == 1), but all four owners are accounts without code, so their ECDSA signatures still count.
- Ruled out: a different code than the one described: slot 0 holds 0x41675c09…, which answers VERSION 1.4.1; the tool's empty proxy_of is because the Safe proxy keeps its singleton in slot 0, not an EIP-1967 slot.
- Ruled out: a key that is unset or never exposed: three owners have nonces 211, 51 and 25, which meets the threshold of 3; the fourth (0x223c…) has nonce 0 and is not needed for the claim.
- Ruled out: a module or guard that limits or bypasses owners: getModulesPaginated returns none and the guard slot is zero.
- Ruled out: an EIP-8151 effect on this address: not this card's subject. The family's only replay (tx 0x09827fd9…) is on another Safe, sent by 0x033ac280…, so it is not cited here; any gas-limit notice for the singleton's family is a separate finding.
- Ruled out: dependent 0xdf5fa1039af2ead0a591e806ae728b9cb9165b93 holds this address as a constant; it was not read, and the card makes no claim about it.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
