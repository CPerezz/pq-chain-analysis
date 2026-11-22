---
id: gnosissafe-705199fe-owner-ecdsa-keys
format: 2
title: A quantum computer that derives 3 of 10 owner keys can empty this Safe
status: confirmed
severity: MEDIUM
justification: Three derived owner keys move all funds; the fix needs owners to swap in post-quantum signer contracts.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x705199fe234a7a2f1bc8b95dd7d08284c8f467f1'
  name: GnosisSafe
  code: verified
  code_url: https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code
  proxy_of: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  copies: 1
  upgradeable: 'yes'
value:
  usd: 22909190
  basis: held
activity:
  txs_90d: 10
impact: funds-loss
action: Swap EOA owners for new post-quantum signer contracts that answer isValidSignature(bytes,bytes) until under
  3 ECDSA owners remain.
evidence_level: source
checks:
- id: singleton
  storage: '0x705199fe234a7a2f1bc8b95dd7d08284c8f467f1'
  slot: 0
  is: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  says: the proxy runs the Safe 1.3.0 singleton
  for:
  - upgradeable
- id: version
  call: '0x705199fe234a7a2f1bc8b95dd7d08284c8f467f1'
  fn: VERSION()(string)
  is: 1.3.0
  says: the Safe reports version 1.3.0
  for:
  - notes
- id: owners
  call: '0x705199fe234a7a2f1bc8b95dd7d08284c8f467f1'
  fn: getOwners()(address[])
  is:
  - '0x2149ea7bd59c0e3fc1c7f162efd8721e2d399e3d'
  - '0x96a670afc529bad89a48919e7ce383c9dad11620'
  - '0x3dd4b4dbe6aee6f49a65f0c1ac508deff761c195'
  - '0x2f10e2358594fd72c7d9e2eea137ef1222c03bd5'
  - '0x18c04b30c3bc7f49b9cb7483da349d757b50b54a'
  - '0x828424517f9f04015db02169f4026d57b2b07229'
  - '0x2cdd560058d5ac32dc416aaa09eaf93230c0b7b3'
  - '0x3cc3a225769900e003e264dd4cb43e90896bc21a'
  - '0xd367f8322b64f29faf71ddb5c1877dc9ed6ec644'
  - '0xe3df2cceac61b1afa311372ecc5b40a3a6585a9e'
  says: the Safe has these ten owners
  for:
  - evidence-2
  - what
- id: threshold
  call: '0x705199fe234a7a2f1bc8b95dd7d08284c8f467f1'
  fn: getThreshold()(uint256)
  is: 3
  says: three owner approvals are needed
  for:
  - action
  - evidence-2
  - justification
  - what
- id: safe-nonce
  call: '0x705199fe234a7a2f1bc8b95dd7d08284c8f467f1'
  fn: nonce()(uint256)
  is: 212
  says: 'the Safe has executed 212 transactions: it is a wallet in use, not an unused implementation'
  for:
  - notes
- id: modules
  call: '0x705199fe234a7a2f1bc8b95dd7d08284c8f467f1'
  fn: getModulesPaginated(address,uint256)(address[],address)
  args:
  - '0x0000000000000000000000000000000000000001'
  - 10
  is:
  - []
  - '0x0000000000000000000000000000000000000001'
  says: no module is enabled, so no module can move funds without owner approvals
  for:
  - evidence-2
- id: guard
  storage: '0x705199fe234a7a2f1bc8b95dd7d08284c8f467f1'
  slot: '0x4a204f620c8c5ccdca3fd54d003badd85ba500436a431f0cbda4f558c93c34c8'
  is: 0
  says: no transaction guard is set
  for:
  - notes
- id: code-2149ea
  code: '0x2149ea7bd59c0e3fc1c7f162efd8721e2d399e3d'
  is: empty
  says: 'owner 0x2149ea7b has no code and no delegation: a plain ECDSA key'
  for:
  - evidence-2
  - what
- id: code-96a670
  code: '0x96a670afc529bad89a48919e7ce383c9dad11620'
  is: empty
  says: 'owner 0x96a670af has no code and no delegation: a plain ECDSA key'
  for:
  - evidence-2
  - what
- id: code-3dd4b4
  code: '0x3dd4b4dbe6aee6f49a65f0c1ac508deff761c195'
  is: empty
  says: 'owner 0x3dd4b4db has no code and no delegation: a plain ECDSA key'
  for:
  - evidence-2
  - what
- id: code-2f10e2
  code: '0x2f10e2358594fd72c7d9e2eea137ef1222c03bd5'
  is: empty
  says: 'owner 0x2f10e235 has no code and no delegation: a plain ECDSA key'
  for:
  - evidence-2
  - what
- id: code-18c04b
  code: '0x18c04b30c3bc7f49b9cb7483da349d757b50b54a'
  is: empty
  says: 'owner 0x18c04b30 has no code and no delegation: a plain ECDSA key'
  for:
  - evidence-2
  - what
- id: code-828424
  code: '0x828424517f9f04015db02169f4026d57b2b07229'
  is: empty
  says: 'owner 0x82842451 has no code and no delegation: a plain ECDSA key'
  for:
  - evidence-2
  - what
- id: code-2cdd56
  code: '0x2cdd560058d5ac32dc416aaa09eaf93230c0b7b3'
  is: empty
  says: 'owner 0x2cdd5600 has no code and no delegation: a plain ECDSA key'
  for:
  - evidence-2
  - what
- id: code-3cc3a2
  code: '0x3cc3a225769900e003e264dd4cb43e90896bc21a'
  is: empty
  says: 'owner 0x3cc3a225 has no code and no delegation: a plain ECDSA key'
  for:
  - evidence-2
  - what
- id: code-d367f8
  code: '0xd367f8322b64f29faf71ddb5c1877dc9ed6ec644'
  is: empty
  says: 'owner 0xd367f832 has no code and no delegation: a plain ECDSA key'
  for:
  - evidence-2
  - what
- id: code-e3df2c
  code: '0xe3df2cceac61b1afa311372ecc5b40a3a6585a9e'
  is: empty
  says: 'owner 0xe3df2cce has no code and no delegation: a plain ECDSA key'
  for:
  - evidence-2
  - what
- id: sent-2149ea
  nonce: '0x2149ea7bd59c0e3fc1c7f162efd8721e2d399e3d'
  min: 1
  says: owner 0x2149ea7b has sent transactions (1 at the block), so its public key is on-chain
  for:
  - evidence-2
  - what
- id: sent-96a670
  nonce: '0x96a670afc529bad89a48919e7ce383c9dad11620'
  min: 1
  says: owner 0x96a670af has sent transactions (84 at the block), so its public key is on-chain
  for:
  - evidence-2
  - what
- id: sent-3dd4b4
  nonce: '0x3dd4b4dbe6aee6f49a65f0c1ac508deff761c195'
  min: 1
  says: owner 0x3dd4b4db has sent transactions (21 at the block), so its public key is on-chain
  for:
  - evidence-2
  - what
- id: sent-2f10e2
  nonce: '0x2f10e2358594fd72c7d9e2eea137ef1222c03bd5'
  min: 1
  says: owner 0x2f10e235 has sent transactions (1,777 at the block), so its public key is on-chain
  for:
  - evidence-2
  - what
- id: sent-18c04b
  nonce: '0x18c04b30c3bc7f49b9cb7483da349d757b50b54a'
  min: 1
  says: owner 0x18c04b30 has sent transactions (221 at the block), so its public key is on-chain
  for:
  - evidence-2
  - what
- id: sent-828424
  nonce: '0x828424517f9f04015db02169f4026d57b2b07229'
  min: 1
  says: owner 0x82842451 has sent transactions (497 at the block), so its public key is on-chain
  for:
  - evidence-2
  - what
- id: sent-2cdd56
  nonce: '0x2cdd560058d5ac32dc416aaa09eaf93230c0b7b3'
  min: 1
  says: owner 0x2cdd5600 has sent transactions (28 at the block), so its public key is on-chain
  for:
  - evidence-2
  - what
- id: sent-3cc3a2
  nonce: '0x3cc3a225769900e003e264dd4cb43e90896bc21a'
  min: 1
  says: owner 0x3cc3a225 has sent transactions (10 at the block), so its public key is on-chain
  for:
  - evidence-2
  - what
- id: sent-e3df2c
  nonce: '0xe3df2cceac61b1afa311372ecc5b40a3a6585a9e'
  min: 1
  says: owner 0xe3df2cce has sent transactions (19 at the block), so its public key is on-chain
  for:
  - evidence-2
  - what
- id: eth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x705199fe234a7a2f1bc8b95dd7d08284c8f467f1'
  is: 2499999410100000000000
  says: the Safe holds about 2,500 ETH
  for:
  - what
- id: exec-sig
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 145
  has: checkSignatures(txHash, txHashData, signatures);
  says: execTransaction checks the owners' approvals of the transaction hash
  for:
  - what
- id: use-threshold
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  lines:
  - 227
  - 230
  has: checkNSignatures(dataHash, data, signatures, _threshold);
  says: the number of approvals required is the stored threshold
  for:
  - what
- id: exec-op
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 176
  has: success = execute(to, value, data, operation,
  says: execTransaction then performs any call or delegatecall the owners approved, with any value
  for:
  - justification
  - upgradeable
  - what
- id: delegatecall
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/base/Executor.sol
  line: 18
  has: success := delegatecall(txGas, to, add(data, 0x20), mload(data), 0, 0)
  says: an approved transaction can delegatecall code that rewrites the Safe's storage, including its singleton
  for:
  - upgradeable
- id: ecdsa
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 299
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: a signature with v 27 or 28 is recovered with ecrecover over the transaction hash
  for:
  - evidence-1
  - justification
  - what
- id: ecdsa-ethsign
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 295
  has: currentOwner = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", dataHash)), v - 4,
    r, s);
  says: a signature with v above 30 is recovered with ecrecover over the eth_sign hash
  for:
  - evidence-1
- id: owner-match
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 301
  has: require(currentOwner > lastOwner && owners[currentOwner] != address(0) && currentOwner != SENTINEL_OWNERS,
    "GS026");
  says: the recovered address counts if it is an owner; the Safe never asks that address anything
  for:
  - action
  - evidence-1
  - justification
  - what
- id: approve
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 291
  has: require(msg.sender == currentOwner || approvedHashes[currentOwner][dataHash] != 0, "GS025");
  says: the other way an owner approves is a transaction from its own account (sender or approveHash)
  for:
  - evidence-1
- id: contract-sig
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 285
  has: require(ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE,
    "GS024");
  says: an owner contract is asked through isValidSignature(bytes,bytes) with the full signature
  for:
  - action
  - evidence-3
- id: magic
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/interfaces/ISignatureValidator.sol
  line: 6
  has: bytes4 internal constant EIP1271_MAGIC_VALUE = 0x20c13b0b;
  says: the answer it expects is the legacy magic value 0x20c13b0b
  for:
  - action
  - evidence-3
- id: sel-legacy
  selector: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  fn: isValidSignature(bytes,bytes)
  says: the singleton's code holds the legacy selector 0x20c13b0b
  for:
  - action
- id: sel-final
  selector: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: the final ERC-1271 selector 0x1626ba7e is absent from the singleton
  for:
  - action
- id: no-master-copy
  selector: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  fn: changeMasterCopy(address)
  absent: true
  says: Safe 1.3.0 has no changeMasterCopy; the singleton changes only through an approved delegatecall
  for:
  - notes
- id: swap
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/base/OwnerManager.sol
  lines:
  - 106
  - 108
  has: owners[prevOwner] = newOwner;
  says: swapOwner puts a new owner in place of an old one
  for:
  - action
  - evidence-3
  - justification
- id: swap-auth
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/base/OwnerManager.sol
  lines:
  - 94
  - 98
  has: ) public authorized {
  says: swapOwner is restricted by the authorized modifier
  for:
  - action
  - evidence-3
  - justification
- id: self
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/common/SelfAuthorized.sol
  line: 8
  has: require(msg.sender == address(this), "GS031");
  says: authorized means only the Safe itself, through an approved execTransaction
  for:
  - action
  - evidence-3
  - justification
- id: fallback-call
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/base/FallbackManager.sol
  line: 45
  has: let success := call(gas(), handler, 0, 0, add(calldatasize(), 20), 0, 0)
  says: the fallback handler is reached by a CALL with no value; it cannot spend the Safe's balance itself
  for:
  - notes
- id: recent-tx
  tx: '0xb72d7e552603278869e23163da4f7016d825f43e4134b2784d91c6462deec3f1'
  to: '0x705199fe234a7a2f1bc8b95dd7d08284c8f467f1'
  ok: true
  says: 'an execTransaction on this Safe succeeded at block 26,409,949: the Safe is in use'
  for:
  - notes
- id: seat
  call: '0xcde525bd723090284ee2f958c729d83cf117aff9'
  fn: isOwner(address)(bool)
  args:
  - '0x705199fe234a7a2f1bc8b95dd7d08284c8f467f1'
  is: true
  says: this Safe is one of the owners of Safe 0xcde525bd
  for:
  - notes
- id: seat-threshold
  call: '0xcde525bd723090284ee2f958c729d83cf117aff9'
  fn: getThreshold()(uint256)
  is: 3
  says: Safe 0xcde525bd needs three owner approvals
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
reviews: []
related: [gnosissafe-cde525bd-owner-ecdsa-keys]
---

## What happens

This Safe runs any transaction that 3 of its 10 owners approve, and all 10 owners are plain ECDSA keys. Nine of them have sent transactions, so their public keys are on-chain. A quantum computer could derive three of those keys and sign away the roughly 2,500 ETH and the tokens the Safe holds.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) counts an owner by ecrecover of its signature, or by an approval sent from that owner's own account.
- [This Safe](https://etherscan.io/address/0x705199fe234a7a2f1bc8b95dd7d08284c8f467f1) needs 3 of its 10 owners; none has code, nine have sent transactions, and no module is enabled.
- [swapOwner](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) replaces an owner when the Safe calls itself; an owner contract is asked via isValidSignature(bytes,bytes).

## Reviewer notes

### Mechanism

The proxy delegates to the Safe 1.3.0 singleton (slot 0; VERSION 1.3.0). execTransaction hashes the transaction with the nonce, calls checkSignatures, which requires the stored threshold (3) of approvals in checkNSignatures, then executes any call or delegatecall with any value. checkNSignatures reads one 65-byte slot per approval: v 0 asks the owner contract isValidSignature(bytes,bytes) for the legacy magic 0x20c13b0b with the full signature; v 1 accepts an owner that is the sender or called approveHash; v above 30 recovers the eth_sign hash; otherwise ecrecover over the hash. The recovered or named address must be an owner, in ascending order; a recovered address is never asked anything. All 10 owners are EOAs without code or delegation; 9 have sent transactions. Owners change only by swapOwner, addOwnerWithThreshold, removeOwner and changeThreshold, all authorized by a self-call that needs the same 3 approvals. No module and no guard are set. This Safe also holds one of the owner seats of Safe 0xcde525bd (threshold 3), so three derived keys here also give one approval there.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: erc1271: the contract-signature path exists, but no owner has code or a delegation, and the submitter picks v, so an EOA owner that later gets code in place is still counted by ecrecover.
- Ruled out: unused-implementation: this is a proxy in use (Safe nonce 212; execTransaction 0xb72d7e55... to it succeeded at block 26,409,949), not the singleton.
- Ruled out: key-state: all 10 owners are set, have no code and no EIP-7702 delegation; 9 have sent transactions (nonces 1 to 1,777); 0xd367f832 has nonce 0.
- Ruled out: setter/path-closed: swapOwner is authorized by self-call, reachable through execTransaction with 3 approvals; threshold is 3, not 0. Safe 1.3.0 has no changeMasterCopy; the singleton changes only by an approved delegatecall.
- Ruled out: direct-path: an owner can also approve by sending the transaction or by approveHash, but that does not close the ECDSA slot, which a submitter can use for any EOA owner.
- Ruled out: other ways to move funds: no module enabled, no guard; the fallback handler (0xf48f2b2d...) is reached by a CALL with no value and cannot spend the Safe's balance itself.
- Ruled out: value-whose: the header figure is what this address alone held at the block (2,500 ETH plus priced tokens); whose money it is (team treasury or customer funds) is not shown by any read, so whose is left empty.
- Ruled out: EIP-8151: the family's replays that fail under EIP-8151 alone (0x16a1d468... to 0x237dee52..., 0x5b42f691... to 0x61a2c600...) are other Safes' transactions; 0xd34b6a89... goes to 0x40a2accb.... Nothing here is cited from them.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
