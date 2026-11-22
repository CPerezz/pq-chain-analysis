---
id: dvn-c9ca319f-dvn-ecdsa-signers
format: 2
title: BitGo LayerZero DVN accepts ECDSA signer quorums a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged 3-of-3 ECDSA quorum verifies fake messages; the operator fixes it by deploying a post-quantum
  DVN.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc9ca319f6da263910fd9b037ec3d817a814ef3d8'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0xc9ca319f6da263910fd9b037ec3d817a814ef3d8#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 4256
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and have OApps point their configs at it.
evidence_level: source
checks:
- id: c1
  source: '0xc9ca319f6da263910fd9b037ec3d817a814ef3d8'
  file: contracts/uln/dvn/MultiSig.sol
  line: 104
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: Each signature is recovered with ECDSA.tryRecover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c3
  source: '0xc9ca319f6da263910fd9b037ec3d817a814ef3d8'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: Recovery uses the ecrecover precompile (secp256k1).
  for:
  - justification
  - what
- id: c4
  source: '0xc9ca319f6da263910fd9b037ec3d817a814ef3d8'
  file: contracts/uln/dvn/DVN.sol
  line: 104
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: 'setSigner is onlySelf: signers rotate to other addresses via the same quorum.'
  for:
  - action
  - evidence-3
  - justification
- id: vs-len
  source: '0xc9ca319f6da263910fd9b037ec3d817a814ef3d8'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (_signatures.length != uint256(quorum) * 65) {
  line: 94
  says: Signature bytes must equal quorum times 65.
  for:
  - evidence-1
  - what
- id: in-set
  source: '0xc9ca319f6da263910fd9b037ec3d817a814ef3d8'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (!isSigner(currentSigner)) return (false, Errors.SignerNotInCommittee);
  line: 108
  says: A recovered signer must be in the signer set.
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

This DVN acts on a call only when a quorum of signatures, each recovered with ECDSA, comes from its signer set. A quantum attacker who derives the signer keys can sign fake messages for OApps that require this DVN.

## Evidence

- [verifySignatures](https://etherscan.io/address/0xc9ca319f6da263910fd9b037ec3d817a814ef3d8#code) needs exactly quorum × 65 bytes of signatures and recovers each with ECDSA.
- [verifySignatures](https://etherscan.io/address/0xc9ca319f6da263910fd9b037ec3d817a814ef3d8#code) accepts a recovered address if it is in the signer set.
- [setSigner](https://etherscan.io/address/0xc9ca319f6da263910fd9b037ec3d817a814ef3d8#code) is callable only by the contract itself, so signer changes stay ECDSA addresses.

## Reviewer notes

### Mechanism

MultiSig.verifySignatures (lines 93-112) requires _signatures.length == quorum*65 (line 94), hashes with the EIP-191 prefix (line 98), and for each 65-byte slice calls ECDSA.tryRecover (line 104), which ends in ecrecover (ECDSA.sol line 139). Recovered signers must ascend (line 107) and be in signerSet (line 108). DVN.execute uses this check before calling targets such as ReceiveUln302.verify; once all required DVNs of an OApp verify, the packet can be committed and executed. setSigner (DVN.sol line 104) is onlySelf, so rotation goes only to other ECDSA keys. The finding records this deprecated DVN at quorum 3 of 3.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The DVN holds no funds itself; funds sit in the OApps that require it.
- Ruled out: Not upgradeable: no proxy.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
