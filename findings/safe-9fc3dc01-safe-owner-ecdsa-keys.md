---
id: safe-9fc3dc01-safe-owner-ecdsa-keys
format: 2
title: Safe multisig whose five owners are ECDSA keys a quantum computer could forge
status: confirmed
severity: MEDIUM
justification: Three forged owner keys move all funds; the owners can fix it by swapping each key for a post-quantum
  signer.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x9fc3dc011b461664c835f2527fffb1169b3c213e'
  name: Safe
  code: verified
  code_url: https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code
  proxy_of: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  copies: 1
value:
  usd: 67343058
  basis: held
activity: {}
impact: funds-loss
action: Swap each ECDSA owner for a post-quantum signer contract that answers the legacy isValidSignature(bytes,bytes).
evidence_level: source
checks:
- id: version
  call: '0x9fc3dc011b461664c835f2527fffb1169b3c213e'
  fn: VERSION()(string)
  is: 1.4.1
  says: the Safe runs version 1.4.1
  for:
  - what
- id: threshold
  call: '0x9fc3dc011b461664c835f2527fffb1169b3c213e'
  fn: getThreshold()(uint256)
  is: 3
  says: three owner approvals are needed
  for:
  - evidence-2
  - justification
  - what
- id: owners
  call: '0x9fc3dc011b461664c835f2527fffb1169b3c213e'
  fn: getOwners()(address[])
  is:
  - '0x5ed8cee6b63b1c6afce3ad7c92f4fd7e1b8fad9f'
  - '0x379be87394421b6a18b19ba47cd98cc8d26b1f7a'
  - '0x24bbc568dc89e4e57baf23b759989f3d6113bbaa'
  - '0x26c3f6fd4f53a03ec8e54aca0c356112ca3ddec8'
  - '0xd779332c5a52566dada11a075a735b18daa6c1f4'
  says: the Safe has these five owners
  for:
  - evidence-2
  - what
- id: safe-nonce
  call: '0x9fc3dc011b461664c835f2527fffb1169b3c213e'
  fn: nonce()(uint256)
  is: 62
  says: the Safe has executed 62 transactions
  for:
  - notes
- id: singleton
  storage: '0x9fc3dc011b461664c835f2527fffb1169b3c213e'
  slot: '0x0'
  is: '0x00000000000000000000000041675c099f32341bf84bfc5382af534df5c7461a'
  says: the proxy runs singleton 0x41675c09
  for:
  - notes
- id: modules
  storage: '0x9fc3dc011b461664c835f2527fffb1169b3c213e'
  slot: '0xcc69885fda6bcc1a4ace058b4a62bf5e179ea78fd58a1ccd71c22cc9b688792f'
  is: 1
  says: 'modules[SENTINEL] points back to SENTINEL: no module is enabled'
  for:
  - evidence-2
- id: guard
  storage: '0x9fc3dc011b461664c835f2527fffb1169b3c213e'
  slot: '0x4a204f620c8c5ccdca3fd54d003badd85ba500436a431f0cbda4f558c93c34c8'
  is: 0
  says: no transaction guard is set
  for:
  - evidence-2
- id: owner1-code
  code: '0x5ed8cee6b63b1c6afce3ad7c92f4fd7e1b8fad9f'
  is: empty
  says: owner 0x5ed8 has no code
  for:
  - evidence-2
  - what
- id: owner2-code
  code: '0x379be87394421b6a18b19ba47cd98cc8d26b1f7a'
  is: empty
  says: owner 0x379b has no code
  for:
  - evidence-2
  - what
- id: owner3-code
  code: '0x24bbc568dc89e4e57baf23b759989f3d6113bbaa'
  is: empty
  says: owner 0x24bb has no code
  for:
  - evidence-2
  - what
- id: owner4-code
  code: '0x26c3f6fd4f53a03ec8e54aca0c356112ca3ddec8'
  is: empty
  says: owner 0x26c3 has no code
  for:
  - evidence-2
  - what
- id: owner5-code
  code: '0xd779332c5a52566dada11a075a735b18daa6c1f4'
  is: empty
  says: owner 0xd779 has no code
  for:
  - evidence-2
  - what
- id: owner1-nonce
  nonce: '0x5ed8cee6b63b1c6afce3ad7c92f4fd7e1b8fad9f'
  min: 1
  says: owner 0x5ed8 has sent transactions, so its public key is on-chain
  for:
  - what
- id: owner2-nonce
  nonce: '0x379be87394421b6a18b19ba47cd98cc8d26b1f7a'
  min: 1
  says: owner 0x379b has sent transactions, so its public key is on-chain
  for:
  - what
- id: owner3-nonce
  nonce: '0x24bbc568dc89e4e57baf23b759989f3d6113bbaa'
  min: 1
  says: owner 0x24bb has sent transactions, so its public key is on-chain
  for:
  - what
- id: owner4-nonce
  nonce: '0x26c3f6fd4f53a03ec8e54aca0c356112ca3ddec8'
  min: 1
  says: owner 0x26c3 has sent transactions, so its public key is on-chain
  for:
  - what
- id: owner5-nonce
  nonce: '0xd779332c5a52566dada11a075a735b18daa6c1f4'
  min: 1
  says: owner 0xd779 has sent transactions, so its public key is on-chain
  for:
  - what
- id: exec-check
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 172
  has: checkSignatures(txHash, txHashData, signatures);
  says: execTransaction checks the owners' signatures
  for:
  - justification
  - what
- id: threshold-rule
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 262
  has: checkNSignatures(dataHash, data, signatures, _threshold);
  says: threshold-many owner signatures are required
  for:
  - justification
  - what
- id: exec-call
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 203
  has: success = execute(to, value, data, operation,
  says: after the check the Safe executes any call or delegatecall
  for:
  - what
- id: ecdsa
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 329
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: a plain signature is recovered with ecrecover
  for:
  - evidence-1
  - justification
  - what
- id: ethsign
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 325
  has: currentOwner = ecrecover(keccak256(abi.encodePacked(
  says: an eth_sign signature is also recovered with ecrecover
  for:
  - evidence-1
  - what
- id: owner-match
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 331
  has: owners[currentOwner] != address(0)
  says: the recovered address counts if it is a stored owner
  for:
  - evidence-1
  - what
- id: legacy-1271
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 315
  has: ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE
  says: a contract owner is asked through isValidSignature
  for:
  - action
- id: legacy-magic
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/interfaces/ISignatureValidator.sol
  line: 6
  has: bytes4 internal constant EIP1271_MAGIC_VALUE = 0x20c13b0b;
  says: the interface asked is the legacy isValidSignature(bytes,bytes)
  for:
  - action
- id: no-final-1271
  bytecode: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  has: 1626ba7e
  absent: true
  says: the final ERC-1271 selector is not in the singleton
  for:
  - action
- id: swap
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/base/OwnerManager.sol
  lines:
  - 99
  - 112
  has: function swapOwner(address prevOwner, address oldOwner, address newOwner) public authorized {
  says: swapOwner replaces one owner with a new address, a contract included
  for:
  - action
  - justification
- id: self-only
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/common/SelfAuthorized.sol
  line: 10
  has: require(msg.sender == address(this), "GS031");
  says: owner changes run only as a Safe transaction approved by the threshold
  for:
  - action
  - justification
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
- who: r-9fc3dc01, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Kev''s first-study finding, MEDIUM (PQ-12): a 3-of-5 Safe 1.4.1 ($80.6M: 20,176 ETH and 22.93M USDC)
    whose five owners are plain ECDSA keys, all exposed; no module or guard; fix: swapOwner to post-quantum signer
    contracts answering the legacy isValidSignature(bytes,bytes). Two refuters agree; Claude read the sheet.'
related: []
---

## What happens

This Safe multisig (version 1.4.1) runs any transaction that 3 of its 5 owners approve. All five owners are plain accounts that have sent transactions and approve with ECDSA keys; a quantum attacker who recovers three of those keys can move everything.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) recovers each owner with ecrecover and accepts the signature if the address is an owner.
- [The Safe](https://etherscan.io/address/0x9fc3dc011b461664c835f2527fffb1169b3c213e) needs 3 of 5 owners, all without code, and has no module and no guard.

## Reviewer notes

### Mechanism

SafeProxy 0x9fc3…213e delegates to singleton 0x41675c09 (slot 0), Safe 1.4.1. execTransaction (line 172) calls checkSignatures, which calls checkNSignatures with the stored threshold (line 262). checkNSignatures (lines 274-334) reads threshold-many 65-byte signatures: v==0 asks the contract owner encoded in r through legacy isValidSignature(bytes,bytes), magic 0x20c13b0b (line 315); v==1 accepts an owner that is msg.sender or that called approveHash (line 321); v>30 recovers with ecrecover over the eth_sign-prefixed hash (line 325); otherwise ecrecover over the hash (line 329). The recovered address must be a stored owner, in ascending order (line 331). Then execute runs the call, a delegatecall included (line 203). At block 26,438,999 the threshold is 3, the five owners are EOAs with no code and nonces 3 to 927 (so each public key is on-chain), modules[SENTINEL] is SENTINEL (no module) and the guard slot is empty. swapOwner, addOwnerWithThreshold and changeThreshold are authorized (self-call only, SelfAuthorized line 10), so the owners can replace each ECDSA owner with a post-quantum signer contract by one threshold transaction each. Such a contract must answer the legacy isValidSignature(bytes,bytes): the final ERC-1271 selector 0x1626ba7e is absent from the singleton. An owner that upgrades its own account in place stays forgeable: the Safe recovers its address and never asks it.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: unused implementation: the address is a SafeProxy with five owners set and a Safe nonce of 62 (nonce() at the block), so it is in use.
- Ruled out: erc1271: the Safe asks a contract owner only when the signature says so (v==0); an EOA owner's ECDSA signature is accepted with no account check (lines 323-332).
- Ruled out: key-state: all five owners have no code and nonces of 3 or more at the block, so their public keys are on-chain.
- Ruled out: direct path: approveHash or a call from the owner itself also needs the owner's ECDSA-signed transaction while the owner is an EOA.
- Ruled out: modules or guard that add a check: modules[SENTINEL] is SENTINEL and the guard slot is zero.
- Ruled out: EIP-8151 angle (second study): an owner moving to real code loses only its off-chain signature and can still approve on-chain (approveHash, line 342); that is a separate migration notice. The family's one replay (tx 0x09827fd9…1328, signer 0x033ac280…dcdd) is not by an owner of this Safe.
- Ruled out: copies: the dossier lists none for this proxy; other Safes on the same singleton are their own rows.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
