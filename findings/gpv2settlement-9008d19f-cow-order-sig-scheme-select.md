---
id: gpv2settlement-9008d19f-cow-order-sig-scheme-select
format: 2
title: CoW GPv2Settlement accepts ECDSA orders a quantum attacker could forge for users
status: confirmed
severity: HIGH
justification: Users' approved tokens stay forgeable in an unchangeable contract; only each user revoking or moving
  funds fixes it.
category: quantum-exposure
pattern: PQ-2
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x9008d19f58aabd9ed0d60971565aa8510560ab41'
  name: GPv2Settlement
  project: cow-protocol
  code: verified
  code_url: https://etherscan.io/address/0x9008d19f58aabd9ed0d60971565aa8510560ab41#code
  copies: 1
value:
  usd: 4637
  basis: held
activity:
  txs_90d: 453078
impact: funds-loss
action: Revoke allowances to the GPv2VaultRelayer or move funds to a fresh address; sign with Eip1271 or PreSign.
evidence_level: source
checks:
- id: c1
  source: '0x9008d19f58aabd9ed0d60971565aa8510560ab41'
  file: src/contracts/mixins/GPv2Signing.sol
  line: 198
  has: signer = ecrecover(message, v, r, s);
  says: ecdsaRecover takes the signer from ecrecover.
  for:
  - evidence-2
  - justification
  - what
- id: scheme
  source: '0x9008d19f58aabd9ed0d60971565aa8510560ab41'
  file: src/contracts/mixins/GPv2Signing.sol
  has: enum Scheme {Eip712, EthSign, Eip1271, PreSign}
  line: 24
  says: Orders choose among four signing schemes.
  for:
  - justification
  - what
- id: eip712
  source: '0x9008d19f58aabd9ed0d60971565aa8510560ab41'
  file: src/contracts/mixins/GPv2Signing.sol
  has: owner = recoverEip712Signer(orderDigest, signature);
  line: 148
  says: The Eip712 scheme sets the order owner from an ECDSA signature.
  for:
  - evidence-1
  - justification
  - what
- id: receiver
  source: '0x9008d19f58aabd9ed0d60971565aa8510560ab41'
  file: src/contracts/mixins/GPv2Signing.sol
  has: recoveredOrder.receiver = order.actualReceiver(owner);
  line: 128
  says: The receiver of the proceeds comes from the signed order.
  for:
  - what
- id: presign
  source: '0x9008d19f58aabd9ed0d60971565aa8510560ab41'
  file: src/contracts/mixins/GPv2Signing.sol
  has: function setPreSignature(bytes calldata orderUid, bool signed) external {
  line: 81
  says: Owners can pre-sign orders on-chain.
  for:
  - action
  - evidence-3
- id: eip1271
  source: '0x9008d19f58aabd9ed0d60971565aa8510560ab41'
  file: src/contracts/mixins/GPv2Signing.sol
  has: EIP1271Verifier(owner).isValidSignature(orderDigest, signature) ==
  line: 294
  says: Eip1271 scheme defers to the owner's contract to verify.
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
  who: Review18 (full GPv2Signing/GPv2Settlement source from Sourcify, on-chain reads)
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
  pattern: PQ-2
reviews: []
related: []
---

## What happens

GPv2Settlement settles token-swap orders whose owner is whoever ECDSA recovers from the order signature, under the Eip712 or EthSign scheme the order picks. A quantum attacker who derives a user's key can sign an order selling that user's approved tokens to a receiver the attacker picks.

## Evidence

- [recoverOrderSigner](https://etherscan.io/address/0x9008d19f58aabd9ed0d60971565aa8510560ab41#code) sets the owner from an ECDSA signature for the Eip712 scheme.
- [ecdsaRecover](https://etherscan.io/address/0x9008d19f58aabd9ed0d60971565aa8510560ab41#code) returns the address ecrecover gives as the signer.
- [setPreSignature](https://etherscan.io/address/0x9008d19f58aabd9ed0d60971565aa8510560ab41#code) lets an owner approve an order on-chain instead of by signature.

## Reviewer notes

### Mechanism

settle (onlySolver) -> recoverOrderFromTrade (GPv2Signing.sol line 111) -> recoverOrderSigner (line 141), which dispatches on the per-trade signingScheme. Eip712 (line 148) and EthSign (line 150) call ecdsaRecover, which sets signer = ecrecover(message, v, r, s) at line 198; that address becomes recoveredOrder.owner (line 127) and the receiver comes from the order (line 128). No account-code check is made, so the ECDSA path still works for an address that delegated via EIP-7702. Eip1271 (line 294) calls isValidSignature on the owner and PreSign (line 326) checks preSignature set by setPreSignature (line 81); both work for post-quantum accounts. settle then pulls the sell token from the owner through the owner's allowance to GPv2VaultRelayer.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Tokens held by the settlement itself are protocol buffers a forged order does not release.
- Ruled out: Smart accounts signing through Eip1271 or PreSign are not exposed.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
