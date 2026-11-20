---
id: 15224f02-fixed-signer
title: "0x15224f02 (tagged deployed by Genetic Chain: Deployer): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x15224f0285e0f3266aff3bc4f7bd5425fd3c9ecf"
  family: "9246ba9bcd4520b7c430e84c0a16ba35"
  copies: 2
  label: "deployed by Genetic Chain: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Owner/operator would have to deploy a new contract to keep signed minting going"
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
  note: "The study note calls this a presale with deposit and claim. The decompiled code shows a signed paid NFT mint instead, and there is no claim function."
---

## Summary

The signed mint compares the recovered signer to the hard-coded address 0xa986…1d2a. That address has no code today, and no function can replace it. If that key's account gets real code, the signed mint stops working. No ETH gets stuck: payment and minting happen in the same call, and the owner can still pull the balance out with withdraw. Only a function stops, so this is MEDIUM.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- 0x4593ad97: require(address(var_u) == 0xa98673d426bcf78ea72aef978f2cff756d941d2a, "invalid signer")
- Bytecode facts: 0xa98673d4…1d2a is an EOA with no code at block 26438999
- No setter writes the signer. transferOwnership and renounceOwnership only change the owner in slot 6
- withdraw (0xf3fef3a3) is onlyOwner and transfers the contract's ETH balance

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new contract whose signer can be changed, or add a mint path that needs no signature. Owner funds can still be recovered with withdraw.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
