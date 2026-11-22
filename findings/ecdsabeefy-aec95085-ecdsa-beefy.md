---
id: ecdsabeefy-aec95085-ecdsa-beefy
format: 2
title: Hyperbridge EcdsaBeefy accepts BEEFY votes a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged BEEFY votes pass as consensus; MEDIUM because the host manager can point the host at a client
  without this path.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xaec9508513ff0a7c3c80c9bac204e572ed2d1233'
  name: EcdsaBeefy
  project: hyperbridge
  code: verified
  code_url: https://etherscan.io/address/0xaec9508513ff0a7c3c80c9bac204e572ed2d1233#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a consensus client without the ECDSA route and have the host manager point the host at it.
evidence_level: source
checks:
- id: c1
  source: '0xaec9508513ff0a7c3c80c9bac204e572ed2d1233'
  file: src/consensus/EcdsaBeefy.sol
  line: 159
  has: address authority = ECDSA.recover(commitmentHash, vote.signature);
  says: Each BEEFY vote signer is recovered with ECDSA.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xaec9508513ff0a7c3c80c9bac204e572ed2d1233'
  file: node_modules/@openzeppelin/contracts/utils/cryptography/ECDSA.sol
  line: 148
  has: address signer = ecrecover(hash, v, r, s);
  says: Recovery uses the secp256k1 ecrecover precompile.
  for:
  - what
- id: thr
  source: '0xaec9508513ff0a7c3c80c9bac204e572ed2d1233'
  file: src/consensus/EcdsaBeefy.sol
  has: return len >= ((2 * total) / 3) + 1;
  line: 256
  says: A proof needs at least 2/3+1 of the authority set's signatures.
  for:
  - evidence-2
  - justification
  - what
- id: mproof
  source: '0xaec9508513ff0a7c3c80c9bac204e572ed2d1233'
  file: src/consensus/EcdsaBeefy.sol
  has: MerkleMultiProof.VerifyProof(authoritySet.root, relayProof.proof, authorities, authoritySet.len)
  line: 164
  says: Recovered signers are checked against the authority set root.
  for:
  - what
- id: rot
  source: '0xaec9508513ff0a7c3c80c9bac204e572ed2d1233'
  file: src/consensus/EcdsaBeefy.sol
  has: trustedState.nextAuthoritySet = relayProof.latestMmrLeaf.nextAuthoritySet;
  line: 181
  says: The authority set is rotated from the signed MMR leaf.
  for:
  - evidence-3
  - what
sources:
- study: top-callers-classification
  who: Review07 (registry review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

EcdsaBeefy recovers each Polkadot BEEFY validator vote with ECDSA and checks the signers against the authority set root. With 2/3+1 of votes it accepts a new MMR root and rotates the authority set, so a quantum attacker with enough validator keys can sign a false commitment.

## Evidence

- [verifyMmrUpdateProof](https://etherscan.io/address/0xaec9508513ff0a7c3c80c9bac204e572ed2d1233#code) recovers each vote signer with ECDSA.recover over the commitment hash.
- [checkParticipationThreshold](https://etherscan.io/address/0xaec9508513ff0a7c3c80c9bac204e572ed2d1233#code) requires 2/3+1 of the authority set to have signed.
- [verifyMmrUpdateProof](https://etherscan.io/address/0xaec9508513ff0a7c3c80c9bac204e572ed2d1233#code) moves the next authority set taken from the signed MMR leaf into place.

## Reviewer notes

### Mechanism

The router passes proofs with first byte 0x00 to EcdsaBeefy.verify (line 99), which calls verifyMmrUpdateProof (line 113). That function requires votes.length >= 2*len/3+1 (lines 143, 255-256), hashes the commitment (line 155), recovers each signer with ECDSA.recover (line 159, ecrecover in OpenZeppelin line 148) and checks the signers against the authority set root with a Merkle multi-proof (line 164). It then accepts the MMR root, rotates the authority set from the leaf (lines 179-181) and returns parachain headers proven under it as state commitments (lines 213-243). Forged secp256k1 signatures from recovered validator keys therefore yield fabricated Hyperbridge state, against which forged messages can be delivered.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: EcdsaBeefy has no admin and holds no funds itself.

### History

- 2026-11-17: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
