---
id: tunnelcontract-374368fb-rotate-signer-before-migrating
title: "TunnelContract: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x374368fbc18a0dd3c8044bcbe9cc76f718e56da8"
  family: "360854de617c4663d3b2c58a0842331c"
  copies: 9
  name: "TunnelContract"
  upgradeable: "yes"
  rating: LOW
  value_usd: 14978
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "executors (3 of 4) and admin EOA 0x0014Eb4A…"
evidence:
  level: source-read
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
  note: "Live rotation paths; the proxy is also upgradeable."
---

## Summary

Tunnel bridge: SigVerifier requires the named proposer or executor to have signed, against stored executor and proposer sets. A member with code fails.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Tunnel SigVerifier: reverts unless the proposer or executor its caller names signed; the caller counts them. Read from source.
- SigVerifier.sol:19: signer == ecrecover; Permissions.sol:182 updateExecutors is signed by the current executor threshold
- addProposer/removeProposer/transferAdmin are onlyAdmin
- getAdmin() 0x0014Eb4A…: EOA, nonce 882; getActiveExecutors: 4 executors, threshold 3

## Impact and exposure

- Value held at block 26,438,999: $14,978 (ETH and 49 priced tokens, over 9 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The executors sign updateExecutors to replace a migrating member (threshold 3 of 4). The admin swaps proposers.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
