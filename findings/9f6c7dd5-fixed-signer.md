---
id: 9f6c7dd5-fixed-signer
title: "0x9f6c7dd5: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x9f6c7dd5833b02dc87d4ceedb2493c395d7047a9"
  family: "2aded08378955417c3734d466aaa6442"
  upgradeable: "no"
  rating: LOW
  txs_90d: 5
  last_active: 2026-10-07
fix:
  layer: new-deployment
  who_acts: "operator (redeploy if quoted fee payments are needed); users can keep withdrawing without a quote"
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
  note: "This reading comes from a decompilation, which was noisy. The quote branches are conditional on a non-zero fee/quote argument."
---

## Summary

I confirmed the claim and rated it LOW. The quote signer is fixed at 0x6be3…f136 in the bytecode, has no code today (a plain EOA), and no function can replace it. The code doesn't check whether the signer has code and doesn't accept ERC-1271 signatures. The signature is only needed on the optional signed-price fee-quote path. If the key's account later gets real code, that path stops working, but deposits and zk-proof withdrawals with the quote argument set to zero still work, so users don't lose funds.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- constant quoteSigner = 615937635569154972940076662382529960124840735030 (the hardcoded comparison address in the bytecode is 0x6be3994bad0ad16e59d2e7352b9a975d1f38f136)
- 0xca7b90ed/0x7432c319: require(address(var_ac) == 0x6be3994bad0ad16e59d2e7352b9a975d1f38f136) only inside if (arg17)/if (arg1)
- 0x6be3994b...f136 has no code (EOA) at block 26438999
- withdraw 0xa9b476ea: the quote checks run only inside if (arg11), so a withdrawal with arg11 = 0 needs no signature

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 5 transactions called it in the 90 days before that block; last on 2026-10-07.

## Remediation

Users can withdraw or deposit without a fee quote. If signed quotes are still wanted, redeploy with a signer that can be rotated or with ERC-1271 support.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
