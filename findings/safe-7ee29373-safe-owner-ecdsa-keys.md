---
id: safe-7ee29373-safe-owner-ecdsa-keys
format: 2
title: Three forged owner keys would let a quantum attacker empty this Safe
status: confirmed
severity: MEDIUM
justification: Fixable without a protocol change, but only if 3 of the 5 owners sign to swap each key for a post-quantum
  signer.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7ee29373f075ee1d83b1b93b4fe94ae242df5178'
  name: Safe
  code: verified
  code_url: https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code
  proxy_of: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  copies: 1
  upgradeable: 'yes'
value:
  usd: 5087393
  basis: held
activity: {}
impact: funds-loss
action: Swap each owner key, with swapOwner, for a contract owner that checks a post-quantum signature in isValidSignature(bytes,bytes).
evidence_level: source
checks:
- id: singleton
  storage: '0x7ee29373f075ee1d83b1b93b4fe94ae242df5178'
  slot: '0x0'
  is: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  says: slot 0 of the proxy holds the Safe singleton, the code every call runs
  for:
  - upgradeable
- id: proxycode
  source: '0x7ee29373f075ee1d83b1b93b4fe94ae242df5178'
  file: contracts/proxies/SafeProxy.sol
  line: 42
  has: let success := delegatecall(gas(), _singleton, 0, calldatasize(), 0, 0)
  says: the proxy forwards every call to the singleton in slot 0
  for:
  - upgradeable
- id: version
  call: '0x7ee29373f075ee1d83b1b93b4fe94ae242df5178'
  fn: VERSION()(string)
  is: 1.4.1
  says: the Safe answers version 1.4.1
  for:
  - notes
- id: threshold
  call: '0x7ee29373f075ee1d83b1b93b4fe94ae242df5178'
  fn: getThreshold()(uint256)
  is: 3
  says: three owner approvals are needed
  for:
  - evidence-2
  - evidence-3
  - justification
  - what
- id: owners
  call: '0x7ee29373f075ee1d83b1b93b4fe94ae242df5178'
  fn: getOwners()(address[])
  is:
  - '0xfb528e61ba53f15bbca95cc651b72acdfd5223db'
  - '0x1af9fbf40b4361442318cda24b00fe96b1174db5'
  - '0xbbbb5ebdc5f75dfa3723df38fb7eae587692df23'
  - '0xee1a28b54f3532927950cba66a2cda33c69a8107'
  - '0xc6badce2f5e10db90d74dbe023768259ec4699c7'
  says: the Safe has five owners
  for:
  - evidence-2
  - justification
  - what
- id: safenonce
  call: '0x7ee29373f075ee1d83b1b93b4fe94ae242df5178'
  fn: nonce()(uint256)
  is: 114
  says: the Safe has executed 114 owner-signed transactions, so it is set up and in use
  for:
  - notes
- id: code1
  code: '0xfb528e61ba53f15bbca95cc651b72acdfd5223db'
  is: empty
  says: 'owner 1 has no code: an ordinary ECDSA account, no EIP-7702 delegation'
  for:
  - evidence-2
  - what
- id: code2
  code: '0x1af9fbf40b4361442318cda24b00fe96b1174db5'
  is: empty
  says: 'owner 2 has no code: an ordinary ECDSA account, no EIP-7702 delegation'
  for:
  - evidence-2
  - what
- id: code3
  code: '0xbbbb5ebdc5f75dfa3723df38fb7eae587692df23'
  is: empty
  says: 'owner 3 has no code: an ordinary ECDSA account, no EIP-7702 delegation'
  for:
  - evidence-2
  - what
- id: code4
  code: '0xee1a28b54f3532927950cba66a2cda33c69a8107'
  is: empty
  says: 'owner 4 has no code: an ordinary ECDSA account, no EIP-7702 delegation'
  for:
  - evidence-2
  - what
- id: code5
  code: '0xc6badce2f5e10db90d74dbe023768259ec4699c7'
  is: empty
  says: 'owner 5 has no code: an ordinary ECDSA account, no EIP-7702 delegation'
  for:
  - evidence-2
  - what
- id: nonce3
  nonce: '0xbbbb5ebdc5f75dfa3723df38fb7eae587692df23'
  min: 1
  says: owner 3 has sent transactions, so its public key is on-chain
  for:
  - what
- id: nonce5
  nonce: '0xc6badce2f5e10db90d74dbe023768259ec4699c7'
  min: 1
  says: owner 5 has sent transactions, so its public key is on-chain
  for:
  - what
- id: signedtx
  tx: '0xe96ce964392ae177addd7814d82eaf1d5f48d7fa9f3dfa8bb7062ba7b5b10d8f'
  to: '0x7ee29373f075ee1d83b1b93b4fe94ae242df5178'
  ok: true
  says: an executed transaction of this Safe; its calldata carries three ECDSA signatures that recover to owners
    2, 3 and 1
  for:
  - evidence-3
  - what
- id: ecdsa
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  lines:
  - 322
  - 331
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: 'other v: the slot is recovered with ecrecover and must be an owner; the recovered account is never asked'
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
  says: 'v == 0: a contract owner is asked through isValidSignature(bytes,bytes) with a signature of any length'
  for:
  - action
  - evidence-1
  - justification
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
  - notes
- id: sel-final
  bytecode: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  has: '0x1626ba7e'
  absent: true
  says: the final ERC-1271 selector 0x1626ba7e is absent from the singleton, so an owner contract that answers only
    that one does not count
  for:
  - action
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
- id: checksig
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 172
  has: checkSignatures(txHash, txHashData, signatures);
  says: execTransaction checks threshold-many signatures over the transaction hash
  for:
  - evidence-3
  - what
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
  - justification
  - what
- id: self
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/common/SelfAuthorized.sol
  line: 10
  has: require(msg.sender == address(this), "GS031");
  says: owner changes run only as a call from the Safe itself, that is a transaction its owners approved
  for:
  - action
  - justification
  - what
- id: noguard
  storage: '0x7ee29373f075ee1d83b1b93b4fe94ae242df5178'
  slot: '0x4a204f620c8c5ccdca3fd54d003badd85ba500436a431f0cbda4f558c93c34c8'
  is: 0
  says: no guard is set
  for:
  - what
- id: nomodules
  call: '0x7ee29373f075ee1d83b1b93b4fe94ae242df5178'
  fn: getModulesPaginated(address,uint256)(address[],address)
  args:
  - '0x0000000000000000000000000000000000000001'
  - 10
  is:
  - []
  - '0x0000000000000000000000000000000000000001'
  says: no module is enabled, so nothing executes without owner approvals
  for:
  - what
- id: usdt
  call: '0xdac17f958d2ee523a2206206994597c13d831ec7'
  fn: balanceOf(address)(uint256)
  args:
  - '0x7ee29373f075ee1d83b1b93b4fe94ae242df5178'
  is: 5014980000000
  says: the Safe holds 5,014,980 USDT
  for:
  - evidence-2
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
reviews: []
related: []
---

## What happens

This Safe runs any transfer or call, including owner changes, once 3 of its 5 owners approve. All five owners are ordinary ECDSA accounts, and at least three have signed on-chain, so their keys are exposed. A quantum computer that derives three of those keys can sign for the Safe and take its funds.

## Evidence

- [The Safe's code](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) counts owners' ECDSA signatures, contract owners' answers or approved hashes, then runs the signed call.
- [This Safe](https://etherscan.io/address/0x7ee29373f075ee1d83b1b93b4fe94ae242df5178#readProxyContract) needs 3 of 5 owners; all five are accounts without code. It holds about 5.0 million USDT.
- [One executed transaction](https://etherscan.io/tx/0xe96ce964392ae177addd7814d82eaf1d5f48d7fa9f3dfa8bb7062ba7b5b10d8f) of this Safe carries the ECDSA signatures of three owners.

## Reviewer notes

### Mechanism

The 171-byte proxy delegates every call to the singleton in slot 0, Safe 1.4.1. execTransaction (Safe.sol 139-203) hashes the transaction with the nonce and calls checkSignatures, which needs the threshold (3) of 65-byte slots in ascending owner order (checkNSignatures, 274-334). v == 0 asks a contract owner through the legacy isValidSignature(bytes,bytes) (magic 0x20c13b0b; 0x1626ba7e is absent from the singleton); v == 1 accepts the sender or an on-chain approveHash; v > 30 recovers the eth_sign hash; other v recover the hash with ecrecover. Each address must be an owner (GS026). execute then runs the signed call or delegatecall. Owners 3 and 5 have account nonces 41 and 54. Owners 1 and 2 have nonce 0, but the calldata of tx 0xe96ce964 (Safe nonce 105, a USDT approve) holds three signatures with v 27/28 that recover to owners 2, 3 and 1 against getTransactionHash(..., 105). Four public keys are on-chain; three are enough. Owner changes are self-call only.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or approved-hash path that shields these owners: both exist (v == 0, v == 1), but all five owners are accounts without code, so their ECDSA signatures still count.
- Ruled out: the address not being in use: slot 0 holds the 1.4.1 singleton, the Safe's nonce is 114, threshold 3, five owners, 5,014,980 USDT held.
- Ruled out: keys never exposed: owners 3 and 5 have sent transactions; owners 1 and 2 have account nonce 0 but signed tx 0xe96ce964 (recovered off-chain). Owner 4 (0xee1a28b5...) has nonce 0 and I saw no signature of it; it is not needed.
- Ruled out: a module or guard that bypasses or limits owners: none enabled, guard slot zero.
- Ruled out: an owner fixing itself by upgrading its account in place: the ECDSA branch never calls the recovered address, so the old key counts until swapOwner removes it.
- Ruled out: the fallback handler 0x2f55e8b20d0b9fefa187aa7d00b6cbe563605bf5 (slot 0x6c9a6c4a...): the Safe only forwards unknown calls to it with a plain call. Its source was not read; the card makes no claim about it.
- Ruled out: an EIP-8151 effect: not this card's subject. The family's only replay (tx 0x09827fd9...) is sent to 0x9641d764fc13c8b624c04430c7356c1c7c8102e2 and its calldata does not contain this Safe's address, so it is not cited.
- Ruled out: the old row's $90.1M: the tool reads $5,087,393 at the block; the header keeps the tool's figure.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
