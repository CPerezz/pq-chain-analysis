---
id: v2dutchorderreactor-00000011-uniswapx-cosigner
format: 2
title: UniswapX V2 reactor trusts a quantum-forgeable ECDSA cosigner
status: confirmed
severity: MEDIUM
justification: Immutable reactor checks cosigner with raw ECDSA; Uniswap Labs must redeploy; swappers lose slippage.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x00000011f84b9aa48e5f8aa8b9897600006289be'
  name: V2DutchOrderReactor
  project: uniswap
  code: verified
  code_url: https://etherscan.io/address/0x00000011f84b9aa48e5f8aa8b9897600006289be#code
  copies: 1
  upgradeable: 'no'
  admin: '0x1a9c8182c09f50c8318d769245bea52c32be35bc'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 107118
impact: funds-loss
action: Deploy a reactor that checks the cosigner via ERC-1271 or a post-quantum scheme and route new orders to
  it.
evidence_level: source
checks:
- id: c1
  source: '0x00000011f84b9aa48e5f8aa8b9897600006289be'
  file: src/reactors/V2DutchOrderReactor.sol
  line: 119
  has: address signer = ecrecover(keccak256(abi.encodePacked(orderHash, abi.encode(order.cosignerData))), v, r,
    s);
  says: Cosignature is checked with raw ecrecover in _validateOrder.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: new-cmp
  source: '0x00000011f84b9aa48e5f8aa8b9897600006289be'
  file: src/reactors/V2DutchOrderReactor.sol
  has: if (order.cosigner != signer || signer == address(0)) {
  line: 120
  says: the line or bytes the card cites
  for:
  - evidence-1
  - justification
  - what
- id: new-decay
  source: '0x00000011f84b9aa48e5f8aa8b9897600006289be'
  file: src/reactors/V2DutchOrderReactor.sol
  has: 'outputs: order.baseOutputs.decay(order.cosignerData.decayStartTime, order.cosignerData.decayEndTime),'
  line: 60
  says: the line or bytes the card cites
  for:
  - evidence-2
  - what
- id: new-excl
  source: '0x00000011f84b9aa48e5f8aa8b9897600006289be'
  file: src/reactors/V2DutchOrderReactor.sol
  has: order.cosignerData.exclusiveFiller,
  line: 65
  says: the line or bytes the card cites
  for:
  - what
- id: new-bound
  source: '0x00000011f84b9aa48e5f8aa8b9897600006289be'
  file: src/reactors/V2DutchOrderReactor.sol
  has: if (outputAmount < output.startAmount) {
  line: 98
  says: the line or bytes the card cites
  for:
  - evidence-3
  - justification
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review07 (registry review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

The reactor fills swappers' Dutch orders only when an ECDSA cosignature recovers to the order's cosigner address. A quantum attacker who forges the cosigner sets decay times and exclusivity, filling open orders at the swapper's worst signed amounts.

## Evidence

- [_validateOrder](https://etherscan.io/address/0x00000011f84b9aa48e5f8aa8b9897600006289be#code) recovers the cosigner with ecrecover and reverts unless it equals order.cosigner.
- [_resolve](https://etherscan.io/address/0x00000011f84b9aa48e5f8aa8b9897600006289be#code) decays input and outputs between the cosigned decayStartTime and decayEndTime.
- [_updateWithCosignerAmounts](https://etherscan.io/address/0x00000011f84b9aa48e5f8aa8b9897600006289be#code) rejects cosigner outputs below the swapper's signed start amounts.

## Reviewer notes

### Mechanism

_resolve (lines 43-69) decodes the order, hashes it, and calls _validateOrder (lines 111-123), which decodes r, s, v from order.cosignature and requires ecrecover(keccak256(orderHash || abi.encode(cosignerData))) == order.cosigner (lines 119-120). _updateWithCosignerAmounts (lines 83-104) only lets the cosigner improve start amounts. Input and outputs then decay between cosignerData.decayStartTime and decayEndTime (lines 59-60), and handleExclusiveOverride applies the cosigned exclusiveFiller and override bps (lines 64-68). Swapper tokens move via permit2.permitWitnessTransferFrom with the swapper's own signature (lines 72-81). A forged cosignature with past decay times and the attacker as exclusive filler fills at the swapper's end amounts, capturing the slippage tolerance.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Cosigner cannot push amounts beyond the swapper's signed start/end range.
- Ruled out: Reactor holds no funds between fills.
- Ruled out: Owner functions only set the protocol fee controller; not upgradeable.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
