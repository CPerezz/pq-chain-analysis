---
id: contract-c5aea9e1-barz-passkey
format: 2
title: Barz passkey wallet relies on a P-256 key a quantum attacker could recover
status: candidate
severity: MEDIUM
justification: 'MEDIUM: Trust Wallet must register a post-quantum verification facet, then each owner must swap
  facets.'
category: quantum-exposure
pattern: PQ-9
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc5aea9e1fcc733a36fff56fd17bcd0be615fe225'
  project: trust-wallet
  code: decompiled
  code_url: code/0xe152e0d0626438840037db419d2e66fa32002f1ee719b1dbe2892314bc67b6de.sol
  copies: 1
  admin: '0x0000000000000000000000000000000000000020'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 2
impact: funds-loss
action: Register a post-quantum verification facet in FacetRegistry and ship wallet support so owners can replace
  the P-256 facet.
evidence_level: bytecode
checks:
- id: code
  code: '0xc5aea9e1fcc733a36fff56fd17bcd0be615fe225'
  is: contract
  bytes: 573
  says: The address holds 573 bytes of contract code (a Barz proxy).
  for:
  - action
  - evidence-1
  - justification
  - what
- id: sel-facetaddress
  selector: '0xc5aea9e1fcc733a36fff56fd17bcd0be615fe225'
  fn: facetAddress(bytes4)
  says: The proxy calls facetAddress(bytes4) to route unknown selectors to facets.
  for:
  - evidence-1
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review14 (facet source, facet sample, family balances)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This address is a Trust Wallet Barz smart-account proxy that forwards each call to the facet registered for the call's function selector. Signature checks run in the verification facet it delegates to, not in this proxy.

## Evidence

- [Proxy code](https://etherscan.io/address/0xc5aea9e1fcc733a36fff56fd17bcd0be615fe225#code) is 573 bytes and looks up unknown selectors through facetAddress(bytes4).

## Reviewer notes

### Mechanism

The proxy fallback reads the facet for msg.sig from a diamond storage mapping and delegatecalls it. If no facet is stored, it staticcalls facetAddress(bytes4) (selector 0xcdffacc6) on a default handler. According to kev's finding, validateUserOp (AccountFacet) calls validateOwnerSignature in Secp256r1VerificationFacet. That facet verifies a P-256 signature against the stored owner public key using LibSecp256r1 with modexp. A quantum attacker who recovers the private key from the public key can sign UserOperations. diamondCut is limited to facets registered in Trust Wallet's FacetRegistry, and none of those is post-quantum. The facet in use at this address was not checked here: no verified source is available for it.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Changing the passkey only swaps one P-256 key for another.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
