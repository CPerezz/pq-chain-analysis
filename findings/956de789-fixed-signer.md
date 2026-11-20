---
id: 956de789-fixed-signer
title: "0x956de789: signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x956de789315ca4838c7ea2cd87d689a6c594134b"
  family: "e5dd338e1b9ad9ea27321c4ae8cb972e"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody: not affected"
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
  verdict: refuted
  rating: NONE
  note: "No ecrecover-to-address(1) call found anywhere in the contract despite the inherited template classification; the claimed mechanism is not present in this code."
---

## Summary

A staking/NFT-count tracker (`getStakeContracts`, `getUserStakeSum`, `mintedNFTsCounts`, `usedID`). 8 STATICCALLs found in the bytecode (stack-traced); every one resolves to a constant address other than `0x0000...0001` (external stake-contract/NFT queries), none is a gas-forwarded call to the ecrecover precompile. The study's 'same as its template (fixed-signer mint)' classification does not match this contract's code.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: launchpad mint: the signer must be SIGNER, fixed in the code. Same code idiom as template 09e5c621, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- stack-traced disassembly of every STATICCALL in the bytecode: none has `PUSH1 0x01` feeding the address slot immediately before the `GAS`/`STATICCALL` pair (i.e. none calls the ecrecover precompile)
- no ecrecover(...) call appears anywhere in the heimdall-decompiled Solidity either
- function surface (nonce/pause or stake/mint-count tracking) does not match the mint-voucher idiom of the template at all

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

n/a

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
