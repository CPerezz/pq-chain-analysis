---
id: simpleaccount-8abb1336-signer-upgrade-only
title: "SimpleAccount: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x8abb13360b87be5eeb1b98647a016add927a136c"
  family: "c43fd5ca18cb64065bcadf7c2d1c4bf4"
  copies: 4
  name: "SimpleAccount"
  label: "deployed by Pimlico: ERC-4337 Bundler 2"
  upgradeable: "yes"
  admin: "the account's owner EOA 0x27a007d1317310d56546eC20726D59522d86B53c"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "the account owner (EOA)"
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
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Live EOA owner with an UUPS upgrade function — LOW, correcting the row's 'owner() is zero or absent' (that read the implementation, not the proxy)."
---

## Summary

SimpleAccount (ERC-4337) behind a UUPS proxy; owner is a plain EOA with real code = 0x, so it can call upgradeTo/upgradeToAndCall itself once its own signature path breaks (it isn't disqualified by having zero outgoing txs — ERC-4337 owners sign UserOps, they don't need to send transactions directly).

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: SimpleAccount: user operations need the owner's ECDSA signature and the owner has no setter; execute also accepts a direct call from the owner (read), and the owner may upgrade the code. Read (same text as a family read). Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: upgradeTo(address), but owner() is zero or absent. 4 with an upgrade function whose caller was not read.
- node, block 26438999: proxy 0xe9a02ce2319bbc263baab66f8f6b74305cf42777, owner() = 0x27a007d1317310d56546eC20726D59522d86B53c, code at that address = 0x (EOA), nonce = 0
- batch facts: upgrades=[upgradeTo(address), upgradeToAndCall(address,bytes), ...], owner() getter on implementation = 0 (only the uninitialized implementation itself)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner calls upgradeTo to a fixed implementation once reachable.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
