---
id: a20078ae-fixed-signer
title: "0xa20078ae: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xa20078aebd8fc3136ee1fb089785f7d48555d4ab"
  family: "29a1925eb930e9df6c725f108214f202"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "deployer/owner (new-charge liveness only)"
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
  note: "Only new price-dependent charges stop if the whole oracle signer set gets code (unlikely all at once); owner retains withdrawETH/withdrawToken/cancel to recover funds either way."
---

## Summary

A subscription/fee-charging contract (`chargeDiscounted`, `subscribeAndChargeDiscounted`, `setPlatformFee`) that prices in BNB via a RedStone-style push-oracle verified against a fixed authorised-signer set (`getUniqueSignersThreshold`, `getAuthorisedSignerIndex`); EIP-8151 stops new price-dependent charges once those signer addresses get code.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: launchpad mint: the signer must be SIGNER, fixed in the code. Same code idiom as template 09e5c621, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- decompile shows `uint256 public constant getUniqueSignersThreshold = 3;` and a `getAuthorisedSignerIndex(address) public pure` function matching the RedStone oracle-consumer idiom (hardcoded authorised-signer set, not admin-settable)
- facts.exits includes cancel(address), withdrawETH(uint256), withdrawToken(address,uint256) — owner-reachable way to pull funds out regardless of the oracle
- facts.setters = [transferOwnership] only; no setter touches the oracle signer set

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

No on-chain fix for the hardcoded RedStone signer set; would need redeployment pointed at a currently-safe signer set, or an off-chain price fallback.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
