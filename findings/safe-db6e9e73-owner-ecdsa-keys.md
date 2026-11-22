---
id: safe-db6e9e73-owner-ecdsa-keys
format: 2
title: Safe multisig accepts ECDSA owner signatures that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Threshold ECDSA owner keys move all funds; MEDIUM as owners can swap EOAs for post-quantum signer
  contracts today.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xdb6e9e7390e9acc34619e56efa48ade01cff6f12'
  name: Safe
  project: safe
  code: verified
  code_url: https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code
  proxy_of: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  copies: 1
value:
  usd: 1045220
  basis: held
activity:
  txs_90d: 12
impact: funds-loss
action: Replace EOA owners with post-quantum signer contracts via swapOwner, approved by the current threshold.
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
  says: Default signatures are verified with ecrecover on the data hash.
  for:
  - evidence-1
  - justification
  - what
- id: v0
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  has: ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE
  line: 315
  says: Contract owners are verified through their own isValidSignature.
  for:
  - action
  - evidence-3
  - justification
- id: own
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

This Safe executes a transaction once threshold-many owners approve, and EOA owners approve with ECDSA signatures. A quantum attacker who recovers threshold-many owner keys can move the Safe's funds or change its owners.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) uses ecrecover on the data hash to name the owner for a default signature.
- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) also accepts eth_sign-style ECDSA signatures when v exceeds 30.
- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) checks contract owners via isValidSignature, so a post-quantum signer contract can be an owner.

## Reviewer notes

### Mechanism

Safe.checkNSignatures (lines 286-333) walks threshold-many signature slots. v == 0: the owner is a contract named in r and is checked with isValidSignature on the full signature (line 315). v == 1: approved hash or msg.sender is the owner (line 321). v > 30: ecrecover of the eth_sign-prefixed hash (line 325). Otherwise: ecrecover(dataHash, v, r, s) (line 329). Line 331 requires each recovered address to be an owner, in ascending order. An EOA owner is satisfied through ecrecover, so a recovered secp256k1 key (the public key follows from any posted signature) lets an attacker sign. With threshold-many keys, execTransaction can transfer funds or call swapOwner/changeThreshold on the Safe itself. Replacing EOA owners with contract owners that verify post-quantum signatures in isValidSignature removes the ECDSA path for those seats.

### Checks

- Header facts: this address alone, at block 26,438,999.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
