---
id: contract-bb4c20cb-order-sig-ecdsa-only
format: 2
title: Old Aori deployment accepts ECDSA order signatures a quantum attacker can forge
status: candidate
severity: MEDIUM
justification: Forged orders let a solver pull users' approved tokens; immutable, so fix is a new deployment, pause
  or revocation
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xbb4c20cb237f3629d1afc3ecb3e84148fa426c12'
  project: aori
  code: decompiled
  code_url: code/0xa9dd8f22c788b1f6dc9b8726eca9db9691d5fa828a32e69cbd28121b68f0ecaa.sol
  copies: 1
  upgradeable: 'no'
  admin: '0xb4afac168ca0cce40c5b4d4e8e49a1e18a630b40'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Pause this deployment and move users to a version that verifies ERC-1271 signatures for contract accounts.
evidence_level: bytecode
checks:
- id: b1
  bytecode: '0xbb4c20cb237f3629d1afc3ecb3e84148fa426c12'
  has: 60015afa
  says: runtime code calls the ecrecover precompile
  for:
  - evidence-1
  - justification
  - what
- id: sel-pause
  selector: '0xbb4c20cb237f3629d1afc3ecb3e84148fa426c12'
  fn: pause()
  says: an owner pause function is in the code
  for:
  - action
  - evidence-2
  - justification
- id: sel-solver
  selector: '0xbb4c20cb237f3629d1afc3ecb3e84148fa426c12'
  fn: addAllowedSolver(address)
  says: solvers are whitelisted by the owner
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

This older Aori contract checks user order signatures with ecrecover, and its owner whitelists the solvers that submit orders. A quantum attacker who recovers a user's key can sign an order paying themselves, and a whitelisted solver's fill pulls the user's approved tokens.

## Evidence

- The [runtime code](https://etherscan.io/address/0xbb4c20cb237f3629d1afc3ecb3e84148fa426c12#code) calls the ecrecover precompile.
- The [owner functions](https://etherscan.io/address/0xbb4c20cb237f3629d1afc3ecb3e84148fa426c12#code) include pause and solver whitelisting.

## Reviewer notes

### Mechanism

Unverified bytecode. Kev infers from selector overlap with verified Aori (39 of 46 selectors) that its order deposit path runs validateDeposit: ECDSA.recover(digest, signature) must equal order.offerer, then safeTransferFrom(offerer, this, inputAmount). The runtime calls the ecrecover precompile (offset 13305). Kev found no isValidSignature selector. Owner-only pause and addAllowedSolver/removeAllowedSolver whitelists exist. Exposure is users' leftover approvals, not measured.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract holds about $0; no upgrade path (not a proxy)

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
