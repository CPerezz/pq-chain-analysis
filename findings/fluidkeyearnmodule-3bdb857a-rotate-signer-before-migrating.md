---
id: fluidkeyearnmodule-3bdb857a-rotate-signer-before-migrating
title: "FluidkeyEarnModule: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x3bdb857afe9b51d8916d80240d2ade40d4d3f2f9"
  family: "871a1f6d0a91f17cce21a49c683f94de"
  copies: 3
  name: "FluidkeyEarnModule"
  upgradeable: "no"
  rating: LOW
  txs_90d: 3358
  last_active: 2026-11-18
  recoveries_14d: 153
fix:
  layer: onchain-config
  who_acts: "owner Safe 0x9E3e…e7CD or an existing relayer"
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
  note: "Relayer set can be replaced by a live Safe owner, so LOW holds. Only the auto-earn automation is affected; no funds are held."
---

## Summary

FluidkeyEarnModule: autoEarn accepts ECDSA signatures from authorized relayers. A relayer key whose account holds code can no longer authorize auto-earn deposits.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source. Executed: a real transaction loses its effect with code at the signer.
- FluidkeyEarnModule.sol:183/193: addAuthorizedRelayer and removeAuthorizedRelayer use onlyAuthorizedRelayer, which lets the owner or any existing relayer call them
- Ownable(_owner) (OpenZeppelin); autoEarn line 392 requires ECDSA.recover to return an address in authorizedRelayers
- owner() = Safe 0x9E3e…e7CD, 2-of-3, at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 3,358 transactions called it in the 90 days before that block; last on 2026-11-18.
- 153 signature recoveries in the study's two-week trace window.

## Remediation

The owner Safe (or another relayer) adds a new EOA relayer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
