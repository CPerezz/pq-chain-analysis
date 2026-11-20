---
id: priceoracle-822b4c47-fixed-signer
title: "PriceOracle: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x822b4c4713433c6b88547845850a39343bf0957e"
  family: "5db5a4f7831546afa05994a342922e22"
  name: "PriceOracle"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Caviar (new oracle)"
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
  note: "View-only price oracle with an immutable signer and nothing locked: MEDIUM."
---

## Summary

Caviar/Reservoir PriceOracle: price messages must be signed by the Reservoir oracle address, which is fixed in this code. If that key takes code, the price checks fail. The contract holds no funds.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Caviar pair: the price message must be signed by the Reservoir oracle address (text cut; fixed in the oracle contract by design). Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source: ReservoirOracle._verifyMessage uses ecrecover == immutable RESERVOIR_ORACLE_ADDRESS; no setter
- immutable read from the code: 0x32da57e736e05f75aa4fae2e9be60fd904492726
- that signer has a 7702 delegation (0xef0100…, latest, block ~26453088): still accepted under EIP-8151, but it would stop if the account took real code
- facts: 1338 bytes, no proxy slots, balance 0 at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new oracle.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
