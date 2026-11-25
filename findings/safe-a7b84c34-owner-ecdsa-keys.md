---
id: safe-a7b84c34-owner-ecdsa-keys
format: 2
title: Safe multisig accepts ECDSA owner signatures that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: EOA owners approve via ecrecover; owners can swap them for post-quantum signer contracts already
  accepted via ERC-1271.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa7b84c346fda049715a0ca9e7310d272545a338b'
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
action: Swap EOA owners for post-quantum signer contracts via swapOwner, validated through isValidSignature.
evidence_level: source
checks:
- id: c1
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 325
  has: currentOwner = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", dataHash)), v - 4,
    r, s);
  says: eth_sign signatures are verified with ecrecover.
  for:
  - evidence-2
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
- id: c-1271
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  has: ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE
  line: 315
  says: Contract owners are verified via ERC-1271 isValidSignature.
  for:
  - action
  - evidence-3
  - justification
- id: c-owner
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  has: require(currentOwner > lastOwner && owners[currentOwner] != address(0)
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

This Safe executes transactions once threshold-many owners approve, and an EOA owner approves with a secp256k1 signature checked by ecrecover. A quantum attacker who recovers threshold-many owner keys can sign any transaction, including moving assets or changing owners.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) recovers the signer with ecrecover(dataHash, v, r, s).
- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) also accepts eth_sign signatures through ecrecover.
- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) accepts contract owners via isValidSignature, allowing post-quantum signers.

## Reviewer notes

### Mechanism

The proxy runs Safe 1.4.1 singleton 0x41675c09. checkNSignatures walks threshold-many 65-byte slots: v==0 calls ISignatureValidator(owner).isValidSignature on the full contract signature (line 315); v==1 checks msg.sender or approvedHashes (line 321); v>30 uses ecrecover on the eth_sign-prefixed hash (line 325); otherwise ecrecover(dataHash, v, r, s) (line 329). Line 331 requires each recovered address to be an owner in ascending order. An EOA owner is satisfied by an ECDSA signature, so a recovered key forges its approval; threshold-many forged approvals let execTransaction run any call, including swapOwner or changing the singleton.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract owners are checked through isValidSignature, not ecrecover.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
