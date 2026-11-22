---
id: safe-81ad394c-owner-ecdsa-keys
format: 2
title: Safe multisig 6-of-11 lets quantum-recovered owner keys move its holdings
status: confirmed
severity: MEDIUM
justification: EOA owners approve with ECDSA; owners can swap them for post-quantum signer contracts, so medium.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x81ad394c0fa87e99ca46e1aca093bee020f203f4'
  name: Safe
  project: safe
  code: verified
  code_url: https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code
  proxy_of: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  copies: 1
value:
  usd: 756450
  basis: held
activity:
  txs_90d: 18
impact: funds-loss
action: Swap EOA owners for post-quantum signer contracts via swapOwner, keeping the threshold.
evidence_level: source
checks:
- id: c1
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 325
  has: currentOwner = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", dataHash)), v - 4,
    r, s);
  says: eth_sign-style signatures are verified with ecrecover.
  for:
  - evidence-2
  - what
- id: c2
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 329
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: Standard owner signatures are verified with ecrecover over the data hash.
  for:
  - evidence-1
  - justification
  - what
- id: c3
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  has: ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE
  line: 315
  says: Contract owners are verified through EIP-1271 isValidSignature.
  for:
  - action
  - evidence-3
  - justification
- id: c4
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  has: owners[currentOwner] != address(0)
  line: 331
  says: Each recovered signer must be a current owner.
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
reviews: []
related: []
---

## What happens

This Safe executes transactions once threshold-many owners approve, and an EOA owner approves with an ECDSA signature checked by ecrecover. A quantum attacker who recovers enough owner keys can forge those approvals and move the Safe's assets.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) recovers each EOA owner with ecrecover over the transaction hash.
- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) also accepts eth_sign-style ECDSA signatures.
- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) verifies contract owners through isValidSignature.

## Reviewer notes

### Mechanism

execTransaction calls checkNSignatures, which walks threshold-many 65-byte slots. v==0 checks a contract owner via ISignatureValidator.isValidSignature (line 315); v==1 accepts approveHash or msg.sender (line 321); v>30 runs ecrecover on the eth_sign hash (line 325); otherwise ecrecover(dataHash, v, r, s) (line 329). Line 331 requires each recovered address to be an owner in ascending order. EOA owners are satisfied only via ecrecover or their own transactions, so recovering threshold-many keys allows arbitrary execution, including owner changes.

### Checks

- Header facts: this address alone, at block 26,438,999.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
