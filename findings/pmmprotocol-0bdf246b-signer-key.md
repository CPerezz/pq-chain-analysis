---
id: pmmprotocol-0bdf246b-signer-key
format: 2
title: PMMProtocol tries ECDSA first on maker quotes a quantum attacker could forge
status: confirmed
severity: LOW
justification: 'Only ECDSA makers are exposed; its maker is a Safe paid via Permit2, and a redeploy checking code
  first fixes it: LOW.'
category: quantum-exposure
pattern: PQ-2
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0bdf246b4aef9cfe4dd6eef153a1b645ac4bcbb6'
  name: PMMProtocol
  code: verified
  code_url: https://etherscan.io/address/0x0bdf246b4aef9cfe4dd6eef153a1b645ac4bcbb6#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Redeploy with a check of the maker's account code before ecrecover, as Permit2 does.
evidence_level: source
checks:
- id: c1
  source: '0x0bdf246b4aef9cfe4dd6eef153a1b645ac4bcbb6'
  file: src/PmmProtocol.sol
  line: 125
  has: if (!ECDSA.recoverOrIsValidSignature(order.makerAddress, orderHash, r, vs)) {
  says: fillOrderRFQCompact uses recover-then-ERC-1271 when the hint is unset
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c2
  source: '0x0bdf246b4aef9cfe4dd6eef153a1b645ac4bcbb6'
  file: src/PmmProtocol.sol
  line: 179
  has: if (!ECDSA.recoverOrIsValidSignature(order.makerAddress, orderHash, signature)) {
  says: fillOrderRFQTo uses recover-then-ERC-1271 when the hint is unset
  for:
  - action
  - evidence-1
  - justification
  - what
- id: hint
  source: '0x0bdf246b4aef9cfe4dd6eef153a1b645ac4bcbb6'
  file: src/PmmProtocol.sol
  has: if (flagsAndAmount & _SIGNER_SMART_CONTRACT_HINT != 0) {
  line: 171
  says: ERC-1271-only path depends on a flag in the taker's flagsAndAmount
  for:
  - evidence-1
  - what
- id: pull
  source: '0x0bdf246b4aef9cfe4dd6eef153a1b645ac4bcbb6'
  file: src/PmmProtocol.sol
  has: IERC20(order.makerAsset).safeTransferFrom(maker, receiver, makerAmount);
  line: 296
  says: Without Permit2, the maker's approved tokens are pulled directly
  for:
  - what
- id: p2
  source: '0x0bdf246b4aef9cfe4dd6eef153a1b645ac4bcbb6'
  file: src/PmmProtocol.sol
  has: IPermit2(SafeERC20._PERMIT2).permitTransferFrom(
  line: 287
  says: Permit2 signature transfer moves the maker asset
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
  who: Review11 (Claude), finding review
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
- study: eip-8151-impact
  who: Claude (study families read or judged, the registry text read; not executed; not reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: ''
  pattern: PQ-2
reviews: []
related: []
---

## What happens

PMMProtocol fills market makers' signed RFQ orders and pulls the maker's tokens. Unless the taker sets a smart-contract flag, it tries ECDSA recovery on the maker's signature before ERC-1271. A quantum attacker who derives an ECDSA maker's key can sign quotes that spend that maker's approved tokens.

## Evidence

- [fillOrderRFQTo](https://etherscan.io/address/0x0bdf246b4aef9cfe4dd6eef153a1b645ac4bcbb6#code) calls recoverOrIsValidSignature when the smart-contract hint is unset.
- [fillOrderRFQCompact](https://etherscan.io/address/0x0bdf246b4aef9cfe4dd6eef153a1b645ac4bcbb6#code) takes the same recover-first path for (r, vs) signatures.
- [_fillOrderRFQTo](https://etherscan.io/address/0x0bdf246b4aef9cfe4dd6eef153a1b645ac4bcbb6#code) moves maker tokens through Permit2 signature transfers when usePermit2 is set.

## Reviewer notes

### Mechanism

fillOrderRFQTo (lines 171-182) and fillOrderRFQCompact (lines 114-128): if flagsAndAmount has _SIGNER_SMART_CONTRACT_HINT, only ERC-1271 (isValidSignature / isValidSignature65) is used; otherwise ECDSA.recoverOrIsValidSignature runs ecrecover first, then ERC-1271. The taker sets the flag. _fillOrderRFQTo then moves the maker asset: Permit2 permitWitnessTransferFrom/permitTransferFrom with order.permit2Signature (lines 266-290), Permit2 allowance transfer (line 293), or plain safeTransferFrom (line 296). Permit2 verifies its own signature with code checked first, so a contract maker using Permit2 is protected there. The observed maker is a 1-of-2 Safe using Permit2 with zero allowances to this contract. No owner or proxy; code cannot change.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No owner, admin or proxy: code is immutable
- Ruled out: Contract holds no funds
- Ruled out: Observed maker Safe has zero ERC-20 and Permit2 allowances to this contract

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
