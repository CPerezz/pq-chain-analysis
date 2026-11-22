---
id: 1f9a27fc-rotate-signer-before-migrating
title: "0x1f9a27fc: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x1f9a27fc9ea14b4430750e3b718b92752573929a"
  family: "4aab626c7722a8bf358b3aee36821465"
  copies: 2
  upgradeable: "yes"
  admin: "owner 0xfe93D561A66C7F71862219bBd640Bddb9f7eB1Be (UUPS)"
  rating: LOW
  txs_90d: 2439
  last_active: 2026-11-13
  recoveries_14d: 25
fix:
  layer: onchain-config
  who_acts: "owner 0xfe93D561A66C7F71862219bBd640Bddb9f7eB1Be of proxy 0x8c57f6d52c7de20aaf35d383451c8d6e67b639ff"
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
  note: "LOW: onlyOwner setter, owner is an active EOA (7702-delegated, which EIP-8151 still accepts)."
---

## Summary

UUPS Ownable implementation (unverified) behind proxy 0x8c57f6d5…39ff; authorizations must be signed by a stored authorizationSigner. Under EIP-8151 a signer with real code stops verifying.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setAuthorizationSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- Proxy 0x8c57f6d5… implementation slot = 0x1f9a27fc… at block
- Decompiled setAuthorizationSigner (0x45fe486c): require(msg.sender == owner) with OwnableUnauthorizedAccount (0x118cdaa7)
- owner() of proxy = 0xfe93D561… at block: an EOA with an EIP-7702 delegation (code 0xef0100…), nonce 828

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 2,439 transactions called it in the 90 days before that block; last on 2026-11-13.
- 25 signature recoveries in the study's two-week trace window.

## Remediation

The owner calls setAuthorizationSigner(newKey) before the current signer account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
