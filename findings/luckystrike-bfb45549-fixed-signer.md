---
id: luckystrike-bfb45549-fixed-signer
title: "LuckyStrike: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xbfb45549e5630e1f4e6bb4d3f7132563100e08c9"
  family: "1ab8a524d80fff349ff9eb286a2362cb"
  copies: 2
  name: "LuckyStrike"
  upgradeable: "no"
  rating: HIGH
  value_usd: 2070
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "none possible"
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
  rating: HIGH
  note: "HIGH: no update path, and the jackpot pools are locked. The decisive cause is the fixed 3,000 gas (eip-8151-fixed-gas-recovery), not the fixed signer: the signers are Ledger device keys that cannot realistically take code."
---

## Summary

LuckyStrike lottery: jackpot draws need an Oraclize Ledger proof checked with safer_ecrecover, which forwards a fixed 3,000 gas. From activation, every valid recovery fails and no jackpot can be drawn. The jackpot sums have no other exit, and the Ledger root key is a constant.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Oraclize verifySig: the recovered address must be the address of the public key carried in the proof; the result flag of the precompile is ignored / Oraclize safer_ecrecover: a constant 3,000 gas to…. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- LuckyStrike.sol:1326 call(3000, 1, …); :1189 LEDGERKEY constant
- Only the success branch of __callback assigns a jackpot winner; no owner or timeout path for sum[1..4] (reading.first.json other_paths)
- Row code = the verified 0x0f09c13a… (same code hash); balance 1.1472 ETH; no proxy

## Impact and exposure

- Value held at block 26,438,999: $2,070 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None in-place; the contract cannot be changed. Instant-game paths and already-won jackpots still pay directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
