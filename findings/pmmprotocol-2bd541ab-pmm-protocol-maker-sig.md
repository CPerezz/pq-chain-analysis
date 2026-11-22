---
id: pmmprotocol-2bd541ab-pmm-protocol-maker-sig
format: 2
title: OKX PMMProtocol accepts ECDSA maker orders a quantum attacker could forge
status: confirmed
severity: LOW
justification: Forged maker orders drain approved balances; LOW since each maker can already quote from an ERC-1271
  account.
category: quantum-exposure
pattern: PQ-2
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2bd541ab3b704f7d4c9dff79efadeaa85ec034f1'
  name: PMMProtocol
  project: okx
  code: verified
  code_url: https://etherscan.io/address/0x2bd541ab3b704f7d4c9dff79efadeaa85ec034f1#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 15869
impact: funds-loss
action: 'Makers: quote from an ERC-1271 account verifying a post-quantum signature and revoke ECDSA address approvals.'
evidence_level: source
checks:
- id: c1
  source: '0x2bd541ab3b704f7d4c9dff79efadeaa85ec034f1'
  file: src/PmmProtocol.sol
  line: 147
  has: '!ECDSA.recoverOrIsValidSignature('
  says: The compact fill path checks the maker with ecrecover before ERC-1271.
  for:
  - evidence-2
  - what
- id: c2
  source: '0x2bd541ab3b704f7d4c9dff79efadeaa85ec034f1'
  file: src/PmmProtocol.sol
  line: 227
  has: '!ECDSA.recoverOrIsValidSignature('
  says: fillOrderRFQTo checks the maker with ecrecover before ERC-1271 when the hint is unset.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: hint
  source: '0x2bd541ab3b704f7d4c9dff79efadeaa85ec034f1'
  file: src/PmmProtocol.sol
  has: if (flagsAndAmount & _SIGNER_SMART_CONTRACT_HINT != 0) {
  line: 213
  says: The filler-supplied flag selects the ERC-1271-only path.
  for:
  - action
  - justification
  - what
- id: xfer
  source: '0x2bd541ab3b704f7d4c9dff79efadeaa85ec034f1'
  file: src/PmmProtocol.sol
  has: IERC20(order.makerAsset).safeTransferFrom(
  line: 318
  says: The maker's asset is pulled from the maker's approval.
  for:
  - evidence-3
  - justification
  - what
- id: back
  source: '0x2bd541ab3b704f7d4c9dff79efadeaa85ec034f1'
  file: src/PmmProtocol.sol
  has: IERC20(order.takerAsset).safeTransferFrom(
  line: 342
  says: The taker asset is sent back to the maker.
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
  who: review (Review12)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
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

PMMProtocol fills market makers' signed RFQ orders from the maker's approved tokens. Unless the filler sets the hint bit, ecrecover checks the maker's signature before ERC-1271. A quantum attacker who recovers a maker's key signs orders at any price and pulls what the maker approved.

## Evidence

- [fillOrderRFQTo](https://etherscan.io/address/0x2bd541ab3b704f7d4c9dff79efadeaa85ec034f1#code) uses recoverOrIsValidSignature when the filler leaves the hint bit unset.
- [fillOrderRFQCompact](https://etherscan.io/address/0x2bd541ab3b704f7d4c9dff79efadeaa85ec034f1#code) takes the same ecrecover-first path for r, vs signatures.
- [_fillOrderRFQTo](https://etherscan.io/address/0x2bd541ab3b704f7d4c9dff79efadeaa85ec034f1#code) transfers makerAsset from the maker at the signed amounts.

## Reviewer notes

### Mechanism

fillOrderRFQTo (lines 198-251) checks bit 254 (_SIGNER_SMART_CONTRACT_HINT, line 54) of the filler-supplied flagsAndAmount. If set, ECDSA.isValidSignature (ERC-1271) is used. Otherwise, ECDSA.recoverOrIsValidSignature (line 227) tries ecrecover first and uses ERC-1271 only if that fails. fillOrderRFQCompact does the same at line 147. _fillOrderRFQTo (line 253 onward) then calls safeTransferFrom or safeTransferFromPermit2 to move makerAsset from order.makerAddress (lines 311-323) and takerAsset back to the maker (line 342), at the signed amounts. A forged order with a tiny takerAmount drains the maker's approved balance. The filler leaves the hint bit unset for any maker with an ECDSA key, including 7702-delegated EOAs.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Takers are not exposed: they pay only what they send in their own transaction.
- Ruled out: Contract holds no funds and has no admin or proxy.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
