---
id: fixedpricepool-d6ebb6da-fixed-signer
title: "FixedPricePool: signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xd6ebb6da725df0dc9aba945d4ca149e933c09f52"
  family: "e96f413722be1d867e33a6bf4758360c"
  copies: 91
  name: "FixedPricePool"
  upgradeable: "no"
  rating: NONE
  value_usd: 57
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 6
  last_active: 2026-11-09
fix:
  layer: none
  who_acts: "nobody: not affected"
evidence:
  level: source-read
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
  verdict: refuted
  rating: NONE
  note: "The signature check is disabled by this pool's fixed configuration (antiSnipeEnabled = false)."
---

## Summary

Fjord FixedPricePool clone (args appended to the code): the delegateSigner check runs only when antiSnipeEnabled, which is false for this pool, so buys never recover a signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: FixedPricePool: buys must carry a signature of delegateSigner(), a value fixed in each pool's code. Read by hand.
- Update path, read at block 26,438,999: delegates to a fixed address.
- Code: clone-with-immutable-args forwarding to 0xdf448fd6… (BasePool.sol/FixedPricePool.sol); no upgrade
- BasePool.buy: _validateAntisnipe (recover == delegateSigner()) only if antiSnipeEnabled(); antiSnipeEnabled() at 26438999 = false (immutable arg)
- delegateSigner() = 0xC3f54007… (EOA) is never used here; status()=2, saleEnd 1733839200; close()/redeem() need no signature

## Impact and exposure

- Value held at block 26,438,999: $57 (ETH and 49 priced tokens, over 91 addresses).
- Activity: 6 transactions called it in the 90 days before that block; last on 2026-11-09.

## Remediation

None.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
