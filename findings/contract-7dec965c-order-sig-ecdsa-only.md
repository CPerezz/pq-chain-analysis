---
id: contract-7dec965c-order-sig-ecdsa-only
format: 2
title: Old Aori deployment accepts ECDSA-only orders a quantum attacker could forge
status: candidate
severity: MEDIUM
justification: Immutable ECDSA-only order check; only a new deployment fixes it, the owner can pause, users can
  revoke approvals.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7dec965cf240f81299683f48a18ebdbe8b2accb5'
  project: aori
  code: decompiled
  code_url: code/0x0cdefc683ae7c844dcdf403d62a60d481debe45231293a7b5cf567fabb861524.sol
  copies: 1
  upgradeable: 'no'
  admin: '0xb4afac168ca0cce40c5b4d4e8e49a1e18a630b40'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1
impact: funds-loss
action: Pause this deployment and move users to a version that checks ERC-1271 signatures for contract accounts.
evidence_level: bytecode
checks:
- id: b1
  bytecode: '0x7dec965cf240f81299683f48a18ebdbe8b2accb5'
  has: 600160a01b038254165af1
  says: code calls ecrecover
  for:
  - evidence-1
  - justification
  - what
- id: b2
  bytecode: '0x7dec965cf240f81299683f48a18ebdbe8b2accb5'
  has: 600160a01b03831690602085602481855afa
  says: code calls ecrecover
  for:
  - what
- id: b3
  bytecode: '0x7dec965cf240f81299683f48a18ebdbe8b2accb5'
  has: 600160806000825afa
  says: code calls ecrecover
  for:
  - evidence-1
- id: sel-solver
  selector: '0x7dec965cf240f81299683f48a18ebdbe8b2accb5'
  fn: addAllowedSolver(address)
  says: solver whitelist exists
  for:
  - evidence-2
  - what
- id: sel-pause
  selector: '0x7dec965cf240f81299683f48a18ebdbe8b2accb5'
  fn: pause()
  says: pause function exists
  for:
  - action
  - evidence-2
  - justification
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review13 (deployer trace, selector match against verified Aori, owner/pause reads; former finding unidentified-7dec965c-user-sig-ecdsa-only)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
- study: top-callers-classification
  who: Review23 (finding review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (the study family's recovery functions read, a real transaction replayed four ways; not reviewed by
    a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: confirmed
  rating: ''
  pattern: PQ-1
reviews: []
related: []
---

## What happens

This older Aori contract keeps a whitelist of solvers and checks order signatures with ECDSA recovery. A quantum attacker who recovers a user's key can forge an order paying themselves, and a whitelisted solver filling it pulls the user's approved tokens.

## Evidence

- The [runtime code](https://etherscan.io/address/0x7dec965cf240f81299683f48a18ebdbe8b2accb5#code) calls the ecrecover precompile.
- The [contract](https://etherscan.io/address/0x7dec965cf240f81299683f48a18ebdbe8b2accb5#code) has an owner-managed solver whitelist and a pause function.

## Reviewer notes

### Mechanism

Bytecode only. The runtime code calls the ecrecover precompile at offsets 5675, 14240 and 21004, and has addAllowedSolver and pause. Its selectors largely match verified Aori, where validateDeposit does ECDSA.recover(digest, signature), requires the result to equal order.offerer, then pulls inputAmount from the offerer with safeTransferFrom. A forged order with an attacker-chosen recipient and outputAmount, filled by a whitelisted solver, takes the user's approved tokens. The owner EOA can pause. The contract is unpaused and had no activity in the last 30 days. Exposure is users' leftover approvals, which were not measured.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract holds about $0 itself; exposure is users' approvals, not balance.
- Ruled out: No upgrade path; logic is immutable.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
