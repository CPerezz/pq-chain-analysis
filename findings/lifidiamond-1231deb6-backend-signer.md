---
id: lifidiamond-1231deb6-backend-signer
format: 2
title: LI.FI diamond accepts ECDSA-signed bridge quotes a quantum attacker could forge
status: confirmed
severity: LOW
justification: Forged quotes move only the caller's own deposit, so LOW; the owner fixes it by cutting in facets
  with a PQ check.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1231deb6f5749ef6ce6943a275a1d3e7486f4eae'
  name: LiFiDiamond
  project: lifi
  code: verified
  code_url: https://etherscan.io/address/0x1231deb6f5749ef6ce6943a275a1d3e7486f4eae#code
  copies: 1
  admin: '0x55117eccc867db72aeb25f728ccf57c3c3b4faee'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 792004
impact: liveness
action: Replace the six facets via diamondCut with versions that verify a post-quantum backend signature.
evidence_level: source
checks:
- id: facet-lookup
  source: '0x1231deb6f5749ef6ce6943a275a1d3e7486f4eae'
  file: src/LiFiDiamond.sol
  has: address facet = ds.selectorToFacetAndPosition[msg.sig].facetAddress;
  line: 38
  says: Calls are routed to a facet by selector.
  for:
  - evidence-1
  - what
- id: fallback-delegatecall
  source: '0x1231deb6f5749ef6ce6943a275a1d3e7486f4eae'
  file: src/LiFiDiamond.sol
  has: let result := delegatecall(gas(), facet, 0, calldatasize(), 0, 0)
  line: 50
  says: Facet code runs via delegatecall in the diamond.
  for:
  - evidence-1
  - justification
  - what
- id: owner-set
  source: '0x1231deb6f5749ef6ce6943a275a1d3e7486f4eae'
  file: src/LiFiDiamond.sol
  has: LibDiamond.setContractOwner(_contractOwner);
  line: 10
  says: The diamond has an owner set at deployment.
  for:
  - action
  - evidence-2
  - justification
- id: cut-selector
  source: '0x1231deb6f5749ef6ce6943a275a1d3e7486f4eae'
  file: src/LiFiDiamond.sol
  has: functionSelectors[0] = IDiamondCut.diamondCut.selector;
  line: 15
  says: diamondCut is registered, allowing facet replacement.
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
  who: Review06 (Claude), 2026-11-17 review
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

LiFiDiamond routes each call by selector to a facet and runs it by delegatecall. Six bridge facets check an ECDSA quote signature from one backend key. A quantum attacker who derives that key can pass the check, but only with tokens the caller deposits.

## Evidence

- [fallback](https://etherscan.io/address/0x1231deb6f5749ef6ce6943a275a1d3e7486f4eae#code) looks up the facet for msg.sig and delegatecalls it, so facet checks run in the diamond.
- [constructor](https://etherscan.io/address/0x1231deb6f5749ef6ce6943a275a1d3e7486f4eae#code) sets the owner and registers diamondCut, through which facets are replaced.

## Reviewer notes

### Mechanism

LiFiDiamond.fallback (lines 27-62) reads ds.selectorToFacetAndPosition[msg.sig] (line 38) and delegatecalls the facet (line 50). Per kev, AcrossV4SwapFacet, SymbiosisFacet, LayerSwapFacet, UnitFacet, EcoFacet and NEARIntentsFacet each build an EIP-712 digest over the bridge data and require ECDSA.recover(digest, signature) == BACKEND_SIGNER, an immutable EOA. Funds enter via LibAsset.depositAsset from msg.sender and leave to the signed bridge, so a forged quote moves only the caller's tokens. The owner (timelock, set at line 10) can replace facets through diamondCut (registered at lines 15-21).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Pooled funds: the diamond holds dust and the six paths pull only from msg.sender.
- Ruled out: Other users' approvals cannot be pulled through these paths.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
