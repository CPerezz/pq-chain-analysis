---
id: 129848b0-wallets-fixed-signers
title: "0x129848b0: wallet with signers fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x129848b0c45cba2332321cf6bd930b5313e64388"
  family: "f6adb0e04f92426dab9f568ca5ca52d6"
  copies: 247
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody: not affected"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-wallets-fixed-signers"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "The key is settable on the controller, funds move by controller calls without signatures, and an approveOrder path exists: refuted. Not verified: which caller setListingSigner allows (likely the owner, 0xfE19…)."
---

## Summary

A 45-byte clone of 0x98874e98…, a vault controlled by the fixed contract 0x4151871a…. isValidSignature accepts hashes pre-approved by the controller, or an ECDSA signature from listingSigner(), which is read live from the controller, and the controller has setListingSigner(address).

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: wallets whose ERC-1271 accepts the owner's ECDSA signature; the owner executes directly. Bytecode and names.
- Update path, read at block 26,438,999: delegates to a fixed address.
- Impl decompile: approveOrder/execute/sweepEth only callable by 0x4151871a… (no signature); isValidSignature returns the magic value for approved hashes, else recover == 0x4151871a….listingSigner()
- Controller 0x4151871a… selectors include setListingSigner(address) 0xca0776b6, setOperator, setCollector, approveOrder, sweepEth; listingSigner() = owner() = 0xfE191A30… (EOA, nonce 155, latest)
- Clone storage slots 0-5 empty; nothing per-clone stores a key

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 247 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None needed: the controller can set a new listing signer or pre-approve orders.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
