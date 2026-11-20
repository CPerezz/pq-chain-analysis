---
id: mainlandportal-93fca5da-signer-upgrade-only
title: "MainlandPortal: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x93fca5dad20bd25a0572c87dd93fc202fc4bbe46"
  family: "a1046f1740c35610812450bb2437aba3"
  copies: 2
  name: "MainlandPortal"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody — the check can never pass"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signer-upgrade-only"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "admin has been address(0) since deployment (the setter is dead code), so the ecrecover check was already permanently unreachable before EIP-8151 — refuted."
---

## Summary

MainlandPortal._emergencyProcessMessageFromChild requires signer == admin, but MainlandPortal has no constructor and the line that would set admin (`// admin = msg.sender;` inside initialize()) is commented out. admin is permanently the zero address, so this function (and initialize/setAuth/replayCall, all gated the same way) has been unreachable by any real caller since deployment — independent of EIP-8151.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: MainlandPortal _emergencyProcessMessageFromChild: the stored admin must sign. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source (MainlandPortal.sol:1006-1094): no constructor in the contract; initialize()/setAuth()/replayCall()/_emergencyProcessMessageFromChild all require msg.sender (or ecrecover's result) == admin
- batch facts getters: admin()="0" at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

n/a — claim is wrong.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
