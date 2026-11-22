---
id: dvn-38654142-dvn-ecdsa-signers
format: 2
title: Frax LayerZero DVN accepts ECDSA signer quorums a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged signer quorums verify fake messages for OApps relying on this DVN; the operator fixes it by
  deploying a PQ DVN.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x38654142f5e672ae86a1b21523aafc765e6a1e08'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0x38654142f5e672ae86a1b21523aafc765e6a1e08#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 5820
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and move OApp configs to it.
evidence_level: source
checks:
- id: c1
  source: '0x38654142f5e672ae86a1b21523aafc765e6a1e08'
  file: contracts/uln/dvn/MultiSig.sol
  line: 104
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: verifySignatures recovers each signature with ECDSA.tryRecover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c3
  source: '0x38654142f5e672ae86a1b21523aafc765e6a1e08'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover calls the ecrecover precompile.
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0x38654142f5e672ae86a1b21523aafc765e6a1e08'
  file: contracts/uln/dvn/DVN.sol
  line: 104
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: setSigner is callable only by the DVN itself and sets signer addresses.
  for:
  - action
  - evidence-3
- id: v94
  source: '0x38654142f5e672ae86a1b21523aafc765e6a1e08'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (_signatures.length != uint256(quorum) * 65) {
  line: 94
  says: The signature bytes must equal quorum × 65.
  for:
  - evidence-1
  - what
- id: v108
  source: '0x38654142f5e672ae86a1b21523aafc765e6a1e08'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (!isSigner(currentSigner)) return (false, Errors.SignerNotInCommittee);
  line: 108
  says: Each recovered address must be a committee signer.
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

This DVN verifies LayerZero messages for OApps on Ethereum, and it acts on a call only when a quorum of secp256k1 signatures recovers to its signers. A quantum attacker who recovers a quorum of signer keys can sign fabricated verifications for OApps that require this DVN.

## Evidence

- [verifySignatures](https://etherscan.io/address/0x38654142f5e672ae86a1b21523aafc765e6a1e08#code) needs quorum × 65 bytes of signatures and recovers each signature with ECDSA.
- [tryRecover](https://etherscan.io/address/0x38654142f5e672ae86a1b21523aafc765e6a1e08#code) calls ecrecover, and each recovered address must be in the signer set.
- [setSigner](https://etherscan.io/address/0x38654142f5e672ae86a1b21523aafc765e6a1e08#code) is self-only and adds ECDSA signer addresses, so rotation stays within ECDSA.

## Reviewer notes

### Mechanism

DVN.execute hashes each target call and checks MultiSig.verifySignatures (MultiSig.sol lines 93-112). Line 94 requires quorum*65 bytes. Line 104 calls ECDSA.tryRecover, which uses ecrecover (ECDSA.sol line 139). Line 107 requires signers in ascending order, and line 108 requires each recovered address to be in signerSet. The verified call is in practice ReceiveUln302.verify. Once all of an OApp's required DVNs have verified, the payload is committed to EndpointV2 and lzReceive executes it. Per kev, quorumChangeAdmin grants ADMIN_ROLE on quorum signatures alone. setSigner and setQuorum are onlySelf (DVN.sol line 104), so signers can be rotated only to other ECDSA addresses. Kev reads this DVN as Frax, quorum 2 of 3.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The DVN itself holds no funds; the funds sit in the consuming OApps.
- Ruled out: Not upgradeable: no proxy.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
