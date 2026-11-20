---
id: 128f4fbd-rotate-signer-before-migrating
title: "0x128f4fbd: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x128f4fbde99e0628d822f5082c164c82d9516171"
  family: "51d86b4832eb52ebb9cc75220dd9c6af"
  copies: 2
  upgradeable: "no"
  rating: LOW
  value_usd: 1624
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1404
  last_active: 2026-11-17
  recoveries_14d: 38
fix:
  layer: onchain-config
  who_acts: "owner Safe 2/3"
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
  note: "Setters callable by a live 2/3 Safe."
---

## Summary

LiquidityBank (unverified) checks verifying/withdraw signers from storage sets; a signer with code fails recovery. Under EIP-8151 a signer that takes non-delegation code stops recovering, so this path stops until the key is rotated.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (addVerifyingSigner, addWithdrawSigner, removeWithdrawSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction loses its effect with code at the signer.
- heimdall decompile: addVerifyingSigner/addWithdrawSigner/removeWithdrawSigner require msg.sender == owner (slot 8da5cb5b)
- owner() at block 26438999 = 0x6102C626…, a Safe with 3 owners, threshold 2

## Impact and exposure

- Value held at block 26,438,999: $1,624 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1,404 transactions called it in the 90 days before that block; last on 2026-11-17.
- 38 signature recoveries in the study's two-week trace window.

## Remediation

Owner Safe adds new signers and removes the old ones.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
