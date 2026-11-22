---
id: d056f1d4-wallets-fixed-signers
title: "0xd056f1d4: wallet with signers fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xd056f1d470ba5ddc9d2c1a14a4c2e7bb2bd5e45f"
  family: "ec3d3092516d904a0866847c925cdc71"
  copies: 69
  upgradeable: "no"
  rating: LOW
  value_usd: 219
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 175
  last_active: 2026-11-17
  recoveries_14d: 80
fix:
  layer: onchain-config
  who_acts: "the client key holder together with the enclave (rotation call fd189e10)"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-wallets-fixed-signers"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "LOW because a signature-gated setter replaces the client key. Not a way out without signatures: every spend path, the heir takeover included, needs ecrecover. Attention: the enclave (slot0) and heir are fixed for good; if the enclave address ever got real code, all paths except the inactivity escape (disabled here, period 0) would die."
---

## Summary

TEE-assisted wallet clone (52-byte proxy to the fixed impl 0xae1b7dc3…). Spending needs client and enclave ECDSA signatures, but the client key can be replaced by a client+enclave-signed call, so the user can rotate before migrating. The heir path still needs heir and enclave signatures, so it is no signature-free way out.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: TEE-assisted wallets (69; 80 recoveries): client and enclave keys sign; inferred from names: an heir takes over after inactivity (lastSpend); no key setter by name. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: delegates to a fixed address.
- Impl bytecode (unverified, read by hand): execute 865cc004 = client(slot3)+enclave(slot0) recover; c0c3a6b4 = heir(slot1)+enclave recover; 5706a032 = client-only after lastSpend+period (period = slot1>>160); b2d12675 = client-only in solo mode (slot1 bit 224); fd189e10 writes slot3 = new client after client+enclave signatures and bumps the nonce; slot0/slot1 are written only by the one-shot init c8c149c3
- isValidSignature: plain ecrecover against client (and enclave), no code check, no 1271 forwarding
- Clone storage (latest, block ~26452917): enclave 0x58d07d5d…, heir 0x334e1037…, period 0 and solo flag false (inactivity escape and solo mode off), client 0xfa3ef58f…, nonce 95; all three EOAs
- value_usd 219, txs_90d 175, last_active 2026-11-17 (row)

## Impact and exposure

- Value held at block 26,438,999: $219 (ETH and 49 priced tokens, over 69 addresses).
- Activity: 175 transactions called it in the 90 days before that block; last on 2026-11-17.
- 80 signature recoveries in the study's two-week trace window.

## Remediation

Before the client account gets real code, call fd189e10 with client+enclave signatures to rotate the client to a key that stays an EOA, or move the funds out.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
