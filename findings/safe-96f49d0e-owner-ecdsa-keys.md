---
id: safe-96f49d0e-owner-ecdsa-keys
format: 2
title: Safe multisig accepts ECDSA owner signatures that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Owner ECDSA keys authorize any transaction; owners can swap EOAs for post-quantum signer contracts,
  so MEDIUM.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x96f49d0e9724dfd8780fa667ac37a993f005cb94'
  name: Safe
  project: safe
  code: verified
  code_url: https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code
  proxy_of: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  copies: 1
value:
  usd: 180
  basis: held
activity:
  txs_90d: 52
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
  says: eth_sign-style signatures are verified with ecrecover.
  for:
  - justification
  - what
- id: c2
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 329
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: Default owner signatures are verified with ecrecover.
  for:
  - evidence-1
  - justification
  - what
- id: s-contract
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  has: ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE
  line: 315
  says: Contract owners are verified via EIP-1271 isValidSignature.
  for:
  - action
  - evidence-2
  - justification
- id: s-owner
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
  pattern: PQ-12
reviews: []
related: []
---

## What happens

This Safe executes a transaction once threshold-many owners approve, and an EOA owner approves with an ECDSA signature checked by ecrecover. A quantum attacker who recovers threshold-many owner keys can sign any transaction and move what the Safe holds.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) recovers the signer with ecrecover(dataHash, v, r, s) for default signatures.
- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) accepts a contract owner's signature through isValidSignature.

## Reviewer notes

### Mechanism

Safe 1.4.1 singleton behind a proxy. checkNSignatures (contracts/Safe.sol ~286-333) loops over threshold-many 65-byte slots. v==0: contract signature, owner address from r, checked via ISignatureValidator.isValidSignature (line 315). v==1: approved hash or msg.sender (line 321). v>30: ecrecover over eth_sign prefixed hash (line 325). Otherwise ecrecover(dataHash, v, r, s) (line 329). Line 331 requires each recovered address to be an owner in ascending order. An EOA owner is satisfied by ecrecover, so its secp256k1 key is the exposure; a quantum attacker deriving keys from posted signatures can satisfy the threshold and run execTransaction, including swapOwner or changing the singleton. Contract owners avoid this path.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Owners and threshold of this specific Safe were not read here

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
