---
id: a6f6e791-rotate-signer-before-migrating
title: "0xa6f6e791: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xa6f6e791c0152fb983162a216bfa9229e30896c6"
  family: "15cf800e842e672533e131643b9dbac6"
  upgradeable: "no"
  rating: LOW
  value_usd: 902
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 13460
  last_active: 2026-11-18
  recoveries_14d: 2015
fix:
  layer: onchain-config
  who_acts: "default admin"
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
  note: "Setter callable by a live EOA admin."
---

## Summary

Unverified signature-gated order executor; orders need an ECDSA signature by the stored signer (slot 3). Under EIP-8151 a signer that takes non-delegation code stops recovering, so this path stops until the key is rotated.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (grantRole, revokeRole, setSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- reading.first.json: setSigner (0x6c19e783) gated on role 0 (DEFAULT_ADMIN)
- hasRole(0x0, 0x690f4e2f…) = true and defaultAdmin() = 0x690f4e2f… at block 26438999
- 0x690f4e2f… is an EOA (no code, nonce 1067) at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $902 (ETH and 49 priced tokens).
- Activity: 13,460 transactions called it in the 90 days before that block; last on 2026-11-18.
- 2,015 signature recoveries in the study's two-week trace window.

## Remediation

Default admin calls setSigner with a fresh EOA.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
