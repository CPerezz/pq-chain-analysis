---
id: contract-fbeedcfe-signer-key
format: 2
title: Unidentified 1inch maker trusts one ECDSA key a quantum attacker could derive
status: candidate
severity: MEDIUM
justification: The operator key signs orders selling the inventory; its signer is fixed, so the operator must redeploy
  and move funds.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xfbeedcfe378866dab6abbafd8b2986f5c1768737'
  code: decompiled
  code_url: code/0xe4655f85874e38780979963e8a05a76c8054ccbfe833ab3a3022b821470f5fdb.sol
  copies: 1
value:
  usd: 875904
  basis: held
activity:
  txs_90d: 29443
impact: funds-loss
action: Deploy a maker contract whose isValidSignature verifies a post-quantum key, move the inventory to it, and
  retire this one.
evidence_level: bytecode
checks:
- id: code
  code: '0xfbeedcfe378866dab6abbafd8b2986f5c1768737'
  is: contract
  bytes: 20373
  says: The address holds 20,373 bytes of contract code.
  for:
  - action
  - evidence-1
  - evidence-2
  - justification
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review06 (Claude), 2026-11-17 review
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This unverified market-maker contract answers 1inch's signature check by recovering the order signer with ECDSA and comparing it with one operator key. A quantum attacker who derives that operator key can sign 1inch orders that sell the contract's tokens at any price.

## Evidence

- The [contract](https://etherscan.io/address/0xfbeedcfe378866dab6abbafd8b2986f5c1768737#code) holds unverified code that 1inch fills call for signature checks.
- In [a 1inch fill](https://etherscan.io/tx/0x7e3365144aba9d14a0de76cd03c06b6ecc6e5080a8df30cf73947d077bb1131b) the router calls isValidSignature, and the contract's ECDSA recovery returns the operator EOA.

## Reviewer notes

### Mechanism

The contract has no verified source. In traced 1inch AggregationRouterV6 fills (tx 0x7e3365… and 0x878f7f…), the router STATICCALLs isValidSignature(bytes32,bytes) (0x1626ba7e) on the contract. Inside that frame the contract calls the ecrecover precompile 0x01, which returns operator EOA 0xa009fa1a…. The router then calls the 0x0986bdd5 hook and moves the maker's tokens. The operator address is embedded in the runtime bytecode and there is no proxy. Because of this, the signer cannot be rotated. A derived key therefore lets an attacker sign orders that drain the inventory.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No proxy: signer rotation through an upgrade is not possible.
- Ruled out: No user approvals involved; exposure is the maker's own inventory.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
