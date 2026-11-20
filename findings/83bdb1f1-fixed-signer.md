---
id: 83bdb1f1-fixed-signer
title: "0x83bdb1f1: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x83bdb1f1b6659a0229f5c919810ca06495c84250"
  family: "895f754f5b42b4cb76cf341d6c82e396"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Operator/owner: redeploy the contract with a new signer."
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
  note: "The decompiled code looks like a trading bot or token drainer, not a presale. The signature-gated functions are also owner-only."
---

## Summary

Confirmed, rated MEDIUM. The signature check compares the recovered address to the hard-coded EOA 0x933e…1626, and nothing can replace it. Under EIP-8151, only the two owner-only, signature-gated transferFrom functions would stop. Nothing gets locked, because store_b can withdraw tokens and ETH without a signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Unresolved_f03ea4f5 / Unresolved_19210419: require(address(var_k) == 0x933e5a768e631ca3d8f61d2b52353d103a4e1626, "v9")
- Verified facts: 0x933e…1626 is an EOA with no code
- No function writes the signer: transferOwnership writes store_a (owner) and Unresolved_6dc89061 writes store_b (profiter)
- withdraw/withdrawAll/c73f360e/42d0aff9 let store_b withdraw with no signature

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new contract with a replaceable signer (or ERC-1271 support), or keep the 0x933e key as a plain EOA.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
