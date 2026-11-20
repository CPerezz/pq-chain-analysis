---
id: 4837f64c-rotate-signer-before-migrating
title: "0x4837f64c (tagged deployed by FalconSwap: Deployer): signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x4837f64cd9201abf0f7625fd7126249cab8bd556"
  family: "43041f31a98b0fc8322375241bd2684e"
  label: "deployed by FalconSwap: Deployer"
  upgradeable: "no"
  rating: LOW
  value_usd: 12632
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 6
  last_active: 2026-11-09
  recoveries_14d: 11
fix:
  layer: account-migration
  who_acts: "each user (withdraws directly)"
evidence:
  level: bytecode
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
  note: "LOW: the same act (moving one's own balance) stays open by a direct call. Based on a partial decompile; the signed path's exact purpose was not fully decoded."
---

## Summary

FalconSwap pooled vault: signed operations recover user signatures (9 distinct signers) and use the recovered address as the balance key. A user whose account takes code cannot sign, but balances are keyed by address and can be withdrawn directly.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a pooled vault (7 ETH with tokens; 11 recoveries in the window). Bytecode and names. Executed: a real transaction reverts with code at the signer.
- _cards.jsonl: ecrecover result flows to hashed/map_key, 9 distinct signers, none the account itself
- heimdall decompile: withdrawETH(address,uint256) debits storage_map_f[msg.sender] with no signature; deposits are likewise keyed on msg.sender
- owner 0x77ba75a9… (EOA nonce 131) controls the token listing

## Impact and exposure

- Value held at block 26,438,999: $12,632 (ETH and 49 priced tokens).
- Activity: 6 transactions called it in the 90 days before that block; last on 2026-11-09.
- 11 signature recoveries in the study's two-week trace window.

## Remediation

An affected user withdraws by direct call and redeposits from a new key, or uses a 7702 delegation.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
