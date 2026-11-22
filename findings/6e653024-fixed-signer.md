---
id: 6e653024-fixed-signer
title: "0x6e653024: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x6e653024fe23e4a7f2a1c8e14c388f71dd44668f"
  family: "dd3f0ebb66a0bbded204d47fee33369f"
  copies: 204
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 133544
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

ETH PrimaBlock pool (impl 0x273ca078) in state 2 (paid, tokens confirmed). All 46.35 ETH and the UOS left are unclaimed refunds and tokens that anyone can release with no signature. Signed paths still reachable: the admin rescue call 1fb75dbf and position transfers, which die once 0xaa0afc85 has code.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: 204 clones holding 74 ETH: a signer that is a constant in the code, next to a signer named in the call. Bytecode and names.
- Update path, read at block 26,438,999: delegates to a fixed address.
- slot0=0x020100 (state 2, tokens confirmed at block 8167371, UOS 0xd13c7342). Balance 46.352840455 ETH.
- debug_traceCall of fffe58a2([addr]) from 0xdead at 26438999 pays 0xea3699d3 7.725 ETH and 0x9b6c689d 38.627 ETH (= whole balance). No ecrecover call.
- 2d923501(UOS,[addr]) pays 0x7a714852 102,743,986 and 0x9b6c689d 502,170,018 = the whole 604,914,014 UOS balance, with no signature.
- A call to 1fb75dbf from admin 0x501901b1 reaches ecrecover at 26438999 and reverts on a bad signature. Only the mass airdrops WDT (0.0004) and EBK (100.5; 14.5k recipients) depend on it.

## Impact and exposure

- Value held at block 26,438,999: $133,544 (ETH and 49 priced tokens, over 204 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

No update path (proxy with a hardcoded implementation). Keep 0xaa0afc85 an EOA or migrate it only by an EIP-7702 delegation, which still recovers. If it must get real code, have the admin run any 1fb75dbf rescue first. The money exits (fffe58a2, 2d923501, 8e5bcbb0, c0d9e7fb, ac5eda28/9aae82c1, 12d7e533) need no signature.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
