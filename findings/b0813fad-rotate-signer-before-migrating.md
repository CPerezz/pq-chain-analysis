---
id: b0813fad-rotate-signer-before-migrating
title: "0xb0813fad: signer key to rotate before its account takes code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb0813fadbb418503fe6b23f410cf27572e74948b"
  family: "fd568f63de97a4b5e0aba1caf3c51028"
  copies: 152
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 55761
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "none: setter caller is the deploying factory, which has no forwarding function"
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
  rating: MEDIUM
  note: "LOW fails: the setter's only caller is a factory that cannot call it after creation. MEDIUM because only signed deposits and the admin call die and no ETH is locked behind the signature."
---

## Summary

PrimaBlock-style pool wrapper delegating to library 0xed0b1e03…5ff6: signed deposits (when the flag is on) and the admin call 0x148b9557 need an ecrecover signature from the stored signer at slot 0x14 (0xaa0afc85…8777, EOA nonce 223).

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: an earlier or later version of the b26359b4 wallets (152 addresses, 31 ETH); same verdict by structure. Bytecode and names.
- heimdall: wrapper 0x56e28135(address) requires msg.sender == slot 0x18 and delegatecalls library 0xa3fee64b, which writes the signer at slot 0x14 (the only writer)
- slot 0x18 = 0x97aff5d9…b7ee, a factory contract (nonce 152) whose only functions are two pool-creation entries (0x6b075547, 0xdcc6825e); 0x56e28135 appears only inside the embedded pool initcode
- simulated 0x56e28135 from the factory succeeds (emits 0xdaf47bd3); it reverts from anyone else, so no live party can rotate the signer
- library: withdrawals (f522fc1b, f64e7cda) use msg.sender only, and 0x148b9557 sends value 0, so ETH (12.5) does not leave through signed paths

## Impact and exposure

- Value held at block 26,438,999: $55,761 (ETH and 49 priced tokens, over 152 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None on-chain. The signer key must stay an EOA, or keep only a 7702 delegation. Contributors still withdraw directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
