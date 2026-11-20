---
id: dexblue-00000000-rotate-signer-before-migrating
title: "dexBlue: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x000000000000541e251335090ac5b47176af4f7e"
  family: "5f1e19fa2926116305eaa1656b9b06cd"
  name: "dexBlue"
  label: "dex.blue"
  upgradeable: "no"
  rating: LOW
  value_usd: 24181
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-10-28
fix:
  layer: onchain-config
  who_acts: "owner (likely EOA 0x26d8…2ad9) and users"
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
  note: "Users keep a direct withdrawal path even if arbiters die; arbiter rotation by owner."
---

## Summary

dexBlue exchange: orders and multiSig withdrawals recover the trader and an arbiter; arbiters are nominated by the owner.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: dexBlue order: the signee is whoever signed the order, the trader or its delegate / dexBlue multiSigSend: the caller withdraws its balance with a signature of an arbiter / dexBlue multiSigTransfer:…. Read from source.
- nominateArbiter(address,bool) is owner-only, changeOwner is owner-only (dexBlue.sol:2479,2556)
- Users exit without any signature: blockFundsForSingleSigWithdrawal then initiateSingleSigWithdrawal (dexBlue.sol:1712,1726)
- owner storage slot not resolved; nonzero address slot 13 = 0x26d8…2ad9 EOA nonce 8 [INFERENCE: likely owner]

## Impact and exposure

- Value held at block 26,438,999: $24,181 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-10-28.

## Remediation

Owner nominates new arbiter keys; users use single-sig withdrawal.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
