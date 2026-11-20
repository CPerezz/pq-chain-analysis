---
id: 65cc4909-fixed-signer
title: "0x65cc4909: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x65cc4909c74c59ccaac127af1ad3173750dcff94"
  family: "683e9a3d07843d65b3a6e1e06c4ae1a2"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The holder of signer key 0x923a…ba30, which is also the current owner. If that account gets real code, only a redeployment restores the signed updates."
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
  note: "The study note calls this a presale with signed deposit/claim, but the decompiled code shows an NFT where only token metadata updates need the signature. The gated functions move no value."
---

## Summary

The signer is a hard-coded constant that is also the current owner, has no code today, and cannot be replaced (no setter, no upgrade path). If it ever gets non-delegation code, the signed token metadata updates stop working. No funds are locked: publicMint does not need a signature, and the owner can still call withdraw().

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- The signature functions check `require(... == 0x923a9eae85e8c61083bd984285b72edf4113ba30, CustomError_8baa579f())` after ECDSA recovery.
- Verified facts: 0x923a9eae85e8c61083bd984285b72edf4113ba30 has no code at block 26438999 (it is an EOA).
- owner() getter returns the same address. transferOwnership only writes the owner slot.
- upgradeable: no. There are no upgrade functions.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The signer key should only use EIP-7702 delegation and never deploy real code at that address. If it does, redeploy the contract with a replaceable signer or ERC-1271 support.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
