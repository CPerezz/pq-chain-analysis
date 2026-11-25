---
id: aggregationrouterv6-11111112-lop-order-sig-scheme-select
format: 2
title: 1inch router accepts forged ECDSA maker orders from a quantum attacker
status: confirmed
severity: HIGH
justification: Makers' approved funds stay forgeable after migration; the router cannot change, so each maker must
  revoke or move.
category: quantum-exposure
pattern: PQ-2
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x111111125421ca6dc452d289314280a0f8842a65'
  name: AggregationRouterV6
  project: 1inch
  code: verified
  code_url: https://etherscan.io/address/0x111111125421ca6dc452d289314280a0f8842a65#code
  copies: 1
  admin: '0x9f8102b1bb05785bad2874f2c7b1aaea4c6d976a'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1154930
impact: funds-loss
action: Deploy a new router whose ECDSA path requires maker.code.length == 0; tell makers to revoke approvals to
  this one.
evidence_level: source
checks:
- id: c1
  source: '0x111111125421ca6dc452d289314280a0f8842a65'
  file: contracts/networks/AggregationRouterV6.mainnet.sol
  line: 3814
  has: if (maker == address(0) || maker != ECDSA.recover(orderHash, r, vs)) revert BadSignature();
  says: _fillOrder accepts only if ECDSA recovers the maker, no code check
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c3
  source: '0x111111125421ca6dc452d289314280a0f8842a65'
  file: contracts/networks/AggregationRouterV6.mainnet.sol
  line: 5772
  has: function pause() external onlyOwner {
  says: owner can pause trading
  for:
  - evidence-3
  - justification
- id: fill
  source: '0x111111125421ca6dc452d289314280a0f8842a65'
  file: contracts/networks/AggregationRouterV6.mainnet.sol
  has: (makingAmount, takingAmount) = _fill(order, orderHash, remainingMakingAmount, amount, takerTraits, target,
    extension, interaction);
  line: 3828
  says: _fillOrder executes the fill after the signature check
  for:
  - evidence-2
  - what
- id: rescue
  source: '0x111111125421ca6dc452d289314280a0f8842a65'
  file: contracts/networks/AggregationRouterV6.mainnet.sol
  has: function rescueFunds(IERC20 token, uint256 amount) external onlyOwner {
  line: 5765
  says: owner power is limited to rescuing funds (with pause)
  for:
  - action
  - evidence-3
  - justification
- id: fo
  source: '0x111111125421ca6dc452d289314280a0f8842a65'
  file: contracts/networks/AggregationRouterV6.mainnet.sol
  has: return _fillOrder(order, r, vs, amount, takerTraits, msg.sender, msg.data[:0], msg.data[:0]);
  line: 3776
  says: public fillOrder routes to the ECDSA-checking _fillOrder
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
  who: Review09 (finding review)
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

The router fills makers' limit orders and, on the fillOrder path, trusts an ECDSA signature recovered to the maker without checking for account code. A quantum attacker who recovers a maker's old key signs orders and fills them against that maker's token approvals to the router.

## Evidence

- [_fillOrder](https://etherscan.io/address/0x111111125421ca6dc452d289314280a0f8842a65#code) accepts an order if ECDSA recovers the maker from the order hash.
- [_fillOrder](https://etherscan.io/address/0x111111125421ca6dc452d289314280a0f8842a65#code) then pulls the maker's asset through _fill to the taker.
- [The owner](https://etherscan.io/address/0x111111125421ca6dc452d289314280a0f8842a65#code) can rescue funds and pause, not change the signature check.

## Reviewer notes

### Mechanism

fillOrder (l.3769-3777) and fillOrderArgs (l.3782-3797) call _fillOrder. On the first fill (l.3812), _fillOrder reads the maker (l.3813) and reverts only if maker != ECDSA.recover(orderHash, r, vs) (l.3814). There is no check of maker code, so an address that migrated in place (for example with EIP-7702) still has a valid old ECDSA key. An optional maker permit is applied at l.3819, and _fill (l.3828) moves the making asset from the maker to the taker. fillContractOrder (l.3834) uses ERC-1271, but the taker chooses which path to use. The owner (a 3-of-4 Safe) has only rescueFunds (l.5765), pause and unpause (l.5772-5779), and the ownership functions (l.4498-4511). There is no proxy, so the check cannot be changed.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Router holdings are not the exposure; it holds about nothing.
- Ruled out: Fresh post-quantum smart accounts with no ECDSA key are not forgeable via fillOrder.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
