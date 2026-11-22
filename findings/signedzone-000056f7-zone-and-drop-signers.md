---
id: signedzone-000056f7-zone-and-drop-signers
format: 2
title: OpenSea SignedZone trusts ECDSA co-signatures a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Signer scheme is fixed in code; OpenSea must deploy a new zone with a post-quantum signer and move
  orders to it.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x000056f7000000ece9003ca63978907a00ffd100'
  name: SignedZone
  project: opensea
  code: verified
  code_url: https://etherscan.io/address/0x000056f7000000ece9003ca63978907a00ffd100#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 305691
impact: funds-loss
action: Deploy a zone that verifies a post-quantum signer, point restricted orders at it and deactivate the ECDSA
  signers.
evidence_level: source
checks:
- id: c1
  source: '0x000056f7000000ece9003ca63978907a00ffd100'
  file: src/main/zones/signed-zone/interfaces/SignedZoneControllerInterface.sol
  line: 81
  has: function updateSigner(
  says: The controller can turn signers on or off for a zone.
  for:
  - action
  - evidence-3
- id: s-notice
  source: '0x000056f7000000ece9003ca63978907a00ffd100'
  file: src/main/zones/signed-zone/signed-zone-sub-1/SignedZone.sol
  has: SignedZone is an implementation of SIP-7 that requires orders
  line: 30
  says: The zone requires orders to be co-signed by an approved signer.
  for:
  - evidence-1
  - justification
  - what
- id: s-signers
  source: '0x000056f7000000ece9003ca63978907a00ffd100'
  file: src/main/zones/signed-zone/signed-zone-sub-1/SignedZone.sol
  has: mapping(address => bool) private _signers;
  line: 39
  says: Signers are stored as plain addresses (ECDSA keys).
  for:
  - evidence-2
  - justification
  - what
- id: s-controller
  source: '0x000056f7000000ece9003ca63978907a00ffd100'
  file: src/main/zones/signed-zone/signed-zone-sub-1/SignedZone.sol
  has: address private immutable _controller;
  line: 36
  says: The controller is immutable and set at deployment.
  for:
  - action
  - evidence-3
  - justification
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review13 (re-read verified source on Sourcify; controller and owner reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
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

SignedZone lets Seaport fill a restricted order only when an approved signer has co-signed it. A quantum attacker who recovers that signer key can fill restricted orders OpenSea would refuse.

## Evidence

- [SignedZone](https://etherscan.io/address/0x000056f7000000ece9003ca63978907a00ffd100#code) requires orders to be signed by an approved signer.
- [Approved signers](https://etherscan.io/address/0x000056f7000000ece9003ca63978907a00ffd100#code) are kept as a list of plain addresses, so a signer is an ECDSA key.
- [The controller](https://etherscan.io/address/0x000056f7000000ece9003ca63978907a00ffd100#code) is fixed at deployment and only switches signers on or off.

## Reviewer notes

### Mechanism

Seaport calls authorizeOrder(zoneParameters) (line 148) for restricted orders. The zone reads expectedFulfiller and expiration from extraData and builds the EIP-712 signedOrderHash (lines 331-344). It recovers the signer with inline ecrecover over a 64-byte EIP-2098 signature (_recoverSigner, lines 669+ and 747-755). It reverts unless _signers[recoveredSigner] (line 39 mapping, lines 347-352). Signers are set only through the immutable _controller (line 36) via updateSigner (_updateSigner, line 516). The active signer has signed on-chain, so its public key is exposed. A recovered key lets an attacker produce co-signatures for stale orders or other fulfillers. The maker's own Seaport signature is still needed.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No proxy: the verification code is not upgradeable.
- Ruled out: The zone holds no funds; the exposure is the makers' restricted orders.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
