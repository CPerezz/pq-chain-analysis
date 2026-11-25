---
id: rollup-91ff8bbd-committee-attestations
format: 2
title: Aztec Rollup v2 trusts ECDSA attester keys that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Block proposals and attestations rest on ECDSA; Aztec Governance must fix it by registering a post-quantum
  rollup.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x91ff8bbd8ebb07893010d50a48a1609e5ebd8e34'
  name: Rollup
  project: aztec
  code: verified
  code_url: https://etherscan.io/address/0x91ff8bbd8ebb07893010d50a48a1609e5ebd8e34#code
  copies: 1
  admin: '0x1102471eb3378fee427121c9efcea452e4b6b75e'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 186242
impact: funds-loss
action: Register a new rollup version whose attester and proposer signatures use post-quantum keys, then move portals
  and users to it.
evidence_level: source
checks:
- id: c1
  source: '0x91ff8bbd8ebb07893010d50a48a1609e5ebd8e34'
  file: src/shared/libraries/SignatureLib.sol
  line: 25
  has: address recovered = ECDSA.recover(_digest, _signature.v, _signature.r, _signature.s);
  says: SignatureLib.verify recovers the signer with ECDSA.recover.
  for:
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x91ff8bbd8ebb07893010d50a48a1609e5ebd8e34'
  file: lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 148
  has: address signer = ecrecover(hash, v, r, s);
  says: OpenZeppelin ECDSA uses the ecrecover precompile.
  for:
  - what
- id: c3
  source: '0x91ff8bbd8ebb07893010d50a48a1609e5ebd8e34'
  file: src/core/libraries/rollup/ValidatorSelectionLib.sol
  line: 373
  has: stack.reconstructedCommittee[i] = ECDSA.recover(_digest, v, r, s);
  says: verifyAttestations recovers committee members with ECDSA.recover.
  for:
  - evidence-2
  - justification
  - what
- id: c5
  source: '0x91ff8bbd8ebb07893010d50a48a1609e5ebd8e34'
  file: src/core/libraries/rollup/InvalidateLib.sol
  line: 108
  has: (recovered,,) = ECDSA.tryRecover(digest, signature.v, signature.r, signature.s);
  says: invalidateBadAttestation recovers attesters with ECDSA.tryRecover.
  for:
  - evidence-3
- id: c6
  source: '0x91ff8bbd8ebb07893010d50a48a1609e5ebd8e34'
  file: lib/openzeppelin-contracts/contracts/access/Ownable.sol
  line: 84
  has: function transferOwnership(address newOwner) public virtual onlyOwner {
  says: The contract is Ownable, so an owner exists who can act.
  for:
  - action
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

This rollup accepts L2 blocks when ECDSA recovers the proposer and committee members from their signatures. A quantum attacker who derives attester keys signs blocks as those validators; with a forged epoch proof this releases portal funds.

## Evidence

- [verify](https://etherscan.io/address/0x91ff8bbd8ebb07893010d50a48a1609e5ebd8e34#code) accepts a proposer signature only if ECDSA recovers the expected signer.
- [verifyAttestations](https://etherscan.io/address/0x91ff8bbd8ebb07893010d50a48a1609e5ebd8e34#code) rebuilds the committee from addresses recovered with ECDSA.
- [invalidateBadAttestation](https://etherscan.io/address/0x91ff8bbd8ebb07893010d50a48a1609e5ebd8e34#code) also judges attestations by ECDSA recovery.

## Reviewer notes

### Mechanism

Rollup.propose calls ValidatorSelectionLib, which checks the proposer's signature over the block and attestation digests via SignatureLib.verify (SignatureLib.sol line 25, ECDSA.recover -> ecrecover at ECDSA.sol line 148). verifyAttestations (ValidatorSelectionLib.sol line 373) recovers each signing committee member with ECDSA.recover to rebuild the committee and match its stored commitment. InvalidateLib.invalidateBadAttestation (line 108) uses ECDSA.tryRecover to challenge bad attestations. Once an epoch is proven via submitEpochRootProof (separate proof finding), the block's L2-to-L1 messages reach the Outbox and portals release tokens. The owner (Aztec Governance, Ownable) cannot change the scheme in place; the fix is a new rollup version.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Validator stake slashed by forged votes is not paid to the attacker.
- Ruled out: The rollup's own AZTEC rewards are not unlocked by forged blocks.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
