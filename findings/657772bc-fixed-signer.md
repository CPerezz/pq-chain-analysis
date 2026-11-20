---
id: 657772bc-fixed-signer
title: "0x657772bc: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x657772bca06fce84295531a33ed9dc761b2b8f63"
  family: "9aa6fd3d2d9f82bb7901e42529b9bb02"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The operator deploys a new contract with a new signer, and users move to it."
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
  note: "The decompilation of 0x33f600a4 is partial. I chose MEDIUM because I found no stored user balance; this rests on the code shown, not on value or activity. Matching the constant to 0xd7bb… comes from converting its decimal value."
---

## Summary

The quote signer is a hardcoded constant, 0xd7bb…7bff, which is an EOA today. Nothing can replace it and there is no ERC-1271 path. If that key's account gets real code, signed quotes stop working. The decompilation shows no stored user funds to lock, so only the function stops.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- The constant quoteSigner = 1231615064721811994428023709587128117646027291647 converts to 0xd7bb87916b9820430d807585d79514bc37567bff. The verified bytecode facts say this address has no code (EOA).
- The constant distributor converts to 0xa3c7…feb2, a contract (16243 bytes). The constant weth is 0xc02a…6cc2.
- Only owner state changes: transferOwnership writes pendingOwner (slot 1), acceptOwnership writes owner, setPaused writes the paused flag. No function writes a signer.
- The InvalidQuote error suggests a signed-quote check in 0x33f600a4.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new router whose signer can be rotated or that accepts ERC-1271 signatures, and keep the quoteSigner key free of code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
