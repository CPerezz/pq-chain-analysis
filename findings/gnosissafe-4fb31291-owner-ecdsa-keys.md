---
id: gnosissafe-4fb31291-owner-ecdsa-keys
format: 2
title: Safe multisig accepts ECDSA owner signatures a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: EOA owners approve via ECDSA; owners can swap them for post-quantum signer contracts, which the Safe
  already accepts.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4fb312915b779b1339388e14b6d079741ca83128'
  name: GnosisSafe
  project: safe
  code: verified
  code_url: https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code
  proxy_of: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  copies: 1
value:
  usd: 460688
  basis: held
activity:
  txs_90d: 1212
impact: funds-loss
action: Replace EOA owners with post-quantum signer contracts via swapOwner, keeping the threshold.
evidence_level: source
checks:
- id: c1
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 295
  has: currentOwner = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", dataHash)), v - 4,
    r, s);
  says: eth_sign flow accepts an ECDSA signature via ecrecover.
  for:
  - evidence-2
  - what
- id: c2
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 299
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: Default flow accepts an ECDSA signature via ecrecover over the data hash.
  for:
  - evidence-1
  - justification
  - what
- id: s-1271
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  has: ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE
  line: 285
  says: Contract owners are checked through ERC-1271 with the full signature.
  for:
  - action
  - evidence-3
  - justification
- id: s-owner
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  has: require(currentOwner > lastOwner && owners[currentOwner] != address(0)
  line: 301
  says: Each recovered signer must be a distinct, current owner.
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

This Safe executes transactions once threshold-many owners approve, and an EOA owner approves with an ECDSA signature checked by ecrecover. A quantum attacker who recovers threshold-many owner keys can sign any transaction and move the Safe's holdings.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) recovers the signer with ecrecover over the transaction hash.
- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) also accepts eth_sign-style ECDSA signatures through ecrecover.
- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) accepts contract owners through isValidSignature on the full signature.

## Reviewer notes

### Mechanism

The proxy delegates to the GnosisSafe 1.3.0 singleton. execTransaction calls checkNSignatures, which loops over threshold-many 65-byte slots. Line 285: v==0 calls the owner contract's isValidSignature with the full contract signature. Line 291: v==1 requires msg.sender==owner or a prior approveHash. Line 295: v>30 runs ecrecover on the eth_sign-prefixed hash. Line 299: otherwise ecrecover(dataHash,v,r,s). Line 301 requires each recovered address to be an owner, in ascending order. An EOA owner is satisfied by ecrecover, so recovering its secp256k1 key from a posted signature lets an attacker sign for it; with threshold-many keys the attacker can execute any call, including owner changes. Contract owners go through ERC-1271 instead, so swapping EOA owners for post-quantum signer contracts removes their ECDSA path.

### Checks

- Header facts: this address alone, at block 26,438,999.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
