---
id: feeadapter-15a7ca97-fee-signer
format: 2
title: Everclear FeeAdapter accepts ECDSA fee quotes a quantum attacker could forge
status: confirmed
severity: LOW
justification: Forged quotes skip only Everclear's own fee, so LOW; Everclear fixes it by deploying a post-quantum-verified
  adapter.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x15a7ca97d1ed168fb34a4055cefa2e2f9bdb6c75'
  name: FeeAdapter
  project: everclear
  code: verified
  code_url: https://etherscan.io/address/0x15a7ca97d1ed168fb34a4055cefa2e2f9bdb6c75#code
  copies: 1
  upgradeable: 'no'
  admin: '0xa02a88f0bbd47045001bd460ad186c30f9a974d6'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Deploy a fee adapter that verifies fee quotes through ERC-1271 or a post-quantum signature scheme.
evidence_level: source
checks:
- id: c1
  source: '0x15a7ca97d1ed168fb34a4055cefa2e2f9bdb6c75'
  file: src/contracts/intent/FeeAdapter.sol
  line: 383
  has: address _recoveredSigner = ECDSA.recover(MessageHashUtils.toEthSignedMessageHash(_hash), _signature);
  says: The fee quote signer is recovered with ECDSA.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: cmp
  source: '0x15a7ca97d1ed168fb34a4055cefa2e2f9bdb6c75'
  file: src/contracts/intent/FeeAdapter.sol
  has: if (_recoveredSigner != feeSigner) {
  line: 384
  says: The recovered signer must equal feeSigner.
  for:
  - evidence-1
  - what
- id: fees
  source: '0x15a7ca97d1ed168fb34a4055cefa2e2f9bdb6c75'
  file: src/contracts/intent/FeeAdapter.sol
  has: _verifySignature(abi.encode(_tokenFee, _nativeFee, _inputAsset, _deadline), _sig);
  line: 402
  says: Fee handling verifies the signed fee quote.
  for:
  - evidence-2
  - justification
  - what
- id: push
  source: '0x15a7ca97d1ed168fb34a4055cefa2e2f9bdb6c75'
  file: src/contracts/intent/FeeAdapter.sol
  has: _pushTokens(feeRecipient, _inputAsset, _tokenFee);
  line: 411
  says: Token fees go to Everclear's feeRecipient.
  for:
  - evidence-2
- id: spoke
  source: '0x15a7ca97d1ed168fb34a4055cefa2e2f9bdb6c75'
  file: src/contracts/intent/FeeAdapter.sol
  has: spoke.newIntent(_destinations, _receiver, _inputAsset, _outputAsset, _amount, _maxFee, _ttl, _data);
  line: 347
  says: The intent is created on the Everclear spoke.
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
  who: Review07 (registry review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This adapter collects Everclear's fee, then creates the intent on the Everclear spoke. It accepts a fee quote only if ECDSA recovers the feeSigner address from the quote's signature. A quantum attacker who recovers that key can sign zero-fee quotes for its own intents and skip the fee.

## Evidence

- [_verifySignature](https://etherscan.io/address/0x15a7ca97d1ed168fb34a4055cefa2e2f9bdb6c75#code) reverts unless the ECDSA-recovered signer equals feeSigner.
- [_handleFees](https://etherscan.io/address/0x15a7ca97d1ed168fb34a4055cefa2e2f9bdb6c75#code) checks the signed fee quote, then sends the token fee to feeRecipient.

## Reviewer notes

### Mechanism

Intent creation calls _handleFees (lines 394-418). At line 402 it calls _verifySignature(abi.encode(_tokenFee, _nativeFee, _inputAsset, _deadline), _sig). _verifySignature (lines 381-387) hashes the data, applies toEthSignedMessageHash and ECDSA.recover (line 383, ecrecover in ECDSA.sol line 142), and reverts if the result is not feeSigner (line 384). Fees then go to feeRecipient (lines 411, 416). The intent itself is created by spoke.newIntent (line 347). A forged quote only sets the fee paid to Everclear, so only fee revenue is lost.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The fee quote does not authorise releasing user or pooled funds; the spoke handles intents separately.
- Ruled out: The contract is not upgradeable and holds nothing.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
