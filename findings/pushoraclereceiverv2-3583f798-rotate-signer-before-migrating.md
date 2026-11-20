---
id: pushoraclereceiverv2-3583f798-rotate-signer-before-migrating
title: "PushOracleReceiverV2: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x3583f79886aa6fcbd5d2575b3d27311399d447a6"
  family: "2e761ac4fcb61e4217cedc53b8a3230f"
  copies: 14
  name: "PushOracleReceiverV2"
  upgradeable: "no"
  rating: LOW
  value_usd: 1444
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 17182
  last_active: 2026-11-18
  recoveries_14d: 1465
fix:
  layer: onchain-config
  who_acts: "owner"
evidence:
  level: source-read
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
  note: "Setter callable by a live EOA owner."
---

## Summary

DIA PushOracleReceiverV2 accepts updates only from authorised signers; a signer with code fails recovery. Under EIP-8151 a signer that takes non-delegation code stops recovering, so this path stops until the key is rotated.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: DIA push oracle: the intent names its signer, which must be authorised and must have signed / DIA push oracle (batch): the same check, returning a status instead of reverting, so a bad intent is…. Read from source. Executed: a real transaction loses its effect with code at the signer.
- PushOracleReceiverV2.sol: setSignerAuthorization(address,bool) onlyOwner
- owner() = 0x26c95f67…; owner is an EOA (no code, nonce 77) at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $1,444 (ETH and 49 priced tokens, over 14 addresses).
- Activity: 17,182 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,465 signature recoveries in the study's two-week trace window.

## Remediation

Owner authorises a new EOA signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
