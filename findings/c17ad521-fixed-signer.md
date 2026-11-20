---
id: c17ad521-fixed-signer
title: "0xc17ad521: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc17ad5217dc97c172889f3b27944f0aba163501f"
  family: "e622b9d764bee0d0f833eb101a0b19b7"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "deployer/owner (fee-authorization liveness only)"
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
  note: "Fee-authorization liveness only: owner can rescueERC20/rescueERC721 any asset that would otherwise be stuck, so nothing is permanently locked by this defect."
---

## Summary

A marketplace fee-split/escrow helper (`FEE_AUTHORIZATION_TYPEHASH`, `SEAPORT`/`PLATFORM`/`BID_CURRENCY` constants) that accepts a fee authorization only from a hardcoded `FEE_AUTHORIZER`; EIP-8151 stops fee-split authorization once that address gets code.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: launchpad mint: the signer must be SIGNER, fixed in the code. Same code idiom as template 09e5c621, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- decompile shows `uint256 public constant FEE_AUTHORIZER = 177878917680461542387627213444614497682243359619;` and `FEE_AUTHORIZATION_TYPEHASH`, consistent with an EIP-712 signature check against a fixed authorizer
- facts.exits includes rescueERC20(address,address,uint256) and rescueERC721(address,address,uint256) — an owner-reachable way out for stuck assets
- facts.setters = [transferOwnership] only; facts.upgrades = [] -> FEE_AUTHORIZER cannot be rotated

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

No on-chain fix; redeploy with a replaceable fee authorizer before EIP-8151 activates.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
