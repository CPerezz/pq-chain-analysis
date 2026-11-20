---
id: ambirepaymaster-364e984c-fixed-signer
title: "AmbirePaymaster: signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x364e984c82ea307020ca8f605b10ddc24f32322d"
  family: "aff4750440805e532411deef5345fc4e"
  copies: 3
  name: "AmbirePaymaster"
  upgradeable: "no"
  rating: NONE
  txs_90d: 3452
  last_active: 2026-11-17
  recoveries_14d: 175
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
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "Accepts ERC-1271 for the expected signer."
---

## Summary

The paymaster compares against relayer 0xf540…3869 through Ambire's SignatureValidator, which has a SmartWallet mode. That mode returns the wallet address after calling its isValidSignature, so a relayer that gains code can still validate through ERC-1271. call() is relayer-only by msg.sender.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Ambire paymaster: the recovered address must be the relayer fixed in the code. Read by hand. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- AmbirePaymaster: `(recovered,) = SignatureValidator.recoverAddrAllowUnprotected(hash, sig, true); recovered == relayer`
- SignatureValidator SmartWallet branch: `wallet.isValidSignature(hash, sig)` then signerKey = wallet
- code matches the Sourcify-verified 0x30dc…44f5 except for the relayer immutable; cast code relayer = 0x

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 3,452 transactions called it in the 90 days before that block; last on 2026-11-17.
- 175 signature recoveries in the study's two-week trace window.

## Remediation

none

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
