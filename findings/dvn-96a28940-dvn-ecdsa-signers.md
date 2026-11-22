---
id: dvn-96a28940-dvn-ecdsa-signers
format: 2
title: LayerZero DVN accepts ECDSA signer quorums that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged signer quorums verify fake messages for OApps requiring this DVN; operators must deploy a
  post-quantum DVN.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x96a2894042dfec802a23b1ad02f0314ac24b6010'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0x96a2894042dfec802a23b1ad02f0314ac24b6010#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and have OApps point their configs at it.
evidence_level: source
checks:
- id: c1
  source: '0x96a2894042dfec802a23b1ad02f0314ac24b6010'
  file: contracts/uln/dvn/MultiSig.sol
  line: 104
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: Each signature slice is recovered with ECDSA.tryRecover.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c2
  source: '0x96a2894042dfec802a23b1ad02f0314ac24b6010'
  file: contracts/uln/dvn/MultiSig.sol
  line: 106
  has: if (error != ECDSA.RecoverError.NoError) return (false, Errors.SignatureError);
  says: A failed recovery rejects the quorum.
  for:
  - what
- id: c3
  source: '0x96a2894042dfec802a23b1ad02f0314ac24b6010'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: Recovery uses the ecrecover precompile.
  for:
  - evidence-3
  - justification
  - what
- id: c4
  source: '0x96a2894042dfec802a23b1ad02f0314ac24b6010'
  file: contracts/uln/dvn/DVN.sol
  line: 104
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: Signers change only through onlySelf setSigner.
  for:
  - evidence-3
- id: s-len
  source: '0x96a2894042dfec802a23b1ad02f0314ac24b6010'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (_signatures.length != uint256(quorum) * 65) {
  line: 94
  says: Signatures must be exactly quorum 65-byte entries.
  for:
  - evidence-1
  - what
- id: s-member
  source: '0x96a2894042dfec802a23b1ad02f0314ac24b6010'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (!isSigner(currentSigner)) return (false, Errors.SignerNotInCommittee);
  line: 108
  says: Recovered signer must be in the committee.
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

This DVN accepts a call when a quorum of 65-byte signatures each recovers, via ECDSA, to an address in its signer set. A quantum attacker who derives the signer keys from their public keys can sign a fabricated packet verification for OApps that require this DVN.

## Evidence

- [verifySignatures](https://etherscan.io/address/0x96a2894042dfec802a23b1ad02f0314ac24b6010#code) requires exactly quorum × 65 bytes of signatures.
- [verifySignatures](https://etherscan.io/address/0x96a2894042dfec802a23b1ad02f0314ac24b6010#code) recovers each signer with ECDSA.tryRecover and checks it is in the committee.
- [setSigner](https://etherscan.io/address/0x96a2894042dfec802a23b1ad02f0314ac24b6010#code) is onlySelf, so signers can be swapped only for other addresses checked by ecrecover.

## Reviewer notes

### Mechanism

MultiSig.verifySignatures (MultiSig.sol lines 93-112) requires _signatures.length == quorum*65 (line 94), wraps the hash with the EIP-191 prefix (line 98), then for each 65-byte slice calls ECDSA.tryRecover (line 104), which uses ecrecover (ECDSA.sol line 139). Each recovered signer must be strictly ascending (line 107) and in signerSet (line 108). In the finding, DVN.execute uses this check before calling ReceiveUln302.verify for the receiving OApp's packet. quorumChangeAdmin grants ADMIN_ROLE on quorum signatures alone. setSigner (DVN.sol line 104) is onlySelf and only rotates to other ECDSA addresses.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract is not upgradeable; holds no funds itself.
- Ruled out: No transactions from this DVN were recorded in the study window.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
