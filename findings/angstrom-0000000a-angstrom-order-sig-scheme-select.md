---
id: angstrom-0000000a-angstrom-order-sig-scheme-select
format: 2
title: Angstrom accepts ECDSA orders that a quantum attacker could forge for users
status: confirmed
severity: MEDIUM
justification: Order checks are immutable; Sorella runs the only nodes, can filter orders and can redeploy, so MEDIUM.
category: quantum-exposure
pattern: PQ-2
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0000000aa232009084bd71a5797d089aa4edfad4'
  name: Angstrom
  project: sorella
  code: verified
  code_url: https://etherscan.io/address/0x0000000aa232009084bd71a5797d089aa4edfad4#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 607760
  basis: held
activity:
  txs_90d: 420165
impact: funds-loss
action: Deploy a new Angstrom that checks account code before accepting ECDSA orders; meanwhile have nodes refuse
  such orders.
evidence_level: source
checks:
- id: node-gate
  source: '0x0000000aa232009084bd71a5797d089aa4edfad4'
  file: src/modules/TopLevelAuth.sol
  has: if (!_isNode[msg.sender]) revert NotNode();
  line: 225
  says: Bundle execution requires a registered node caller.
  for:
  - evidence-1
  - justification
  - what
- id: toggle
  source: '0x0000000aa232009084bd71a5797d089aa4edfad4'
  file: src/modules/TopLevelAuth.sol
  has: _isNode[node] = !_isNode[node];
  line: 190
  says: toggleNodes flips node membership.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: ctrl
  source: '0x0000000aa232009084bd71a5797d089aa4edfad4'
  file: src/modules/TopLevelAuth.sol
  has: if (msg.sender != _controller) revert NotController();
  line: 218
  says: Admin functions require the controller.
  for:
  - evidence-2
  - justification
- id: s42
  source: '0x0000000aa232009084bd71a5797d089aa4edfad4'
  file: lib/solady/src/utils/SignatureCheckerLib.sol
  has: if iszero(extcodesize(signer)) {
  line: 90
  says: The library uses ECDSA only when the signer has no code.
  for:
  - action
  - evidence-3
  - what
- id: s104
  source: '0x0000000aa232009084bd71a5797d089aa4edfad4'
  file: lib/solady/src/utils/SignatureCheckerLib.sol
  has: let recovered := mload(staticcall(gas(), 1, 0x00, 0x80, 0x01, 0x20))
  line: 104
  says: ECDSA recovery calls the ecrecover precompile.
  for:
  - evidence-3
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review06 (Claude), 2026-11-17 review
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
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

Angstrom settles signed user orders in bundles that only registered nodes submit. Orders may pick a raw ECDSA check with no account-code test, so a quantum attacker with a user's key can spend that user's funds.

## Evidence

- [_nodeBundleLock](https://etherscan.io/address/0x0000000aa232009084bd71a5797d089aa4edfad4#code) reverts unless the caller is a registered node.
- [toggleNodes](https://etherscan.io/address/0x0000000aa232009084bd71a5797d089aa4edfad4#code) lets the controller add or remove nodes.
- [SignatureCheckerLib](https://etherscan.io/address/0x0000000aa232009084bd71a5797d089aa4edfad4#code) uses ecrecover only when the signer has no code.

## Reviewer notes

### Mechanism

execute is gated by _nodeBundleLock (TopLevelAuth.sol 223-227, line 225 requires _isNode[msg.sender]). Per kev's review of Angstrom.sol lines 148-150 and 229-231, each order's variant flag selects SignatureLib.readAndCheckEcdsa (raw ecrecover; the recovered address becomes `from`) or ERC-1271. The ECDSA branch never checks whether `from` has code. Settlement.sol lines 105-116 then take amountIn from `from`'s internal balance or via safeTransferFrom, and pay amountOut to the order's recipient. Contrast: Solady SignatureCheckerLib.isValidSignatureNowCalldata (lines 90-104), used only for node attestations at TopLevelAuth line 206, checks extcodesize before ecrecover. The controller manages nodes via toggleNodes (lines 186-191).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: unlockWithEmptyAttestation uses a node signature only to unlock pools for a block and moves no funds
- Ruled out: No proxy exists, so the order logic cannot be upgraded in place

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
