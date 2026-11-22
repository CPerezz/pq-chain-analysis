---
id: 604f50ba-fixed-signer
title: "0x604f50ba: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x604f50ba6c704b2820890aa2063e7de400b0b434"
  family: "a87700140e8e1426cfbd7739da2aa8f6"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 2
  last_active: 2026-09-06
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
  note: "The presale window (timestamps 0x61cc31a0 to 0x61cc77f0, December 2021) has already closed, so the signed path can no longer succeed in any case. The rating reflects the mechanism only: signed minting of new tokens."
---

## Summary

The voucher presale mint checks the ecrecover result against the hardcoded address 0xfd98…fa83, which has no code today and cannot be replaced. If that key's account got real code, only the signed mint of new NFTs would stop. Nothing held would be locked: the owner can withdraw the ETH, and holders can still transfer their tokens.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Unresolved_3872843b: require(address(var_n) == 0xfd98fc120459ed7dfc17963a6c0179c2e50efa83, "invalid voucher")
- Verified facts: 0xfd98fc120459ed7dfc17963a6c0179c2e50efa83 is an EOA (no code)
- No function writes a signer; the only setter is transferOwnership, which writes the owner slot
- No code-length or ERC-1271 check on the signer

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 2 transactions called it in the 90 days before that block; last on 2026-09-06.

## Remediation

Keep the signer key as an EOA (or 7702-delegated), or deploy a new contract with a replaceable signer or ERC-1271 support.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
