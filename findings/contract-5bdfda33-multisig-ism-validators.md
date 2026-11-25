---
id: contract-5bdfda33-multisig-ism-validators
format: 2
title: Hyperlane ISM clone accepts ECDSA validator quorums open to quantum forgery
status: candidate
severity: MEDIUM
justification: Inbound messages rest on ECDSA validator keys; the owner Safe can repoint ISMs, but validators must
  also move to PQ keys
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5bdfda33f5a1f81b6a526aeb2fc413a6523a116d'
  project: hyperlane
  code: decompiled
  code_url: code/0x5d855ec3c8541607bc9314b38f747d5d4e01a6a1ddde4ef3ca11013b314b2cd0.sol
  copies: 1
value:
  usd: 0
  basis: held
activity:
  txs_90d: 2381
impact: funds-loss
action: Keep this ISM out of default and app routes, and verify messages with a post-quantum validator ISM instead.
evidence_level: bytecode
checks:
- id: code
  code: '0x5bdfda33f5a1f81b6a526aeb2fc413a6523a116d'
  is: contract
  bytes: 342
  says: The address holds 342 bytes of contract code (a forwarding proxy).
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

This small proxy forwards every call to Hyperlane's message-id multisig ISM code. That code accepts a message once a threshold of ECDSA validator signatures checks out. A quantum attacker who recovers a quorum of those keys can forge messages it accepts.

## Evidence

- [Contract code](https://etherscan.io/address/0x5bdfda33f5a1f81b6a526aeb2fc413a6523a116d#code) is a 342-byte proxy that forwards calls to the multisig ISM implementation.

## Reviewer notes

### Mechanism

The 342-byte runtime is an EIP-3448 meta-proxy. Its fallback delegatecalls implementation 0x5371942d (StaticMessageIdMultisigIsm), appending the immutable args (validators, threshold) from its own code. AbstractMultisigIsm.verify (line 71) runs ECDSA.recover over the checkpoint digest for `threshold` signatures (line 87) and requires the signers in validator order (line 96). Per kev, the old default ISM 0x7e1cdfb6 routed Base to this clone. Since block 25,991,130 the Mailbox default ISM is 0xb05bbc47, which routes Base to same-code successors. This clone is retired and has had no calls since then. It still verifies whatever is routed to it with ECDSA quorums.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No current Mailbox default-ISM route points at this clone.
- Ruled out: Holds no funds itself.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
