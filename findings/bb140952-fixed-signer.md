---
id: bb140952-fixed-signer
title: "0xbb140952: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xbb14095284ba378d88817555c59d56b5553fee08"
  family: "8c4df15fd712fd83299946de0141a1f3"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 1342
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Whoever would submit a signed solution (a puzzle solver given a signature by SOLUTION_SIGNER)."
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
  note: "The study_note calls this a presale, but the code is a puzzle/bounty token. I rated it MEDIUM because buyer WETH stays reachable by selling into the pool. If the pool were drained or illiquid, refund() would be the only exit and holders' funds would lock, which would move it toward HIGH."
---

## Summary

The signer is a hardcoded constant and has no code today (EOA), and nothing in the contract can replace it. If that key's account ever gets real code, solution() can never succeed, so the bounty payout and the refund() path stop working. Holders can still sell their tokens into the live Uniswap pool, so no funds are locked; only the function stops.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- SOLUTION_SIGNER is a constant 0x51fB...87ae; the row facts give constants[].code_bytes=0, delegated=false
- solution(): require(ecrecover(...) == SOLUTION_SIGNER)
- There is no function that writes the signer; setOwner only changes info.owner
- refund(): require(isExpFinalized()); info.solved is set to true only in solution()

## Impact and exposure

- Value held at block 26,438,999: $1,342 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The code cannot change the signer, so the only fix is a new deployment whose signer can be rotated or that accepts ERC-1271 signatures. Until then, keep the SOLUTION_SIGNER account as an EOA or a 7702-delegated account only.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
