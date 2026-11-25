---
id: safe-4353e2df-owner-ecdsa-keys
format: 2
title: Safe multisig accepts ECDSA owner signatures that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Recovering threshold-many owner keys moves all funds; MEDIUM as owners can swap EOAs for ERC-1271
  signer contracts.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4353e2df4e3444e97e20b2bda165bdd9a23913ab'
  name: Safe
  project: safe
  code: verified
  code_url: https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code
  proxy_of: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  copies: 1
value:
  usd: 257
  basis: held
activity:
  txs_90d: 2
impact: funds-loss
action: Replace EOA owners with post-quantum signer contracts via swapOwner, validated through isValidSignature.
evidence_level: source
checks:
- id: c1
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 325
  has: currentOwner = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", dataHash)), v - 4,
    r, s);
  says: eth_sign path recovers the owner with ecrecover.
  for:
  - evidence-1
  - what
- id: c2
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 329
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: Default path recovers the owner with ecrecover(dataHash, v, r, s).
  for:
  - evidence-1
  - justification
  - what
- id: c-owner
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  has: require(currentOwner > lastOwner && owners[currentOwner] != address(0)
  line: 331
  says: Recovered signer must be an owner, in ascending order.
  for:
  - evidence-2
  - what
- id: c-1271
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  has: ISignatureValidator(currentOwner).isValidSignature(data, contractSignature)
  line: 315
  says: Contract owners are verified via ERC-1271 on the full signature.
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
  pattern: PQ-12
reviews: []
related: []
---

## What happens

This Safe runs transactions once threshold-many owners approve, and an EOA owner approves with an ECDSA signature checked by ecrecover. A quantum attacker who recovers threshold-many owner keys can sign any transaction, moving the Safe's assets or changing its owners.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) recovers each EOA owner from the signature with ecrecover.
- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) accepts the recovered address if it is an owner.
- [Contract owners](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) are checked through isValidSignature on the full signature.

## Reviewer notes

### Mechanism

execTransaction calls checkNSignatures, which walks threshold-many 65-byte signature slots. v==0 treats r as a contract owner and calls ISignatureValidator.isValidSignature on the appended full-length signature (line 315); v==1 needs msg.sender==owner or an approveHash entry (line 321); v>30 uses ecrecover on the eth_sign-prefixed hash (line 325); otherwise ecrecover(dataHash, v, r, s) (line 329). Line 331 requires the address to be an owner, in ascending order. EOA owners are satisfied only via ecrecover or by sending the transaction, so their secp256k1 keys are the exposure; owner and threshold changes (swapOwner etc.) go through the same check. Kev's census: this Safe runs 1.4.1, 3 of 4, with AllowanceModule enabled.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No guard set on the tracked Safes (kev's census).

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
