---
id: safe-f20b3387-owner-ecdsa-keys
format: 2
title: Safe multisig lets a quantum attacker with threshold owner keys move its assets
status: confirmed
severity: MEDIUM
justification: Owner ECDSA keys authorize everything; owners can swap EOAs for post-quantum signer contracts, so
  MEDIUM.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xf20b338752976878754518183873602902360704'
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
  txs_90d: 204
impact: funds-loss
action: Replace EOA owners with post-quantum signer contracts via swapOwner, approved by the current threshold of
  owners.
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
  says: Default signatures are verified with ecrecover on the transaction hash.
  for:
  - evidence-1
  - justification
  - what
- id: c315
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  has: ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE
  line: 315
  says: Contract owners sign through their own isValidSignature.
  for:
  - action
  - evidence-3
  - justification
- id: c331
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  has: owners[currentOwner] != address(0)
  line: 331
  says: Each recovered signer must be a current owner.
  for:
  - evidence-1
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

This Safe runs any transaction once threshold-many owners approve, and an EOA owner approves with an ECDSA signature checked by ecrecover. A quantum attacker who recovers threshold-many owner keys can sign as those owners and move assets or change owners.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) recovers the signer with ecrecover and requires it to be an owner.
- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) also accepts eth_sign-style ECDSA signatures via ecrecover.
- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) accepts contract owners through isValidSignature, the path for post-quantum signers.

## Reviewer notes

### Mechanism

execTransaction calls checkNSignatures, which loops over threshold-many 65-byte signature slots. v==0: contract owner encoded in r, checked via ISignatureValidator(owner).isValidSignature(data, contractSignature) (line 315). v==1: approveHash or msg.sender==owner (line 321). v>30: ecrecover of the eth_sign-prefixed hash (line 325). Otherwise ecrecover(dataHash, v, r, s) (line 329). Line 331 requires each recovered address to be an owner in ascending order. EOA owners are satisfied only by ecrecover or by sending the transaction themselves, so recovering threshold-many secp256k1 keys gives full control, including swapOwner/changeThreshold via self-calls. Contract owners verify via isValidSignature, so swapping EOAs for post-quantum signer contracts removes the ECDSA path.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No guard is set on the tracked Safes.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
