---
id: contract-eb2a48dd-multisig-ism-validators
format: 2
title: Hyperlane Base message-id ISM relies on quantum-forgeable ECDSA validators
status: candidate
severity: MEDIUM
justification: ECDSA validator quorums are quantum-recoverable; MEDIUM because one Hyperlane Safe can repoint the
  ISM to a PQ verifier
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xeb2a48ddc7d660ffb79a71b201cb6fd8daba850f'
  project: hyperlane
  code: decompiled
  code_url: code/0xd1e20266d814cda29dd45bdf98a0a0910a689cc11a21f526485d1419c35643e4.sol
  copies: 1
value:
  usd: 0
  basis: held
activity:
  txs_90d: 10119
impact: funds-loss
action: Deploy a post-quantum validator ISM and have the owner Safe route Base messages to it, with validators on
  post-quantum keys
evidence_level: bytecode
checks:
- id: code
  code: '0xeb2a48ddc7d660ffb79a71b201cb6fd8daba850f'
  is: contract
  bytes: 342
  says: The address holds a 342-byte contract, a delegating meta-proxy.
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

This contract is a small proxy that forwards every call to Hyperlane's message-id multisig ISM code, which accepts inbound messages from Base once a validator quorum's ECDSA signatures check out. A quantum attacker who recovers that quorum's keys can forge messages that default-ISM apps accept.

## Evidence

- [Contract code](https://etherscan.io/address/0xeb2a48ddc7d660ffb79a71b201cb6fd8daba850f#code) is a 342-byte proxy that forwards all calls to the message-id multisig ISM implementation.

## Reviewer notes

### Mechanism

The 342-byte runtime is an EIP-3448 meta-proxy. Its fallback delegatecalls 0x5371942d… (StaticMessageIdMultisigIsm) and appends its own code tail as immutable args. Those args are the validators and the threshold (3 of 5 for Base, per kev). Mailbox.process calls recipientIsm(recipient).verify. For default-ISM apps this goes through aggregation, then routing (Base domain), then an aggregation of 1 of 2, which includes this clone. AbstractMultisigIsm.verify (line 71) runs ECDSA.recover over the checkpoint digest for threshold signatures (line 87). It requires signers in validator order (line 96). The proxy has no admin and cannot be changed. The fix is to repoint the routing or default ISM.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The validator set is fixed in the clone's code and cannot be swapped in place; repointing the ISM is the only path.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
