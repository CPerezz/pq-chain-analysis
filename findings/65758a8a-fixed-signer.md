---
id: 65758a8a-fixed-signer
title: "0x65758a8a (tagged deployed by Relay: Solver 0x56c...a8b): signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x65758a8ac660b8be0f301b43541b945871c4f088"
  family: "1fc5d73aa1431ef177a16a4168ebdb9a"
  copies: 3
  label: "deployed by Relay: Solver 0x56c...a8b"
  upgradeable: "no"
  rating: LOW
  txs_90d: 9
  last_active: 2026-11-16
  recoveries_14d: 1
fix:
  layer: none
  who_acts: "owner"
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
  note: "The direct owner path keeps the act open, and nothing is held: LOW."
---

## Summary

Trading router/bot of the same family as 0xe921bf7b…, with constant owner 0xea2abb76… (a 7702-delegated EOA). Signed relayed orders recover that key, but execute (0x3593564c) and the sweep (0xbe57b6d1) require msg.sender==owner directly. It holds no funds.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: a signer that is a constant in the code. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Decompile: require(msg.sender==0xea2abb76…) on 0x3593564c and 0xbe57b6d1, which transfers the whole balance.
- 0xea2abb76… code 0xef0100… (delegation); balance 0 ETH and 0 WETH; no ERC-20 inflows in 200k blocks.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 9 transactions called it in the 90 days before that block; last on 2026-11-16.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

None.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
