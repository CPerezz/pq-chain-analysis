---
id: localethereum-867ffb5a-own-signature-only-exit
title: "LocalEthereumEscrows: funds released only by the party's own signature"
project: localethereum
status: confirmed
severity: HIGH
patterns: [PQ-16]
impact: funds-locked
contracts:
- address: "0x867ffb5a3871b500f65bdfafe0136f9667deae06"
  family: "583c5a3723df423540d14111dee85852"
  copies: 2
  name: "LocalEthereumEscrows"
  label: "LocalEthereum 1"
  upgradeable: "no"
  rating: HIGH
  value_usd: 12057
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2
  last_active: 2026-11-18
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
  note: "disputed trades locked; no sweep"
---

## Summary

`LocalEthereumEscrows` at `0x867ffb5a3871b500f65bdfafe0136f9667deae06` (Etherscan tag: LocalEthereum 1), with 1 more addresses running its code. It releases a party's funds or rights only on that party's own ECDSA signature; once the party's account has code, they are locked.

## Mechanism

PQ-16. Once the party's account has real code the signature recovers no address, and nobody else can act for it unless an administrator can.

## Evidence

- How it was placed: LocalEthereum escrow: as LocalCoinSwap: a dispute can be resolved only with a signature of the buyer or of the seller. Read by hand.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Read by hand: resolveDispute needs a signature of the buyer or the seller; release, buyerCancel, sellerCancel and sellerRequestCancel are direct.
- Unlike the V2 escrows there is no owner sweep of stuck trades (functions at this address: release, buyerCancel, sellerCancel, sellerRequestCancel, disableSellerCancel, resolveDispute, setRequestCancellationMinimumTime, transferToken, withdrawFees), so a disputed trade whose signing party has code stays locked.
- 2 transactions in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $12,057 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 2 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Act before migrating the address; new deployments accept ERC-1271 or a direct call.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-own-signature-only-exit` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
