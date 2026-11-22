---
id: localethereumescrows-9f543912-own-signature-only-exit
title: "LocalEthereumEscrows: funds released only by the party's own signature"
status: confirmed
severity: HIGH
patterns: [PQ-16]
impact: funds-locked
contracts:
- address: "0x9f543912b88b98b7a2729ab9dc713217e52c3c75"
  family: "19f602bc04cb48b2419d43e914a8712d"
  copies: 2
  name: "LocalEthereumEscrows"
  upgradeable: "no"
  rating: HIGH
  value_usd: 315
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "escrow buyers/sellers"
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
  note: "No update path, no ETH sweep: escrowed users' ETH can be locked when the honest party has code and the counterparty won't sign -> HIGH; txs_90d=0."
---

## Summary

P2P ETH escrow: the funds are released by seller release/cancel or by the arbitrator's resolveDispute, which needs an ECDSA signature by the buyer or the seller. A party whose account takes non-7702 code can no longer sign a dispute request; if the counterparty refuses to sign (seller won't release after mark-paid, or buyer marks paid without paying), the escrowed ETH stays stuck.

## Mechanism

PQ-16. Once the party's account has real code the signature recovers no address, and nobody else can act for it unless an administrator can.

## Evidence

- How it was placed: LocalEthereum escrows: the arbitrator resolves a dispute only with the buyer's or seller's signature; same design as the filed LocalEthereum entry. Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source/867ffb..._LocalEthereumEscrows.sol: resolveDispute is onlyArbitrator and requires ecrecover(tradeID+resolve instruction) == buyer or seller (L151-183, recover at L718); no isValidSignature/code check
- Direct-call paths exist (release by seller, buyerCancel/disableSellerCancel by buyer, sellerCancel/sellerRequestCancel by seller via msg.sender), but once the buyer marks paid (disableSellerCancel) only release or resolveDispute moves the escrow
- Owner sweeps: withdrawFees capped at feesAvailableForWithdraw; transferToken/transferTokenFrom move ERC20 only - no ETH sweep. ETH held 0.160 ETH (row value $315) at block 26438999
- owner()=0x8456..5a3E (EOA), arbitrator()=0x47b6..4f46 (EOA); no proxy slot or upgrade function

## Impact and exposure

- Value held at block 26,438,999: $315 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Parties should not move escrow-participant keys to code-bearing accounts while a trade is open; a fixed release needs a new deployment.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-own-signature-only-exit` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
