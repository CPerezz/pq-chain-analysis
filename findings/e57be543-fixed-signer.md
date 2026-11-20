---
id: e57be543-fixed-signer
title: "0xe57be543: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe57be543777aa70d75052c4ab7e8563f05eeec40"
  family: "091f0907c9ae420c42b6a3d17d7b794f"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 1
  last_active: 2026-08-26
fix:
  layer: new-deployment
  who_acts: "project owner (redeploy)"
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
  note: "Existing NFTs stay transferable; nothing gets locked."
---

## Summary

SIGNER is a constant EOA (code_bytes 0) with no setter and no 1271 check. If it gains code, mint stops; no funds are held, so only new minting stops.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- address private constant SIGNER = 0xAAa8...24A1
- mint(): recover(signature) == SIGNER
- constants[0].code_bytes=0, delegated=false
- mint forwards address(this).balance to _treasury

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-08-26.

## Remediation

Keep the signer key's account an EOA or 7702-delegated, or redeploy with a signer that can be changed or with ERC-1271 support.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
