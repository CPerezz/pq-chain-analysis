---
id: safe-748aed55-owner-ecdsa-keys
format: 2
title: Safe multisig accepts ECDSA owner signatures that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Owner ECDSA keys authorize everything; MEDIUM because owners can replace EOAs with post-quantum signer
  contracts.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x748aed55d2a85d84e30558ed4798b0a47cb7dde6'
  name: Safe
  project: safe
  code: verified
  code_url: https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code
  proxy_of: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  copies: 1
value:
  usd: 21691082
  basis: held
activity:
  txs_90d: 5
impact: funds-loss
action: Replace EOA owners with post-quantum signer contracts that verify through isValidSignature.
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
  - evidence-2
  - what
- id: c2
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 329
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: Default owner signatures are verified with ecrecover over the data hash.
  for:
  - evidence-1
  - justification
  - what
- id: c-1271
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  has: ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE
  line: 315
  says: Contract owners are verified through their own isValidSignature.
  for:
  - action
  - evidence-3
  - justification
- id: c-owner
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

This Safe runs a transaction once threshold-many owners approve, and an EOA owner approves with an ECDSA signature checked by ecrecover. A quantum attacker who recovers threshold-many owner keys can move the Safe's holdings or change its owners.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) takes the owner recovered by ecrecover from the data hash.
- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) also accepts eth_sign-style signatures through ecrecover.
- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) accepts contract owners through isValidSignature with the full signature.

## Reviewer notes

### Mechanism

The proxy delegates to Safe 1.4.1 singleton 0x41675c09. execTransaction calls checkNSignatures, which walks threshold-many 65-byte slots. For v==0 (line 286) the owner is a contract checked via ISignatureValidator.isValidSignature on the full signature (line 315). For v==1 it uses approveHash or msg.sender (line 321). For v>30 it runs ecrecover over the eth_sign-prefixed hash (line 325). Otherwise it runs ecrecover(dataHash, v, r, s) (line 329). Line 331 requires each recovered address to be an owner, in ascending order. EOA owners are satisfied only through ecrecover or their own transactions, so their secp256k1 keys are the exposure. Owner changes (swapOwner) need the same threshold, so the current owners can migrate to post-quantum ERC-1271 signer contracts.

### Checks

- Header facts: this address alone, at block 26,438,999.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
