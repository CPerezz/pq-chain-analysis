---
id: wstock3-15c5f0f1-rotate-signer-before-migrating
title: "WStock3: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x15c5f0f18feb8a9f5808ccd2fc4ac279d9d89bb8"
  family: "58f0e620a2935567b1d0de5314614dd5"
  name: "WStock3"
  label: "deployed by StonkSwap: Deployer"
  upgradeable: "no"
  rating: LOW
  value_usd: 26888
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "authAddress EOA 0x99E1…faeA"
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
  note: "The key holder itself is a live EOA and the setter is a direct call, so it stays usable even after migration."
---

## Summary

WStock3: buy/sell require a signature recovered to authAddress. ETH leaves only through signed sell(); there is no owner withdrawal.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be one stored signer of the contract (an affiliate, system, consensus, updater, admin or whitelist key). Read from source.
- setAuthAddress(address) is onlyAuthorized, i.e. msg.sender == authAddress (WStock3.sol:101), so only the key holder rotates it; Ownable owner has no setter
- getAuthAddress() = 0x99E1…faeA, EOA nonce 198 at 26438999 (also owner)

## Impact and exposure

- Value held at block 26,438,999: $26,888 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

authAddress holder calls setAuthAddress(newKey) before migrating; if it migrates first, the setter still works by direct call.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
