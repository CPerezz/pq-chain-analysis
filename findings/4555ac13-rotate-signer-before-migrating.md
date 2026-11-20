---
id: 4555ac13-rotate-signer-before-migrating
title: "0x4555ac13 (tagged deployed by SODAX: Deployer): signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x4555ac13d7338d9e671584c1d118c06b2a3c88ed"
  family: "10bf4481d11c2da82619b5ce1f38c98b"
  copies: 2
  label: "deployed by SODAX: Deployer"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 2979
  last_active: 2026-11-17
  recoveries_14d: 322
fix:
  layer: onchain-config
  who_acts: "owner Safe 2-of-3"
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
  note: "Owner-only validator setters (and UUPS upgrade) exist; the owner is a live 2-of-3 Safe."
---

## Summary

UUPS proxy (impl 0x5aa84590…5b74) of a validator-signature bridge/verifier with per-chain validator sets and a threshold; validators holding code would stop counting.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: validators per chain with a threshold, changed by functions. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- heimdall decompile of impl: updateValidators(bytes[],uint8), updatePerChainValidators, removePerChainValidators, setValidatorThreshold and upgradeToAndCall all require msg.sender==owner (0x118cdaa7)
- eth_call at block 26438999: setValidatorThreshold(1) from owner Safe succeeds, from 0xdead reverts 0x118cdaa7
- owner()=0x36BB43bED1338Ab7D9F07e06bF5e330D4FdBfd6f, Safe 2-of-3 (probe)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 2,979 transactions called it in the 90 days before that block; last on 2026-11-17.
- 322 signature recoveries in the study's two-week trace window.

## Remediation

Owner Safe replaces affected validators (or upgrades) before a validator key takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
