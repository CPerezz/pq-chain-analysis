---
id: dcfd18e6-signer-upgrade-only
title: "0xdcfd18e6: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xdcfd18e6e32e9e85c9fdf2cd3587b212061aa90a"
  family: "214cc1d86462ac16b0a38c9d6e7dfc89"
  upgradeable: "yes"
  admin: "ProxyAdmin 0xf65071a0… owned by EOA 0xeeB0030f… (nonce 75)"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "EOA 0xeeB0030f… via ProxyAdmin 0xf65071a0…"
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
  note: "Live admin: LOW."
---

## Summary

Implementation behind live transparent proxy 0x10fc9e6e… (EIP-712 signed transfers with setTransferHandler/setTokenAllowed). The proxy's admin is a ProxyAdmin owned by a live EOA.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (proxy). Rule: stored-key (by upgrade). Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Proxy 0x10fc9e6e… EIP-1967 impl = 0xdcfd18e6, admin = 0xf65071a0… at 26438999 (dossier state and cast storage, same at latest)
- ProxyAdmin owner() = 0xeeB0030f133166Cf4c586c0fa0913451CdD2f18a: no code, nonce 75; proxy owner() is the same EOA

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Upgrade the proxy to an implementation with a new signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
