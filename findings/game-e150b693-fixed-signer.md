---
id: game-e150b693-fixed-signer
title: "GAME: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe150b693404a433b1c822c113f3fa84fe8e2c255"
  family: "f64ec9dc7ee4a1b1d99cb88f1a3f38d9"
  copies: 19
  name: "GAME"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 4621
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "owner 0x4468bab1… (EOA)"
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

GAME raffle: Oraclize random-DS proofs are checked through safer_ecrecover against keys chained to the constant LEDGERKEY. With the 3,000-gas call every recovery fails from activation (the PQ-14 row covers that), so outcomes never settle; the owner can still sweep the pot.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Oraclize verifySig (variant): the recovered address must be the address of the public key carried in the proof; the result flag is ignored / Oraclize safer_ecrecover: a constant 3,000 gas to the…. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source: LEDGERKEY constant (hex 7fb95646…); safer_ecrecover uses call(3000, 1, ...) (Bitlagio.sol:995; same Oraclize library in GAME.sol)
- Owner exit with no signature: takeAll() onlyOwner; owner 0x4468bab1b1d16ee3b9610f7e16eb25af80f85a39 cast code 0x
- No setter for the proof keys; no EIP-1967 slot

## Impact and exposure

- Value held at block 26,438,999: $4,621 (ETH and 49 priced tokens, over 19 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner sweeps the pot and refunds or settles players off-chain; a new deployment is needed to keep running.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
