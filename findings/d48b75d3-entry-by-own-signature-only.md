---
id: d48b75d3-entry-by-own-signature-only
title: "0xd48b75d3: entry only by one's own signature"
status: confirmed
severity: LOW
patterns: [PQ-21]
impact: liveness
contracts:
- address: "0xd48b75d37ae027b088c6dce985c5010a1e197216"
  family: "f148a5c00a57c6c500f2b63b61778dff"
  copies: 12
  upgradeable: "no"
  rating: LOW
  txs_90d: 39605
  last_active: 2026-11-09
  recoveries_14d: 1
fix:
  layer: account-migration
  who_acts: "claimants claim before their key's account takes real code, or keep a 7702 delegation"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-entry-by-own-signature-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Claiming needs the claimant's own signature and there is no other claim path, so a claimant whose account takes real code cannot claim; claiming first or keeping a 7702 delegation avoids it: LOW."
---

## Summary

Unverified airdrop/claim contract (Merkle root, claimFor with the user's signature, fees, endAirdrop). A claimant with real code can't sign, so its allocation can't be claimed.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: claims signed by the user named. Bytecode and names.
- heimdall decompile: claim entry 0x15b9021b claimFor(address,bytes32[],uint256,(..),bytes32,bytes) builds an EIP-712 digest and recovers; no direct claim selector found (exits list only claimFor)
- txs.json: the claim tx 0xfe36848e... was sent by the claimant itself and still carried its signature (recovered == sender)
- endAirdrop(address) (owner store_b only) sweeps the remaining token balance to the owner's chosen address

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 12 addresses).
- Activity: 39,605 transactions called it in the 90 days before that block; last on 2026-11-09.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

Claimant claims before installing real code or keeps a 7702 delegation; otherwise the owner would have to distribute manually after endAirdrop.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
