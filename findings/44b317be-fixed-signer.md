---
id: 44b317be-fixed-signer
title: "0x44b317be: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x44b317be48a42bbe6445dc62c4681a95a278b417"
  family: "62976f20ba7f67544693e376c0db73e9"
  copies: 91
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 74491
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

USDC PrimaBlock pool (impl 0x4a4c4221) in state 2, tokens never confirmed. Investors' 17,338.65 USDC went to the sale in 2020. The 628.86 USDC held is the pool fee, moved by a direct call from the signer key. Confirm-and-claim and refund routes work without any signature. Only cosigned admin functions die.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: 91 clones holding 41 ETH: a signer that is a constant in the code. Bytecode and names.
- Update path, read at block 26,438,999: delegates to a fixed address.
- slot0=0x020000. USDC held 628.862917 against fee slot 4 = 628.862817. Signed 7c422f1d at block 9610621 sent 17,338.646216 USDC to 0x229b9e25.
- 12d7e533 sent from 0xaa0afc85 (direct msg.sender check, no ecrecover) moves the fee to fee contract 0xb2c0e134 by transferFrom (debug_traceCall at 26438999).
- Anvil fork at 26438999: admin 0x1f85258d c0d9e7fb(KTH) succeeds with no ecrecover, and 2d923501 then pays 777 KTH to 15 investors. Separately, admin ac5eda28 moves the pool to state 3, and fffe58a2 refunds all 1,628.86 USDC in the pool (incl. 1,000 test USDC).
- A call to 1fb75dbf from admin 0x1f85258d reaches ecrecover at 26438999 and reverts on a bad signature.

## Impact and exposure

- Value held at block 26,438,999: $74,491 (ETH and 49 priced tokens, over 91 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

No update path (proxy with a hardcoded implementation). Keep 0xaa0afc85 an EOA or migrate it only by an EIP-7702 delegation, which still recovers. If it must get real code, have the admin run any 1fb75dbf rescue first. The money exits (fffe58a2, 2d923501, 8e5bcbb0, c0d9e7fb, ac5eda28/9aae82c1, 12d7e533) need no signature.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
