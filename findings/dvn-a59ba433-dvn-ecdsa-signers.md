---
id: dvn-a59ba433-dvn-ecdsa-signers
format: 2
title: LayerZero Twinstake DVN accepts ECDSA quorums a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged signer quorum verifies fake messages for OApps; the operator must deploy a post-quantum DVN,
  no protocol change
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa59ba433ac34d2927232918ef5b2eaafcf130ba5'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0xa59ba433ac34d2927232918ef5b2eaafcf130ba5#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 245658
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and have OApps and the default config point
  at it
evidence_level: source
checks:
- id: c1
  source: '0xa59ba433ac34d2927232918ef5b2eaafcf130ba5'
  file: contracts/uln/dvn/MultiSig.sol
  line: 91
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: Each signature slice is recovered with ECDSA.tryRecover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c3
  source: '0xa59ba433ac34d2927232918ef5b2eaafcf130ba5'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: Recovery uses the ecrecover precompile.
  for:
  - evidence-1
  - justification
  - what
- id: c4
  source: '0xa59ba433ac34d2927232918ef5b2eaafcf130ba5'
  file: contracts/uln/dvn/DVN.sol
  line: 99
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: setSigner is onlySelf and sets signer addresses.
  for:
  - evidence-3
- id: q1
  source: '0xa59ba433ac34d2927232918ef5b2eaafcf130ba5'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (_signatures.length != uint256(quorum) * 65) {
  line: 82
  says: Signature blob must be exactly quorum 65-byte signatures.
  for:
  - what
- id: s95
  source: '0xa59ba433ac34d2927232918ef5b2eaafcf130ba5'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (!signers[currentSigner]) return (false, Errors.SignerNotInCommittee);
  line: 95
  says: Recovered address must be an active signer.
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
reviews: []
related: []
---

## What happens

This DVN executes calls, such as verifying cross-chain packets, only when a quorum of ECDSA signatures recovers to its listed signers. A quantum attacker who derives the signer keys forges that quorum and verifies fabricated packets for OApps that require this DVN.

## Evidence

- [verifySignatures](https://etherscan.io/address/0xa59ba433ac34d2927232918ef5b2eaafcf130ba5#code) recovers each 65-byte signature with ECDSA.tryRecover.
- [verifySignatures](https://etherscan.io/address/0xa59ba433ac34d2927232918ef5b2eaafcf130ba5#code) accepts a recovered address if it is in the signers set.
- [setSigner](https://etherscan.io/address/0xa59ba433ac34d2927232918ef5b2eaafcf130ba5#code) rotates signers to other addresses, which are again ECDSA keys.

## Reviewer notes

### Mechanism

DVN.execute (ADMIN_ROLE) hashes each target call and checks MultiSig.verifySignatures(hash, signatures): line 82 requires signatures.length == quorum*65; lines 89-97 recover each slice with ECDSA.tryRecover (line 91, ecrecover at ECDSA.sol line 139), require ascending order (line 94) and membership in signers (line 95). The call made is in practice ReceiveUln302.verify; once all required DVNs verify, the payload is committed to EndpointV2 and lzReceive releases funds. quorumChangeAdmin grants ADMIN_ROLE on quorum signatures alone. setSigner (DVN.sol line 99) is onlySelf and only rotates to other ECDSA addresses.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The DVN itself holds no funds; the value sits in the OApps that require it.
- Ruled out: No proxy or upgrade function.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
