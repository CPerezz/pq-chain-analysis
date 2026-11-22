---
id: contract-0d6ce815-signer-key
format: 2
title: Signed-swap treasury trusts one ECDSA key a quantum attacker could recover
status: candidate
severity: MEDIUM
justification: Swaps are authorised by one ECDSA key; setVerifier only rotates it, so the owner must redeploy to
  fix it.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0d6ce8158640cc02f405dee694d8aeda56ed3271'
  code: decompiled
  code_url: code/0x4404c634f759b899e2f534a7eb4bca9c57c7dbf8126f968d580c45f0392a4ed4.sol
  copies: 1
  upgradeable: 'no'
  admin: '0x3bf77324ec75c24107077d90275ddaa14efc866f'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Redeploy with a post-quantum signature verifier, or keep the contract's balances near zero.
evidence_level: bytecode
checks:
- id: b1
  bytecode: '0x0d6ce8158640cc02f405dee694d8aeda56ed3271'
  has: 60015afa
  says: The runtime code calls the ecrecover precompile.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: code
  code: '0x0d6ce8158640cc02f405dee694d8aeda56ed3271'
  is: contract
  bytes: 16198
  says: The address holds contract code.
  for:
  - what
- id: sel-verifier
  selector: '0x0d6ce8158640cc02f405dee694d8aeda56ed3271'
  fn: verifier()
  says: The contract exposes the verifier key getter.
  for:
  - evidence-2
  - what
- id: sel-setverifier
  selector: '0x0d6ce8158640cc02f405dee694d8aeda56ed3271'
  fn: setVerifier(address)
  says: The contract lets the owner replace the verifier address.
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
  who: Review09 (finding review)
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
  rating: LOW
reviews: []
related: []
---

## What happens

This unverified contract swaps tokens it holds when a caller submits parameters signed by its verifier key, checked with ecrecover. A quantum attacker who recovers that ECDSA key can sign swaps of the contract's funds on the attacker's terms.

## Evidence

- The [runtime code](https://etherscan.io/address/0x0d6ce8158640cc02f405dee694d8aeda56ed3271#code) calls the ecrecover precompile.
- The [contract](https://etherscan.io/address/0x0d6ce8158640cc02f405dee694d8aeda56ed3271#code) exposes verifier() and setVerifier(address), which swap the key, not the scheme.

## Reviewer notes

### Mechanism

Bytecode only, no verified source. The runtime code calls the ecrecover precompile (offset 12043). Kev's trace of the sibling contract with identical design shows the signed swap entry (selector 0xa28c0efa) recovering a signer from a digest of the swap parameters. It compares that signer with verifier() and then calls UniswapV2Router02.swapTokensForExactTokens with the contract's own token balance. setVerifier(address) is owner-only and replaces the stored key address; it cannot change the signature scheme. Kev's classifier found no ERC-1271 path. Whether the signed payload fixes `to` was not established.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Rotating the key with setVerifier does not remove the ECDSA dependence

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
