---
id: 4826f615-fixed-signer
title: "0x4826f615: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x4826f615cdd26999d45b5f02c1be2ebff67ae57f"
  family: "e3740397c563aedcaada7579efdd7eff"
  copies: 58
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 3759
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
  note: "MEDIUM: no update path. Every asset held now leaves by an unsigned or direct-call path (simulated), so nothing is locked. But the admin's cosigned arbitrary call 1fb75dbf (the only rescue for tokens other than the confirmed one) and position transfers die for good with no equivalent path. LOW would apply only if the reviewer treats 1fb75dbf as an unneeded auxiliary path. 5028c8bb itself has a same-act unsigned alternative. Deal states (slot0 byte2): 0 open, where deposits (0fd46419/aa0b7db7), withdraw fe55892d and payout 7c422f1d/a71b00d0 need the 0xaa0afc85 signature; 1 failed (a9cc4718, admin or signer direct); 2 paid; 3 refunding (ac5eda28/9aae82c1, admin or signer direct, only before tokens are confirmed). In state 2: c0d9e7fb (admin or signer direct) confirms tokens; 2d923501 token claims and fffe58a2 refunds are open to anyone; 12d7e533 fees (signer by direct call). Signed functions still reachable in 2: 1fb75dbf (admin arbitrary call), 089fff19/c519c77b (position transfers), 5028c8bb/c437a9a5 (admin-funded targeted refund)."
---

## Summary

ETH PrimaBlock pool (impl 0xdcc74735) in state 2, tokens never confirmed. The 191.97 ETH raised was paid to the admin in 2019. The 0.9647 ETH held is exactly the fee, moved by a direct signer call. 5028c8bb is a cosigned admin-funded targeted refund, and an unsigned pro-rata equivalent (8e5bcbb0 + fffe58a2) works.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: 58 clones: a signer that is a constant in the code. Bytecode and names.
- Update path, read at block 26,438,999: delegates to a fixed address.
- slot0=0x020000. Balance 0.9646582192 ETH = fee slot 4. Signed a71b00d0 (block 7722888) sent 191.967 ETH to admin 0xdb01f2e7.
- debug_traceCall: 12d7e533 from 0xaa0afc85 (direct check, no ecrecover) sends the 0.9646582192 ETH to 0x074403c5.
- Fork with the signer constant patched to a test key: admin 5028c8bb(0.1 ETH, [inv0,inv1], [0.05,0.05]) credits the investors without moving ETH, and fffe58a2 then pays each 0.05 ETH. Unpatched: 8e5bcbb0 with 1 ETH (any sender, no ecrecover) + fffe58a2 refunds 1.0 ETH to 24 investors.
- Fork: admin c0d9e7fb(KTH) confirms with no ecrecover (fee paid out), and 2d923501 distributes the tokens to 24 investors. A call to 1fb75dbf from the admin reaches ecrecover at 26438999.

## Impact and exposure

- Value held at block 26,438,999: $3,759 (ETH and 49 priced tokens, over 58 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

No update path (proxy with a hardcoded implementation). Keep 0xaa0afc85 an EOA or migrate it only by an EIP-7702 delegation, which still recovers. If it must get real code, have the admin run any 1fb75dbf rescue first. The money exits (fffe58a2, 2d923501, 8e5bcbb0, c0d9e7fb, ac5eda28/9aae82c1, 12d7e533) need no signature.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
