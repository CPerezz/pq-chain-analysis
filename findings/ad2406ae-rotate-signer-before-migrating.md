---
id: ad2406ae-rotate-signer-before-migrating
title: "0xad2406ae: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xad2406ae4eadca4176c8d72a5bc6c70351b741a2"
  family: "ca4939cf9b90ecbd76ec15b49a77ae81"
  copies: 123
  upgradeable: "no"
  rating: LOW
  value_usd: 48543
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "pool manager at slot 0x16 (0x8ad364b5, EOA)"
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
  note: "Setter exists and its gate is a live EOA; nothing is locked (withdrawals are signature-free)."
---

## Summary

Pool wrapper that delegatecalls library 0x18d13dc2 (b26359b4 family): signed deposits (when a flag is on) and the admin call need an ECDSA signature from the operator stored at slot 0x14. If the operator gets code, those paths revert; withdrawals need no signature.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a version of the b26359b4 wallets (123 addresses, 26.9 ETH); same verdict by structure. Bytecode and names.
- Library reading (b26359b4 dossier): recovery is compared with the signer at self+0x14, no ERC-1271; withdrawals 0xf522fc1b/0xf64e7cda use msg.sender only; body 0x61d67ca5 writes signer and flag
- Wrapper decompile (s2/0xad24…): 0x5295dfe6 → library 0x61d67ca5, gated by require(slot 0x16 == msg.sender)
- At block 26438999: slot 0x14 (operator) = 0, so the signed paths already revert; slot 0x16 = 0x8ad364b5754b0b691a8cee22f4df91ee16ee1c28, a contract-free EOA with nonce 123

## Impact and exposure

- Value held at block 26,438,999: $48,543 (ETH and 49 priced tokens, over 123 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Manager sets a new operator or turns the deposit flag off via 0x5295dfe6; withdrawals stay open.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
