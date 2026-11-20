---
id: bfa745f3-fixed-signer
title: "0xbfa745f3 (tagged deployed by The Everyones: Deployer): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xbfa745f303342c122a9501b977778382daa15a48"
  family: "b6ae9756860bcfeb84d91a241a177080"
  label: "deployed by The Everyones: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner (setPhase to public sale, or a new deployment for an allowlist)"
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
  note: "The study note calls this a presale with deposit and claim, but the code is an NFT mint. The phase-2 branch of the allowlist mint does not use the 0x4bbf... signer in a way that gates funds."
---

## Summary

The allowlist mint checks ecrecover against the hardcoded EOA 0x7e37..., and no function can replace it. If that key's account gets real code under EIP-8151, only the phase-1 signed mint stops. Nothing is locked: the owner can withdraw all ETH, and the public mint works without a signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- 0xacf86e33: require(address(var_t) == 0x7e3734637dcb3a1ae4019f46db57b33a3d96b096, "Address not allowlisted for Phase 1")
- 0x60a96dcf returns ecrecover == 0x4bbfb4b577dad0eaf72b44e869aa09c34cf3e6af (view-like bool only)
- Both signer addresses are EOAs with no code at block 26438999
- There is no signer setter; the only owner setters cover price, phase, supply, URI and ownership

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner switches to the public phase (setPhase(3)) or deploys a new contract with a settable signer; the signer key's account should stay free of code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
