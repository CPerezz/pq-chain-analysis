---
id: pgpu-d2fcb8aa-rotate-signer-before-migrating
title: "pGPU: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd2fcb8aac6334d6eb706e59c4bb84a881f884501"
  family: "23c74ba1538b9d5bb0fb0e741433e3e4"
  copies: 4
  name: "pGPU"
  label: "zKML: ZKML Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 1653
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1611
  last_active: 2026-11-18
fix:
  layer: onchain-config
  who_acts: "owner"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Key holder is a live EOA and can hand over ownership."
---

## Summary

pGPU ERC-20 whose signer is its Ownable owner; if the owner account takes code its signatures stop recovering. Under EIP-8151 a signer that takes non-delegation code stops recovering, so this path stops until the key is rotated.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one address in storage and the only such address the code names is its owner, which can be handed over (renounceOwnership, transferOwnership). Rule: stored-key (the owner).
- heimdall decompile: owner-gated functions use `owner == msg.sender`; transferOwnership(address) in facts setters
- owner() at block 26438999 = 0xaF9f4873…; owner is an EOA (no code, nonce 10) at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $1,653 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 1,611 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Owner transfers ownership to a fresh EOA before migrating.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
