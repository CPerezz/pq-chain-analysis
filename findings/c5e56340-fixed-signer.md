---
id: c5e56340-fixed-signer
title: "0xc5e56340: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc5e56340595360d8fe105c52c6a2bc192e6a39d8"
  family: "f084038978ef6d6615ab7001292f374d"
  copies: 4
  upgradeable: "no"
  rating: LOW
  value_usd: 16
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 142
  last_active: 2026-11-17
  recoveries_14d: 83
fix:
  layer: none
  who_acts: "OWNER 0xc8ea…38d1"
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
  rating: LOW
  note: "The SAME act (authorizing an order) stays open to the owner by direct call, and funds leave by owner sweep, so LOW."
---

## Summary

DepegHookHelperV3's isValidSignature (for CoW settlement) accepts a digest if approvedDigest[digest] is set, or an ECDSA signature from the constant OWNER. With code at OWNER the ECDSA branch fails, but OWNER can still approve digests by direct call to setApprovedDigest. sweep/sweepETH are owner direct calls.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: ERC-1271 contract answering for a signer that is a constant in its code. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- heimdall: isValidSignature returns 0x1626ba7e if storage_map_b[digest] is set; otherwise it compares the recovered signer to the hard-coded 0xc8ea…38d1.
- setApprovedDigest(bytes32,bool), setAllowedTarget, sweep(address,address) and sweepETH require msg.sender == 0xc8ea…38d1.
- OWNER is an EOA (nonce 143, no code); the contract holds 0 ETH.

## Impact and exposure

- Value held at block 26,438,999: $16 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 142 transactions called it in the 90 days before that block; last on 2026-11-17.
- 83 signature recoveries in the study's two-week trace window.

## Remediation

OWNER pre-approves order digests with setApprovedDigest instead of signing.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
