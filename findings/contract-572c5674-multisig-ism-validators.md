---
id: contract-572c5674-multisig-ism-validators
format: 2
title: Retired Hyperlane Superseed ISM trusts quantum-breakable validator keys
status: candidate
severity: MEDIUM
justification: A validator ECDSA quorum is forgeable with a quantum computer; Hyperlane's Safe and validators must
  move to PQ.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x572c56742bf8bc6629b85f24db40070e4d1b71b8'
  project: hyperlane
  code: decompiled
  code_url: code/0x7b459f274a2281005c2dbf4f136cb2826556fa5074d158462632a14dabc30094.sol
  copies: 1
value:
  usd: 0
  basis: held
activity:
  txs_90d: 9
impact: funds-loss
action: Deploy a post-quantum validator ISM, have the owner Safe point routes at it, and move validators to post-quantum
  keys.
evidence_level: bytecode
checks:
- id: code
  code: '0x572c56742bf8bc6629b85f24db40070e4d1b71b8'
  is: contract
  bytes: 374
  says: The address holds contract code (374 bytes), consistent with a minimal meta-proxy clone.
  for:
  - action
  - evidence-1
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
  who: Review18 (implementation sources from Sourcify, full read of the live default-ISM tree, historical default
    ISM reads, Mailbox Process events)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This Hyperlane message-id multisig ISM clone accepts a message when a threshold of ECDSA validator signatures checks out. A quantum attacker who recovers the validator quorum's keys could forge messages that this ISM accepts.

## Evidence

- [The clone](https://etherscan.io/address/0x572c56742bf8bc6629b85f24db40070e4d1b71b8#code) holds 374 bytes of code, a minimal proxy with no logic of its own.

## Reviewer notes

### Mechanism

The address holds 374 bytes of code. The decompiled code, unverified and used here only as a lead, shows an EIP-3448 meta-proxy. Its fallback delegatecalls StaticMessageIdMultisigIsm 0x5371942d with calldata plus its immutable args (validators, threshold). In that implementation, AbstractMultisigIsm.verify (line 71) runs ECDSA.recover over the checkpoint digest for threshold signatures (line 87) and requires the signers to be in validator order (line 96). Kev's finding says this clone served Superseed under the previous default ISM 0x7e1cdfb6. It was retired when Mailbox defaultIsm switched to 0xb05bbc47 at block 25,991,130. Superseed has no route now, and the clone was last called before the study window.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Live exposure: the clone is no longer in the Mailbox default ISM tree and had no calls in the 30-day window.
- Ruled out: Funds held directly: the contract holds about $0.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
