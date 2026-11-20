---
id: e286d80a-signed-shortcut-lost
title: "0xe286d80a: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xe286d80af5ae89efc8c8d325ea5e724a4cb8a6ab"
  family: "57d514518da1ba47e908a78700e65cdf"
  upgradeable: "no"
  rating: LOW
  txs_90d: 0
fix:
  layer: offchain
  who_acts: "users swap directly"
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
  note: "Intent settlement for user-signed intents: a user whose account has code loses only the solver route and swaps directly: LOW."
---

## Summary

Not a Gemini custodian. Intent settlement: a solver registered in solverRegistry submits a user-signed intent (expiry, chainid, per-user nonces), and the contract swaps via the aggregator ('Output below minimum'). Stored addresses are owner, aggregator (setAggregator, owner-only), solverRegistry and fee recipient (owner-only). None is a signing key; the signature belongs to the intent's user, so EIP-8151 only removes this signed path for users whose address has code.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Gemini custodian completeUnlock: the caller must be a signer and two more signers of the custodian's fixed set must have signed / Gemini enableSweep: marks for sweeping the…. Same code idiom as template 59db0469, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- decompile: setAggregator and fee/recipient setter require msg.sender == owner; owner()=0x3684b81d...0a52
- 3483f35f requires solverRegistry.isSolver(msg.sender), block.timestamp <= deadline, chainid match; nonces(address)/getNonce(address) per-user mapping
- ecrecover helper reverts 'INVALID_SIGNATURE' on a zero address; no 1271 fallback; balance 0, no proxy

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None needed on-chain; users whose address has code trade directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: the review found that root issue `eip-8151-signed-shortcut-lost` applies, not `eip-8151-fixed-signer`; filed under it.
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
