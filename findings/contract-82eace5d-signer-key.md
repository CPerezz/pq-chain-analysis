---
id: contract-82eace5d-signer-key
format: 2
title: Smart-account co-signer trusts one ECDSA key a quantum attacker could recover
status: candidate
severity: MEDIUM
justification: A recovered co-signer key plus an owner's key takes a smart account; the operator must deploy a new
  module and co-signer
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x82eace5d23ef8fc5e825a05e8eacd908289ee4dc'
  code: decompiled
  code_url: code/0xeb6efd688307072cfe530e587c1361395929ac91e0befe7e235cb7e0220191ca.sol
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 100
impact: funds-loss
action: Deploy a post-quantum co-signer and module, and have account owners enable it and disable the current module.
evidence_level: bytecode
checks:
- id: b1
  bytecode: '0x82eace5d23ef8fc5e825a05e8eacd908289ee4dc'
  has: 60015afa
  says: The runtime code calls the ecrecover precompile.
  for:
  - evidence-1
  - justification
  - what
- id: sel-ivs
  selector: '0x82eace5d23ef8fc5e825a05e8eacd908289ee4dc'
  fn: isValidSignature(bytes32,bytes)
  says: The code has the ERC-1271 isValidSignature entry point.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: sel-gvs
  selector: '0x82eace5d23ef8fc5e825a05e8eacd908289ee4dc'
  fn: getVerifyingSigner()
  says: The code exposes a getter for the stored verifying signer.
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
  who: Review08 (paymaster bytecode, EntryPoint deposit reads, deployer siblings)
  date: 2026-11-17
  by: ai-assisted
  verdict: reported
  rating: LOW
- study: top-callers-classification
  who: Review18 (LiquidityBank bytecode strings and selectors, proxy and paymaster reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: reported
  rating: LOW
- study: top-callers-classification
  who: Review15 (co-signer bytecode, module immutable, traced user operation)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
- study: top-callers-classification
  who: Review22 (module bytecode, NAME/VERSION, trace, account enumeration and balances; moved from biconomy-ecdsa-validator)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This contract co-signs smart-account operations: isValidSignature recovers an ECDSA signer and checks it against one stored verifying signer. A quantum attacker who recovers that key forges co-signatures, and with an account owner's key controls that account.

## Evidence

- [isValidSignature](https://etherscan.io/address/0x82eace5d23ef8fc5e825a05e8eacd908289ee4dc#code) is in the code and the runtime calls the ecrecover precompile.
- [getVerifyingSigner](https://etherscan.io/address/0x82eace5d23ef8fc5e825a05e8eacd908289ee4dc#code) exposes the single stored signer address.

## Reviewer notes

### Mechanism

isValidSignature(bytes32,bytes) (selector 0x1626ba7e) parses the signature bytes and recovers an address through the ecrecover precompile (STATICCALL to 0x01 at runtime offset 1580), using OpenZeppelin ECDSA checks such as the 's' value bound. It then compares the result with the stored verifying signer that getVerifyingSigner() returns. Kev's trace shows ownership module 0xba418fa6 holding this contract as an immutable and calling isValidSignature in validateUserOp before it recovers the account owner. Forging the co-signature therefore also requires the owner's key. Kev reads owner() as renounced, so the signer is fixed.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The co-signer key alone does not move funds; the account owner's signature is also required.
- Ruled out: Not upgradeable; the contract holds about $0.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
