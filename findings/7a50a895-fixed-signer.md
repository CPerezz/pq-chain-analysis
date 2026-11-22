---
id: 7a50a895-fixed-signer
title: "0x7a50a895: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x7a50a89550c4b142d1df57ec47b9cb3386d852da"
  family: "53acd230cbedbb89287adaa196dbdb31"
  upgradeable: "yes"
  admin: "ProxyAdmin 0x26c120c15f2ad7a45fa6f8b70d19dcbcecb71161 owned by EOA 0xc51f8da800f23117d3ac3a51dc669d17fa298a2e"
  rating: LOW
  txs_90d: 6555
  last_active: 2026-11-18
  recoveries_14d: 940
fix:
  layer: contract-upgrade
  who_acts: "EOA 0xc51f8da8… via ProxyAdmin 0x26c120c1…"
evidence:
  level: executed
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "A live EOA controls the upgrade: LOW. The owner's nonce is low but nonzero."
---

## Summary

An ERC-1271 swap contract behind a proxy that answers for a constant signer. Orders fail once that signer holds code.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: ERC-1271 swap contract answering for a signer that is a constant in its code. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: proxy to 0xc495f766b0e93999679380a0f8cdc2f7d2fe1cda, admin 0x26c120c15f2ad7a45fa6f8b70d19dcbcecb71161.
- EIP-1967 admin slot at 26438999 = 0x26c120c1… (ProxyAdmin); owner() = 0xc51f8da800f23117d3ac3a51dc669d17fa298a2e
- 0xc51f8da8…: no code, nonce 4 (a live EOA)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 6,555 transactions called it in the 90 days before that block; last on 2026-11-18.
- 940 signature recoveries in the study's two-week trace window.

## Remediation

Upgrade the implementation with a new signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
