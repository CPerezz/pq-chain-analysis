---
id: safe-d67f25ef-safe-owner-keys
format: 2
title: Safe wallet owners are ECDSA keys that a quantum computer could forge
status: confirmed
severity: MEDIUM
justification: Funds can be taken with four forged owner keys; the fix needs four of the seven owners to swap the
  keys.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd67f25ef2399a0c769b1a35634c5ce77166714db'
  name: Safe
  code: verified
  code_url: https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code
  proxy_of: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  copies: 1
value:
  usd: 87976218
  basis: held
activity: {}
impact: funds-loss
action: Swap each owner key for a post-quantum signer contract that answers isValidSignature(bytes,bytes), with
  swapOwner signed by four owners.
evidence_level: source
checks:
- id: singleton
  storage: '0xd67f25ef2399a0c769b1a35634c5ce77166714db'
  slot: '0x0'
  is: '0x00000000000000000000000041675c099f32341bf84bfc5382af534df5c7461a'
  says: the proxy's slot 0 holds the Safe singleton whose code it runs
  for:
  - notes
- id: version
  call: '0xd67f25ef2399a0c769b1a35634c5ce77166714db'
  fn: VERSION()(string)
  args: []
  is: 1.4.1
  says: the Safe runs version 1.4.1
  for:
  - notes
- id: threshold
  call: '0xd67f25ef2399a0c769b1a35634c5ce77166714db'
  fn: getThreshold()(uint256)
  args: []
  is: 4
  says: four owner approvals are required
  for:
  - action
  - evidence-2
  - justification
  - what
- id: owners
  call: '0xd67f25ef2399a0c769b1a35634c5ce77166714db'
  fn: getOwners()(address[])
  args: []
  is:
  - '0xc9180ff81675b86a73a02e61233e6145658f4488'
  - '0x7fd82ad94cf5d9d947beb7ce3328300aa34acb3c'
  - '0x84fd60540cab330011812cb5e342a6db45095fa1'
  - '0x859003b39a165bb775b04657826c397ad84fe208'
  - '0xec224d0dc9d80c1f6d5a486efe2667f040834130'
  - '0x42c979dbbd691fda334807fd4c3ffe67ea3df9aa'
  - '0x27619cacedcd18a08a1cdcb206a6f14196210fce'
  says: the Safe has these seven owners
  for:
  - evidence-2
  - justification
  - what
- id: used
  call: '0xd67f25ef2399a0c769b1a35634c5ce77166714db'
  fn: nonce()(uint256)
  args: []
  is: 6
  says: the Safe has executed six transactions, so it is set up and in use
  for:
  - notes
- id: no-modules
  call: '0xd67f25ef2399a0c769b1a35634c5ce77166714db'
  fn: getModulesPaginated(address,uint256)(address[],address)
  args:
  - '0x0000000000000000000000000000000000000001'
  - 10
  is:
  - []
  - '0x0000000000000000000000000000000000000001'
  says: no module is enabled, so nothing moves funds without owner approvals
  for:
  - notes
- id: eth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0xd67f25ef2399a0c769b1a35634c5ce77166714db'
  is: 10000000002010000000000
  says: the Safe holds about 10,000 ETH
  for:
  - notes
- id: exec
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 172
  has: checkSignatures(txHash, txHashData, signatures);
  says: execTransaction runs a transaction only after checkSignatures passes
  for:
  - justification
  - what
- id: needs-threshold
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  lines:
  - 259
  - 262
  has: checkNSignatures(dataHash, data, signatures, _threshold);
  says: checkSignatures requires threshold-many valid owner signatures
  for:
  - what
- id: recover
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 329
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: a plain signature is recovered with ECDSA; the owner's account is not asked
  for:
  - evidence-1
  - justification
  - what
- id: is-owner
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 331
  has: owners[currentOwner] != address(0)
  says: the recovered address counts when it is a stored owner
  for:
  - evidence-1
  - justification
  - what
- id: contract-owner
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 315
  has: ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE
  says: when the signature has v = 0 the owner contract named in it is asked through isValidSignature(bytes,bytes)
  for:
  - action
  - evidence-3
- id: magic
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/interfaces/ISignatureValidator.sol
  line: 6
  has: bytes4 internal constant EIP1271_MAGIC_VALUE = 0x20c13b0b;
  says: the expected answer is the legacy magic value 0x20c13b0b
  for:
  - action
  - evidence-3
- id: legacy-selector
  selector: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  fn: isValidSignature(bytes,bytes)
  says: the singleton's code holds the legacy selector 0x20c13b0b
  for:
  - action
  - evidence-3
- id: no-final-selector
  selector: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: the final ERC-1271 selector 0x1626ba7e is not in the singleton's code
  for:
  - action
  - evidence-3
- id: swap
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/base/OwnerManager.sol
  lines:
  - 99
  - 109
  has: owners[newOwner] = owners[oldOwner];
  says: swapOwner replaces one owner with another address and is marked authorized
  for:
  - action
  - evidence-3
  - justification
- id: swap-auth
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/base/OwnerManager.sol
  line: 99
  has: function swapOwner(address prevOwner, address oldOwner, address newOwner) public authorized {
  says: swapOwner carries the authorized modifier
  for:
  - action
  - evidence-3
  - justification
- id: self-only
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/common/SelfAuthorized.sol
  line: 10
  has: require(msg.sender == address(this), "GS031");
  says: authorized functions accept only a call from the Safe itself, that is a transaction its owners approved
  for:
  - action
  - evidence-3
  - justification
- id: owner1-eoa
  code: '0xc9180ff81675b86a73a02e61233e6145658f4488'
  is: empty
  says: 'owner 1 has no code: it is a plain key'
  for:
  - evidence-2
  - what
- id: owner2-eoa
  code: '0x7fd82ad94cf5d9d947beb7ce3328300aa34acb3c'
  is: empty
  says: 'owner 2 has no code: it is a plain key'
  for:
  - evidence-2
  - what
- id: owner3-eoa
  code: '0x84fd60540cab330011812cb5e342a6db45095fa1'
  is: empty
  says: 'owner 3 has no code: it is a plain key'
  for:
  - evidence-2
  - what
- id: owner4-eoa
  code: '0x859003b39a165bb775b04657826c397ad84fe208'
  is: empty
  says: 'owner 4 has no code: it is a plain key'
  for:
  - evidence-2
  - what
- id: owner5-eoa
  code: '0xec224d0dc9d80c1f6d5a486efe2667f040834130'
  is: empty
  says: 'owner 5 has no code: it is a plain key'
  for:
  - evidence-2
  - what
- id: owner6-eoa
  code: '0x42c979dbbd691fda334807fd4c3ffe67ea3df9aa'
  is: empty
  says: 'owner 6 has no code: it is a plain key'
  for:
  - evidence-2
  - what
- id: owner7-eoa
  code: '0x27619cacedcd18a08a1cdcb206a6f14196210fce'
  is: empty
  says: 'owner 7 has no code: it is a plain key'
  for:
  - evidence-2
  - what
- id: owner1-sent
  nonce: '0xc9180ff81675b86a73a02e61233e6145658f4488'
  min: 1
  says: owner 1 has sent transactions (54), which publishes its public key
  for:
  - evidence-2
- id: owner2-sent
  nonce: '0x7fd82ad94cf5d9d947beb7ce3328300aa34acb3c'
  min: 1
  says: owner 2 has sent transactions (55), which publishes its public key
  for:
  - evidence-2
- id: owner3-sent
  nonce: '0x84fd60540cab330011812cb5e342a6db45095fa1'
  min: 1
  says: owner 3 has sent transactions (19), which publishes its public key
  for:
  - evidence-2
- id: owner7-sent
  nonce: '0x27619cacedcd18a08a1cdcb206a6f14196210fce'
  min: 1
  says: owner 7 has sent transactions (5), which publishes its public key
  for:
  - evidence-2
- id: no-guard
  storage: '0xd67f25ef2399a0c769b1a35634c5ce77166714db'
  slot: '0x4a204f620c8c5ccdca3fd54d003badd85ba500436a431f0cbda4f558c93c34c8'
  is: 0
  says: no transaction guard is set
  for:
  - notes
- id: replay-elsewhere
  tx: '0x09827fd946d676f0c1ed2123efc82c8a9e8ee00cfbee153ea8160453e8391328'
  to: '0x9641d764fc13c8b624c04430c7356c1c7c8102e2'
  ok: true
  says: the family's replayed transaction is sent to another contract, not to this Safe
  for:
  - notes
- id: usdt
  call: '0xdac17f958d2ee523a2206206994597c13d831ec7'
  fn: balanceOf(address)(uint256)
  args:
  - '0xd67f25ef2399a0c769b1a35634c5ce77166714db'
  is: 70000009020800
  says: the Safe holds about 70,000,009 USDT
  for:
  - notes
- id: no-mastercopy-setter
  selector: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  fn: changeMasterCopy(address)
  absent: true
  says: the 1.4.1 singleton has no changeMasterCopy function
  for:
  - notes
- id: delegatecall
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/base/Executor.sol
  line: 31
  has: success := delegatecall(txGas, to, add(data, 0x20), mload(data), 0, 0)
  says: an approved Safe transaction can be a delegatecall, which can write the Safe's own storage
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
- who: r-d67f25ef, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Kev''s first-study finding, MEDIUM (PQ-12): a 4-of-7 Safe whose seven owners are plain ECDSA keys,
    four exposed (enough for the threshold); checkNSignatures never asks the owner''s account; fix: swapOwner to
    post-quantum signer contracts answering the legacy isValidSignature(bytes,bytes). Two refuters agree; Claude
    read the sheet.'
related: []
---

## What happens

This Safe executes any transaction that four of its seven owners approve, and it accepts an ECDSA signature as an approval. All seven owners are plain keys. A quantum computer that forges four of them can move everything the Safe holds.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) recovers an owner's signature with ECDSA and counts it without asking the owner's account.
- The [Safe](https://etherscan.io/address/0xd67f25ef2399a0c769b1a35634c5ce77166714db) needs 4 of 7 owners. None of the seven has code, and four have sent transactions, which makes their public keys public.
- An owner that is a contract is asked through the legacy [isValidSignature(bytes,bytes)](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code), and swapOwner lets the owners install one.

## Reviewer notes

### Mechanism

SafeProxy delegates to the Safe 1.4.1 singleton in slot 0. execTransaction (Safe.sol line 172) calls checkSignatures, which requires threshold-many (4) signatures in checkNSignatures (lines 274-334). Per signature: v = 0 asks the owner contract through isValidSignature(bytes,bytes) and expects 0x20c13b0b (line 315); v = 1 accepts an approved hash or the caller itself (line 321); otherwise ecrecover (lines 325, 329). Line 331 requires the result to be a stored owner. Whoever submits chooses v, so an ECDSA signature for an owner address is accepted whatever code that address holds: an owner that upgrades its own account in place stays forgeable. The v = 1 path also rests on the owner's key, since an EOA owner sends that transaction with it. All 7 owners have empty code; 4 of them (nonces 54, 55, 19, 5) have sent transactions, so their public keys are known; the other 3 have nonce 0 and their keys become public once they sign a Safe transaction. Fix inside the wallet: swapOwner (OwnerManager.sol lines 99-112, authorized = call from the Safe itself) to contract signers that answer the legacy interface; the final ERC-1271 selector 0x1626ba7e is absent from the singleton. Rated MEDIUM: fixable without a protocol change, by several parties (4 of 7 owners) acting. No module and no guard is set. Safe 1.4.1 has no changeMasterCopy; a delegatecall transaction approved by 4 owners could still rewrite slot 0, so upgradeable is left as the tool read it.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: owners that are already contracts: all seven owner addresses have empty code at the block.
- Ruled out: an unused address: nonce() is 6, threshold 4, seven owners set, and it holds about 10,000 ETH plus USDT.
- Ruled out: a module that moves funds without owner signatures: getModulesPaginated returns none; the guard slot is 0.
- Ruled out: the contract-signature branch as protection: it runs only when the submitter sets v = 0; with v = 27 or 28 the Safe recovers the owner address and never calls it.
- Ruled out: the family replay 0x09827fd9... (fails under EIP-8151 alone): not cited; it is sent to 0x9641d764..., its calldata does not contain this Safe's address, and its signer 0x033ac280... is not an owner here, so it belongs to another address running this code.
- Ruled out: final ERC-1271 for contract owners: selector 0x1626ba7e is absent from the singleton; 1.4.1 asks the legacy isValidSignature(bytes,bytes) like 1.3.0.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
