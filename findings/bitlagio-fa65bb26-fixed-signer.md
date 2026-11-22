---
id: bitlagio-fa65bb26-fixed-signer
title: "Bitlagio: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec"
  family: "e7a57a7c320f42aa7060e39b5262b4c7"
  name: "Bitlagio"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 4782
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "owner 0x9a9236da… (EOA)"
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
  note: "No update path; the game's bankroll and pending bets leave only at the owner's discretion (operator's money path). Players' pending stakes depend on the owner refunding."
---

## Summary

Bitlagio: Oraclize random-DS proofs are checked through safer_ecrecover against keys chained to the constant LEDGERKEY. With the 3,000-gas call every recovery fails from activation (the PQ-14 row covers that), so outcomes never settle; the owner can still sweep the pot.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Oraclize verifySig: the recovered address must be the address of the public key carried in the proof; the result flag of the precompile is ignored / Oraclize safer_ecrecover: a constant 3,000 gas to…. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source: LEDGERKEY constant (hex 7fb95646…); safer_ecrecover uses call(3000, 1, ...) (Bitlagio.sol:995; same Oraclize library in GAME.sol)
- Owner exit with no signature: withdrawFromPot(uint) onlyOwner; owner 0x9a9236dabd08652c140e8931849c79f9c4d78607 cast code 0x
- No setter for the proof keys; no EIP-1967 slot

## Impact and exposure

- Value held at block 26,438,999: $4,782 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner sweeps the pot and refunds or settles players off-chain; a new deployment is needed to keep running.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
