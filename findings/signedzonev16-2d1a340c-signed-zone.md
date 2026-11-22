---
id: signedzonev16-2d1a340c-signed-zone
format: 2
title: Reservoir oracle zone trusts ECDSA co-signers a quantum attacker could forge
status: confirmed
severity: LOW
justification: Forged co-signatures fill orders makers cancelled off-chain; LOW because the zone owner can remove
  the signers.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2d1a340cd83434243d090931afabf95b7d3078b0'
  name: SignedZoneV16
  project: reservoir
  code: verified
  code_url: https://etherscan.io/address/0x2d1a340cd83434243d090931afabf95b7d3078b0#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Remove the three ECDSA signers via the zone controller; deploy a new zone with a post-quantum co-signer
evidence_level: source
checks:
- id: c1
  source: '0x2d1a340cd83434243d090931afabf95b7d3078b0'
  file: contracts/seaport-oracle/zones/interfaces/SignedZoneControllerInterface.sol
  line: 90
  has: function updateSigner(
  says: the controller can switch a zone's signer on or off
  for:
  - action
  - evidence-3
  - justification
- id: s-ecrec
  source: '0x2d1a340cd83434243d090931afabf95b7d3078b0'
  file: contracts/seaport-oracle/zones/SignedZoneV16.sol
  has: Ecrecover_precompile, // Call ecrecover precompile.
  line: 505
  says: the co-signature is checked with the ecrecover precompile
  for:
  - evidence-1
  - justification
  - what
- id: s-signers
  source: '0x2d1a340cd83434243d090931afabf95b7d3078b0'
  file: contracts/seaport-oracle/zones/SignedZoneV16.sol
  has: mapping(address => bool) private _signers;
  line: 33
  says: the zone stores the set of authorized signers
  for:
  - evidence-2
  - what
- id: s-controller
  source: '0x2d1a340cd83434243d090931afabf95b7d3078b0'
  file: contracts/seaport-oracle/zones/SignedZoneV16.sol
  has: address private immutable _controller;
  line: 30
  says: the zone has a fixed controller
  for:
  - evidence-2
- id: s-doc
  source: '0x2d1a340cd83434243d090931afabf95b7d3078b0'
  file: contracts/seaport-oracle/zones/SignedZoneV16.sol
  has: to be signed by an approved signer.
  line: 21
  says: orders must be co-signed by an approved signer
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
  who: Review13 (re-read verified source on Sourcify; controller, owner and signer reads; attribution)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This Seaport zone lets an order be filled only when an approved signer co-signs it. It checks that co-signature with the ecrecover precompile. A quantum attacker who recovers a signer key can co-sign fills of orders the oracle would refuse, including ones makers cancelled off-chain.

## Evidence

- [SignedZoneV16](https://etherscan.io/address/0x2d1a340cd83434243d090931afabf95b7d3078b0#code) recovers the co-signer with the ecrecover precompile.
- [SignedZoneV16](https://etherscan.io/address/0x2d1a340cd83434243d090931afabf95b7d3078b0#code) keeps a mapping of authorized signers, managed by its controller.
- The [controller interface](https://etherscan.io/address/0x2d1a340cd83434243d090931afabf95b7d3078b0#code) has updateSigner to switch a zone's signer on or off.

## Reviewer notes

### Mechanism

Seaport calls SignedZoneV16.authorizeOrder (line 109) for restricted orders naming the zone. It reads the expected fulfiller, the expiration and the context from extraData. It then derives the EIP-712 signed-order hash and recovers the signer in _recoverSigner (lines 434-524) with an inline staticcall to the ecrecover precompile (lines 502-509). It reverts with SignerNotActive unless _signers[recovered] is true (lines 230-234). Only the controller changes _signers (_updateSigner, _assertCallerIsController), through SignedZoneControllerInterface.updateSigner (line 90), for the zone owner. The maker's own Seaport signature is still required, so a forged co-signature only releases items at the maker's signed terms.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Zone holds no funds and has no proxy or owner of its own
- Ruled out: Maker's Seaport signature is not bypassed

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
