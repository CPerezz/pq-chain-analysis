---
id: c8ad2512-fixed-signer
title: "0xc8ad2512 (tagged deployed by Ethane.app: Relayer 1): signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xc8ad251244575bfbe7dad9475014d0e20d40cff1"
  family: "6a7335e92478c3538cb2a81d5984a749"
  copies: 239
  label: "deployed by Ethane.app: Relayer 1"
  upgradeable: "no"
  rating: HIGH
  value_usd: 784
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "holder of key 0xadc9…5bb5"
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
  note: "No update path. The owner's funds leave only on a fixed key's signature → HIGH. Key immutability is read from bytecode, not source."
---

## Summary

Minimal wallet: 0x29451959 delegatecalls the fixed implementation 0x938097d8…5d83, which checks an EIP-712 signature by the key packed in sigs[0] and then CALLs with value. The write to sigs[0] keeps the key and only increments the low 96-bit nonce, and there is no ERC-1271 path.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: 239 clones with two selectors and one stored key. Bytecode and names.
- Update path, read at block 26,438,999: delegates to a fixed address.
- clone code hard-codes delegatecall target 0x938097d831678e93f3a1608b74d08b5a434e5d83 (no proxy slot)
- sigs[0] (slot 0xad3228…ba5fb5) = 0xadc961647d940c4c49ac25c8aae3b026fa055bb5‖nonce 2; key code 0x today
- implementation disassembly: the only STATICCALL is ecrecover; at 0x583 the stored word is masked to keep the top 160 bits and the nonce is incremented; the other SSTORE marks a used signature
- balance 0.014 ETH now

## Impact and exposure

- Value held at block 26,438,999: $784 (ETH and 49 priced tokens, over 239 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The key holder sweeps funds while the key is an EOA.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
