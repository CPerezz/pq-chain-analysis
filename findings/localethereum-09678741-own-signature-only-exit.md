---
id: localethereum-09678741-own-signature-only-exit
title: "LocalEthereumEscrows: funds released only by the party's own signature"
project: localethereum
status: confirmed
severity: HIGH
patterns: [PQ-16]
impact: funds-locked
contracts:
- address: "0x09678741bd50c3e74301f38fbd0136307099ae5d"
  family: "afcdcf8075a5ec2aba20a474929c3d82"
  copies: 2
  name: "LocalEthereumEscrows"
  label: "LocalEthereum 2"
  upgradeable: "no"
  rating: HIGH
  value_usd: 8761
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "escrow buyers/sellers (operator cannot rescue ETH)"
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

- How it was placed: LocalEthereum escrow v1: a dispute can be resolved only with a signature of the buyer or of the seller. Read by hand.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source/LocalEthereumEscrows.sol: resolveDispute is onlyArbitrator and requires ecrecover(tradeID+resolve instruction) == buyer or seller (L239-268, ecrecover at L254); no isValidSignature/code check
- Direct-call paths exist (release by seller, buyerCancel/disableSellerCancel by buyer, sellerCancel/sellerRequestCancel by seller via msg.sender), but once the buyer marks paid (disableSellerCancel) only release or resolveDispute moves the escrow
- Owner sweeps: withdrawFees capped at feesAvailableForWithdraw; transferToken/transferTokenFrom move ERC20 only - no ETH sweep. ETH held 4.855 ETH (row value $8,761) at block 26438999
- owner()=0x73D5..AFCa (a contract), arbitrator()=0xA38F..3E18 (EOA); no proxy slot or upgrade function

## Impact and exposure

- Value held at block 26,438,999: $8,761 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Parties should not move escrow-participant keys to code-bearing accounts while a trade is open; a fixed release needs a new deployment.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-own-signature-only-exit` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
