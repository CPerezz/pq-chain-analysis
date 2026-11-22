---
id: 3d97a339-fixed-signer
title: "0x3d97a339: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x3d97a339c8d51edcc3e046c97fcca534212455e5"
  family: "d192121c0211f50fadedf4017c95be27"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 72
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The owner redeploys with a new signer. ETH already held can still be withdrawn with withdrawMintPayments."
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
  note: "The heimdall decompilation does not show the ecrecover call or say which of the two constants is the signer. Both are EOAs, so the verdict holds either way. The study note calls this a presale, but the code is an ERC721 mint."
---

## Summary

The signer is hardcoded in the bytecode and has no setter. Both candidate addresses are EOAs today. If the signer account gets real code, only new signed mints stop. The ETH held stays withdrawable by the owner, so nothing is locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- constants 0x08760dfe…64ea and 0xb4850bec…deb5 have code_bytes 0 and are not delegated
- the only setter is transferOwnership(address), which writes store_g (slot 7, the owner)
- withdrawMintPayments(): require(owner==msg.sender); transfer(address(this).balance)
- upgradeable: no; no proxy slot

## Impact and exposure

- Value held at block 26,438,999: $72 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new contract with a settable signer, or accept ERC-1271 signatures for the signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
