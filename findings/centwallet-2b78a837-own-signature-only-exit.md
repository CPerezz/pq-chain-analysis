---
id: centwallet-2b78a837-own-signature-only-exit
title: "CentWallet: funds released only by the party's own signature"
status: confirmed
severity: HIGH
patterns: [PQ-16]
impact: funds-locked
contracts:
- address: "0x2b78a837c37549539c62ab54a235a8e19fea812f"
  family: "1567048089bd6f48b2aaddca70022941"
  name: "CentWallet"
  label: "Cent.co: Wallet"
  upgradeable: "no"
  rating: HIGH
  value_usd: 70053
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "each party acts before its address takes code"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-own-signature-only-exit"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
  note: "users' funds locked if their linked keys take code"
---

## Summary

`CentWallet` at `0x2b78a837c37549539c62ab54a235a8e19fea812f` (Etherscan tag: Cent.co: Wallet). It releases a party's funds or rights only on that party's own ECDSA signature; once the party's account has code, they are locked.

## Mechanism

PQ-16. Once the party's account has real code the signature recovers no address, and nobody else can act for it unless an administrator can.

## Evidence

- How it was placed: CentWallet: every function is for the admin only and takes the signature of a key linked to the wallet; a wallet whose linked keys all sit on accounts with code cannot withdraw. 39 ETH, no recovery…. Read by hand.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Read by hand: every function is for Cent's admins and takes the signature of a key linked to the wallet; addAdmin, removeAdmin and changeRootAdmin manage admins, not the users' linked keys.
- A wallet whose linked keys all sit on accounts with code cannot withdraw. No proxy, no upgrade. Dormant.

## Impact and exposure

- Value held at block 26,438,999: $70,053 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Act before migrating the address; new deployments accept ERC-1271 or a direct call.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-own-signature-only-exit` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
