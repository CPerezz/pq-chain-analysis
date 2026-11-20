---
id: 6ae289f4-signed-shortcut-lost
title: "0x6ae289f4 (tagged deployed by Inverse USD: Deployer): signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x6ae289f469292fce7fedda74c6d411d4527fa239"
  family: "d2d6a0ae36a6b0944b4fefa1a3e4f77f"
  label: "deployed by Inverse USD: Deployer"
  upgradeable: "no"
  rating: LOW
  value_usd: 41685
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 92
  last_active: 2026-11-17
fix:
  layer: offchain
  who_acts: "the holder"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Signed shortcut whose act stays open by a direct call for the same party → LOW. value $41685, txs_90d 92."
---

## Summary

deployed by Inverse USD: Deployer: token bytecode with a permit; under EIP-8151 a holder whose address has code can no longer use permit.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Curve Twocrypto pool LP token permit: assert ecrecover(digest) == _owner, no ERC-1271; an owner with code approves directly instead. Read by hand.
- deployed by Inverse USD: Deployer: bytecode carries both permit selector 0xd505accf and approve selector 0x095ea7b3 (dossier code.hex)
- No verified source; study classed it permit-like by bytecode and names
- approve is called by the holder itself, same party as permit

## Impact and exposure

- Value held at block 26,438,999: $41,685 (ETH and 49 priced tokens).
- Activity: 92 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

The holder calls approve itself.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
