---
id: dvn-b0b2ef16-dvn-ecdsa-signers
format: 2
title: Paxos LayerZero DVN accepts one ECDSA signature a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: A forged signer quorum verifies fake messages for OApps that require this DVN; the operator must
  deploy a PQ DVN.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb0b2ef168f52f6d1e42f461e11117295ef992daf'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0xb0b2ef168f52f6d1e42f461e11117295ef992daf#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 24255
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and have OApps point their configs at it.
evidence_level: source
checks:
- id: c1
  source: '0xb0b2ef168f52f6d1e42f461e11117295ef992daf'
  file: contracts/uln/dvn/MultiSig.sol
  line: 91
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: verifySignatures recovers each signer with ECDSA.tryRecover.
  for:
  - action
  - evidence-1
  - evidence-3
  - justification
  - what
- id: c3
  source: '0xb0b2ef168f52f6d1e42f461e11117295ef992daf'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover calls the ecrecover precompile.
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0xb0b2ef168f52f6d1e42f461e11117295ef992daf'
  file: contracts/uln/dvn/DVN.sol
  line: 99
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: setSigner is onlySelf, changing signers via the multisig.
  for:
  - evidence-3
- id: c-len
  source: '0xb0b2ef168f52f6d1e42f461e11117295ef992daf'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (_signatures.length != uint256(quorum) * 65) {
  line: 82
  says: Exactly quorum 65-byte signatures are required.
  for:
  - what
- id: c-member
  source: '0xb0b2ef168f52f6d1e42f461e11117295ef992daf'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (!signers[currentSigner]) return (false, Errors.SignerNotInCommittee);
  line: 95
  says: Each recovered address must be a committee signer.
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

This DVN acts on cross-chain messages only after a quorum of its signers sign, checked by recovering each ECDSA signature. A quantum attacker who derives a signer key forges the quorum and makes the DVN verify fabricated messages.

## Evidence

- [verifySignatures](https://etherscan.io/address/0xb0b2ef168f52f6d1e42f461e11117295ef992daf#code) recovers each 65-byte signature with ECDSA and requires the signer to be in the committee.
- [tryRecover](https://etherscan.io/address/0xb0b2ef168f52f6d1e42f461e11117295ef992daf#code) uses the ecrecover precompile on secp256k1 signatures.
- [setSigner](https://etherscan.io/address/0xb0b2ef168f52f6d1e42f461e11117295ef992daf#code) rotates signers only to other addresses checked the same ECDSA way.

## Reviewer notes

### Mechanism

DVN.execute (ADMIN_ROLE) hashes the target calls and calls MultiSig.verifySignatures (MultiSig.sol lines 81-99): it requires signatures.length == quorum*65 (line 82), recovers each slice with ECDSA.tryRecover (line 91, ecrecover at ECDSA.sol line 139), enforces ascending order (line 94) and committee membership (line 95). The call that follows is ReceiveUln302.verify; once all required DVNs of an OApp have verified, the payload hash is committed to EndpointV2 and lzReceive executes it. Per kev's census this DVN's quorum is 1 of 1, so a single recovered key suffices. quorumChangeAdmin grants ADMIN_ROLE on quorum signatures alone; setSigner/setQuorum are onlySelf (DVN.sol line 99) and keep ECDSA keys.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The DVN holds no funds itself; value sits in the OApps that require it.
- Ruled out: Not upgradeable; no proxy.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
