---
id: 1932c038-fixed-signer
title: "0x1932c038: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x1932c038eadbc883a885ffadc8adb8d2dfccd49f"
  family: "7d86a3786c41961150fbd561d0e77f26"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "deployer/owner (bid-fill liveness only)"
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
  note: "Signed bid/offer fills stop (liveness), but owner-only rescueTokens/rescueTokensFromExecutioner recover any stuck balance regardless, so nothing is locked."
---

## Summary

A bid/offer escrow contract (`isBricked`, `permit2`, `vault`/`executioner` constants) whose offer-fill path is gated by an EIP-712 signature; EIP-8151 stops new signed fills once the signing key's address gets code. `rescueTokens`/`rescueTokensFromExecutioner` are plain owner-only functions, not signature-gated.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: launchpad mint: the signer must be SIGNER, fixed in the code. Same code idiom as template 09e5c621, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- stack-traced disassembly confirms a STATICCALL with gas forwarded to address 1 (ecrecover precompile) inside one of the contract's Unresolved_* functions
- `rescueTokens(address,address,uint256)` and `rescueTokensFromExecutioner(address,address,uint256)` both gate only on `require(msg.sender == owner)` (source: decompiled.sol) — no ecrecover involved in the rescue path itself
- facts.setters = [transferOwnership] only; facts.upgrades = [] -> no way to rotate the bid-authorization signer
- facts.exits = ['cancelOrder(uint256)', 'permitWitnessTransferFrom(((address,uint256)[],uint256,uint256),(address,uint256)[],address,bytes32,string,bytes)', 'rescueTokens(address,address,uint256)', 'transfer(address,uint256)', 'transferOwnership(address)']: rescueTokens present -> owner can pull tokens out independent of whether the signed bid-fill path still works

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

No on-chain fix for the hardcoded signer; redeploy with a replaceable signer, or rescue remaining tokens before EIP-8151 activates.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
