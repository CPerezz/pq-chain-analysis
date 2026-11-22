---
id: gnosissafe-acce2d0b-owner-ecdsa-keys
format: 2
title: Safe multisig accepts ECDSA owner signatures a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Owners' ECDSA keys authorize everything; owners can swap EOAs for post-quantum signer contracts,
  so MEDIUM.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xacce2d0b77bcb844a1b95c64696b071ab8c7ada3'
  name: GnosisSafe
  project: safe
  code: verified
  code_url: https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code
  proxy_of: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  copies: 1
value:
  usd: 1
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Replace EOA owners with post-quantum signer contracts via swapOwner, using the contract-signature path.
evidence_level: source
checks:
- id: c1
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 295
  has: currentOwner = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", dataHash)), v - 4,
    r, s);
  says: checkNSignatures recovers eth_sign signatures with ecrecover.
  for:
  - evidence-2
  - what
- id: c2
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 299
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: checkNSignatures recovers EOA owner signatures with ecrecover.
  for:
  - evidence-1
  - justification
  - what
- id: c-contract
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  has: ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE
  line: 285
  says: Contract owners are verified through isValidSignature.
  for:
  - action
  - evidence-3
  - justification
- id: c-owner
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  has: require(currentOwner > lastOwner && owners[currentOwner] != address(0)
  line: 301
  says: Each recovered signer must be an owner.
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

This Safe runs any transaction once threshold-many owners approve, and an EOA owner approves with an ECDSA signature checked by ecrecover. A quantum attacker who recovers threshold-many owner keys can move the Safe's assets or change its owners.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) recovers the signer with ecrecover(dataHash, v, r, s).
- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) also recovers eth_sign-style signatures with ecrecover.
- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) accepts contract owners through isValidSignature, the post-quantum path.

## Reviewer notes

### Mechanism

The proxy delegates to the GnosisSafe 1.3.0 singleton. execTransaction calls checkSignatures/checkNSignatures, which loops over threshold-many 65-byte slots (line 256). v==0 treats r as a contract owner and calls isValidSignature (line 285); v==1 accepts msg.sender or a prior approveHash (line 291); v>30 uses ecrecover on the eth_sign-prefixed hash (line 295); otherwise ecrecover(dataHash, v, r, s) (line 299). Line 301 requires the recovered address to be an owner, in ascending order. An EOA owner is satisfied through ecrecover, so recovering threshold-many owner private keys from their public keys lets an attacker sign any Safe transaction, including swapOwner or asset transfers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract owners validated by isValidSignature do not depend on ECDSA keys.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
