---
id: qanx-aaa9214f-rotate-signer-before-migrating
title: "QANX: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xaaa9214f675316182eaa21c85f0ca99160cc3aaa"
  family: "e894bd67de9046ba695220b714736c3d"
  name: "QANX"
  upgradeable: "no"
  rating: LOW
  txs_90d: 14128
  last_active: 2026-11-18
fix:
  layer: onchain-config
  who_acts: "cheque signer key holder 0xc3af…237f"
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
  note: "The key holder itself can rotate. It has nonce 0 but signs off-chain, so it is live. If it migrates first without rotating, a contract account can still call setChequeSigner as msg.sender."
---

## Summary

QANX token with signed cheques (locked transfers). The cheque signer is a stored key; ecrecover must equal it.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setChequeSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- setChequeSigner reverts unless msg.sender == current cheque signer (slot 5) (heimdall qanx)
- Slot 5 at 26438999 = 0xc3af0f01…237f: EOA, no code, nonce 0, but it actively signs cheques
- No owner or admin is involved; only the key holder rotates

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 14,128 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

The cheque signer calls setChequeSigner(new key) before its account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
