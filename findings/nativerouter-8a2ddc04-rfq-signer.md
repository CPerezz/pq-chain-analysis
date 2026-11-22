---
id: nativerouter-8a2ddc04-rfq-signer
format: 2
title: Native router trusts ECDSA quote signers a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged quotes can pay out CreditVault funds, and the fix is a new Native deployment.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x8a2ddc0461fcf96f81a05529bed540d4f1eb2a00'
  name: NativeRouter
  project: native
  code: verified
  code_url: https://etherscan.io/address/0x8a2ddc0461fcf96f81a05529bed540d4f1eb2a00#code
  copies: 1
  admin: '0x83fc28e6962e41e38f7854308eff827e3f6b906b'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 102887
impact: funds-loss
action: Deploy a router and pools that verify post-quantum signatures, whitelist them, and pause this router.
evidence_level: source
checks:
- id: c1
  source: '0x8a2ddc0461fcf96f81a05529bed540d4f1eb2a00'
  file: src/NativeRouter.sol
  line: 349
  has: address recoveredSigner = ECDSA.recover(digest, quote.widgetFeeSignature);
  says: RFQ widget-fee signature is checked with ECDSA.recover.
  for:
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x8a2ddc0461fcf96f81a05529bed540d4f1eb2a00'
  file: src/NativeRouter.sol
  line: 373
  has: address recoveredSigner = ECDSA.recover(digest, params.signature);
  says: External swap signature is checked with ECDSA.recover.
  for:
  - what
- id: c6
  source: '0x8a2ddc0461fcf96f81a05529bed540d4f1eb2a00'
  file: src/NativeRFQPool.sol
  line: 235
  has: require(quote.signer == ECDSA.recover(digest, quote.signature), ErrorsLib.InvalidSignature());
  says: Pool accepts a quote only if ECDSA recovers the market-maker signer.
  for:
  - evidence-2
  - justification
  - what
- id: c9
  source: '0x8a2ddc0461fcf96f81a05529bed540d4f1eb2a00'
  file: src/NativeRouter.sol
  line: 230
  has: function setSigner(address signer, bool isSigner) public onlyOwner {
  says: Owner can add or remove signer addresses.
  for:
  - action
  - evidence-3
  - justification
- id: c10
  source: '0x8a2ddc0461fcf96f81a05529bed540d4f1eb2a00'
  file: src/NativeRouter.sol
  line: 260
  has: function pause() external onlyOwner {
  says: Owner can pause the router.
  for:
  - action
- id: new-req
  source: '0x8a2ddc0461fcf96f81a05529bed540d4f1eb2a00'
  file: src/NativeRouter.sol
  has: require(signers[recoveredSigner], ErrorsLib.InvalidSignature());
  line: 351
  says: Recovered RFQ signer must be in the owner-set signers map.
  for:
  - evidence-1
  - what
- id: new-pool
  source: '0x8a2ddc0461fcf96f81a05529bed540d4f1eb2a00'
  file: src/NativeRouter.sol
  has: NativeRFQPool(payable(quote.pool)).tradeRFQT(effectiveSellerTokenAmount, quote);
  line: 121
  says: Router forwards the verified quote to the pool for execution.
  for:
  - evidence-2
  - what
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

This router executes RFQ trades and external swaps after ECDSA recovers a signer that the owner listed as authorized. A quantum attacker who recovers that signer key and a market maker's key can sign quotes that make a Native pool pay out CreditVault funds.

## Evidence

- [_verifyRFQSignature](https://etherscan.io/address/0x8a2ddc0461fcf96f81a05529bed540d4f1eb2a00#code) requires the ECDSA-recovered widget-fee signer to be in `signers`.
- [tradeRFQT](https://etherscan.io/address/0x8a2ddc0461fcf96f81a05529bed540d4f1eb2a00#code) then calls the whitelisted pool, whose quote check is ECDSA over the market maker's signature.
- [setSigner](https://etherscan.io/address/0x8a2ddc0461fcf96f81a05529bed540d4f1eb2a00#code) lets the owner rotate signer addresses, but the scheme stays ECDSA.

## Reviewer notes

### Mechanism

NativeRouter.tradeRFQT (line 72) requires isNativePools[quote.pool] (line 81) and calls _verifyRFQSignature (line 83), which builds an EIP-712 digest and does ECDSA.recover(digest, quote.widgetFeeSignature) (line 349), requiring signers[recoveredSigner] (line 351). It then calls NativeRFQPool.tradeRFQT (line 121); the pool's _verifyPMMSignature requires quote.signer == ECDSA.recover(digest, quote.signature) (NativeRFQPool line 235) and pays the recipient from its treasury, the CreditVault. externalSwap (line 126) checks params.signature via ECDSA.recover at line 373 against the same signers set. Owner setSigner (230) and pause (260) rotate keys or halt trading but cannot change the scheme; the contract is not a proxy, so the fix is a new deployment.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The router itself holds about $0; funds at risk sit in the CreditVault.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
