---
id: de7480c5-fixed-signer
title: "0xde7480c5 (tagged deployed by CIAN: Deployer): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xde7480c5fee782411d6cb4119a7b2dbd9af84352"
  family: "ad73b2e2048d26bf965d35abfa0fb4dc"
  label: "deployed by CIAN: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The strategy owner or proxy admin would deploy a new implementation with an updated signer set. RedStone's signer operators are the ones whose keys are affected."
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "The study note's 'Presale' label is wrong; this is a RedStone-consuming strategy. Because 3 of the 5 signers must sign, more than 2 signer keys would need code before anything breaks. The decompilation is too unclear to confirm that withdraw never reaches the RedStone path, but the code shown has no signature check on it."
---

## Summary

The 5 RedStone signers are fixed constants, and all 5 are EOAs (no code) today, so the claim holds. If at least 3 of them gained real code, rebalancing that depends on RedStone data would stop working. Vault deposit and withdraw do not appear to need signatures, so in the decompiled code funds do not look locked; one function stops.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: implementationAddress(), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- getAuthorisedSignerIndex compares the address it is given against 5 hard-coded addresses; the facts list all 5 as EOAs with no code
- unresolved_c274583a = 'redstone-primary-prod'; unresolved_f90c4924 = 3 is the number of signers required
- Unresolved_73f36f71 (the initializer) has require(address(this) != 0xde7480c5…, '!proxy'), so this contract is used behind proxies
- deposit 0xb6b55f25 and withdraw 0x2e1a7d4d check only msg.sender == vault; the decompiled code shows no signature check

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Upgrade the proxies to a new implementation with an updated RedStone signer set. Alternatively, rely on the on-chain priceOracle path for rebalancing.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
