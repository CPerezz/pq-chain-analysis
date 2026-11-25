---
id: nativerouter-0f9f2366-rfq-signer
format: 2
title: Paused Native router trusts ECDSA fee signatures a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: The router's trade check is ECDSA only; the owner Safe can rotate signers or pause, but a fix needs
  a new deployment.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0f9f2366c6157f2acd3c2bfa45cd9031c152d2cf'
  name: NativeRouter
  project: native
  code: verified
  code_url: https://etherscan.io/address/0x0f9f2366c6157f2acd3c2bfa45cd9031c152d2cf#code
  copies: 1
  admin: '0x83fc28e6962e41e38f7854308eff827e3f6b906b'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a router whose quote and widget-fee checks verify post-quantum signatures, and retire this one.
evidence_level: source
checks:
- id: c1
  source: '0x0f9f2366c6157f2acd3c2bfa45cd9031c152d2cf'
  file: src/NativeRouter.sol
  line: 275
  has: address recoveredSigner = ECDSA.recover(digest, quote.widgetFeeSignature);
  says: Router recovers the widget-fee signer with ECDSA.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x0f9f2366c6157f2acd3c2bfa45cd9031c152d2cf'
  file: lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: ECDSA.recover uses the ecrecover precompile.
  for:
  - what
- id: c3
  source: '0x0f9f2366c6157f2acd3c2bfa45cd9031c152d2cf'
  file: src/NativeRFQPool.sol
  line: 233
  has: require(quote.signer == ECDSA.recover(digest, quote.signature), ErrorsLib.InvalidSignature());
  says: Pool accepts market-maker quotes by ECDSA recovery.
  for:
  - what
- id: c7
  source: '0x0f9f2366c6157f2acd3c2bfa45cd9031c152d2cf'
  file: src/NativeRouter.sol
  line: 167
  has: function setSigner(address signer, bool isSigner) public onlyOwner {
  says: Owner can add or remove signer addresses.
  for:
  - action
  - evidence-3
  - justification
- id: c8
  source: '0x0f9f2366c6157f2acd3c2bfa45cd9031c152d2cf'
  file: src/NativeRouter.sol
  line: 186
  has: function pause() external onlyOwner {
  says: Owner can pause the router.
  for:
  - justification
- id: r-pool
  source: '0x0f9f2366c6157f2acd3c2bfa45cd9031c152d2cf'
  file: src/NativeRouter.sol
  has: require(isNativePools[quote.pool], ErrorsLib.InvalidNativePool());
  line: 77
  says: Trades go only to owner-whitelisted Native pools.
  for:
  - what
- id: r-signers
  source: '0x0f9f2366c6157f2acd3c2bfa45cd9031c152d2cf'
  file: src/NativeRouter.sol
  has: require(signers[recoveredSigner], ErrorsLib.InvalidSignature());
  line: 277
  says: Recovered ECDSA address must be an authorized signer.
  for:
  - evidence-1
- id: r-pause
  source: '0x0f9f2366c6157f2acd3c2bfa45cd9031c152d2cf'
  file: src/NativeRouter.sol
  has: external payable override nonReentrant whenNotPaused
  line: 73
  says: tradeRFQT is blocked while the router is paused.
  for:
  - evidence-2
  - what
- id: r-call
  source: '0x0f9f2366c6157f2acd3c2bfa45cd9031c152d2cf'
  file: src/NativeRouter.sol
  has: NativeRFQPool(payable(quote.pool)).tradeRFQT(effectiveSellerTokenAmount, quote);
  line: 110
  says: Router hands the verified quote to the pool for settlement.
  for:
  - evidence-2
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
reviews: []
related: []
---

## What happens

This NativeRouter forwards RFQ trades to whitelisted Native pools after Native's signer approves the quote's widget fee with an ECDSA signature. A quantum attacker who recovers that key and a market maker's key can forge trades the pool pays from its treasury if the router is unpaused.

## Evidence

- [_verifyRFQSignature](https://etherscan.io/address/0x0f9f2366c6157f2acd3c2bfa45cd9031c152d2cf#code) accepts a quote only if ECDSA recovers an address in the signers set.
- [tradeRFQT](https://etherscan.io/address/0x0f9f2366c6157f2acd3c2bfa45cd9031c152d2cf#code) runs only when not paused and calls the pool's tradeRFQT.
- [setSigner](https://etherscan.io/address/0x0f9f2366c6157f2acd3c2bfa45cd9031c152d2cf#code) lets the owner swap signer addresses but not the signature scheme.

## Reviewer notes

### Mechanism

NativeRouter.tradeRFQT (line 69, whenNotPaused) requires isNativePools[quote.pool] (line 77) and calls _verifyRFQSignature (line 79). That function builds an EIP-712 digest over the quote and widget fee and calls ECDSA.recover(digest, quote.widgetFeeSignature) (line 275), which uses ecrecover (ECDSA.sol line 139), then requires signers[recoveredSigner] (line 277). The router then transfers seller tokens to the pool's treasury and calls NativeRFQPool.tradeRFQT (line 110), where the pool checks the market maker's ECDSA signature (NativeRFQPool.sol line 233) and pays the taker. The owner can setSigner (line 167) and pause (line 186); kev's finding records this router as paused, so the path is live only if unpaused.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Router itself holds about $0; funds at stake sit in the CreditVault behind the pools.
- Ruled out: Router is paused per kev's on-chain read.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
