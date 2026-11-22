---
id: contract-62b3aa5a-barz-passkey
format: 2
title: Trust Wallet Barz wallet relies on a P-256 passkey a quantum attacker can break
status: candidate
severity: MEDIUM
justification: 'Swappable facets need a post-quantum one in Trust Wallet''s registry first, then the owner migrates:
  MEDIUM.'
category: quantum-exposure
pattern: PQ-9
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x62b3aa5a0b99074b5d8a983c130845cef930057e'
  project: trust-wallet
  code: decompiled
  code_url: code/0xe152e0d0626438840037db419d2e66fa32002f1ee719b1dbe2892314bc67b6de.sol
  copies: 1
  admin: '0x0000000000000000000000000000000000000020'
value:
  usd: 151
  basis: held
activity:
  txs_90d: 287
impact: funds-loss
action: Register a post-quantum verification facet, ship app support, and have owners replace the P-256 facet via
  diamondCut.
evidence_level: bytecode
checks:
- id: code
  code: '0x62b3aa5a0b99074b5d8a983c130845cef930057e'
  is: contract
  bytes: 573
  says: The address holds contract code (the Barz proxy).
  for:
  - evidence-1
  - justification
  - what
- id: sel-facetaddress
  selector: '0x62b3aa5a0b99074b5d8a983c130845cef930057e'
  fn: facetAddress(bytes4)
  says: The proxy code calls facetAddress (0xcdffacc6) to resolve facets.
  for:
  - action
  - evidence-1
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
  who: Review14 (facet source, facet sample, family balances)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This Barz wallet is a diamond proxy that delegates each call to the facet registered for its function selector. Its owner key is a P-256 passkey; a quantum attacker who recovers it can sign operations and drain the wallet.

## Evidence

- [Proxy code](https://etherscan.io/address/0x62b3aa5a0b99074b5d8a983c130845cef930057e#code) routes calls to facets by selector and queries facetAddress for unknown ones.

## Reviewer notes

### Mechanism

The 573-byte proxy fallback looks up the facet for msg.sig in diamond storage and delegatecalls it. If none is set, it staticcalls facetAddress(bytes4) (selector 0xcdffacc6) on a default handler. Per kev's finding, validateUserOp in AccountFacet calls the verification facet's validateOwnerSignature, and isValidSignature routes there directly. Secp256r1VerificationFacet checks the signature against the stored P-256 owner key through LibSecp256r1.Verify, which uses the modexp precompile. diamondCut is enforceIsSelf and accepts only facets registered in the FacetRegistry, and that registry holds no post-quantum facet.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Rotating the passkey only swaps one P-256 key for another.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
