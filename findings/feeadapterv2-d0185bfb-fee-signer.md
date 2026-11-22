---
id: feeadapterv2-d0185bfb-fee-signer
format: 2
title: Everclear FeeAdapterV2 trusts an ECDSA fee signer a quantum attacker can forge
status: confirmed
severity: LOW
justification: Only Everclear's own fee rests on the ECDSA signer; Everclear must deploy a new adapter to fix it.
  LOW.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd0185bfb8107c5b2336bc73ce3fdd9bfb504540e'
  name: FeeAdapterV2
  project: everclear
  code: verified
  code_url: https://etherscan.io/address/0xd0185bfb8107c5b2336bc73ce3fdd9bfb504540e#code
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
  source: '0xd0185bfb8107c5b2336bc73ce3fdd9bfb504540e'
  file: src/contracts/intent/FeeAdapterV2.sol
  line: 432
  has: address _recoveredSigner = ECDSA.recover(MessageHashUtils.toEthSignedMessageHash(_hash), _signature);
  says: _verifySignature recovers the signer with ECDSA.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xd0185bfb8107c5b2336bc73ce3fdd9bfb504540e'
  file: ../../node_modules/@openzeppelin/contracts/utils/cryptography/ECDSA.sol
  line: 142
  has: address signer = ecrecover(hash, v, r, s);
  says: ECDSA recovery uses the ecrecover precompile.
  for:
  - what
- id: c5
  source: '0xd0185bfb8107c5b2336bc73ce3fdd9bfb504540e'
  file: src/interfaces/intent/IEverclearSpokeV6.sol
  line: 245
  has: function pause() external;
  says: The adapter works with the Everclear spoke, which handles intents separately.
  for:
  - justification
- id: c-cmp
  source: '0xd0185bfb8107c5b2336bc73ce3fdd9bfb504540e'
  file: src/contracts/intent/FeeAdapterV2.sol
  has: if (_recoveredSigner != feeSigner) {
  line: 433
  says: The recovered address must equal feeSigner.
  for:
  - evidence-1
  - what
- id: fee-tok
  source: '0xd0185bfb8107c5b2336bc73ce3fdd9bfb504540e'
  file: src/contracts/intent/FeeAdapterV2.sol
  has: _pushTokens(feeRecipient, _inputAsset, _tokenFee);
  line: 456
  says: The token fee goes to feeRecipient.
  for:
  - evidence-2
  - what
- id: fee-nat
  source: '0xd0185bfb8107c5b2336bc73ce3fdd9bfb504540e'
  file: src/contracts/intent/FeeAdapterV2.sol
  has: Address.sendValue(payable(feeRecipient), _nativeFee);
  line: 461
  says: The native fee goes to feeRecipient.
  for:
  - evidence-2
- id: fee-only
  source: '0xd0185bfb8107c5b2336bc73ce3fdd9bfb504540e'
  file: src/contracts/intent/FeeAdapterV2.sol
  has: function _handleFees(
  line: 443
  says: The quote feeds the fee-handling function.
  for:
  - justification
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

FeeAdapterV2 takes Everclear's fee on an intent against a fee quote signed by the ECDSA key feeSigner. A quantum attacker who recovers that key can sign zero-fee quotes for its own intents and skip Everclear's fee.

## Evidence

- [_verifySignature](https://etherscan.io/address/0xd0185bfb8107c5b2336bc73ce3fdd9bfb504540e#code) reverts unless ECDSA recovers feeSigner from the quote hash.
- [_handleFees](https://etherscan.io/address/0xd0185bfb8107c5b2336bc73ce3fdd9bfb504540e#code) sends only the quoted token and native fees to feeRecipient.

## Reviewer notes

### Mechanism

The fee-taking paths of FeeAdapterV2 (e.g. newOrderSplitEvenly) verify the fee quote in _verifySignature (lines 423-436). That function hashes the data hash with address(this) and block.chainid (line 427), and marks the hash as used to block replay (lines 429-430). It then calls ECDSA.recover over the eth-signed message hash (line 432), which uses ecrecover (ECDSA.sol line 142), and reverts unless the result equals feeSigner (lines 433-434). _handleFees (lines 443-463) checks the deadline, then pushes tokenFee and nativeFee to feeRecipient. A forged quote with zero fees therefore only removes Everclear's fee; the intent itself is created on the Everclear spoke. _updateFeeSigner (lines 411-416) replaces the signer with another address, so key rotation alone keeps an ECDSA key.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not a proxy; the contract holds about $0.
- Ruled out: The fee quote does not authorise releasing user or pooled funds on the spoke.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
