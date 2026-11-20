---
id: rysk-2e493d50-signed-shortcut-lost
title: "Rysk: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x2e493d5003b3fe59bded727a36340470e6f3de2b"
  family: "5caa4e48a76df7bea3e93d8cc7b3a543"
  copies: 4
  name: "Rysk"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 1626
  last_active: 2026-11-18
  recoveries_14d: 447
fix:
  layer: offchain
  who_acts: "the affected holder (calls the direct function itself)"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Direct path exists for the same party (msg.sender-based approve/transfer/delegate); only a way of signing is lost, so LOW."
---

## Summary

Rysk: a signed shortcut (permit) recovers the holder's key; under EIP-8151 a holder whose address has non-delegation code can no longer use it, while the same act stays open by direct call.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: solmate permit: the recovered address must be the owner named in the call, zero rejected; nothing else is accepted here / Rysk checkSignature: SignatureChecker on the account named. Read from source. Executed: a real transaction reverts with code at the signer.
- Direct functions present in bytecode at block 26438999 of 0x81f038db75b14f9be3488216fbf0649e3e912fce (implementation/clone target): approve (0x095ea7b3), transfer (0xa9059cbb); each acts for msg.sender, so a holder with code calls them itself.
- Signed path(s) lost for a signer with code: permit-style signature; study reading: solmate permit: the recovered address must be the owner named in the call, zero rejected; nothing else is accepted here / Rysk checkSignature: SignatureChecker on the account named
- Dossier ~/dev/pq-chain-analysis/goals/eip-8151-analysis/readings/5caa4e48a76df7bea3e93d8cc7b3a543 (source + scanner: STATICCALL to precompile 0x01 present).
- Rysk.checkSignature uses OZ SignatureChecker.isValidSignatureNow (src/Rysk.sol l.729-736), which falls back to ERC-1271 for accounts with code, so trader-signed trade paths still work for 1271 wallets.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 1,626 transactions called it in the 90 days before that block; last on 2026-11-18.
- 447 signature recoveries in the study's two-week trace window.

## Remediation

Holder with code calls approve/transfer/delegate directly instead of signing.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
