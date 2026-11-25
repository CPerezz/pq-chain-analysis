---
id: safe-507b3f6d-owner-ecdsa-keys
format: 2
title: Safe multisig accepts ECDSA owner signatures that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Owner ECDSA keys authorize everything; MEDIUM since owners can swap EOAs for post-quantum signer
  contracts today.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x507b3f6d4f85c451f7914006c647391a1afb96d6'
  name: Safe
  project: safe
  code: verified
  code_url: https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code
  proxy_of: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  copies: 1
value:
  usd: 143635
  basis: held
activity:
  txs_90d: 4
impact: funds-loss
action: Replace EOA owners with post-quantum signer contracts via swapOwner, signed by the current threshold.
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
  - what
- id: c2
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 329
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: Default path recovers the owner with ecrecover over dataHash.
  for:
  - evidence-1
  - justification
  - what
- id: v0
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  has: ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE
  line: 315
  says: Contract owners are verified by their own isValidSignature on the full signature.
  for:
  - action
  - evidence-3
  - justification
- id: g26
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  has: require(currentOwner > lastOwner && owners[currentOwner] != address(0)
  line: 331
  says: The recovered address must be an owner, in ascending order.
  for:
  - evidence-2
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

This Safe runs any transaction once threshold-many owners approve, and an EOA owner approves with an ECDSA signature checked by ecrecover. A quantum attacker who recovers threshold-many owner keys can move the Safe's funds or change its owners.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) recovers the signer with ecrecover(dataHash, v, r, s) for EOA owners.
- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) accepts the recovered address if it is an owner, in ascending order.
- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) also accepts contract owners via isValidSignature on the full signature.

## Reviewer notes

### Mechanism

execTransaction calls checkNSignatures, which loops over threshold-many 65-byte slots. v==0 (line 286) treats r as a contract owner and calls isValidSignature with the full appended signature (line 315); v==1 (line 316) requires msg.sender or approvedHashes; v>30 ecrecovers the eth_sign-prefixed hash (line 325); otherwise ecrecover(dataHash, v, r, s) (line 329). Line 331 requires the address to be an owner and ascending. An EOA owner is only satisfied through ecrecover or its own transaction, so recovered keys suffice to pass the threshold, then execTransaction can transfer assets or call swapOwner/changeThreshold on itself. Replacing EOA owners with ERC-1271 post-quantum signer contracts removes the ECDSA path.

### Checks

- Header facts: this address alone, at block 26,438,999.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
