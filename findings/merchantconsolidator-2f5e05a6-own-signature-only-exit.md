---
id: merchantconsolidator-2f5e05a6-own-signature-only-exit
title: "MerchantConsolidator: funds released only by the party's own signature"
status: confirmed
severity: MEDIUM
patterns: [PQ-16]
impact: liveness
contracts:
- address: "0x2f5e05a65f25d7bec3d8f02a9689cdf43eccd3e6"
  family: "d54dd91dc42dc30c395222a07c676a7a"
  copies: 3
  name: "MerchantConsolidator"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 138
  last_active: 2026-11-18
  recoveries_14d: 27
fix:
  layer: none
  who_acts: "merchant (direct call batchSweep)"
evidence:
  level: executed
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
  rating: MEDIUM
  note: "Rebinding the recipient dies for good (no update path, no other path for that act); nothing is locked, since sweeps to the bound recipient still work by a direct call -> MEDIUM."
---

## Summary

Payment-processor consolidator for 7702-delegated source EOAs: funds at sources can always be swept, but only to the bound authorizedRecipient. Only rebinding a source to a new recipient needs the merchant's ECDSA co-signature. A merchant with code loses only that rebinding; sweeping to the existing recipient still works by direct call.

## Mechanism

PQ-16. Once the party's account has real code the signature recovers no address, and nobody else can act for it unless an administrator can.

## Evidence

- How it was placed: the stored registrar signs every assignment; a change of the authorised recipient also needs a 65-byte ECDSA signature of the merchant (read): a merchant whose address has code cannot give it. Read by hand. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- contracts/Merchantconsolidator.sol L226-229: a recipient change requires _recoverSigner(digest, merchantSignature) == merchant (ecrecover L176)
- batchSweep/batchSweepERC20 (L337-355) are direct calls gated by msg.sender == merchant or an authorized relayer, with no signature; sweepETH/sweepERC20FullBalance pay authorizedRecipientOf[source]
- The canonical contract holds nothing (receive reverts); funds sit at the merchants' delegated source EOAs. Row value n/a, txs_90d=138
- No proxy, no upgrade function

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 138 transactions called it in the 90 days before that block; last on 2026-11-18.
- 27 signature recoveries in the study's two-week trace window.

## Remediation

The merchant keeps sweeping to the bound recipient; to change the recipient, use new sources or re-delegate them.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-own-signature-only-exit` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
