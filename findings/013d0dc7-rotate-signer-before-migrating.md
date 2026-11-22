---
id: 013d0dc7-rotate-signer-before-migrating
title: "0x013d0dc7: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x013d0dc75808d097b00a1ce8dc6d464fb7c7746e"
  family: "aac6704277f4e5cb25362c96bf6bd3ac"
  copies: 2
  upgradeable: "yes"
  rating: LOW
  value_usd: 2142554
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 11066
  last_active: 2026-11-18
  recoveries_14d: 11314
fix:
  layer: onchain-config
  who_acts: "vault owner (EOA 0x4cC434aB)"
evidence:
  level: executed
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
  note: "LOW: live EOA owner on the proxy. The row address itself is a bare implementation."
---

## Summary

Unverified UUPS TradingVault. ERC-1271 answers for an owner-managed ECDSA signer allowlist; a signer with code gets 0xffffffff.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (upgradeToAndCall). Rule: stored-key (by upgrade). Executed: a real transaction reverts with code at the signer. Rated by hand: setTrader replaces the signer.
- reading aac67042: the owner sets signers via 0x7ef59d01; a signer can remove itself (0x4ea870aa)
- the row address is the implementation (owner() = 0, no proxy slot); proxy 0xb5378cf5 has impl = this address and owner() = 0x4cC434aB (EOA, nonce 13)

## Impact and exposure

- Value held at block 26,438,999: $2.1M (ETH and 49 priced tokens, over 2 addresses).
- Activity: 11,066 transactions called it in the 90 days before that block; last on 2026-11-18.
- 11,314 signature recoveries in the study's two-week trace window.

## Remediation

The owner replaces the signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
