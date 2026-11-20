---
id: 3f776980-fixed-signer
title: "0x3f776980: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x3f7769805c2a54eb49ae41cf57f2864a24b4570a"
  family: "3ac8b0368ac7c04c780680b89088d98f"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The project/operator: keep 0x923a…ba30 free of real code (an EOA or a 7702 delegation still works), or deploy a new contract."
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
  note: "The signer address happens to equal the current owner() value, but the check compares against the bytecode constant, so changing ownership does not change the signer. The study note calls this a presale with signed deposit and claim, but the code shows signed trait updates on an NFT instead."
---

## Summary

The signer is a hardcoded constant, 0x923a9eae85e8c61083bd984285b72edf4113ba30, which is an EOA today. No function can replace it and there is no ERC-1271 or code check. If that key's account gets real code, holders can no longer customize their tokens (flip, reveal or update layers). Minting, ownership and withdraw keep working and no funds get locked, so only a feature stops.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- 0x7138f55b/0x4e58ef6c/0x37127fed/0x82bd57a0/0xc465d084: require(recovered == 0x923a9eae85e8c61083bd984285b72edf4113ba30, CustomError_8baa579f())
- Verified facts: 0x923a…ba30 is an EOA (no code) at block 26438999
- transferOwnership writes store_q (slot 1, owner) only; the signer comparison uses the literal, not storage
- withdraw (0x3ccfd60b): onlyOwner, transfers balance to store_r, no signature

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Keep the signer key as an EOA or use only a 7702 delegation for it; never deploy real code at that address. If real code is unavoidable, redeploy with a settable signer or ERC-1271 support.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
