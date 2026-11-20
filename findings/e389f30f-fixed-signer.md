---
id: e389f30f-fixed-signer
title: "0xe389f30f: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe389f30f9cc6a4c58582129c0b270f1dd9d47f5c"
  family: "38c0506570fbfa22d5d83047d87910af"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Project owner/operator"
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
  note: "The study note calls this a presale, but the decompiled code shows a signed NFT mint with no payable deposit path."
---

## Summary

The claim/mint function only accepts signatures from the hardcoded EOA 0x918de5f6…2912, and nothing in the contract can replace it. If that key's account gets real code, signed mints stop. Nothing is locked: NFTs already minted stay transferable, and the owner can still withdraw the ETH.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- 0xce3dc5cf: require(address(var_s) == 0x918de5f6a7411219d7ea785dce2d5d6b120b2912, "Signature invalid")
- Verified facts: 0x918de5f6…2912 is an EOA (no code) at block 26438999
- No function writes the signer. The only setter, transferOwnership, changes the owner.
- withdraw() is owner-only and sends address(this).balance to the owner

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new claim contract whose signer can be changed, or that also accepts ERC-1271 signatures. Until then, keep the signer key as an EOA or a 7702-delegated account.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
