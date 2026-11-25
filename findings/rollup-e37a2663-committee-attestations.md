---
id: rollup-e37a2663-committee-attestations
format: 2
title: Aztec Rollup trusts ECDSA committee attestations a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Attester keys are ECDSA; only Governance can fix it, by registering a new rollup version with post-quantum
  keys.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe37a2663cc9c119ba41572c40fab0bbb23a5402f'
  name: Rollup
  project: aztec
  code: verified
  code_url: https://etherscan.io/address/0xe37a2663cc9c119ba41572c40fab0bbb23a5402f#code
  copies: 1
  admin: '0x1102471eb3378fee427121c9efcea452e4b6b75e'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 48528
impact: funds-loss
action: Deploy and register a rollup version whose attestations use post-quantum signatures, and move stake, portals
  and users to it.
evidence_level: source
checks:
- id: c1
  source: '0xe37a2663cc9c119ba41572c40fab0bbb23a5402f'
  file: src/shared/libraries/SignatureLib.sol
  line: 25
  has: address recovered = ECDSA.recover(_digest, _signature.v, _signature.r, _signature.s);
  says: Proposer signatures are checked by ECDSA recovery.
  for:
  - evidence-1
  - what
- id: c2
  source: '0xe37a2663cc9c119ba41572c40fab0bbb23a5402f'
  file: src/core/libraries/rollup/ValidatorSelectionLib.sol
  line: 375
  has: stack.reconstructedCommittee[i] = ECDSA.recover(_digest, v, r, s);
  says: Committee attestations are ECDSA-recovered to rebuild the committee.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c3
  source: '0xe37a2663cc9c119ba41572c40fab0bbb23a5402f'
  file: lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 148
  has: address signer = ecrecover(hash, v, r, s);
  says: ECDSA recovery uses the ecrecover precompile.
  for:
  - what
- id: c5
  source: '0xe37a2663cc9c119ba41572c40fab0bbb23a5402f'
  file: src/core/libraries/rollup/InvalidateLib.sol
  line: 108
  has: (recovered,,) = ECDSA.tryRecover(digest, signature.v, signature.r, signature.s);
  says: Attestation challenges also rely on ECDSA recovery.
  for:
  - evidence-3
- id: c6
  source: '0xe37a2663cc9c119ba41572c40fab0bbb23a5402f'
  file: lib/openzeppelin-contracts/contracts/access/Ownable.sol
  line: 84
  has: function transferOwnership(address newOwner) public virtual onlyOwner {
  says: The contract has an owner (Governance) that holds admin rights.
  for:
  - justification
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review00 (Sourcify/Blockscout source of rollup versions 0, 2 and 3; Registry, GSE, Governance and portal
    reads; Xatu activity of the new contracts)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

The Rollup accepts L2 block proposals only with ECDSA signatures from the slot's proposer and from committee members. A quantum attacker who derives attester keys can sign proposals and attestations for blocks of its choosing on this rollup.

## Evidence

- [verify](https://etherscan.io/address/0xe37a2663cc9c119ba41572c40fab0bbb23a5402f#code) accepts a proposer signature only if ECDSA recovers the expected signer.
- [verifyAttestations](https://etherscan.io/address/0xe37a2663cc9c119ba41572c40fab0bbb23a5402f#code) rebuilds the committee by ECDSA-recovering each attester's signature.
- [invalidateBadAttestation](https://etherscan.io/address/0xe37a2663cc9c119ba41572c40fab0bbb23a5402f#code) also judges attestations through ECDSA recovery.

## Reviewer notes

### Mechanism

Rollup.propose calls ValidatorSelectionLib.verifyProposer, which checks the proposer's signature over the block digest and the attestation list through SignatureLib.verify (ECDSA.recover, SignatureLib.sol line 25). verifyAttestations (ValidatorSelectionLib.sol lines 357-396) recovers each signing committee member with ECDSA.recover (line 375), requires at least 2/3+1 signatures, and matches the rebuilt committee against the stored commitment. InvalidateLib.invalidateBadAttestation (line 108) uses ECDSA.tryRecover for challenges. With attester keys derived by a quantum computer, an attacker passes these checks. Once the epoch is proven via submitEpochRootProof (requires a forged proof too, separate finding), the block's L2-to-L1 messages let portals release tokens and FeeJuicePortal pay out. The verifier and signature scheme are fixed in this deployment; Governance must register a new version.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The rollup's own AZTEC balance is owed rewards that forged blocks do not unlock.
- Ruled out: Slashed validator stake is not paid to the attacker.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
