---
id: 887541ff-entry-by-own-signature-only
title: "0x887541ff: entry only by one's own signature"
status: confirmed
severity: LOW
patterns: [PQ-21]
impact: none
contracts:
- address: "0x887541ff8c2f1908c489a62983157ac22b331a15"
  family: "71cc2503ce9c94dca47d9b2e4ac97455"
  upgradeable: "no"
  rating: LOW
  txs_90d: 92
  last_active: 2026-11-05
  recoveries_14d: 2
fix:
  layer: none
  who_acts: "nobody (signers 0xb149... and 0x9bcd... are EOAs)"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-entry-by-own-signature-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "The callers allowed by the stored signatures are EOAs, so EIP-8151 changes nothing; nothing token holders own is behind a signature. It is really a fixed-signer gate rather than entry. The node-only reads (balance, owner() at 26438999) timed out but are not decisive."
---

## Summary

Unverified ERC20 (Ownable, standard transfer/approve) with two extra functions, 0x7556a6ea and 0xd11633dc, that send the contract's ETH out. They run only if one of two signatures stored in the contract recovers to msg.sender. Holders' tokens move by plain transfer, with no signature.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: the recovered address is compared with the caller. Bytecode and names.
- disassembly of code.hex (scratch d8875): ecrecover(slot6 hash, v slot0c, r slot0a, s slot0b) == CALLER, OR (short-circuit JUMPI 0x0820) a second stored signature == CALLER; on success, ETH is sent to the caller
- txs.json: tx 0x69e9c0be... made 2 recoveries; the first gave 0xb14910ba..., the sender 0x9bcd8076... passed through the second stored signature (tx succeeded), which fits the OR check
- latest, block ~26452926/26452937 (publicnode): 0xb14910bafbf1200766b85217d3e9824ab80b8d6e has no code, nonce 209; 0x9bcd8076840378a6edffc97ed824621c48d9104a has no code, nonce 6036
- state.json (dossier, block 26438999): 0 ETH

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 92 transactions called it in the 90 days before that block; last on 2026-11-05.
- 2 signature recoveries in the study's two-week trace window.

## Remediation

None needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
