---
id: visiontoken-f406f7a9-signed-shortcut-lost
format: 2
title: VISION holders whose accounts take real code lose permit and signed sells
status: confirmed
severity: INFORMATIONAL
justification: 'Nothing breaks by itself: a holder whose account takes real code keeps approve and sell by direct
  call.'
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xf406f7a9046793267bc276908778b29563323996'
  name: VisionToken
  label: 'APY Vision: VISION Token'
  code: verified
  code_url: https://etherscan.io/address/0xf406f7a9046793267bc276908778b29563323996#code
  copies: 2
  family: df08a44881801306116ad01163affc7a
  upgradeable: 'no'
value:
  usd: 95820
  whose: users
  basis: held
activity: {}
impact: liveness
action: Tell holders to use approve and sell directly from their own account once it takes real code; an EIP-7702
  delegation keeps permit working.
evidence_level: source
checks:
- id: permit-rec
  source: '0xf406f7a9046793267bc276908778b29563323996'
  file: VisionToken.sol
  lines:
  - 2241
  - 2243
  has: require(recoveredAddress != address(0) && recoveredAddress == owner, "INVALID_SIGNATURE");
  says: permit recovers with ecrecover and accepts only the named owner, then approves
  for:
  - evidence-1
  - justification
  - what
  - whose
- id: sell-rec
  source: '0xf406f7a9046793267bc276908778b29563323996'
  file: VisionToken.sol
  lines:
  - 2181
  - 2183
  has: require(recoveredAddress != address(0) && recoveredAddress == _from, "INVALID_SIGNATURE");
  says: permitSell recovers with ecrecover and requires the seller, then sells
  for:
  - evidence-2
  - justification
  - what
  - whose
- id: approve
  source: '0xf406f7a9046793267bc276908778b29563323996'
  file: VisionToken.sol
  lines:
  - 1306
  - 1307
  has: function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
  says: approve by direct call from the holder
  for:
  - action
  - justification
  - what
- id: sell
  source: '0xf406f7a9046793267bc276908778b29563323996'
  file: VisionToken.sol
  lines:
  - 2151
  - 2157
  has: _sell(msg.sender, _to, _quantityToSell, _minCurrencyReturned);
  says: sell by direct call from the holder
  for:
  - action
  - justification
  - what
- id: state
  call: '0xf406f7a9046793267bc276908778b29563323996'
  fn: state()(uint256)
  is: '1'
  says: the offering is running
  for:
  - what
- id: paused
  call: '0xf406f7a9046793267bc276908778b29563323996'
  fn: paused()(bool)
  is: 'false'
  says: not paused
  for:
  - notes
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

The VISION token lets a holder approve a spender or sell tokens for ETH with a signature that anyone can submit. Once the holder's account takes real code, that signature no longer counts; direct approve and sell still work.

## Evidence

- [permit](https://etherscan.io/address/0xf406f7a9046793267bc276908778b29563323996#code) recovers the signer and requires it to equal the owner named in the call.
- [permitSell](https://etherscan.io/address/0xf406f7a9046793267bc276908778b29563323996#code) recovers the signer and requires it to equal the seller before selling.

## Reviewer notes

### Mechanism

permit (lines 2222-2244) and permitSell (2161-2184) build an EIP-712 digest, call ecrecover and require the result to equal the owner/seller argument; there is no ERC-1271 or code-size branch. Direct alternatives: approve (1306, whenNotPaused; paused() is false) and sell (2151-2158, msg.sender). The contract is in STATE_RUN (state()=1) with ETH as currency (currency()=0). permitBuy (2012-2035) also checks _from, but it is not payable while _buy collects msg.value against _currencyValue in ETH (line 1628), so it cannot buy anything here and is left off the card.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: ERC-1271 path: none in permit, permitSell or permitBuy (lines 2032-2033, 2181-2182, 2241-2242).
- Ruled out: unused implementation: state()=1 (running), totalSupply 1.54e24 and 53 ETH held at this address; it is used directly.
- Ruled out: path closed: paused() is false and state is RUN at block 26438999.
- Ruled out: breaks by itself: no fixed gas on the precompile; the one recovery in the window came through tx 0x2679...883e sent to another contract (0xbee162fa...), not cited because other steps of that bundle are unread.
- Ruled out: copy 0x4129b789a5d6cf48588868ad76a81afe4db8e440 runs the same code, holds no value and had no recoveries in the window; this address is the one in use.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
