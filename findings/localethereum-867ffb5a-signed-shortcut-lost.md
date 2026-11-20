---
id: localethereum-867ffb5a-signed-shortcut-lost
title: "LocalEthereumEscrows: signed shortcut lost by users with code"
project: localethereum
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x867ffb5a3871b500f65bdfafe0136f9667deae06"
  family: "583c5a3723df423540d14111dee85852"
  copies: 2
  name: "LocalEthereumEscrows"
  label: "LocalEthereum 1"
  upgradeable: "no"
  rating: LOW
  value_usd: 12091
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2
  last_active: 2026-11-18
fix:
  layer: offchain
  who_acts: "buyer/seller with code"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "LOW holds for the relayed instructions. Edge case: arbitration needs at least one party without code; even then the seller can release and the buyer can cancel, so nothing is locked by design. Value $12091, txs_90d 2 (not rating inputs)."
---

## Summary

LocalEthereum escrow: buyers and sellers may relay instructions by signature, and the arbitrator settles disputes with the signature of either party. Under EIP-8151 a party with code can't sign, but every relayed instruction has a direct twin.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: LocalEthereum escrow: as LocalCoinSwap: a dispute can be resolved only with a signature of the buyer or of the seller. Read by hand.
- source: relay() instructions map to release/disableSellerCancel/buyerCancel/sellerCancel/sellerRequestCancel, each callable directly (require msg.sender == _seller/_buyer)
- resolveDispute (onlyArbitrator) needs a signature from the buyer OR the seller: it fails only when both parties have code
- arbitrator 0xA38F728C… at block: EOA, nonce 3577; createEscrow needs the relayer signature, and setRelayer is onlyOwner (owner 0x47D70D72…)

## Impact and exposure

- Value held at block 26,438,999: $12,091 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 2 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Parties with code use the direct calls; a dispute between two parties that both have code has no arbitration path.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
