---
id: ee991053-fixed-signer
title: "0xee991053: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xee991053c362fe6d40af54117d50130bcb1ac786"
  family: "57a7e58c5ee0388b1deb9bd62d829aec"
  copies: 168
  upgradeable: "no"
  rating: LOW
  txs_90d: 518
  last_active: 2026-11-17
  recoveries_14d: 125
fix:
  layer: none
  who_acts: "bot owner 0x1cf958f46bc155e8e0f911203a2ba16271719ede (EOA)"
evidence:
  level: bytecode
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
  verdict: confirmed
  rating: LOW
  note: "The same act stays open to the affected party by a direct call, so LOW."
---

## Summary

Minimal-proxy MEV bot whose holderBuy path needs the stored owner's signature. The owner can still trade directly with mevBuy/mevSell and pull funds with rescue.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: MEV bot contracts (168 clones; 125 recoveries in the window): trades are signed by a stored owner key with no visible rotation. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: delegates to a fixed address.
- code is an EIP-1167 proxy to 0xaad30a82… (selectors mevBuy, mevSell, rescue, holderBuy, owner, nonce)
- mevBuy/mevSell/rescue require msg.sender == owner (heimdall)
- cast call --from owner rescue(0x0, owner) succeeds; owner() is an EOA
- proxy balance 0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 168 addresses).
- Activity: 518 transactions called it in the 90 days before that block; last on 2026-11-17.
- 125 signature recoveries in the study's two-week trace window.

## Remediation

None needed; the owner acts directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
