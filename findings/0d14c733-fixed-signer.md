---
id: 0d14c733-fixed-signer
title: "0x0d14c733: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0d14c73344366055185734e237f44740354037c5"
  family: "e5f00da3d8500cfb9936f388b92a0169"
  copies: 6
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "deployer/owner (fill liveness only)"
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
  note: "Quote fills stop (liveness) but the owner's sweepToken/sweepETH/withdrawInventory exit lets them recover the held inventory regardless, so nothing is locked."
---

## Summary

An OTC/RFQ-style quote-filling contract (`initialize`, `tokenConfigs`, `usedQuotes`, `withdrawInventory`) that only fills a trade signed by a fixed quote signer; EIP-8151 stops new fills once that signer's address gets code.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: launchpad mint: the signer must be SIGNER, fixed in the code. Same code idiom as template 09e5c621, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- stack-traced disassembly confirms a STATICCALL with gas forwarded to address 1 (ecrecover precompile) inside the contract's bytecode
- function surface (`initialize`/`tokenConfigs`/`usedQuotes`/`withdrawInventory`/`sweepToken`/`sweepETH` where present) matches an inventory-holding OTC quote filler, same family as the independently-confirmed quoteSigner contract 0xe88fc588
- facts.setters = [transferOwnership] only; facts.upgrades = [] -> no way to rotate the quote signer
- facts.exits = ['sweepToken(address,address,uint256)', 'transfer(address,uint256)', 'transferFrom(address,address,uint256)', 'transferOwnership(address)']: sweepToken/sweepETH present -> owner can pull the inventory out directly, independent of whether quote-filling still works

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 6 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

No on-chain fix for the hardcoded quote signer; redeploy with a replaceable signer, or sweep remaining inventory before EIP-8151 activates.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
