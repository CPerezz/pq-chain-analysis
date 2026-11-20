---
id: localethereum-867ffb5a-rotate-signer-before-migrating
title: "LocalEthereumEscrows: signer key to rotate before its account takes code"
project: localethereum
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
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
  layer: onchain-config
  who_acts: "buyer/seller (direct calls), owner EOA 0x47d70d729c6efd464cc49ebb6f4ee240219ecb9e for relayer"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "LOW: the same acts stay open by direct calls, and the relayer key is replaceable by a live owner."
---

## Summary

LocalEthereum escrow: resolveDispute needs a signature from the buyer or the seller, createEscrow needs a relayer signature, and relayed actions recover the party. A party with code loses only the signed routes.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: LocalEthereum escrow: as LocalCoinSwap: a dispute can be resolved only with a signature of the buyer or of the seller. Read by hand.
- LocalEthereumEscrows.sol:151-162: arbitrator resolves with a signature from either party; :127: createEscrow requires the relayer's signature
- release/buyerCancel/sellerCancel/sellerRequestCancel/disableSellerCancel (lines 193-272) are direct calls by msg.sender
- setRelayer/setArbitrator/setOwner are onlyOwner; owner 0x47d70d72… is an EOA with nonce 985

## Impact and exposure

- Value held at block 26,438,999: $12,091 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 2 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Parties use the direct calls, the owner replaces the relayer if needed, and the counterparty's signature still allows arbitration.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
