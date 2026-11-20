---
id: mototoken-bd965230-fixed-signer
title: "MotoToken: signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xbd965230588eaa536de6aa45e8ebbc01638535e0"
  family: "aa56e9b1a27d71b1aca6f92f742a60ab"
  copies: 2
  name: "MotoToken"
  upgradeable: "no"
  rating: NONE
  txs_90d: 56936
  last_active: 2026-11-17
fix:
  layer: none
  who_acts: "none"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: MEDIUM
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "Every path to the check is closed for good by state, and it accepts ERC-1271. Permit uses the holder's own key, not a fixed signer."
---

## Summary

The GATE_SIGNER check only runs before trading opens, and trading is open for good. Even then, the check falls back to ERC-1271 on a signer with code.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: MotoToken: GATE_SIGNER (immutable) authorises accounts only before trading opens, after which no signature is needed; permit by the owner named (MEDIUM). Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- tradingOpen() = true and gateArmed() = true at block 26438999; tradingOpen depends on timestamp >= HARD_OPEN or openAt, and openNow reverts AlreadyOpen, so it cannot close again
- _authorize returns early when tradingOpen(); _update skips the gate when open
- _checkGateSignature (lines 433-457) tries ERC-1271 when signer.code.length != 0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 56,936 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

none

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
