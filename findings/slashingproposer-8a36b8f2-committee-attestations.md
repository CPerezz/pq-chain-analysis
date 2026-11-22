---
id: slashingproposer-8a36b8f2-committee-attestations
format: 2
title: Aztec v2 slashing votes trust ECDSA signatures a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: ECDSA proposer votes can be forged from exposed keys; only a new Governance rollup version with PQ
  keys fixes it.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x8a36b8f2ca71d8d8bd98e03ebf8b4d0939daf0ba'
  name: SlashingProposer
  project: aztec
  code: verified
  code_url: https://etherscan.io/address/0x8a36b8f2ca71d8d8bd98e03ebf8b4d0939daf0ba#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 19811
impact: funds-loss
action: Register a new rollup version whose proposers and attesters sign with post-quantum keys, and move validators
  to it.
evidence_level: source
checks:
- id: c1
  source: '0x8a36b8f2ca71d8d8bd98e03ebf8b4d0939daf0ba'
  file: src/shared/libraries/SignatureLib.sol
  line: 25
  has: address recovered = ECDSA.recover(_digest, _signature.v, _signature.r, _signature.s);
  says: SignatureLib.verify checks signatures with ECDSA.recover against the expected signer.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x8a36b8f2ca71d8d8bd98e03ebf8b4d0939daf0ba'
  file: lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 148
  has: address signer = ecrecover(hash, v, r, s);
  says: ECDSA recovery uses the ecrecover precompile.
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
- study: top-callers-classification
  who: Review00 (Sourcify/Blockscout source of rollup versions 0, 2 and 3; Registry, GSE, Governance and portal
    reads; Xatu activity of the new contracts)
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

This SlashingProposer counts slashing votes signed by the slot's proposer and checks them with ECDSA recovery. A quantum attacker who derives proposer keys can sign votes to slash honest validators.

## Evidence

- [SignatureLib.verify](https://etherscan.io/address/0x8a36b8f2ca71d8d8bd98e03ebf8b4d0939daf0ba#code) accepts a signature if ECDSA.recover returns the expected signer.
- [ECDSA.tryRecover](https://etherscan.io/address/0x8a36b8f2ca71d8d8bd98e03ebf8b4d0939daf0ba#code) recovers the signer with the ecrecover precompile.

## Reviewer notes

### Mechanism

SlashingProposer.vote (v2, line 399 per kev's excerpts) takes an EIP-712 digest of the vote signed by the current slot's proposer and checks it via SignatureLib.verify (SignatureLib.sol line 25), which calls ECDSA.recover -> tryRecover -> ecrecover (ECDSA.sol line 148) and requires the recovered address to equal the proposer. A quantum attacker who derives the proposer's secp256k1 key from its on-chain signatures can produce valid votes; once a quorum of slots vote, the slash executes through the Slasher, subject to a 5-of-9 Safe veto. Slashed stake leaves the validator and is not paid to voters. The scheme is fixed in this contract; the fix is a new rollup version registered by Aztec Governance.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract holds no funds of its own.
- Ruled out: Slashed stake is not paid to the attacker.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
