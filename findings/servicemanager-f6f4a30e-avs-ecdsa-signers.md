---
id: servicemanager-f6f4a30e-avs-ecdsa-signers
format: 2
title: Predicate ServiceManager trusts ECDSA attester keys a quantum attacker can forge
status: confirmed
severity: LOW
justification: Forged attestations bypass compliance gates but move only callers' own funds; owner Safe can upgrade
  to PQ signatures.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xf6f4a30eef7cf51ed4ee1415fb3bfdaf3694b0d2'
  name: ServiceManager
  project: predicate
  code: verified
  code_url: https://etherscan.io/address/0x7fc138988d13ded38fa22abc4e15e855c92b092e#code
  proxy_of: '0x7fc138988d13ded38fa22abc4e15e855c92b092e'
  copies: 1
  upgradeable: 'yes'
  admin: '0x7153803c06d6a36d6d91aeb3c1ed8e5b934df601'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1172
impact: liveness
action: Upgrade the ServiceManager to verify post-quantum operator signatures and raise policy thresholds above
  one.
evidence_level: source
checks:
- id: c1
  source: '0x7fc138988d13ded38fa22abc4e15e855c92b092e'
  file: src/ServiceManager.sol
  line: 360
  has: address recoveredSigner = ECDSA.recover(messageHash, signatures[i]);
  says: validateSignatures recovers the signer with ECDSA.recover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x7fc138988d13ded38fa22abc4e15e855c92b092e'
  file: lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 148
  has: address signer = ecrecover(hash, v, r, s);
  says: ECDSA library uses the ecrecover precompile.
  for:
  - evidence-1
  - what
- id: c3
  source: '0x7fc138988d13ded38fa22abc4e15e855c92b092e'
  file: src/ServiceManager.sol
  line: 136
  has: function rotatePredicateSigningKey(address _oldSigningKey, address _newSigningKey) external {
  says: Operators rotate to another ECDSA signing address.
  for:
  - evidence-3
- id: c4
  source: '0x7fc138988d13ded38fa22abc4e15e855c92b092e'
  file: lib/openzeppelin-contracts-upgradeable/contracts/access/Ownable2StepUpgradeable.sol
  line: 62
  has: function transferOwnership(address newOwner) public virtual override onlyOwner {
  says: Contract has an owner able to administer it.
  for:
  - justification
- id: s-thr
  source: '0x7fc138988d13ded38fa22abc4e15e855c92b092e'
  file: src/ServiceManager.sol
  has: uint256 numSignaturesRequired = policyIdToThreshold[_task.policyID];
  line: 349
  says: Required signature count comes from the policy threshold.
  for:
  - action
  - evidence-2
  - what
- id: s-reg
  source: '0x7fc138988d13ded38fa22abc4e15e855c92b092e'
  file: src/ServiceManager.sol
  has: operators[operator].status == OperatorStatus.REGISTERED
  line: 364
  says: Recovered signer's operator must be registered.
  for:
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
reviews: []
related: []
---

## What happens

The ServiceManager approves compliance tasks for client contracts when registered operators' ECDSA signatures recover to their signing keys. A quantum attacker who recovers an operator key can sign any task and pass the policy check.

## Evidence

- [validateSignatures](https://etherscan.io/address/0x7fc138988d13ded38fa22abc4e15e855c92b092e#code) recovers each signer with ECDSA.recover over the task hash.
- [validateSignatures](https://etherscan.io/address/0x7fc138988d13ded38fa22abc4e15e855c92b092e#code) requires as many signatures as the policy threshold.
- [rotatePredicateSigningKey](https://etherscan.io/address/0x7fc138988d13ded38fa22abc4e15e855c92b092e#code) swaps one ECDSA signing address for another.

## Reviewer notes

### Mechanism

Clients call validateSignatures(task, signerAddresses, signatures). Lines 341-353 require a nonzero threshold, an unexpired unspent task and quorumThresholdCount equal to policyIdToThreshold[policyID]. Lines 355-366 hash the task with hashTaskSafe, then for each required signature ECDSA.recover (OpenZeppelin tryRecover, ecrecover at line 148) must equal the sorted signerAddresses[i], whose operator in signingKeyToOperator must be REGISTERED. Line 383 marks the task spent. Kev found both live policies use threshold 1 with a single attester key, so one recovered key approves any task. rotatePredicateSigningKey (line 136) rotates only to another ECDSA address.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Gated client calls spend the caller's own assets; no pooled funds can be taken through a forged attestation.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
