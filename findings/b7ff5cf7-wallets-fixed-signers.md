---
id: b7ff5cf7-wallets-fixed-signers
title: "0xb7ff5cf7: wallet with signers fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb7ff5cf7bd9ac0b162ed34a54fd4235d32844742"
  family: "26cdcf7c240f4f985a647b27fd8831f4"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "IVT token operator"
evidence:
  level: source-read
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
  rating: MEDIUM
  note: "No funds by design and nothing locked here; only the signed change-approval dies, so MEDIUM. Whether the IVT proxy can switch to another permission contract was not checked."
---

## Summary

Not a wallet: IVTPermission (verified on Sourcify), a 2-of-3 approval contract. confirmChange ecrecovers signers from a mapping set only in the constructor, then calls back the calling proxy with a new address (an upgrade approval). It holds no funds; if the signers' keys gain code, that upgrade path dies.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: Ownbit multisig: `required` distinct owners must have signed with ECDSA; the caller does not count; no function changes the owners. Same code idiom as template 66d724c3, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Sourcify source: signers mapping and required written only in the constructor; the only runtime SSTORE is transactions[time]; verifySignatures uses raw ecrecover with no code check
- Constructor args (Sourcify): signers 0x4f562683…e237, 0x120a601a…8526, 0xb2ba8ab4…0dfa, required 2; signers(addr) true for all, required() = 2 (latest, block ~26452900)
- All three signers are EOAs (latest via publicnode, block ~26452900); no proxy slots, balance 0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new permission contract with replaceable signers and point the IVT proxy at it, if the proxy allows that, before the keys gain code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
