---
id: b59ffa67-rotate-signer-before-migrating
title: "0xb59ffa67: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb59ffa679380b65bc2c1fdf690db7aa214c884bf"
  family: "cb2d74565688c402b02ffeac19d8170d"
  copies: 2345
  upgradeable: "no"
  rating: LOW
  value_usd: 73446
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "controller key holder 0x1297…3bf5"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Setter callable by the key holder itself (direct call, no signature)."
---

## Summary

Unverified relay/forwarder contract (one of 2,345): execute (0x10bfce71) needs an ecrecover signature from the stored controller. If the controller takes code, relayed transactions stop.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: 2,345 relay contracts: the signer named must be the stored controller, which setController replaces. Bytecode and names.
- heimdall decompile (s1/cb2d74): setController(address) succeeds only when msg.sender == controller, with no signature
- controller() = 0x1297d245…3bf5, EOA with nonce 0 (the key holder itself is the live party)
- simulated setController(0x…dEaD) from the controller at block 26438999 emits SetControllerSuccess

## Impact and exposure

- Value held at block 26,438,999: $73,446 (ETH and 49 priced tokens, over 2,345 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Controller calls setController to a new EOA before migrating; a controller that already holds code can still call it directly via msg.sender.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
