---
id: 072aaea0-fixed-signer
title: "0x072aaea0 (tagged deployed by Pimlico: ERC-4337 Bundler 405): signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x072aaea048994c6124a1cc9f23e27e72adbb3ba0"
  family: "a0da3964db19cc2c501117607b487834"
  label: "deployed by Pimlico: ERC-4337 Bundler 405"
  upgradeable: "no"
  rating: HIGH
  txs_90d: 7
  last_active: 2026-11-16
  recoveries_14d: 6
fix:
  layer: account-migration
  who_acts: "account owner"
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
  rating: HIGH
  note: "A wallet whose fixed owner key is the only way to move its funds; moving out before the key migrates is a migration step, not a way out: HIGH, as for the other fixed-owner wallets."
---

## Summary

ERC-4337 trading account (V4 unlockCallback, sweep, withdraw): validateUserOp accepts only an ecrecover equal to the constant 0x208d1e45…438e, and every fund-moving function requires msg.sender==EntryPoint v0.8. If that key takes real code, nothing moves the account's assets, including its ~0.0002 ETH EntryPoint deposit.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: account whose signer is a constant in the code. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Simulation: sweep and execute(0x0565bb67) succeed from EntryPoint 0x4337084d…f108 and revert 0x9a8b812a from signer 0x208d1e45…438e (cast call --from).
- Signer 0x208d1e45…438e has no code; recent userOps recovered it (txs.json).
- Balance 0 ETH and 0 WETH, no ERC-20 inflows in 200k blocks; EntryPoint v0.8 deposit ~1.75-2.09e14 wei (cast).

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 7 transactions called it in the 90 days before that block; last on 2026-11-16.
- 6 signature recoveries in the study's two-week trace window.

## Remediation

The owner empties the account before the key takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
