---
id: bebopsettlement-bbbbbbb5-order-sig-scheme-select
format: 2
title: Bebop settlement lets a quantum attacker sign orders as any approving trader
status: confirmed
severity: HIGH
justification: Signer picks ECDSA per order, so migrated users stay forgeable; no admin can fix it, only Bebop redeploying.
category: quantum-exposure
pattern: PQ-2
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xbbbbbbb520d69a9775e85b458c58c648259fad5f'
  name: BebopSettlement
  project: bebop
  code: verified
  code_url: https://etherscan.io/address/0xbbbbbbb520d69a9775e85b458c58c648259fad5f#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 228926
impact: funds-loss
action: Deploy a settlement without the ECDSA signature types and move makers and the front end to it.
evidence_level: source
checks:
- id: c1
  source: '0xbbbbbbb520d69a9775e85b458c58c648259fad5f'
  file: src/base/BebopSigning.sol
  line: 147
  has: address signer = ecrecover(hash, v, r, s);
  says: EIP-712 orders are checked with ecrecover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xbbbbbbb520d69a9775e85b458c58c648259fad5f'
  file: src/base/BebopSigning.sol
  line: 164
  has: address signer = ecrecover(ethSignHash, v, r, s);
  says: eth_sign orders are checked with ecrecover.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: flagtaker
  source: '0xbbbbbbb520d69a9775e85b458c58c648259fad5f'
  file: src/base/BebopSigning.sol
  has: Signature.Type signatureType = Order.extractSignatureType(order.flags);
  line: 290
  says: Taker signature type comes from the order's flags.
  for:
  - evidence-3
  - justification
  - what
- id: flagmaker
  source: '0xbbbbbbb520d69a9775e85b458c58c648259fad5f'
  file: src/base/BebopSigning.sol
  has: (, Signature.Type signatureType) = Signature.extractMakerFlags(makerSignature.flags);
  line: 208
  says: Maker signature type comes from the maker signature's flags.
  for:
  - justification
  - what
- id: takerval
  source: '0xbbbbbbb520d69a9775e85b458c58c648259fad5f'
  file: src/base/BebopSigning.sol
  has: if (msg.sender != order.taker_address){
  line: 289
  says: A third party can submit an order on the taker's behalf with a taker signature.
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
  who: Claude (the study family's recovery functions read, a real transaction replayed four ways; not reviewed by
    a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: confirmed
  rating: ''
reviews: []
related: []
---

## What happens

BebopSettlement settles RFQ orders and accepts maker and taker signatures checked by ecrecover, under an EIP-712 or eth_sign type the order itself selects. A quantum attacker with a recovered ECDSA key signs orders as that maker or taker, even after the address moves to post-quantum authorisation.

## Evidence

- [_validateSignature](https://etherscan.io/address/0xbbbbbbb520d69a9775e85b458c58c648259fad5f#code) accepts an EIP-712 signature when ecrecover returns the maker or taker.
- [_validateSignature](https://etherscan.io/address/0xbbbbbbb520d69a9775e85b458c58c648259fad5f#code) also accepts an eth_sign signature recovered with ecrecover.
- [The taker's signature type](https://etherscan.io/address/0xbbbbbbb520d69a9775e85b458c58c648259fad5f#code) is read from the order's own flags.

## Reviewer notes

### Mechanism

BebopSigning._validateSignature (lines 142-172) branches on a signatureType supplied with the order. For EIP712 (line 147) and ETHSIGN (line 164) it calls ecrecover and accepts the result if it equals validationAddress, or for makers a signer in orderSignerRegistry (lines 149, 166). For EIP1271 it calls isValidSignature (line 153). Maker types come from makerSignature.flags via Signature.extractMakerFlags (lines 208, 223, 269). Taker types come from order.flags via Order.extractSignatureType (lines 290, 312, 336), checked when msg.sender != order.taker_address. Nothing binds an address to one scheme, so the ECDSA types stay selectable after an account adopts post-quantum code. Settlement then moves approved tokens of the forged party.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract holds only dust; exposure is users' approvals.
- Ruled out: No proxy or owner to upgrade the check.
- Ruled out: Smart-contract wallets without an ECDSA key can only use the ERC-1271 type.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
