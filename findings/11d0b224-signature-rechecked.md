---
id: 11d0b224-signature-rechecked
title: "0x11d0b224: a signature checked again after others relied on it"
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0x11d0b2243739656f54c0277ed0eecde46658a537"
  family: "baa73883b63370c91cf51cba4f85318f"
  copies: 2
  upgradeable: "no"
  rating: CRITICAL
  value_usd: 7603
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "provider (by moving channels to a new contract)"
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
  note: "The relying party (the provider) loses earned payments with no update path; the settle timeout favours the user who stopped being able to sign."
---

## Summary

A user-to-provider ETH/token payment channel (4 ETH at the block). When a user closes a channel unilaterally, the provider can correct the balance during the settle window only with the user's ECDSA signature on a later balance. If the user's address takes code, the provider cannot show what the user spent, and the user settles with the full deposit.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: a payment channel (4 ETH): tickets the provider signed are settled later; a provider with code would void unsettled tickets. Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- decompiled 0x5a95b4da: only the user can close; it opens a settle window (`storage_map_f[id].field_1 += block.number`)
- decompiled 0x57a4bfed / 0x908c1c06: provider-only; ecrecover over the balance message must equal the channel user ('invalid user signature')
- decompiled settleChannel(bytes32): after the window, pays out from the stored balances with no signature
- no proxy slots and no upgrade function

## Impact and exposure

- Value held at block 26,438,999: $7,603 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None on chain: providers must stop extending credit to users whose addresses may take code and should move to a channel contract that accepts ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry.
