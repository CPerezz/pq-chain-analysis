---
id: blend-29469395-order-sig-ecdsa-only
format: 2
title: Blur Blend accepts ECDSA-only lender offers a quantum attacker could forge
status: confirmed
severity: HIGH
justification: Forged lender offers borrow lender ETH; the contract cannot be upgraded, so Blur must redeploy or
  lenders withdraw.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x29469395eaf6f95920e59f858042f0e28d98a20b'
  name: Blend
  project: blur
  code: verified
  code_url: https://etherscan.io/address/0xb258ca5559b11cd702f363796522b04d7722ea56#code
  proxy_of: '0xb258ca5559b11cd702f363796522b04d7722ea56'
  copies: 1
  upgradeable: 'yes'
  admin: '0xfa9fb502534761dbddacf5b7e2aa84684815f1bb'
value:
  usd: 1248
  basis: held
activity:
  txs_90d: 29975
impact: funds-loss
action: Deploy a new lending contract that verifies offers through the signer's account code (ERC-1271 or ERC-7913).
evidence_level: source
checks:
- id: c1
  source: '0xb258ca5559b11cd702f363796522b04d7722ea56'
  file: contracts/blend/lib/Signatures.sol
  line: 282
  has: address recoveredSigner = ecrecover(digest, v, r, s);
  says: The signer is recovered with ecrecover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: v-call
  source: '0xb258ca5559b11cd702f363796522b04d7722ea56'
  file: contracts/blend/lib/Signatures.sol
  has: _verify(lender, hashToSign, v, r, s);
  line: 247
  says: The lender's signature is verified for the offer.
  for:
  - justification
  - what
- id: v-oracle
  source: '0xb258ca5559b11cd702f363796522b04d7722ea56'
  file: contracts/blend/lib/Signatures.sol
  has: if (oracle != address(0)) {
  line: 250
  says: The oracle check is optional.
  for:
  - evidence-2
  - what
- id: v-cmp
  source: '0xb258ca5559b11cd702f363796522b04d7722ea56'
  file: contracts/blend/lib/Signatures.sol
  has: if (recoveredSigner == address(0) || signer != recoveredSigner) {
  line: 283
  says: The recovered address must equal the signer.
  for:
  - evidence-1
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: review (Review01)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
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

Blend lends a lender's Blur Pool ETH against NFTs when the lender's signed offer passes ecrecover. A quantum attacker with a lender's key signs an offer naming no oracle, skipping the co-signature, and borrows that ETH.

## Evidence

- [_verify](https://etherscan.io/address/0xb258ca5559b11cd702f363796522b04d7722ea56#code) accepts a signature when ecrecover returns the lender address, with no contract-account check.
- [_verifyOfferAuthorization](https://etherscan.io/address/0xb258ca5559b11cd702f363796522b04d7722ea56#code) checks the oracle signature only if the offer's oracle field is nonzero.

## Reviewer notes

### Mechanism

borrow -> _borrow -> _takeLoanOffer -> OfferController._validateOffer (line 30) -> Signatures._verifyOfferAuthorization(offerHash, lender, oracle, signature). Line 247 calls _verify(lender, ...), which at lines 282-283 runs ecrecover(digest, v, r, s) and compares it to the lender. There is no ERC-1271 path. The oracle check at lines 250-267 runs only if oracle != address(0). The oracle is part of the lender-signed offer (line 186), so a forged offer sets it to zero. The forged offer also names the attacker's collection. borrow then pulls loanAmount from offer.lender on Blur Pool. The upgrade paths (upgradeTo, transferOwnership) are owner-gated, and per kev's finding the owner Safe can no longer sign.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Blend's own token holdings are not the exposure; lender deposits in Blur Pool are.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
