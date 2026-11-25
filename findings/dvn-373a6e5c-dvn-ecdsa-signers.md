---
id: dvn-373a6e5c-dvn-ecdsa-signers
format: 2
title: Deutsche Telekom DVN trusts ECDSA signers a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: DVN quorum is ECDSA only; the operator can fix it by deploying a post-quantum DVN for OApps to point
  at.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x373a6e5c0c4e89e24819f00aa37ea370917aaff4'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0x373a6e5c0c4e89e24819f00aa37ea370917aaff4#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 21936
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and have OApps point their configs at it.
evidence_level: source
checks:
- id: c1
  source: '0x373a6e5c0c4e89e24819f00aa37ea370917aaff4'
  file: contracts/uln/dvn/MultiSig.sol
  line: 104
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: each signature is recovered with ECDSA.tryRecover
  for:
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x373a6e5c0c4e89e24819f00aa37ea370917aaff4'
  file: contracts/uln/dvn/MultiSig.sol
  line: 106
  has: if (error != ECDSA.RecoverError.NoError) return (false, Errors.SignatureError);
  says: a signature that fails recovery is rejected
  for:
  - what
- id: c3
  source: '0x373a6e5c0c4e89e24819f00aa37ea370917aaff4'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: recovery uses the ecrecover precompile
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0x373a6e5c0c4e89e24819f00aa37ea370917aaff4'
  file: contracts/uln/dvn/DVN.sol
  line: 104
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: signer changes are only via the contract's own signed execute
  for:
  - action
  - evidence-3
  - justification
- id: vs-len
  source: '0x373a6e5c0c4e89e24819f00aa37ea370917aaff4'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (_signatures.length != uint256(quorum) * 65) {
  line: 94
  says: exactly quorum 65-byte signatures are required
  for:
  - what
- id: c-member
  source: '0x373a6e5c0c4e89e24819f00aa37ea370917aaff4'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (!isSigner(currentSigner)) return (false, Errors.SignerNotInCommittee);
  line: 108
  says: recovered address must be in the signer set
  for:
  - evidence-1
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: review (Review04)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This DVN accepts a call to execute only when a quorum of signatures recovers, via ecrecover, to addresses in its signer set. A quantum attacker who derives the signer keys can sign a forged quorum and verify fabricated LayerZero messages for OApps that require this DVN.

## Evidence

- [verifySignatures](https://etherscan.io/address/0x373a6e5c0c4e89e24819f00aa37ea370917aaff4#code) recovers each 65-byte signature with ECDSA.tryRecover and checks committee membership.
- [tryRecover](https://etherscan.io/address/0x373a6e5c0c4e89e24819f00aa37ea370917aaff4#code) relies on the ecrecover precompile.
- [setSigner](https://etherscan.io/address/0x373a6e5c0c4e89e24819f00aa37ea370917aaff4#code) is onlySelf and adds signer addresses checked by ECDSA recovery.

## Reviewer notes

### Mechanism

MultiSig.verifySignatures (lines 93-112) requires _signatures.length == quorum*65 (line 94) and forms the EIP-191 digest (line 98). For each slice it calls ECDSA.tryRecover (line 104), which calls ecrecover (ECDSA.sol line 139). It rejects recovery errors (106), unordered signers (107) and non-members (108). DVN.execute uses this check before calling targets such as ReceiveUln302.verify. Once all required DVNs of an OApp verify, the payload can be committed and executed by lzReceive. setSigner (DVN.sol line 104) is onlySelf, so rotation is only to other ECDSA addresses. Kev reports quorum 1 of 1 for this DVN.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The DVN itself holds no funds; funds sit in the OApps that require it.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
