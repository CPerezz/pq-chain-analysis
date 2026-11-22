---
id: bridge-44e37608-dl-bridge-signers
format: 2
title: Quantum attacker could forge Confidential Layer bridge withdrawals
status: confirmed
severity: MEDIUM
justification: Withdrawals rest on ECDSA signer keys; the owner can fix it by upgrading the proxy to a post-quantum
  verifier.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x44e37608f744a7aeb16f7dc9bf052c310e6cd015'
  name: Bridge
  project: confidential-layer
  code: verified
  code_url: https://etherscan.io/address/0x3f2e4e5a70f2a424d7c4e4e0323c878c77c20537#code
  proxy_of: '0x3f2e4e5a70f2a424d7c4e4e0323c878c77c20537'
  copies: 1
  upgradeable: 'yes'
  admin: '0xab014cfff054692eeae239777c06647b47832d4c'
value:
  usd: 57514
  basis: held
activity:
  txs_90d: 229
impact: funds-loss
action: Upgrade the implementation to verify withdrawals with post-quantum signatures or a proof of the source-chain
  event.
evidence_level: source
checks:
- id: c1
  source: '0x3f2e4e5a70f2a424d7c4e4e0323c878c77c20537'
  file: contracts/utils/Signers.sol
  line: 46
  has: signers_[i] = signHash_.toEthSignedMessageHash().recover(signatures_[i]);
  says: Withdrawal signatures are recovered with ECDSA.
  for:
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x3f2e4e5a70f2a424d7c4e4e0323c878c77c20537'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 169
  has: address signer = ecrecover(hash, v, r, s);
  says: Recovery uses the ecrecover precompile.
  for:
  - evidence-1
  - justification
  - what
- id: c4
  source: '0x3f2e4e5a70f2a424d7c4e4e0323c878c77c20537'
  file: '@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol'
  line: 66
  has: function upgradeTo(address newImplementation) external virtual onlyProxy {
  says: The UUPS proxy can be upgraded via upgradeTo.
  for:
  - action
  - evidence-3
  - justification
- id: c5
  source: '0x3f2e4e5a70f2a424d7c4e4e0323c878c77c20537'
  file: '@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol'
  line: 79
  has: function upgradeToAndCall(address newImplementation, bytes memory data) external payable virtual onlyProxy
    {
  says: The UUPS proxy can be upgraded via upgradeToAndCall.
  for:
  - action
- id: s-contains
  source: '0x3f2e4e5a70f2a424d7c4e4e0323c878c77c20537'
  file: contracts/utils/Signers.sol
  has: 'require(_signers.contains(signers_[i]), "Signers: invalid signer");'
  line: 30
  says: Recovered signer must be in the signer set.
  for:
  - evidence-2
  - what
- id: s-threshold
  source: '0x3f2e4e5a70f2a424d7c4e4e0323c878c77c20537'
  file: contracts/utils/Signers.sol
  has: 'require(signers_.length >= signaturesThreshold, "Signers: threshold is not met");'
  line: 39
  says: Signature count must meet the threshold.
  for:
  - evidence-2
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review10 (source and on-chain review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (study families read, judged from bytecode or placed by rules; not reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

The bridge releases or mints tokens on withdrawals approved by ECDSA signatures from its signer set. A quantum attacker who recovers a signer key from its public signatures can forge withdrawals that pass the signer and threshold checks.

## Evidence

- [_checkSignatures](https://etherscan.io/address/0x3f2e4e5a70f2a424d7c4e4e0323c878c77c20537#code) recovers each signer from the withdrawal hash with ECDSA.
- [_checkCorrectSigners](https://etherscan.io/address/0x3f2e4e5a70f2a424d7c4e4e0323c878c77c20537#code) accepts recovered addresses in the signer set once the threshold count is met.
- [upgradeTo](https://etherscan.io/address/0x3f2e4e5a70f2a424d7c4e4e0323c878c77c20537#code) lets the owner replace the implementation behind the proxy.

## Reviewer notes

### Mechanism

The withdraw functions in Bridge.sol hash the withdrawal (including tx hash, nonce, chain id), mark it used and call Signers._checkSignatures. Line 46 recovers each signature with toEthSignedMessageHash().recover (OZ ECDSA, ecrecover at ECDSA.sol line 169). _checkCorrectSigners requires each recovered address to be in _signers (line 30), no duplicates (line 34), and count >= signaturesThreshold (line 39). On-chain the set is one signer with threshold 1 per kev, so one recovered key authorises withdrawals of held ETH and tokens, and mints of wrapped CLONE via mintTo. Owner (2-of-3 Safe) can change signers, threshold and upgrade via UUPS upgradeTo/upgradeToAndCall.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Adding ECDSA signers raises the classical bar, not the quantum one.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
