---
id: dvn-3f965b50-dvn-ecdsa-signers
format: 2
title: LayerZero DVN accepts ECDSA signer quorums that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged signer quorum verifies fake messages for OApps requiring this DVN; operator must deploy a
  post-quantum DVN.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x3f965b507a3ab2dd945c1796c973b206af4e5fcb'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0x3f965b507a3ab2dd945c1796c973b206af4e5fcb#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 404
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and move OApp configs to it.
evidence_level: source
checks:
- id: c1
  source: '0x3f965b507a3ab2dd945c1796c973b206af4e5fcb'
  file: contracts/uln/dvn/MultiSig.sol
  line: 104
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: verifySignatures recovers each signature with ECDSA.tryRecover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x3f965b507a3ab2dd945c1796c973b206af4e5fcb'
  file: contracts/uln/dvn/MultiSig.sol
  line: 106
  has: if (error != ECDSA.RecoverError.NoError) return (false, Errors.SignatureError);
  says: A failed recovery rejects the signature set.
  for:
  - what
- id: c3
  source: '0x3f965b507a3ab2dd945c1796c973b206af4e5fcb'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover uses the ecrecover precompile.
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0x3f965b507a3ab2dd945c1796c973b206af4e5fcb'
  file: contracts/uln/dvn/DVN.sol
  line: 104
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: setSigner changes signer addresses, only via the contract itself.
  for:
  - evidence-3
- id: vs-len
  source: '0x3f965b507a3ab2dd945c1796c973b206af4e5fcb'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (_signatures.length != uint256(quorum) * 65) {
  line: 94
  says: Signature blob must be exactly quorum 65-byte signatures.
  for:
  - what
- id: c8
  source: '0x3f965b507a3ab2dd945c1796c973b206af4e5fcb'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (!isSigner(currentSigner)) return (false, Errors.SignerNotInCommittee);
  line: 108
  says: Each recovered address must be in the signer committee.
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

This DVN acts on a call only when a quorum of its signers' secp256k1 signatures recovers via ecrecover to committee members. A quantum attacker who recovers a quorum of signer keys can forge that quorum and have the DVN verify fabricated cross-chain messages.

## Evidence

- [verifySignatures](https://etherscan.io/address/0x3f965b507a3ab2dd945c1796c973b206af4e5fcb#code) recovers each 65-byte slice with ECDSA.tryRecover and requires a committee signer.
- [tryRecover](https://etherscan.io/address/0x3f965b507a3ab2dd945c1796c973b206af4e5fcb#code) calls the ecrecover precompile.
- [setSigner](https://etherscan.io/address/0x3f965b507a3ab2dd945c1796c973b206af4e5fcb#code) rotates signer addresses, which are ECDSA keys.

## Reviewer notes

### Mechanism

MultiSig.verifySignatures (lines 93-112) requires _signatures.length == quorum*65, hashes with the EIP-191 prefix, and for each slice calls ECDSA.tryRecover (line 104), which calls ecrecover (ECDSA.sol line 139); recovered signers must be strictly ascending and in signerSet (line 108). Per kev, DVN.execute acts on such a quorum, in practice calling ReceiveUln302.verify; once all required DVNs of an OApp verify, the payload commits to EndpointV2 and lzReceive runs. setSigner (DVN.sol line 104) is onlySelf and rotates only to other ECDSA addresses.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No proxy; the contract is not upgradeable.
- Ruled out: The DVN itself holds about nothing; funds sit in the OApps.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
