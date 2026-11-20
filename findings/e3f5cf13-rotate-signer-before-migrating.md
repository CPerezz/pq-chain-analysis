---
id: e3f5cf13-rotate-signer-before-migrating
title: "0xe3f5cf13: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe3f5cf1313dfe3c2827604a187677c34c7ed9aa1"
  family: "6b72c0660b06d99c1a760570d5dde0fd"
  upgradeable: "no"
  rating: LOW
  value_usd: 44031
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 403
  last_active: 2026-11-17
  recoveries_14d: 10
fix:
  layer: onchain-config
  who_acts: "RBAC admin 0x63730113 (EOA)"
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
  note: "The checked key is in a list that a live EOA admin edits. The link from the recovery to isAdmin is inferred from the decompile plus the recovered address, not read from source."
---

## Summary

Trading-vault contract: signed transfers recover the key 0x262f0bfb, an admin in the RBAC contract 0x734ec6a0 (admin()). If that key gets code, signed transfers revert; user withdraw (0xf3fef3a3) uses msg.sender balance.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a transfer signer under a manager with a setter. Bytecode and names.
- txs.json: recovered key 0x262f0bfbc20ffbb1df9511015e887078419e4c7c; isAdmin on 0x734ec6a0 true, isManager/isHandler false
- RBAC 0x734ec6a0 decompile: addAdmin/removeAdmin callable by any admin; getAllAdmins = [0x63730113…, 0x262f0bfb…]
- 0x63730113Bd32B7F9A34157BF8b70f066B3D4D2c6: no code, nonce 50; manager/handler setters on the vault are also admin-gated

## Impact and exposure

- Value held at block 26,438,999: $44,031 (ETH and 49 priced tokens).
- Activity: 403 transactions called it in the 90 days before that block; last on 2026-11-17.
- 10 signature recoveries in the study's two-week trace window.

## Remediation

Admin 0x6373 adds a new EOA admin/signer and removes the old key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
