---
id: contract-5eb42b1b-multisig-ism-validators
format: 2
title: Hyperlane merkle-root ISM for Base accepts forgeable ECDSA validator quorums
status: candidate
severity: MEDIUM
justification: A validator quorum's ECDSA keys open default-ISM apps; one Safe can repoint the ISM, but validators
  need PQ keys too
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5eb42b1b45c70b56a4d5f4d7cd874b5863933bd5'
  project: hyperlane
  code: decompiled
  code_url: code/0xef433a3589a6a472b56104fec23559ff271ca2d14a4037dde20c1d39fd76600e.sol
  copies: 1
value:
  usd: 0
  basis: held
activity:
  txs_90d: 12
impact: funds-loss
action: Deploy a post-quantum validator ISM and repoint the default ISM or routing entry; have validators sign with
  post-quantum keys
evidence_level: bytecode
checks:
- id: code
  code: '0x5eb42b1b45c70b56a4d5f4d7cd874b5863933bd5'
  is: contract
  bytes: 342
  says: The address holds 342 bytes of proxy code that delegates to the merkle-root multisig ISM implementation.
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

This contract is a fixed clone that forwards every call to Hyperlane's merkle-root multisig ISM code. That code accepts a message once enough ECDSA validator signatures recover. A quantum attacker with a quorum's keys could forge inbound messages.

## Evidence

- [Contract code](https://etherscan.io/address/0x5eb42b1b45c70b56a4d5f4d7cd874b5863933bd5#code) is a small proxy that forwards all calls to the merkle-root multisig ISM implementation.

## Reviewer notes

### Mechanism

Mailbox.process calls recipientIsm(recipient).verify(metadata, message). For default-ISM apps, the default ISM routes the Base origin to an aggregation ISM that needs one of two checks: this merkle-root clone or its message-id twin. This clone is a meta-proxy of 0xd4dacca0 (StaticMerkleRootMultisigIsm), and its immutable arguments are the validators and the threshold (3 of 5). AbstractMultisigIsm.verify (line 71) runs ECDSA.recover over the checkpoint digest for threshold signatures (line 87) and requires the signers to appear in validator order (line 96). Anyone who derives three Base validator keys from their public checkpoint signatures can sign a forged checkpoint root together with a merkle proof of a forged message.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The clone's validators and threshold are immutable arguments, so they cannot be changed in place

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
