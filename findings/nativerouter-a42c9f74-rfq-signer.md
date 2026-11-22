---
id: nativerouter-a42c9f74-rfq-signer
format: 2
title: Paused Native router trusts ECDSA quote signers a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Router signer is one ECDSA key; owner can rotate it but not the scheme, so Native must deploy a new
  router.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa42c9f74ac8cb3d957ec1bd1c96b9ccecc1950aa'
  name: NativeRouter
  project: native
  code: verified
  code_url: https://etherscan.io/address/0xa42c9f74ac8cb3d957ec1bd1c96b9ccecc1950aa#code
  copies: 1
  admin: '0x83fc28e6962e41e38f7854308eff827e3f6b906b'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a router that verifies quote signatures with a post-quantum scheme and whitelist it instead of this
  one.
evidence_level: source
checks:
- id: c4
  source: '0xa42c9f74ac8cb3d957ec1bd1c96b9ccecc1950aa'
  file: src/NativeRouter.sol
  line: 324
  has: address recoveredSigner = ECDSA.recover(digest, quote.widgetFeeSignature);
  says: Router recovers the widget-fee signer with ECDSA.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c6
  source: '0xa42c9f74ac8cb3d957ec1bd1c96b9ccecc1950aa'
  file: lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: ECDSA.recover uses the ecrecover precompile (secp256k1).
  for:
  - what
- id: c8
  source: '0xa42c9f74ac8cb3d957ec1bd1c96b9ccecc1950aa'
  file: src/NativeRouter.sol
  line: 203
  has: function setSigner(address signer, bool isSigner) public onlyOwner {
  says: Owner can add or remove router signer addresses.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c9
  source: '0xa42c9f74ac8cb3d957ec1bd1c96b9ccecc1950aa'
  file: src/NativeRouter.sol
  line: 236
  has: function pause() external onlyOwner {
  says: Owner can pause the router.
  for:
  - evidence-3
  - what
- id: r326
  source: '0xa42c9f74ac8cb3d957ec1bd1c96b9ccecc1950aa'
  file: src/NativeRouter.sol
  has: require(signers[recoveredSigner], ErrorsLib.InvalidSignature());
  line: 326
  says: Recovered address must be in the signers whitelist.
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
  who: Review17 (Sourcify source, on-chain and Blockscout reads)
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

This NativeRouter executes RFQ trades and accepts a quote only if ECDSA recovers a whitelisted signer from the widget-fee signature. A quantum attacker who recovers that signer key can authorize trades through this router; the owner can pause it and rotate signers.

## Evidence

- [_verifyRFQSignature](https://etherscan.io/address/0xa42c9f74ac8cb3d957ec1bd1c96b9ccecc1950aa#code) accepts a quote only if ECDSA recovers a whitelisted signer.
- [setSigner](https://etherscan.io/address/0xa42c9f74ac8cb3d957ec1bd1c96b9ccecc1950aa#code) lets the owner add or remove signer addresses, not change the scheme.
- [pause](https://etherscan.io/address/0xa42c9f74ac8cb3d957ec1bd1c96b9ccecc1950aa#code) lets the owner stop RFQ trades.

## Reviewer notes

### Mechanism

NativeRouter.tradeRFQT (line 81, whenNotPaused) calls _verifyRFQSignature (297-327), which hashes the quote with EIP-712 and runs ECDSA.recover(digest, quote.widgetFeeSignature) at line 324, requiring signers[recoveredSigner] at 326. If isNativePools[quote.pool], the router sends seller tokens to the pool's treasury and calls NativeRFQPool.tradeRFQT (line 120), where the market maker's ECDSA quote signature is also checked (NativeRFQPool line 234) before the vault pays out. Signers are set by the owner via setSigner (203); pause (236) stops trades. The bundled CreditVault checks settle/removeCollateral/liquidate approvals with ECDSA (561, 585, 610). All rely on secp256k1; rotating keys does not change the scheme.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The router itself holds about $0.
- Ruled out: No calls to this router in the study's 30-day window.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
