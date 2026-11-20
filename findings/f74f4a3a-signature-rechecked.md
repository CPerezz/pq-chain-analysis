---
id: f74f4a3a-signature-rechecked
title: "0xf74f4a3a: a signature checked again after others relied on it"
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0xf74f4a3aa94b053a02124a9f1ff3ba24312f5c13"
  family: "f8ffa7e2a79f6426a8cb4ae1b43b5ede"
  copies: 825
  upgradeable: "no"
  rating: CRITICAL
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "promisors finalize open liabilities while their keys are EOAs"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signature-rechecked"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: CRITICAL
  note: "This row stands for 825 copies. The representative address is finalized, but copy 0xb5895693eaa1fca3acfa3c763c1556dc87a40e17 is still open at block 26,438,999 with its cost escrowed and a promisor 0x69038820... with no code: if that promisor's account takes code, finalize can never pass and the promisee, who did nothing, loses the escrow; no update path: CRITICAL, as for 0x367b3f1a and 0x0c3d7bea."
---

## Summary

This is a Robonomics liability (later version, proxy to 0xa63596d2…). The same finalize-needs-promisor-signature mechanism applies, but this instance is already finalized, so the check never runs again here.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: Robonomics liabilities, later version (825); same verdict as 9e04da31. Bytecode and names.
- Update path, read at block 26,438,999: proxy to 0xa63596d263e7dfd012a635e4e13dd7dc0096a1f8: no admin, no upgrade function in the implementation.
- Sourcify verified source (scratch review_agents/036/src) RobotLiability.sol (finalize gated on !isFinalized)
- at 26438999: isFinalized()=true, cost()=1, validator()=0
- family f8ffa7e2 (825 copies); the richest copy is 0xb5895693…, not checked

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 825 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None for this address.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry (D-025).
