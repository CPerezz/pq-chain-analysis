---
id: cryptogames-33333313-fixed-signer
title: "CryptoGames: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x3333331365f21e192fd43e599dbb44eff532a667"
  family: "4a28a8cc81e8dc2989423a1aaacb61f9"
  copies: 3
  name: "CryptoGames"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 8
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "owner 0x3333…5b47"
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
  verdict: confirmed
  rating: MEDIUM
  note: "The game dies but an owner path still moves the money, so MEDIUM. Players' pending bets depend on the owner refunding them. The row's HIGH is not supported."
---

## Summary

confirm() settles bets only with ecrecover(seed) == CROUPIER_BOB, a storage address with no setter. With code there, pending bets never settle and there is no player refund function. The owner still moves any amount with multisend/pay_royalty, so the money is not stuck.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: CryptoGames confirm: CROUPIER_BOB, a constant, signs each seed. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source: CROUPIER_BOB is written only at declaration; confirm requires msg.sender == CROUPIER_BOB and `ecrecover(seed,_v,_r,_s) == CROUPIER_BOB`.
- multisend(dests, values, ident) and pay_royalty are onlyOwner, with no signature.
- Croupier 0xB0B3…1b05 (nonce 701) and owner 0x3333…5b47 have no code; 0.0043 ETH held.

## Impact and exposure

- Value held at block 26,438,999: $8 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner refunds pending bets with multisend.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
