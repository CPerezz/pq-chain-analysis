---
id: f9f4ba80-fixed-signer
title: "0xf9f4ba80: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf9f4ba80606cd2ac0ceb16d47fdacb9843ce6ff5"
  family: "3df2bfd69e372e5ed22b1170c99729ec"
  copies: 47
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 12990
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "Holder of 0xaa0afc85 (PrimaBlock signing key) keeps it free of real code or runs any needed 1fb75dbf rescues first; pool admin and the signer key use their direct-call paths"
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
  rating: MEDIUM
  note: "MEDIUM: no update path. Every asset held now leaves by an unsigned or direct-call path (simulated), so nothing is locked. But the admin's cosigned arbitrary call 1fb75dbf (the only rescue for tokens other than the confirmed one) and position transfers die for good with no equivalent path. LOW would apply only if the reviewer treats 1fb75dbf as an unneeded auxiliary path. Deal states (slot0 byte2): 0 open, where deposits (0fd46419/aa0b7db7), withdraw fe55892d and payout 7c422f1d/a71b00d0 need the 0xaa0afc85 signature; 1 failed (a9cc4718, admin or signer direct); 2 paid; 3 refunding (ac5eda28/9aae82c1, admin or signer direct, only before tokens are confirmed). In state 2: c0d9e7fb (admin or signer direct) confirms tokens; 2d923501 token claims and fffe58a2 refunds are open to anyone; 12d7e533 fees (signer by direct call). Signed functions still reachable in 2: 1fb75dbf (admin arbitrary call), 089fff19/c519c77b (position transfers), 5028c8bb/c437a9a5 (admin-funded targeted refund)."
---

## Summary

ETH PrimaBlock pool (impl 0xc87d2f7f) in state 2 with BIDL tokens confirmed. The 5.14 ETH held (later ETH payouts via 8e5bcbb0) and the BIDL left are claimable by anyone with no signature. Only cosigned admin functions die.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: 47 clones: a signer that is a constant in the code. Bytecode and names.
- Update path, read at block 26,438,999: delegates to a fixed address.
- slot0=0x020100. TokensConfirmed BIDL 0x5c7ec304 at block 8620898. Balance 5.138541763 ETH and 234,772,179 BIDL units.
- debug_traceCall of fffe58a2([i]) for each of the 42 deposit-event investors pays out 5.138541762946548196 ETH in total (the whole balance), with no ecrecover.
- 2d923501(BIDL,[i]) per investor pays 234,772,160 of 234,772,179 units (19 units dust).
- A call to 1fb75dbf from admin 0x9d074aa0 reaches ecrecover at 26438999 and reverts. No foreign tokens seen in blocks 7.7M–15.19M.

## Impact and exposure

- Value held at block 26,438,999: $12,990 (ETH and 49 priced tokens, over 47 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

No update path (proxy with a hardcoded implementation). Keep 0xaa0afc85 an EOA or migrate it only by an EIP-7702 delegation, which still recovers. If it must get real code, have the admin run any 1fb75dbf rescue first. The money exits (fffe58a2, 2d923501, 8e5bcbb0, c0d9e7fb, ac5eda28/9aae82c1, 12d7e533) need no signature.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
