---
id: 7084ea98-7702-own-key-only
title: "0x7084ea98: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0x7084ea983591b6e6a4f1a50f5cb9703caeec6b8e"
  family: "116a29a2fbac870e2d674ad40b02ef2e"
  copies: 114470
  upgradeable: "yes"
  rating: LOW
  value_usd: 10489907
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 65258
  last_active: 2026-11-18
  recoveries_14d: 1080
fix:
  layer: account-migration
  who_acts: "each account owner"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-7702-own-key-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Accepts passkeys and external validators besides the own key; it's upgradeable by the account (proxy holders) or by re-delegation (7702)"
---

## Summary

unnamed 7702 delegate (114,470 accounts): 7702 delegate logic whose signature check needs the recovered address to equal address(this). Delegated accounts are unaffected; only an account that later holds real code fails its own check.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: the code accepts only the signature of the account it runs in. As 7702 delegate code it is not affected. An account that took this logic as real code could not sign for itself. Rule: self-only. Executed: a real transaction reverts with code at the signer.
- SmartWallet 1.0.0 (bytecode): reading.first.json says the root key is the account's own address (ECDSA); other key hashes map to WebAuthn P-256 or external validators; UUPS-upgradeable/source (dossier 116a29a2fbac870e2d674ad40b02ef2e)
- Study note: the code accepts only the signature of the account it runs in. As 7702 delegate code it is not affected. An account that took this logic as real code could not sign for itself. Rule: self-only. Executed: a real transacti
- Activity (measured): txs_90d 65,258, last_active 2026-11-18, value_usd 10489907

## Impact and exposure

- Value held at block 26,438,999: $10.5M (ETH and 49 priced tokens, over 114,470 addresses).
- Activity: 65,258 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,080 signature recoveries in the study's two-week trace window.

## Remediation

Keep the 7702 delegation, or re-delegate to logic with a code-aware check, before or after the account gets real code; the account's own key acts.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
