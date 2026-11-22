---
id: contract-b8a4deb1-fabric-robo-airdrop-signer
format: 2
title: Fabric ROBO airdrop trusts an ECDSA signer key a quantum attacker could recover
status: candidate
severity: LOW
justification: Claims rely on one ECDSA signer key; LOW as the contract is empty and dormant; Fabric Protocol can
  rotate the signer.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb8a4deb1c30404555ffeaf30e65b24339abbc2d8'
  project: fabric-protocol
  code: decompiled
  code_url: code/0x30cea3e33584cd9572c67c5efc419281ad53c2dbc89aa955e527c65c1698900b.sol
  copies: 1
  upgradeable: 'no'
  admin: '0x1e63183fb2123f0674582a5a2d251e72de0bd8bf'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Before refunding or reusing it, require the Merkle proof alone or verify a post-quantum signer instead of
  the ECDSA key.
evidence_level: bytecode
checks:
- id: b1
  bytecode: '0xb8a4deb1c30404555ffeaf30e65b24339abbc2d8'
  has: 60015afa
  says: the runtime code calls the ecrecover precompile
  for:
  - evidence-1
  - justification
  - what
- id: s-claim
  selector: '0xb8a4deb1c30404555ffeaf30e65b24339abbc2d8'
  fn: claim(bytes32,uint256,address,bytes32[],bytes)
  says: the claim function is in the code
  for:
  - action
  - evidence-1
  - justification
  - what
- id: s-signer
  selector: '0xb8a4deb1c30404555ffeaf30e65b24339abbc2d8'
  fn: trustedSigner()
  says: the code exposes a trusted signer address
  for:
  - evidence-2
  - what
- id: s-update
  selector: '0xb8a4deb1c30404555ffeaf30e65b24339abbc2d8'
  fn: updateTrustedSigner(address)
  says: the code has a function to replace the signer
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
  who: Review07 (registry review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This contract pays out ROBO airdrop claims and checks a signature from a trusted signer key with ecrecover. A quantum attacker who recovers that key could co-sign claims, but the contract now holds nothing to claim.

## Evidence

- [claim](https://etherscan.io/address/0xb8a4deb1c30404555ffeaf30e65b24339abbc2d8#code) is in the code, and the code calls the ecrecover precompile.
- [trustedSigner](https://etherscan.io/address/0xb8a4deb1c30404555ffeaf30e65b24339abbc2d8#code) holds the single key whose signatures claims are checked against.
- [updateTrustedSigner](https://etherscan.io/address/0xb8a4deb1c30404555ffeaf30e65b24339abbc2d8#code) lets the owner replace the signer.

## Reviewer notes

### Mechanism

Unverified bytecode. claim(bytes32,uint256,address,bytes32[],bytes) (0x877634db) checks a Merkle proof against merkleRoot(), hashes an "\x19Ethereum Signed Message:\n32"-prefixed message and recovers the signer with a staticcall to precompile 0x01 (bytes 60015afa at offset 4288). It compares the result with trustedSigner(), then transfers token() (ROBO) to the claimant. updateTrustedSigner(address) is owner-only; the owner is a 3-of-5 Safe. Kev reads a ROBO balance of 0, no allowance from the Safe or deployer, and no ETH; the rest was withdrawn to the owner Safe. Without source, whether claim requires both the proof and the signature is not established.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Nothing to drain: ROBO balance is zero and no allowance lets the contract pull more (per kev's reads).
- Ruled out: Not upgradeable; only the signer is configurable.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
