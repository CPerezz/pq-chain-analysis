---
id: be95329b-fixed-signer
title: "0xbe95329b: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xbe95329b0882b2a6e95a0092483a131d63c9de18"
  family: "5339ac4178597a9653edef633ef97d07"
  copies: 20
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 12639
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

USDC PrimaBlock pool (impl 0x6b58be1a) in state 2 with PERL confirmed. The 89.03 USDC refund and the 6.06e12 PERL units left are claimable by anyone with no signature. History shows what the dying cosigned 1fb75dbf is for: in 2021 the admin used it to move 79,547 migrated PERL out.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: 20 clones: a signer that is a constant in the code. Bytecode and names.
- Update path, read at block 26,438,999: delegates to a fixed address.
- slot0=0x020100. TokensConfirmed PERL 0xb5a73f5f at block 8425486. USDC 89.031375 and 6,064,884,406,773 PERL units held.
- Per-investor debug_traceCall: fffe58a2 pays 89.031363 USDC and 2d923501(PERL) pays 6,064,884,354,587 units, with no ecrecover.
- Tx 0xe40987e0 (block 12087767): admin 0x1f85258d called 1fb75dbf, with a 0xaa0afc85 ecrecover, to transfer 79,547.29 PERL-v2 (0xeca82185) to 0xf4f1f0e3. The pool now holds 0 of it.
- A call to 1fb75dbf from admin 0x1f85258d reaches ecrecover at 26438999. Only the mass airdrops KTH 777 (2.3k recipients) and AMB 0.01 depend on it.

## Impact and exposure

- Value held at block 26,438,999: $12,639 (ETH and 49 priced tokens, over 20 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

No update path (proxy with a hardcoded implementation). Keep 0xaa0afc85 an EOA or migrate it only by an EIP-7702 delegation, which still recovers. If it must get real code, have the admin run any 1fb75dbf rescue first. The money exits (fffe58a2, 2d923501, 8e5bcbb0, c0d9e7fb, ac5eda28/9aae82c1, 12d7e533) need no signature.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
