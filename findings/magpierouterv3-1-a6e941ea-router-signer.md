---
id: magpierouterv3-1-a6e941ea-router-signer
format: 2
title: Magpie router lets a quantum attacker with a relayer key spend users' approvals
status: confirmed
severity: LOW
justification: Relayer and user signatures are ECDSA only; LOW because the owner can remove internal callers and
  pause.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa6e941eab67569ca4522f70d343714ff51d571c4'
  name: MagpieRouterV3_1
  project: magpie
  code: verified
  code_url: https://etherscan.io/address/0xa6e941eab67569ca4522f70d343714ff51d571c4#code
  copies: 1
  admin: '0xc8d7d0bd61c5ca5a493a229f6754da5560f486ae'
value:
  usd: 2
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Remove every internal caller with updateInternalCaller(caller, false) and pause the router.
evidence_level: source
checks:
- id: c3
  source: '0xa6e941eab67569ca4522f70d343714ff51d571c4'
  file: contracts/MagpieRouterV3_1.sol
  line: 194
  has: address fromAddress = verifySignature(swapData, false);
  says: swapWithUserSignature verifies without useCaller
  for:
  - evidence-1
  - justification
  - what
- id: c4
  source: '0xa6e941eab67569ca4522f70d343714ff51d571c4'
  file: contracts/libraries/LibRouter.sol
  line: 170
  has: signer = ecrecover(hash, v, r, s);
  says: signer recovery is raw ecrecover
  for:
  - evidence-2
  - justification
  - what
- id: c9
  source: '0xa6e941eab67569ca4522f70d343714ff51d571c4'
  file: contracts/MagpieRouterV3_1.sol
  line: 49
  has: function pause() public onlyOwner whenNotPaused {
  says: the owner can pause the router
  for:
  - action
  - justification
- id: oic
  source: '0xa6e941eab67569ca4522f70d343714ff51d571c4'
  file: contracts/MagpieRouterV3_1.sol
  has: onlyInternalCaller
  line: 189
  says: swapWithUserSignature is restricted to whitelisted internal callers
  for:
  - evidence-1
  - what
- id: uf
  source: '0xa6e941eab67569ca4522f70d343714ff51d571c4'
  file: contracts/libraries/LibRouter.sol
  has: fromAddress = recoverSigner(digest, r, s, v);
  line: 257
  says: the user-signature path spends from the recovered signer
  for:
  - evidence-1
- id: tf
  source: '0xa6e941eab67569ca4522f70d343714ff51d571c4'
  file: contracts/MagpieRouterV3_1.sol
  has: swapData.fromAssetAddress.transferFrom(fromAddress, address(this), swapData.amountIn);
  line: 121
  says: swap pulls tokens from fromAddress
  for:
  - evidence-3
  - what
- id: uic
  source: '0xa6e941eab67569ca4522f70d343714ff51d571c4'
  file: contracts/MagpieRouterV3_1.sol
  has: function updateInternalCaller(address caller, bool value) external onlyOwner {
  line: 42
  says: the owner can add or remove internal callers
  for:
  - action
  - justification
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review13 (re-read verified source on Sourcify; owner and pause reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
- study: eip-8151-impact
  who: Claude (the registry text read; no family of this contract had a transaction in the window; not reviewed
    by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: ''
reviews: []
related: []
---

## What happens

The router swaps tokens taken from the address that ECDSA recovers from a user's swap signature, and only whitelisted internal callers may submit those swaps. A quantum attacker who recovers a relayer key and a user's old ECDSA key can spend that user's approvals to the router.

## Evidence

- [swapWithUserSignature](https://etherscan.io/address/0xa6e941eab67569ca4522f70d343714ff51d571c4#code) is restricted to internal callers and takes fromAddress from the recovered signer.
- [recoverSigner](https://etherscan.io/address/0xa6e941eab67569ca4522f70d343714ff51d571c4#code) uses raw ecrecover.
- [swap](https://etherscan.io/address/0xa6e941eab67569ca4522f70d343714ff51d571c4#code) pulls amountIn from fromAddress with transferFrom.

## Reviewer notes

### Mechanism

swapWithUserSignature (MagpieRouterV3_1.sol 189-200, onlyInternalCaller) calls verifySignature(swapData, false) (line 194). That calls LibRouter.verifySignature (202-262), which builds the EIP-712 Swap digest and sets fromAddress = recoverSigner(...) (line 257). recoverSigner uses raw ecrecover (line 170), and there is no ERC-1271 path. swap() then calls transferFrom(fromAddress, router, amountIn) (line 121), and transferFees pulls the fees from the same address. swapWithMagpieSignature (178-186) recovers an internal-caller signer but sets fromAddress = caller() (line 247), so a forged quote there spends only the attacker's own tokens. The owner can remove internal callers (updateInternalCaller, line 42) and pause (line 49).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: A forged Magpie quote signature in swapWithMagpieSignature spends only the caller's own tokens.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
