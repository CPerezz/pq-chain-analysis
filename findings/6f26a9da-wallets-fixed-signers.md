---
id: 6f26a9da-wallets-fixed-signers
title: "0x6f26a9da: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x6f26a9dae77e0a0bf1527ae4abafcb2c78287ac0"
  family: "da435b1734de475646334afa4e3660a3"
  copies: 3
  upgradeable: "no"
  rating: HIGH
  value_usd: 586
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the wallet's owners (2 of 3 EOAs)"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-wallets-fixed-signers"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
  note: "No setter, no proxy, no other exit; the owners' own funds are locked once fewer than 2 owner keys can still recover, so HIGH. This is not the template's exact code (a bucket/deadline variant), but the check is the same."
---

## Summary

A modified SimpleMultiSig (v1.0.1, with bucketed nonces and a deadline). Its only state-changing function, 0x163947e5, needs `threshold` (2) ecrecover'd owner signatures, and the 3 owners are fixed with no setter. Once enough owner EOAs take code, the 0.32 ETH can no longer be moved.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- heimdall: only non-view function 0x163947e5(bucket,deadline,v[],r[],s[],dest,value,data,executor,...) with 'bad_r_len' (sigs==threshold), 'bad_executor', 'time_expired', 'bucket_out_of_range', 'bad_sig'; no owner setter, no proxy slots
- at block 26438999: threshold()=2, ownersArr=[0x1ab13e18c2f1e9eb2e2005afd569d14f53f8a306, 0xea922439112147b1e9661361ac96725fad822f0a, 0xf7e657d8f7f1ed9177cef8dae1bba5d82a8145f7], balance 0.32 ETH; EIP-1967 impl/admin slots 0
- cast code latest: all three owners are EOAs (0x), nonces 29/0/0
- batch row: value_usd 586, txs_90d 0, last_active null, copies 3

## Impact and exposure

- Value held at block 26,438,999: $586 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Before owner keys migrate to code, 2 owners sign one last execute that moves the funds to a new wallet that accepts ERC-1271 or rotatable signers.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
