---
id: nativerouter-a540ec8c-rfq-signer
format: 2
title: Native RFQ router accepts ECDSA quote signatures a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Router trusts one ECDSA signer set; owner can only rotate keys, so the fix is a new post-quantum
  router deployment.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa540ec8c73322200d68e1b86c471a5c850854f22'
  name: NativeRouter
  project: native
  code: verified
  code_url: https://etherscan.io/address/0xa540ec8c73322200d68e1b86c471a5c850854f22#code
  copies: 1
  admin: '0x83fc28e6962e41e38f7854308eff827e3f6b906b'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 13621
impact: funds-loss
action: Deploy a router and pools that verify post-quantum quote and widget-fee signatures, whitelist them and retire
  this router.
evidence_level: source
checks:
- id: c1
  source: '0xa540ec8c73322200d68e1b86c471a5c850854f22'
  file: src/NativeRouter.sol
  line: 283
  has: address recoveredSigner = ECDSA.recover(digest, quote.widgetFeeSignature);
  says: Router recovers the widget-fee signer with ECDSA.recover.
  for:
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xa540ec8c73322200d68e1b86c471a5c850854f22'
  file: lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: ECDSA.recover relies on the ecrecover precompile (secp256k1).
  for:
  - evidence-1
  - what
- id: c3
  source: '0xa540ec8c73322200d68e1b86c471a5c850854f22'
  file: src/NativeRFQPool.sol
  line: 235
  has: require(quote.signer == ECDSA.recover(digest, quote.signature), ErrorsLib.InvalidSignature());
  says: Pool requires the market maker's quote signature to ECDSA-recover to quote.signer.
  for:
  - evidence-3
  - what
- id: c7
  source: '0xa540ec8c73322200d68e1b86c471a5c850854f22'
  file: src/NativeRouter.sol
  line: 175
  has: function setSigner(address signer, bool isSigner) public onlyOwner {
  says: Owner can only set signer addresses on the router.
  for:
  - action
  - evidence-2
  - justification
- id: c8
  source: '0xa540ec8c73322200d68e1b86c471a5c850854f22'
  file: src/NativeRouter.sol
  line: 194
  has: function pause() external onlyOwner {
  says: Owner can pause the router.
  for:
  - action
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

This NativeRouter runs RFQ trades against whitelisted pools if ECDSA recovers a whitelisted signer from the widget-fee signature. A quantum attacker with that signer key and a market maker's quote key can push forged trades that pay out of the CreditVault.

## Evidence

- [_verifyRFQSignature](https://etherscan.io/address/0xa540ec8c73322200d68e1b86c471a5c850854f22#code) recovers the signer of quote.widgetFeeSignature with ECDSA.
- [setSigner](https://etherscan.io/address/0xa540ec8c73322200d68e1b86c471a5c850854f22#code) lets the owner add or remove signer addresses, not change the signature scheme.
- The pool's [_verifyPMMSignature](https://etherscan.io/address/0xa540ec8c73322200d68e1b86c471a5c850854f22#code) requires the market maker's ECDSA quote signature.

## Reviewer notes

### Mechanism

NativeRouter.tradeRFQT (line 69) requires isNativePools[quote.pool] (line 78) and calls _verifyRFQSignature (line 80). That function builds an EIP-712 digest over the quote and widget fee and calls ECDSA.recover(digest, quote.widgetFeeSignature) (line 283), which uses ecrecover (ECDSA.sol line 139); the recovered address must be in signers (line 285). The router then transfers the seller token to the pool's treasury (the CreditVault) and calls NativeRFQPool.tradeRFQT (line 118), where _verifyPMMSignature (NativeRFQPool.sol line 235) requires quote.signer == ECDSA.recover(digest, quote.signature) before the pool pays the taker from the vault. The owner can rotate signers via setSigner (line 175) and pause (line 194) but cannot change the scheme.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The router itself holds about $0; the exposed funds sit in the CreditVault.
- Ruled out: A forged router signature alone is not enough; a market-maker quote key is also needed.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
