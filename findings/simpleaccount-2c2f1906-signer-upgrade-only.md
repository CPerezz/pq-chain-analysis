---
id: simpleaccount-2c2f1906-signer-upgrade-only
title: "SimpleAccount: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x2c2f1906886acc06fe4efac89169bc216315457d"
  family: "64d06ec8096a703f7c70ce05b6c2e02b"
  copies: 3774
  name: "SimpleAccount"
  upgradeable: "yes"
  admin: "0x1a2fdcd2ea83d97e8cc0612ed4277df98f58f95b"
  rating: LOW
  value_usd: 8574
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 6867
  last_active: 2026-11-17
  recoveries_14d: 524
fix:
  layer: account-migration
  who_acts: "EOA owner 0xa3e2240f…"
evidence:
  level: executed
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signer-upgrade-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "A live owner EOA with a same-act direct-call path: LOW."
---

## Summary

SimpleAccount (ERC-4337): user operations need the owner's ECDSA signature with no setter, but execute() also accepts a direct call from the owner and the owner can upgrade the account's code.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: SimpleAccount: user operations need the owner's ECDSA signature and the owner has no setter; execute also accepts a direct call from the owner (read), and the owner may upgrade the code. Read (same text as a family read). Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: proxy to 0x68641de71cfea5a5d0d29712449ee254bb1400c2 with UPGRADE_INTERFACE_VERSION(), owner 0x1a2fdcd2ea83d97e8cc0612ed4277df98f58f95b.
- owner() on the proxy at 26438999 = 0xa3e2240fce3029e691471c785e06ed6e1ad52955 (no EIP-1967 admin slot set; UUPS owner-gated)
- that owner has no code at 26438999 (nonce 0, meaning it has never itself sent a tx, which does not mean the key does not exist)

## Impact and exposure

- Value held at block 26,438,999: $8,574 (ETH and 49 priced tokens, over 3,774 addresses).
- Activity: 6,867 transactions called it in the 90 days before that block; last on 2026-11-17.
- 524 signature recoveries in the study's two-week trace window.

## Remediation

Owner calls execute() directly or upgrades.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
