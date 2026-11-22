---
id: bridge-9f452b7c-bridge-authorities
format: 2
title: Gala bridge accepts ECDSA authority signatures a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Bridge actions are gated by ECDSA authority signatures; Gala can fix it by an authority-signed upgrade,
  so MEDIUM.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x9f452b7cc24e6e6fa690fe77cf5dd2ba3dbf1ed9'
  name: Bridge
  project: gala
  code: verified
  code_url: https://etherscan.io/address/0xc664692f38d2528710edbb74f65db6599bc7dee6#code
  proxy_of: '0xc664692f38d2528710edbb74f65db6599bc7dee6'
  copies: 1
value:
  usd: 2024119
  basis: held
activity:
  txs_90d: 5671
impact: funds-loss
action: Sign an upgrade to a post-quantum verifier with the current authority key, then rotate to post-quantum authorities.
evidence_level: source
checks:
- id: c1
  source: '0xc664692f38d2528710edbb74f65db6599bc7dee6'
  file: contracts/Authority.sol
  line: 35
  has: (address authority, ECDSA.RecoverError error) = ECDSA.tryRecover(digest, signature.v, signature.r, signature.s);
  says: verifyMessage recovers each signer with ECDSA tryRecover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xc664692f38d2528710edbb74f65db6599bc7dee6'
  file: contracts/Authority.sol
  line: 36
  has: if (error != ECDSA.RecoverError.NoError || authority != getAuthority(signature.index)) {
  says: The recovered address must equal the indexed authority.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c3
  source: '0xc664692f38d2528710edbb74f65db6599bc7dee6'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 157
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover calls ecrecover.
  for:
  - what
- id: q1
  source: '0xc664692f38d2528710edbb74f65db6599bc7dee6'
  file: contracts/Authority.sol
  has: return 3 * sigLength >= 2 * allKeys;
  line: 48
  says: Quorum is two thirds of the authority set.
  for:
  - evidence-3
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review17 (Sourcify source and on-chain reads)
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

The bridge accepts a message when enough signatures recover, by ECDSA, to its registered authority addresses. A quantum attacker who recovers an authority key can sign messages that pass this check.

## Evidence

- [verifyMessage](https://etherscan.io/address/0xc664692f38d2528710edbb74f65db6599bc7dee6#code) recovers each signer with ECDSA.tryRecover.
- [verifyMessage](https://etherscan.io/address/0xc664692f38d2528710edbb74f65db6599bc7dee6#code) rejects a signature unless the recovered address equals the indexed authority.
- [quorum](https://etherscan.io/address/0xc664692f38d2528710edbb74f65db6599bc7dee6#code) requires signatures from two thirds of the authority set.

## Reviewer notes

### Mechanism

Authority.verifyMessage (contracts/Authority.sol 20-41) first checks quorum (line 22, 3*sigLength >= 2*allKeys at line 48). It then loops over the signatures, requires the indexes to be in ascending order and in range, and calls ECDSA.tryRecover(digest, v, r, s) (line 35). That function calls ecrecover (ECDSA.sol 157). The result must equal getAuthority(signature.index) (line 36). Kev's finding states that bridgeIn, upgrade and changeAuthorities rely on this check, and that the authority set has one key, so one recovered key meets quorum. Those callers are not in the files shown here.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Adding more ECDSA authorities raises the quorum but does not change the signature scheme.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
