---
id: gmtokenmanager-2c158bc4-gm-attestation-signer
format: 2
title: Ondo Global Markets accepts ECDSA price quotes a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: One ECDSA signer key approves every mint/redeem quote; the check is hard-coded, so Ondo must deploy
  a new manager.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2c158bc456e027b2affccadf1bdbd9f5fc4c5c8c'
  name: GMTokenManager
  project: ondo
  code: verified
  code_url: https://etherscan.io/address/0x2c158bc456e027b2affccadf1bdbd9f5fc4c5c8c#code
  copies: 1
value:
  usd: 0
  basis: held
activity:
  txs_90d: 134669
impact: funds-loss
action: Deploy a token manager that verifies post-quantum attestation signatures and move GM and USDon mint roles
  to it.
evidence_level: source
checks:
- id: c1
  source: '0x2c158bc456e027b2affccadf1bdbd9f5fc4c5c8c'
  file: contracts/globalMarkets/tokenManager/GMTokenManager.sol
  line: 363
  has: address signer = ECDSA.recover(digest, signature);
  says: _verifyQuote recovers the quote signer with ECDSA.recover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: role
  source: '0x2c158bc456e027b2affccadf1bdbd9f5fc4c5c8c'
  file: contracts/globalMarkets/tokenManager/GMTokenManager.sol
  has: if (!hasRole(ATTESTATION_SIGNER_ROLE, signer))
  line: 364
  says: Recovered signer must hold ATTESTATION_SIGNER_ROLE.
  for:
  - evidence-2
  - justification
  - what
- id: oracle
  source: '0x2c158bc456e027b2affccadf1bdbd9f5fc4c5c8c'
  file: contracts/globalMarkets/tokenManager/GMTokenManager.sol
  has: sanityCheckOracle.validatePrice(quote.asset, quote.price);
  line: 340
  says: Quote price is checked against the sanity-check oracle.
  for:
  - evidence-3
  - what
- id: uid
  source: '0x2c158bc456e027b2affccadf1bdbd9f5fc4c5c8c'
  file: contracts/globalMarkets/tokenManager/GMTokenManager.sol
  has: if (userId != quote.userId) revert UserIdMismatch(userId, quote.userId);
  line: 336
  says: Quote must match the caller's registered user id.
  for:
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
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

The token manager mints and redeems GM tokens against price quotes, and accepts a quote only if ECDSA recovers a holder of ATTESTATION_SIGNER_ROLE. A quantum attacker who recovers the signer key can sign quotes for a registered account at prices the sanity-check oracle allows.

## Evidence

- [_verifyQuote](https://etherscan.io/address/0x2c158bc456e027b2affccadf1bdbd9f5fc4c5c8c#code) recovers the quote signer with ECDSA.recover.
- [_verifyQuote](https://etherscan.io/address/0x2c158bc456e027b2affccadf1bdbd9f5fc4c5c8c#code) reverts unless the recovered signer holds ATTESTATION_SIGNER_ROLE.
- [_verifyQuote](https://etherscan.io/address/0x2c158bc456e027b2affccadf1bdbd9f5fc4c5c8c#code) checks the quoted price against the sanity-check oracle.

## Reviewer notes

### Mechanism

mintWithAttestation and redeemWithAttestation (lines 171-316) call _verifyQuote (lines 325-366). It checks replay (331), expiry (334), userId match (336), issuance hours (338), sanityCheckOracle.validatePrice (340), token registration (342) and chain id (344), builds an EIP-712 digest (346-361), then ECDSA.recover (363, via ecrecover in ECDSA.sol line 152) must yield an ATTESTATION_SIGNER_ROLE holder (364-365). A forged quote is limited by the oracle deviation and the rate limiter. The recover call is hard-coded, so rotating the signer key does not remove the ECDSA dependence.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Rotating the signer key does not fix the ECDSA dependence.
- Ruled out: The contract holds no pool of funds; exposure is minted tokens.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
