---
id: newtonclaim-95835589-claim-permit
format: 2
title: Magic Newton NEWT claim accepted ECDSA claim signatures, now closed and empty
status: confirmed
severity: LOW
justification: 'LOW: the claim signature is ECDSA, but a hash-based claim path exists and no team action is needed.'
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x95835589f6e03a9a0f3bae95ab41c75122101fc8'
  name: NewtonClaim
  project: magic-newton
  code: verified
  code_url: https://etherscan.io/address/0x95835589f6e03a9a0f3bae95ab41c75122101fc8#code
  copies: 1
  upgradeable: 'no'
  admin: '0xcd14dc086511f33f91093410cdd0f3eab9ee8beb'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
evidence_level: source
checks:
- id: c1
  source: '0x95835589f6e03a9a0f3bae95ab41c75122101fc8'
  file: src/utils/merkle_distributor/ClaimPermit.sol
  line: 51
  has: address signer = ECDSA.recover(hash, v, r, s);
  says: the claim signature must ECDSA-recover to the account
  for:
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x95835589f6e03a9a0f3bae95ab41c75122101fc8'
  file: lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 148
  has: address signer = ecrecover(hash, v, r, s);
  says: ECDSA recovery uses the ecrecover precompile
  for:
  - evidence-2
  - justification
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
reviews: []
related: []
---

## What happens

NewtonClaim pays NEWT airdrop claims from a Merkle root and lets a third party claim for an account if ECDSA recovers that account from the claim signature. A quantum attacker who forges that signature redirects the account's claim to a beneficiary of its choice.

## Evidence

- [_verifyClaimPermit](https://etherscan.io/address/0x95835589f6e03a9a0f3bae95ab41c75122101fc8#code) requires ECDSA.recover of the claim hash to equal the account.
- [ECDSA.tryRecover](https://etherscan.io/address/0x95835589f6e03a9a0f3bae95ab41c75122101fc8#code) recovers the signer with the ecrecover precompile.

## Reviewer notes

### Mechanism

claimOnBehalf(index, account, beneficiary, amount, merkleProof, v, r, s) calls ClaimPermit._verifyClaimPermit (ClaimPermit.sol lines 46-52), which hashes (index, account, beneficiary, amount, merkleProofHash) under EIP-712 and requires ECDSA.recover(hash, v, r, s) == account (line 51; ECDSA.sol line 148 uses ecrecover). NewtonClaim.sol then checks the Merkle leaf (index, account, amount) at lines 35-36 and transfers amount to beneficiary at line 40. The alternative MerkleDistributor claim pays the account itself after a Merkle proof (lines 64-69), with no signature. Per kev, both paths are limited to the claim window, whose immutable endTime has passed, and the contract holds no NEWT.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The Merkle proof path is hash-based, not exposed to a quantum attacker.
- Ruled out: The contract is not a proxy.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
