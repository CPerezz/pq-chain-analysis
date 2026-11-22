---
id: safe-2a7bc142-owner-ecdsa-keys
format: 2
title: Safe multisig lets a quantum attacker with owner ECDSA keys move its assets
status: confirmed
severity: MEDIUM
justification: Owners approve via ECDSA; MEDIUM since owners can swap EOAs for post-quantum signer contracts in
  place.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2a7bc14200aafde5b8541683f7131c8117079b59'
  name: Safe
  project: safe
  code: verified
  code_url: https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code
  proxy_of: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  copies: 1
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Replace EOA owners with post-quantum signer contracts via swapOwner, which are checked through isValidSignature.
evidence_level: source
checks:
- id: c1
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 325
  has: currentOwner = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", dataHash)), v - 4,
    r, s);
  says: eth_sign flow recovers the signer with ecrecover.
  for:
  - evidence-2
  - what
- id: c2
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 329
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: Default flow recovers the signer with ecrecover.
  for:
  - evidence-1
  - justification
  - what
- id: v0
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  has: ISignatureValidator(currentOwner).isValidSignature(data, contractSignature)
  line: 315
  says: Contract owners are verified via ERC-1271 with the full signature.
  for:
  - action
  - evidence-3
  - justification
  - what
- id: own
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  has: owners[currentOwner] != address(0)
  line: 331
  says: The recovered signer must be an owner.
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

This Safe accepts owner approvals recovered with ecrecover from secp256k1 signatures. A quantum attacker who recovers threshold-many owner keys can sign transactions that this Safe accepts as theirs. Contract owners are checked through their own isValidSignature instead.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) recovers the signer with ecrecover(dataHash, v, r, s).
- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) also accepts eth_sign-prefixed ECDSA signatures when v > 30.
- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) checks contract owners with isValidSignature on the full signature.

## Reviewer notes

### Mechanism

The proxy delegates to singleton 0x41675c09 (Safe 1.4.1). In checkNSignatures (Safe.sol lines 286-333) each 65-byte slot is dispatched on v. v == 0 is a contract signature checked through ISignatureValidator.isValidSignature (line 315). v == 1 is approveHash or msg.sender (line 321). v > 30 is ecrecover of the eth_sign-prefixed hash (line 325). Otherwise the signer is ecrecover(dataHash, v, r, s) (line 329). Line 331 requires each recovered address to be an owner, in ascending order. EOA owners are therefore satisfied by secp256k1 keys, so forging threshold-many of them passes execTransaction. Owner changes such as swapOwner need the same threshold.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Holdings are about $0 and there were no calls in the window, so the amount at stake is not shown.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
