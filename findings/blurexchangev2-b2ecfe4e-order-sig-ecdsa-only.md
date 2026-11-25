---
id: blurexchangev2-b2ecfe4e-order-sig-ecdsa-only
format: 2
title: BlurExchangeV2 accepts ECDSA-only maker orders a quantum attacker could forge
status: confirmed
severity: HIGH
justification: Maker orders rely on ecrecover alone; with no approved oracle every trade reverts, so nothing is
  taken here.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb2ecfe4e4d61f8790bbb9de2d1259b9e2410cea5'
  name: BlurExchangeV2
  project: blur
  code: verified
  code_url: https://etherscan.io/address/0x5fa60726e62c50af45ff2f6280c468da438a7837#code
  proxy_of: '0x5fa60726e62c50af45ff2f6280c468da438a7837'
  copies: 1
  upgradeable: 'yes'
  admin: '0xfa9fb502534761dbddacf5b7e2aa84684815f1bb'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 21044
impact: liveness
action: Deploy a new exchange that verifies maker orders through the signer's account code (ERC-1271 or ERC-7913).
evidence_level: source
checks:
- id: c1
  source: '0x5fa60726e62c50af45ff2f6280c468da438a7837'
  file: contracts/exchangeV2/Signatures.sol
  line: 326
  has: address recoveredSigner = ecrecover(digest, v, r, s);
  says: _verify uses raw ecrecover
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x5fa60726e62c50af45ff2f6280c468da438a7837'
  file: contracts/exchangeV2/BlurExchangeV2.sol
  line: 87
  has: function setOracle(address oracle, bool approved) external onlyOwner {
  says: setOracle is owner-only
  for:
  - evidence-3
- id: s-oracle
  source: '0x5fa60726e62c50af45ff2f6280c468da438a7837'
  file: contracts/exchangeV2/Signatures.sol
  has: if (oracles[oracle] == 0) {
  line: 302
  says: trade path checks the oracle is approved
  for:
  - evidence-2
  - justification
  - what
- id: s-unauth
  source: '0x5fa60726e62c50af45ff2f6280c468da438a7837'
  file: contracts/exchangeV2/Signatures.sol
  has: revert UnauthorizedOracle();
  line: 303
  says: unapproved oracle makes the call revert
  for:
  - evidence-2
  - justification
  - what
- id: s-auth
  source: '0x5fa60726e62c50af45ff2f6280c468da438a7837'
  file: contracts/exchangeV2/Signatures.sol
  has: authorized = _verify(signer, hashToSign, v, r, s);
  line: 276
  says: maker order authorization uses _verify
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

BlurExchangeV2 accepts a maker's order when ecrecover returns the trader's address. Every trade first needs an approved oracle's signature, and with none approved a forged order reverts before funds move.

## Evidence

- [_verify](https://etherscan.io/address/0x5fa60726e62c50af45ff2f6280c468da438a7837#code) accepts a signature when ecrecover returns the expected signer.
- [verifyOracleSignature](https://etherscan.io/address/0x5fa60726e62c50af45ff2f6280c468da438a7837#code) reverts with UnauthorizedOracle when the oracle is not approved.
- [setOracle](https://etherscan.io/address/0x5fa60726e62c50af45ff2f6280c468da438a7837#code) is restricted to the owner.

## Reviewer notes

### Mechanism

takeAsk/takeBid/takeAskSingle/takeBidSingle and the *Pool wrappers check maker orders through Signatures._verifyAuthorization (line 276) -> _verify, which compares ecrecover(digest, v, r, s) (line 326) with the trader. There is no ERC-1271 path. Each entry point first runs the verifyOracleSignature modifier. It reverts with UnauthorizedOracle when oracles[oracle] == 0 (lines 302-303). Per kev, the only approved oracle was removed at block 26,401,100. setOracle (line 87) is onlyOwner, and kev finds the owner Safe can no longer act. So trades revert and a forged maker order releases nothing through this contract.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Funds loss through this contract: no approved oracle, so trades revert before transfer.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
