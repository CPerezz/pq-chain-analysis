---
id: contract-3762a79b-signer-key
format: 2
title: LiquidityBank trusts one ECDSA verifying signer a quantum attacker could forge
status: candidate
severity: MEDIUM
justification: A recovered signer key could authorise releases of deposits; MEDIUM as one operator can keep it paused
  or upgrade it.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x3762a79b34dfb6774cfd45dbf5fd9a2780873783'
  code: decompiled
  code_url: code/0x9c335f456dff1a5c4137a68e3a03a38a8c7596f9a2bfc373001e0d8825242ff4.sol
  proxy_of: '0xab8a2cfc2e4ca8f44cbd0bce309a361bb4c9aeb5'
  copies: 1
  upgradeable: 'yes'
  admin: '0x166fd12e962290250aebf178f60ff0a250e2159c'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 4
impact: funds-loss
action: Keep LiquidityBank paused, or upgrade it to verify a post-quantum signature for orders and releases.
evidence_level: bytecode
checks:
- id: b1
  bytecode: '0xab8a2cfc2e4ca8f44cbd0bce309a361bb4c9aeb5'
  has: 60015afa
  says: The implementation's runtime code calls the ecrecover precompile.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: code
  code: '0x3762a79b34dfb6774cfd45dbf5fd9a2780873783'
  is: contract
  bytes: 1159
  says: The address holds contract code.
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
- study: eip-8151-impact
  who: Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not
    reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: CRITICAL
reviews: []
related: []
---

## What happens

LiquidityBank takes deposits against orders and checks signatures with the ecrecover precompile against a stored verifying signer. A quantum attacker who recovers that signer's ECDSA key could sign releases of deposited funds.

## Evidence

- The [implementation code](https://etherscan.io/address/0xab8a2cfc2e4ca8f44cbd0bce309a361bb4c9aeb5#code) calls the ecrecover precompile.

## Reviewer notes

### Mechanism

The proxy 0x3762a79b delegates to implementation 0xab8a2cfc. That implementation's runtime code calls the ecrecover precompile (STATICCALL to address 1 at byte offset 14091). The decompiled code is unverified and serves only as a lead. It shows a stored getVerifyingSigner, a setter for that signer restricted to the owner, setPaused and setUnpaused gated by the owner, and an order function with the checks 'Order locked' and 'Order already processed'. Following kev's finding, orders, releases and refunds are authorised by the verifying signer's EIP-712 ECDSA signature. Which selector performs the recovery was not established. The contract is paused and holds about $0, so the exposure returns only if it is unpaused and refilled.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No funds currently held; contract paused per kev's reads.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
