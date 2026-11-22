---
id: safe-f95334a8-owner-ecdsa-keys
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
  address: '0xf95334a86d09a6eec74d69da344efaca424b13a9'
  name: Safe
  code: verified
  code_url: https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code
  proxy_of: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  copies: 1
value:
  usd: 67996039
  basis: held
activity: {}
impact: funds-loss
action: Swap owner keys with swapOwner for post-quantum signer contracts answering the legacy isValidSignature(bytes,bytes).
evidence_level: source
checks:
- id: singleton
  storage: '0xf95334a86d09a6eec74d69da344efaca424b13a9'
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
- id: threshold
  call: '0xf95334a86d09a6eec74d69da344efaca424b13a9'
  fn: getThreshold()(uint256)
  is: 4
  says: four owner signatures are needed
  for:
  - evidence-2
  - justification
  - what
- id: owners
  call: '0xf95334a86d09a6eec74d69da344efaca424b13a9'
  fn: getOwners()(address[])
  is:
  - '0xc9180ff81675b86a73a02e61233e6145658f4488'
  - '0x7fd82ad94cf5d9d947beb7ce3328300aa34acb3c'
  - '0x84fd60540cab330011812cb5e342a6db45095fa1'
  - '0x859003b39a165bb775b04657826c397ad84fe208'
  - '0xec224d0dc9d80c1f6d5a486efe2667f040834130'
  - '0x42c979dbbd691fda334807fd4c3ffe67ea3df9aa'
  - '0x27619cacedcd18a08a1cdcb206a6f14196210fce'
  says: the Safe has seven owners
  for:
  - evidence-2
  - what
- id: balance
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0xf95334a86d09a6eec74d69da344efaca424b13a9'
  is: 10000000001000000000000
  says: the Safe holds 10,000 ETH
  for:
  - what
- id: usdt
  call: '0xdac17f958d2ee523a2206206994597c13d831ec7'
  fn: balanceOf(address)(uint256)
  args:
  - '0xf95334a86d09a6eec74d69da344efaca424b13a9'
  is: 50000004010000
  says: the Safe holds about 50,000,004 USDT
  for:
  - what
- id: eoa-1
  code: '0xc9180ff81675b86a73a02e61233e6145658f4488'
  is: empty
  says: this owner is a plain key with no code
  for:
  - what
- id: eoa-2
  code: '0x7fd82ad94cf5d9d947beb7ce3328300aa34acb3c'
  is: empty
  says: this owner is a plain key with no code
  for:
  - what
- id: eoa-3
  code: '0x84fd60540cab330011812cb5e342a6db45095fa1'
  is: empty
  says: this owner is a plain key with no code
  for:
  - what
- id: eoa-4
  code: '0x859003b39a165bb775b04657826c397ad84fe208'
  is: empty
  says: this owner is a plain key with no code
  for:
  - what
- id: eoa-5
  code: '0xec224d0dc9d80c1f6d5a486efe2667f040834130'
  is: empty
  says: this owner is a plain key with no code
  for:
  - what
- id: eoa-6
  code: '0x42c979dbbd691fda334807fd4c3ffe67ea3df9aa'
  is: empty
  says: this owner is a plain key with no code
  for:
  - what
- id: eoa-7
  code: '0x27619cacedcd18a08a1cdcb206a6f14196210fce'
  is: empty
  says: this owner is a plain key with no code
  for:
  - what
- id: sent-1
  nonce: '0xc9180ff81675b86a73a02e61233e6145658f4488'
  min: 54
  says: this owner has sent transactions, so its public key is on-chain
  for:
  - evidence-2
  - what
- id: sent-2
  nonce: '0x7fd82ad94cf5d9d947beb7ce3328300aa34acb3c'
  min: 55
  says: this owner has sent transactions, so its public key is on-chain
  for:
  - evidence-2
  - what
- id: sent-3
  nonce: '0x84fd60540cab330011812cb5e342a6db45095fa1'
  min: 19
  says: this owner has sent transactions, so its public key is on-chain
  for:
  - evidence-2
  - what
- id: sent-4
  nonce: '0x27619cacedcd18a08a1cdcb206a6f14196210fce'
  min: 5
  says: this owner has sent transactions, so its public key is on-chain
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

This Safe, a 4-of-7 multisig holding about 10,000 ETH and 50 million USDT, executes any transaction that four of its owners sign. All seven owners are plain keys that sign with ECDSA. A quantum attacker who recovers four owner keys can move everything it holds.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) accepts an owner's ECDSA signature and never asks the owner's account.
- [The Safe](https://etherscan.io/address/0xf95334a86d09a6eec74d69da344efaca424b13a9) needs 4 of its 7 owners; four owners have sent transactions, so their public keys are on-chain.

## Reviewer notes

### Mechanism

The SafeProxy delegates to the Safe 1.4.1 singleton (slot 0). execTransaction hashes the Safe transaction, increments the nonce and calls checkSignatures, which needs threshold (4) signatures in checkNSignatures. For v = 27/28 (and v > 30, eth_sign) the signer is ecrecover's result; it only has to be in the owners list and in ascending order (line 331). v = 0 asks a contract owner through the legacy isValidSignature(bytes,bytes) (magic 0x20c13b0b; 0x1626ba7e is absent from the singleton); v = 1 accepts an approved hash or msg.sender == owner, both from the owner's own key. Nothing asks an EOA owner's account, so an owner that moves its account to post-quantum authorisation at the same address stays forgeable here. All seven owners have no code at the block; four have nonce >= 1 (54, 55, 19, 5), equal to the threshold. The fix is swapOwner (authorized: a self-call through execTransaction) to contract owners that check a post-quantum signature; changeMasterCopy alone leaves the ECDSA owners in place.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: erc1271: the Safe has a contract-owner path (v = 0), but none of the seven owners has code at the block, so all sign with ECDSA.
- Ruled out: key-state: all seven owners are EOAs with empty code; four have sent transactions (nonces 54, 55, 19, 5), enough for the threshold of 4 even ignoring signatures posted in Safe calldata; the other three (nonce 0) are presumed live.
- Ruled out: direct-path: no module is enabled (getModulesPaginated from the sentinel returns an empty list) and no guard is set (guard slot 0x4a20...34c8 is zero).
- Ruled out: unused-implementation / wrong-code: the address is an initialized proxy (threshold 4, seven owners, nonce 5) whose slot 0 holds the 1.4.1 singleton whose source is read here.
- Ruled out: EIP-8151: if an owner's address took real code its ECDSA signature would stop counting (an EIP-7702 delegation still recovers); the quantum-exposure rubric does not assume that change.
- Ruled out: replay 0x09827fd946d676f0c1ed2123efc82c8a9e8ee00cfbee153ea8160453e8391328 (family replays, signer 0x033ac28073bccc6c1486c99d00d683f2f265dcdd, multiSend root) fails under EIP-8151 alone; its signer is not an owner of this Safe, it belongs to another Safe of the same code, and is not cited.
- Ruled out: whose: the Safe's ETH and USDT could be the owners' own or held for others; nothing on chain shows which, so whose is left empty.
- Ruled out: project: the old row named 'safe', but the Safe team does not hold these keys and nothing shows who runs this multisig, so no project is set.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
