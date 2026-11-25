---
id: nativerfqpool-5d1a3436-rfq-signer
format: 2
title: Native RFQ pool pays vault funds on ECDSA quotes a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged market-maker quote plus router signer pays out vault funds; pool isn't upgradeable, so Native
  must redeploy.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5d1a34369686ae59ac97ae4e1df5635ffda9ee7c'
  name: NativeRFQPool
  project: native
  code: verified
  code_url: https://etherscan.io/address/0x5d1a34369686ae59ac97ae4e1df5635ffda9ee7c#code
  copies: 1
  upgradeable: 'no'
  admin: '0x83fc28e6962e41e38f7854308eff827e3f6b906b'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 13302
impact: funds-loss
action: Deploy a pool and router that verify post-quantum quote signatures, whitelist them, and revoke this pool's
  vault allowance.
evidence_level: source
checks:
- id: c1
  source: '0x5d1a34369686ae59ac97ae4e1df5635ffda9ee7c'
  file: src/NativeRFQPool.sol
  line: 235
  has: require(quote.signer == ECDSA.recover(digest, quote.signature), ErrorsLib.InvalidSignature());
  says: Quote accepted only if ECDSA recovers quote.signer.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x5d1a34369686ae59ac97ae4e1df5635ffda9ee7c'
  file: lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: Recovery uses secp256k1 ecrecover.
  for:
  - what
- id: c3
  source: '0x5d1a34369686ae59ac97ae4e1df5635ffda9ee7c'
  file: src/NativeRFQPool.sol
  line: 168
  has: function setSigner(address signer, bool isSigner) external onlyOwner {
  says: Owner can only add or remove signer addresses.
  for:
  - action
  - evidence-3
  - justification
- id: s-router
  source: '0x5d1a34369686ae59ac97ae4e1df5635ffda9ee7c'
  file: src/NativeRFQPool.sol
  has: require(msg.sender == router, ErrorsLib.OnlyNativeRouter());
  line: 87
  says: Only the router can call tradeRFQT.
  for:
  - what
- id: s-whitelist
  source: '0x5d1a34369686ae59ac97ae4e1df5635ffda9ee7c'
  file: src/NativeRFQPool.sol
  has: require(rfqSigners[quote.signer], ErrorsLib.InvalidSigner());
  line: 213
  says: Quote signer must be whitelisted.
  for:
  - evidence-1
  - what
- id: s-transfer
  source: '0x5d1a34369686ae59ac97ae4e1df5635ffda9ee7c'
  file: src/NativeRFQPool.sol
  has: IERC20(token).safeTransferFrom(treasury, receiver, value);
  line: 208
  says: Pool pays the recipient from the treasury.
  for:
  - evidence-2
  - justification
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
reviews: []
related: []
---

## What happens

This pool executes router-forwarded RFQ trades and pays the recipient from its treasury after checking a whitelisted market maker's ECDSA quote signature. A quantum attacker who recovers a market-maker key, plus Native's router signer, can sign quotes that pay treasury funds to themselves.

## Evidence

- [_verifyPMMSignature](https://etherscan.io/address/0x5d1a34369686ae59ac97ae4e1df5635ffda9ee7c#code) accepts a quote if ECDSA recovers the whitelisted signer.
- [_transferFromTreasury](https://etherscan.io/address/0x5d1a34369686ae59ac97ae4e1df5635ffda9ee7c#code) pulls the buyer token from the treasury to the quote's recipient.
- [setSigner](https://etherscan.io/address/0x5d1a34369686ae59ac97ae4e1df5635ffda9ee7c#code) lets the owner swap signer addresses, not the signature scheme.

## Reviewer notes

### Mechanism

NativeRouter.tradeRFQT checks its own ECDSA widget-fee signer, then calls NativeRFQPool.tradeRFQT (line 86, msg.sender == router at 87). After nonce check, _verifyPMMSignature (212-236) requires rfqSigners[quote.signer] (213) and quote.signer == ECDSA.recover(digest, quote.signature) (235), which uses ecrecover (ECDSA.sol 139). For a credit pool, _transferAndCallback calls CreditVault.swapCallback (189) to book the trade to the signer, then _transferFromTreasury does safeTransferFrom(treasury, receiver, value) (208). The treasury is the CreditVault, which granted this pool an unlimited allowance. Forging both the router signer and a market-maker signature lets an attacker set recipient and amounts. setSigner (168) only rotates addresses; the contract has no proxy, so the scheme cannot change without redeployment.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The pool itself holds about $0; the funds at risk sit in the treasury (CreditVault).
- Ruled out: Not upgradeable: no proxy.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
