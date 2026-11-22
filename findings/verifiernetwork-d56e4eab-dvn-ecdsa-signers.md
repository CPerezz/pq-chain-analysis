---
id: verifiernetwork-d56e4eab-dvn-ecdsa-signers
format: 2
title: LayerZero Google DVN trusts ECDSA quorums a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: A forged ECDSA quorum verifies fake messages; operators and OApp configs must move to a post-quantum
  DVN.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd56e4eab23cb81f43168f9f45211eb027b9ac7cc'
  name: VerifierNetwork
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0xd56e4eab23cb81f43168f9f45211eb027b9ac7cc#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 13978
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures and have OApps and default configs point to it.
evidence_level: source
checks:
- id: c1
  source: '0xd56e4eab23cb81f43168f9f45211eb027b9ac7cc'
  file: contracts/uln/MultiSig.sol
  line: 65
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: verifySignatures recovers each signer with ECDSA.tryRecover.
  for:
  - evidence-1
  - justification
  - what
- id: c3
  source: '0xd56e4eab23cb81f43168f9f45211eb027b9ac7cc'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover uses the ecrecover precompile (secp256k1).
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c4
  source: '0xd56e4eab23cb81f43168f9f45211eb027b9ac7cc'
  file: contracts/uln/VerifierNetwork.sol
  line: 86
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: setSigner is only callable by the contract itself.
  for:
  - action
  - evidence-3
  - justification
- id: nc-member
  source: '0xd56e4eab23cb81f43168f9f45211eb027b9ac7cc'
  file: contracts/uln/MultiSig.sol
  has: if (!signers[currentSigner]) return (false, Errors.SignerNotInCommittee);
  line: 69
  says: Each recovered signer must be in the committee.
  for:
  - evidence-1
  - what
- id: nc-quorum
  source: '0xd56e4eab23cb81f43168f9f45211eb027b9ac7cc'
  file: contracts/uln/MultiSig.sol
  has: if (_signatures.length != uint(quorum) * 65) {
  line: 56
  says: The check requires exactly quorum 65-byte signatures.
  for:
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

This VerifierNetwork verifies LayerZero messages for OApps on Ethereum and accepts a call when a quorum of its signers' ECDSA signatures recovers to committee members. A quantum attacker who derives the signer keys can sign fake message verifications that OApps relying on this verifier accept.

## Evidence

- [verifySignatures](https://etherscan.io/address/0xd56e4eab23cb81f43168f9f45211eb027b9ac7cc#code) recovers each 65-byte signature with ECDSA and checks the signer is in the committee.
- [tryRecover](https://etherscan.io/address/0xd56e4eab23cb81f43168f9f45211eb027b9ac7cc#code) relies on the secp256k1 ecrecover precompile.
- [setSigner](https://etherscan.io/address/0xd56e4eab23cb81f43168f9f45211eb027b9ac7cc#code) is callable only by the contract itself and sets signer addresses.

## Reviewer notes

### Mechanism

MultiSig.verifySignatures (lines 55-73) requires _signatures.length == quorum*65 (line 56). It hashes with the EIP-191 prefix (line 60), then for each 65-byte slice calls ECDSA.tryRecover (line 65), which calls ecrecover (ECDSA.sol line 139). It requires ascending signers (line 68) and committee membership (line 69). The VerifierNetwork execute path makes the signed call, in practice ReceiveUln302.verify, once this check passes. setSigner (VerifierNetwork.sol line 86) is onlySelf, so signers rotate only to other ECDSA addresses. Per kev, the quorum here is 2 of 3. Once all required DVNs of an OApp have verified a packet, it can be committed to EndpointV2 and executed by lzReceive, which releases or mints funds.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract itself holds no funds; the escrow sits in the OApps.
- Ruled out: Not an upgradeable proxy.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
