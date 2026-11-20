---
id: ff003b43-fixed-signer
title: "0xff003b43: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xff003b436c441ea8377dd3756b0e42e549d2704c"
  family: "100434e21d2379b99fd2c2720598b2b7"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 16
  last_active: 2026-10-23
fix:
  layer: new-deployment
  who_acts: "Owner/project. They can switch to publicMint via setMintDay(PUBLIC), use ownerMint, or redeploy."
evidence:
  level: source-read
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
  note: "The study note calls this a presale with deposit and claim, but the code is a free NFT mint. The only signature-gated function is freeMint."
---

## Summary

The signer is a compile-time constant with no setter and no ERC-1271 or code check. It has 0 bytes of code today. If that account gets real code, freeMint stops working. No funds are locked because the contract holds none, and owner-side mint paths stay available.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address constant signer = 0xE68be8d5788646A3c9FD61fEc32C2dF27e23FE46;` in multivers3
- _verifySignature compares the ECDSA.recover result to signer; it is pure, with no isContract or 1271 check
- freeMint requires _verifySignature(keccak256("multivers3Free", msg.sender, maxMintsFree))
- Row facts: signer code_bytes 0, not delegated; upgradeable: no; the only setter is transferOwnership

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 16 transactions called it in the 90 days before that block; last on 2026-10-23.

## Remediation

Keep the signer key a plain EOA (or 7702-delegated only). If that is not possible, the owner can run the remaining mint through ownerMint or publicMint, or deploy a new contract with a signer that can be changed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
