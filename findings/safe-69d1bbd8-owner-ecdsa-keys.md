---
id: safe-69d1bbd8-owner-ecdsa-keys
format: 2
title: Safe multisig accepts ECDSA owner signatures a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: EOA owners approve with secp256k1; owners can swap them for post-quantum signer contracts, so MEDIUM.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x69d1bbd881817795811e3e2973716ddc98bfe9b2'
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
action: Replace EOA owners with post-quantum signer contracts via swapOwner.
evidence_level: source
checks:
- id: c1
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 325
  has: currentOwner = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", dataHash)), v - 4,
    r, s);
  says: eth_sign-style owner signatures are verified with ecrecover.
  for:
  - what
- id: c2
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 329
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: Standard owner signatures are verified with ecrecover.
  for:
  - evidence-1
  - justification
  - what
- id: gs026
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  has: require(currentOwner > lastOwner && owners[currentOwner] != address(0) && currentOwner != SENTINEL_OWNERS,
    "GS026");
  line: 331
  says: Recovered signer must be a current owner.
  for:
  - evidence-2
  - what
- id: v0
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  has: require(ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE,
    "GS024");
  line: 315
  says: Contract owners are verified through their own isValidSignature.
  for:
  - action
  - evidence-3
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
reviews: []
related: []
---

## What happens

This Safe executes transactions once enough owners approve, and an EOA owner approves with an ECDSA signature checked by ecrecover. A quantum attacker who recovers enough owner keys could approve any transaction from this Safe.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) recovers an owner from a signature with ecrecover over the transaction hash.
- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) accepts the recovered address if it is a Safe owner.
- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) also accepts contract owners through isValidSignature.

## Reviewer notes

### Mechanism

Safe.checkNSignatures (Safe.sol lines 286-333) walks threshold-many signature slots. For v > 30 it calls ecrecover on the eth_sign-prefixed hash (line 325); otherwise ecrecover(dataHash, v, r, s) (line 329). Line 331 requires the recovered address to be an owner in ascending order. An attacker who derives threshold-many EOA owner private keys from their public keys can produce valid signatures and run execTransaction, including transfers, swapOwner or singleton changes. Contract owners use v == 0 and isValidSignature (line 315), which allows migrating seats to post-quantum signer contracts.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No guard is set on any tracked Safe.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
