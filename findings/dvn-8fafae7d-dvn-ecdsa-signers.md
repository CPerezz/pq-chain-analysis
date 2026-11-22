---
id: dvn-8fafae7d-dvn-ecdsa-signers
format: 2
title: Stargate's LayerZero DVN accepts ECDSA quorums a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: A forged signer quorum makes this DVN verify fake messages; the operator must deploy a post-quantum
  DVN.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x8fafae7dd957044088b3d0f67359c327c6200d18'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0x8fafae7dd957044088b3d0f67359c327c6200d18#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 230
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and have OApps point their configs at it.
evidence_level: source
checks:
- id: c1
  source: '0x8fafae7dd957044088b3d0f67359c327c6200d18'
  file: contracts/uln/dvn/MultiSig.sol
  line: 91
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: Each signature is recovered with ECDSA.tryRecover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x8fafae7dd957044088b3d0f67359c327c6200d18'
  file: contracts/uln/dvn/MultiSig.sol
  line: 93
  has: if (error != ECDSA.RecoverError.NoError) return (false, Errors.SignatureError);
  says: Recovery failure rejects; success proceeds to membership check.
  for:
  - what
- id: c3
  source: '0x8fafae7dd957044088b3d0f67359c327c6200d18'
  file: node_modules/@openzeppelin/contracts/utils/cryptography/ECDSA.sol
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover uses the ecrecover precompile (secp256k1).
  for:
  - evidence-1
  - justification
  - what
- id: c4
  source: '0x8fafae7dd957044088b3d0f67359c327c6200d18'
  file: contracts/uln/dvn/DVN.sol
  line: 99
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: Signer rotation is onlySelf, to other addresses.
  for:
  - action
  - evidence-3
  - justification
- id: q1
  source: '0x8fafae7dd957044088b3d0f67359c327c6200d18'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (_signatures.length != uint256(quorum) * 65) {
  line: 82
  says: Signatures must number exactly the quorum.
  for:
  - what
- id: q2
  source: '0x8fafae7dd957044088b3d0f67359c327c6200d18'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (!signers[currentSigner]) return (false, Errors.SignerNotInCommittee);
  line: 95
  says: A recovered address is accepted if it is a committee signer.
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
  who: review (Review04)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not
    reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

This DVN executes calls, such as verifying cross-chain messages, only with a quorum of secp256k1 signatures from its signer set. A quantum attacker who recovers a quorum of signer keys can make it verify fabricated messages for OApps that require it.

## Evidence

- [verifySignatures](https://etherscan.io/address/0x8fafae7dd957044088b3d0f67359c327c6200d18#code) recovers each signer with ECDSA.tryRecover, which calls ecrecover.
- [verifySignatures](https://etherscan.io/address/0x8fafae7dd957044088b3d0f67359c327c6200d18#code) accepts a recovered address if it is in the signers committee.
- [setSigner](https://etherscan.io/address/0x8fafae7dd957044088b3d0f67359c327c6200d18#code) is onlySelf and rotates signers to other ECDSA addresses.

## Reviewer notes

### Mechanism

DVN.execute (ADMIN_ROLE) hashes each target call and checks MultiSig.verifySignatures(hash, signatures). The signatures length must equal quorum*65 (line 82). The digest is the eth-signed hash (line 86). Each 65-byte slice is recovered via ECDSA.tryRecover (line 91, ecrecover at ECDSA.sol line 139). Signers must be ascending (line 94) and members of signers (line 95). The call is then made, typically ReceiveUln302.verify. Once all required DVNs of an OApp verify, the payload can be committed to EndpointV2 and executed by lzReceive. quorumChangeAdmin grants ADMIN_ROLE on quorum signatures alone. setSigner/setQuorum are onlySelf, so rotation stays within ECDSA keys. Kev reads quorum 2 of 3 for this DVN. It is marked deprecated but still verified packets in the 30-day window.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The DVN itself holds no funds; value sits in the OApps that require it.
- Ruled out: No proxy or upgrade function.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
