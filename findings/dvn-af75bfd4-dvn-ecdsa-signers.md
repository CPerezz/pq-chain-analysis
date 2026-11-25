---
id: dvn-af75bfd4-dvn-ecdsa-signers
format: 2
title: LayerZero DVN accepts ECDSA signer quorums that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: DVN calls pass on secp256k1 quorum signatures; MEDIUM as operators can fix by deploying a post-quantum
  DVN.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xaf75bfd402f3d4ee84978179a6c87d16c4bd1724'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0xaf75bfd402f3d4ee84978179a6c87d16c4bd1724#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs, and have OApps and LayerZero defaults point
  to it.
evidence_level: source
checks:
- id: c1
  source: '0xaf75bfd402f3d4ee84978179a6c87d16c4bd1724'
  file: contracts/uln/dvn/MultiSig.sol
  line: 91
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: Each quorum signature is recovered with ECDSA.tryRecover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xaf75bfd402f3d4ee84978179a6c87d16c4bd1724'
  file: contracts/uln/dvn/MultiSig.sol
  line: 93
  has: if (error != ECDSA.RecoverError.NoError) return (false, Errors.SignatureError);
  says: A failed recovery rejects the signatures.
  for:
  - evidence-1
  - what
- id: c3
  source: '0xaf75bfd402f3d4ee84978179a6c87d16c4bd1724'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover uses the secp256k1 ecrecover precompile.
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0xaf75bfd402f3d4ee84978179a6c87d16c4bd1724'
  file: contracts/uln/dvn/DVN.sol
  line: 99
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: Signer changes are onlySelf and set signer addresses.
  for:
  - action
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
  who: review (Review04)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This DVN executes calls, such as verifying cross-chain messages, only when a quorum of signatures recovers by ECDSA to its signer set. A quantum attacker who recovers enough signer keys can forge a quorum and verify fabricated messages for OApps that require this DVN.

## Evidence

- [verifySignatures](https://etherscan.io/address/0xaf75bfd402f3d4ee84978179a6c87d16c4bd1724#code) recovers each 65-byte signature with ECDSA.tryRecover.
- [tryRecover](https://etherscan.io/address/0xaf75bfd402f3d4ee84978179a6c87d16c4bd1724#code) calls the ecrecover precompile (secp256k1).
- [setSigner](https://etherscan.io/address/0xaf75bfd402f3d4ee84978179a6c87d16c4bd1724#code) is onlySelf and adds signer addresses, which are ECDSA keys.

## Reviewer notes

### Mechanism

MultiSig.verifySignatures (lines 81-99) requires signatures.length == quorum*65, computes the EIP-191 digest, and for each 65-byte slice calls ECDSA.tryRecover (line 91), which uses ecrecover (ECDSA.sol line 139). Signers must be ascending and in the signers mapping (lines 94-95). DVN.execute uses this check before making target calls, in practice ReceiveUln302.verify. Once all of an OApp's required DVNs have verified, the payload can be committed to EndpointV2 and executed by lzReceive. Per kev, quorumChangeAdmin grants ADMIN_ROLE on quorum signatures alone. setSigner (DVN.sol line 99) is onlySelf and rotates only to other ECDSA addresses.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract is not upgradeable; it holds about $0 itself.
- Ruled out: No quorum or study-window activity was read for this address.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
