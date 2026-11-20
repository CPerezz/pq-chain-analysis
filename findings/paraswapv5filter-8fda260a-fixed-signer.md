---
id: paraswapv5filter-8fda260a-fixed-signer
title: "ParaswapV5Filter: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x8fda260a177b9b5cb405745957a3ab6736795de9"
  family: "46ba5735ffda4abe39a46619c6bc2884"
  copies: 2
  name: "ParaswapV5Filter"
  upgradeable: "no"
  rating: LOW
  txs_90d: 113
  last_active: 2026-11-10
  recoveries_14d: 6
fix:
  layer: onchain-config
  who_acts: "Argent (DappRegistry owner)"
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
  rating: LOW
  note: "Rated LOW: an auxiliary path that is not needed; funds leave by other wallet paths. [INFERENCE] The DappRegistry owner can swap the filter; this was not checked onchain."
---

## Summary

The Argent ParaswapV5Filter checks swap calldata against the immutable masterSigner 0x297a…7346, an EOA that cannot be replaced. If that key gets code, the filter rejects all Paraswap calls from Argent wallets. Wallet owners still move their funds by other paths, and the filter is only a registry entry.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Argent Paraswap filter: the signature must come from the account its caller passes, a Paraswap authority fixed in the code. Read from source. Executed: a real transaction loses its effect with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source ParaswapV5Filter.sol: masterSigner is immutable, set in the constructor, and there is no setter
- Runtime code: the immutable 0x297a5131…7346 has no code at block 26438999
- isValid is view; it only allows or denies one dapp call

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 113 transactions called it in the 90 days before that block; last on 2026-11-10.
- 6 signature recoveries in the study's two-week trace window.

## Remediation

Argent registers a new filter with a new signer in its DappRegistry.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
