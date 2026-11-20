---
id: e00d101d-fixed-signer
title: "0xe00d101d: signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xe00d101d869348ffeed8519838e015e82f7e16b6"
  family: "afacaa6c950160d93c40dd3a29b859a0"
  upgradeable: "no"
  rating: NONE
  value_usd: 6
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 7
  last_active: 2026-11-05
  recoveries_14d: 3
fix:
  layer: none
  who_acts: "none"
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
  note: "The code checks for code first and then uses ERC-1271 on the signer, which is a refute condition."
---

## Summary

The ERC-1271 handler checks whether its owner 0x7190…b37c has code before recovering. If the owner has code, it forwards isValidSignature to the owner instead of calling ecrecover, so a migrated owner keeps answering.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: ERC-1271 contract answering for a signer that is a constant in its code. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- heimdall decompile of 0x1626ba7e: `if (!address(0x7190…b37c).code.length) { ecrecover… } else { staticcall owner.isValidSignature }`
- withdraw, withdrawNative and the token approve/transfer functions are gated by msg.sender == 0x7190…b37c, so no signature is needed to move funds
- cast code 0x71901a9a…b37c at block 26438999 = 0x (an EOA today)

## Impact and exposure

- Value held at block 26,438,999: $6 (ETH and 49 priced tokens).
- Activity: 7 transactions called it in the 90 days before that block; last on 2026-11-05.
- 3 signature recoveries in the study's two-week trace window.

## Remediation

none

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
