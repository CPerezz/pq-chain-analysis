---
id: safe-3f963b4c-owner-ecdsa-keys
format: 2
title: Safe multisig accepts ECDSA owner signatures that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Owner ECDSA keys authorize everything; owners can swap EOAs for post-quantum signer contracts in
  place, so MEDIUM.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x3f963b4c8e2473683c9d48189e27440f76307214'
  name: Safe
  project: safe
  code: verified
  code_url: https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code
  proxy_of: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  copies: 1
value:
  usd: 23403815
  basis: held
activity:
  txs_90d: 28
impact: funds-loss
action: Replace EOA owners with post-quantum signer contracts via swapOwner.
evidence_level: source
checks:
- id: c1
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 325
  has: currentOwner = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", dataHash)), v - 4,
    r, s);
  says: eth_sign path recovers the signer with ecrecover.
  for:
  - evidence-2
  - what
- id: c2
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 329
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: Default path recovers the signer with ecrecover over dataHash.
  for:
  - evidence-1
  - justification
  - what
- id: v0
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  has: ISignatureValidator(currentOwner).isValidSignature(data, contractSignature)
  line: 315
  says: Contract owners are verified by their own isValidSignature.
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

This Safe executes transactions once threshold-many owners approve, and an EOA owner approves with an ECDSA signature checked by ecrecover. A quantum attacker who recovers threshold-many owner keys can sign transactions that move the Safe's holdings or change its owners.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) recovers the owner with ecrecover from the data hash and the signature.
- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) also accepts eth_sign signatures through ecrecover.
- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) accepts contract owners through isValidSignature.

## Reviewer notes

### Mechanism

execTransaction calls checkNSignatures, which walks threshold-many 65-byte slots. For v > 30 (line 325) it ecrecovers the eth_sign-prefixed dataHash; otherwise (line 329) it ecrecovers dataHash directly. Line 331 requires the recovered address to be an owner, in ascending order. An attacker holding threshold-many recovered secp256k1 owner keys satisfies this and executes any call, including swapOwner or a singleton change. Contract owners are instead checked through isValidSignature (line 315) or approveHash (line 321), so swapping EOA owners for post-quantum signer contracts removes the ECDSA path.

### Checks

- Header facts: this address alone, at block 26,438,999.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
