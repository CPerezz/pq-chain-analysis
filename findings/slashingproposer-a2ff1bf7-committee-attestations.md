---
id: slashingproposer-a2ff1bf7-committee-attestations
format: 2
title: Aztec slashing votes rely on ECDSA keys a quantum attacker could recover
status: confirmed
severity: MEDIUM
justification: Forged votes can slash honest validators; Aztec Governance fixes it by registering a post-quantum
  rollup version.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa2ff1bf784d6b1d7ba1bfd67c3538b85f9f85295'
  name: SlashingProposer
  project: aztec
  code: verified
  code_url: https://etherscan.io/address/0xa2ff1bf784d6b1d7ba1bfd67c3538b85f9f85295#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 7852
impact: funds-loss
action: Deploy and register a rollup version whose proposer and attester signatures use post-quantum keys
evidence_level: source
checks:
- id: c1
  source: '0xa2ff1bf784d6b1d7ba1bfd67c3538b85f9f85295'
  file: src/shared/libraries/SignatureLib.sol
  line: 25
  has: address recovered = ECDSA.recover(_digest, _signature.v, _signature.r, _signature.s);
  says: SignatureLib.verify recovers the signer with ECDSA.recover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xa2ff1bf784d6b1d7ba1bfd67c3538b85f9f85295'
  file: lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 148
  has: address signer = ecrecover(hash, v, r, s);
  says: ECDSA.tryRecover uses the ecrecover precompile.
  for:
  - evidence-2
  - justification
  - what
- id: code
  code: '0xa2ff1bf784d6b1d7ba1bfd67c3538b85f9f85295'
  is: contract
  bytes: 12958
  says: The address holds deployed contract code.
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

This contract tallies slashing votes signed by the slot's proposer and accepts a signature when ECDSA recovers the expected signer. A quantum attacker who derives proposer keys from their on-chain signatures signs votes that slash honest validators.

## Evidence

- [SignatureLib.verify](https://etherscan.io/address/0xa2ff1bf784d6b1d7ba1bfd67c3538b85f9f85295#code) requires the ECDSA-recovered address to equal the expected signer.
- [ECDSA.tryRecover](https://etherscan.io/address/0xa2ff1bf784d6b1d7ba1bfd67c3538b85f9f85295#code) derives the signer with the ecrecover precompile on secp256k1.

## Reviewer notes

### Mechanism

SlashingProposer.vote (v3 line 402) takes an EIP-712 digest signed by the current slot's proposer and checks it through SignatureLib.verify (line 25). That calls ECDSA.recover, which reaches ECDSA.tryRecover and the ecrecover precompile (line 148). It requires the recovered address to equal the proposer. Once a quorum is reached (65 of 128 slots on v3), the slash is executed through the Slasher. A 5-of-9 Safe can veto it. A quantum attacker who recovers proposer private keys from their published signatures can cast votes for any slot those keys propose. That lets them slash honest validators' stake. Slashed stake is not paid to the voters. The contract is immutable, so the fix is a new rollup version.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract holds about $0, so there is nothing to drain directly.
- Ruled out: Slashed stake is not paid to the attacker.
- Ruled out: Not upgradeable; no admin was read.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
