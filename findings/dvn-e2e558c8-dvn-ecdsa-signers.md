---
id: dvn-e2e558c8-dvn-ecdsa-signers
format: 2
title: LayerZero DVN accepts ECDSA signer quorums that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Signer quorum is ECDSA; operator must deploy a post-quantum DVN and configs must point at it, no
  protocol change
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe2e558c85e00b4d7529433c1cc78ab678cf62538'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0xe2e558c85e00b4d7529433c1cc78ab678cf62538#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 2855
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and have OApp configs point at it
evidence_level: source
checks:
- id: c1
  source: '0xe2e558c85e00b4d7529433c1cc78ab678cf62538'
  file: contracts/uln/dvn/MultiSig.sol
  line: 104
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: Each signature is recovered with ECDSA.tryRecover
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xe2e558c85e00b4d7529433c1cc78ab678cf62538'
  file: contracts/uln/dvn/MultiSig.sol
  line: 106
  has: if (error != ECDSA.RecoverError.NoError) return (false, Errors.SignatureError);
  says: Signature passes if ECDSA recovery succeeds
  for:
  - what
- id: c3
  source: '0xe2e558c85e00b4d7529433c1cc78ab678cf62538'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: Recovery uses the ecrecover precompile
  for:
  - evidence-3
  - justification
  - what
- id: c4
  source: '0xe2e558c85e00b4d7529433c1cc78ab678cf62538'
  file: contracts/uln/dvn/DVN.sol
  line: 104
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: Signers change only via self-call setSigner
  for:
  - evidence-3
- id: v108
  source: '0xe2e558c85e00b4d7529433c1cc78ab678cf62538'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (!isSigner(currentSigner)) return (false, Errors.SignerNotInCommittee);
  line: 108
  says: Recovered signer must be in the committee set
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

This DVN verifies LayerZero messages for OApps when a quorum of its signers signs; each signature is checked with ECDSA recovery against the signer set. A quantum attacker who recovers enough signer keys forges the quorum and gets fake messages verified for OApps that rely on this DVN.

## Evidence

- [verifySignatures](https://etherscan.io/address/0xe2e558c85e00b4d7529433c1cc78ab678cf62538#code) recovers each 65-byte signature with ECDSA.tryRecover.
- [verifySignatures](https://etherscan.io/address/0xe2e558c85e00b4d7529433c1cc78ab678cf62538#code) accepts a recovered address if it is in the signer set.
- [setSigner](https://etherscan.io/address/0xe2e558c85e00b4d7529433c1cc78ab678cf62538#code) rotates signers only to other addresses checked by ecrecover.

## Reviewer notes

### Mechanism

MultiSig.verifySignatures (lines 93-112) requires signatures.length == quorum*65, computes the EIP-191 digest, and for each slice calls ECDSA.tryRecover (line 104), which uses ecrecover (ECDSA.sol line 139); recovered addresses must ascend and be in signerSet (lines 107-108). DVN execution uses this check before calling the target, in practice ReceiveUln302.verify; once all required DVNs of an OApp verify, the payload can be committed and lzReceive executes it. setSigner (DVN.sol line 104) is onlySelf, so signers can rotate only to other ECDSA keys. Per kev, quorumChangeAdmin grants ADMIN_ROLE on quorum signatures alone.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract holds no funds itself; funds sit in the OApps that require this DVN
- Ruled out: Not upgradeable

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
