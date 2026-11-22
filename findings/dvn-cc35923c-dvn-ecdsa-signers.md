---
id: dvn-cc35923c-dvn-ecdsa-signers
format: 2
title: LayerZero DVN accepts ECDSA signer quorums that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged signer quorum verifies fake messages for OApps that require this DVN; operator must deploy
  a post-quantum DVN.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xcc35923c43893cc31f2815e216afd7efb60f1fb0'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0xcc35923c43893cc31f2815e216afd7efb60f1fb0#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 82
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and have OApps point their configs at it.
evidence_level: source
checks:
- id: c1
  source: '0xcc35923c43893cc31f2815e216afd7efb60f1fb0'
  file: contracts/uln/dvn/MultiSig.sol
  line: 104
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: Each signature slice is checked with ECDSA.tryRecover.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c3
  source: '0xcc35923c43893cc31f2815e216afd7efb60f1fb0'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover uses the ecrecover precompile.
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0xcc35923c43893cc31f2815e216afd7efb60f1fb0'
  file: contracts/uln/dvn/DVN.sol
  line: 104
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: setSigner is onlySelf and takes an address (ECDSA key).
  for:
  - action
  - evidence-3
- id: q94
  source: '0xcc35923c43893cc31f2815e216afd7efb60f1fb0'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (_signatures.length != uint256(quorum) * 65) {
  line: 94
  says: Signatures must be exactly quorum 65-byte ECDSA signatures.
  for:
  - evidence-1
  - justification
  - what
- id: q108
  source: '0xcc35923c43893cc31f2815e216afd7efb60f1fb0'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (!isSigner(currentSigner)) return (false, Errors.SignerNotInCommittee);
  line: 108
  says: Each recovered address must be in the signer set.
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

This DVN accepts a call only when a quorum of secp256k1 signatures recovers to addresses in its signer set. A quantum attacker who derives the signer keys can sign a quorum and have the DVN verify fabricated cross-chain messages.

## Evidence

- [verifySignatures](https://etherscan.io/address/0xcc35923c43893cc31f2815e216afd7efb60f1fb0#code) requires exactly quorum × 65 signature bytes.
- [verifySignatures](https://etherscan.io/address/0xcc35923c43893cc31f2815e216afd7efb60f1fb0#code) recovers each signer with ECDSA (ecrecover) and checks it is in the committee.
- [setSigner](https://etherscan.io/address/0xcc35923c43893cc31f2815e216afd7efb60f1fb0#code) is callable only by the contract itself and swaps one ECDSA signer address for another.

## Reviewer notes

### Mechanism

MultiSig.verifySignatures (MultiSig.sol lines 93-112) requires _signatures.length == quorum*65 (line 94), wraps the hash as an Ethereum signed message (line 98), and for each 65-byte slice calls ECDSA.tryRecover (line 104), which uses ecrecover (ECDSA.sol line 139). Recovered signers must be strictly ascending (line 107) and in signerSet (line 108). Per kev's finding, DVN.execute uses this check before calling ReceiveUln302.verify, so a forged quorum lets fabricated packets be verified for OApps requiring this DVN. setSigner (DVN.sol line 104) is onlySelf and only rotates to other ECDSA addresses.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The DVN itself holds about $0; funds at risk sit in the OApps that require it.
- Ruled out: Not upgradeable per study data.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
