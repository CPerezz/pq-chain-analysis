---
id: 535bea78-rotate-signer-before-migrating
title: "0x535bea78 (tagged deployed by Official Immortal Cat NFT: Deployer): signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x535bea78329785d7ebb307b1a2bc762197f4f764"
  family: "8bedb9aa7138122d83e63ca5d5c5e28c"
  label: "deployed by Official Immortal Cat NFT: Deployer"
  upgradeable: "no"
  rating: LOW
  value_usd: 1998
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "the owner sets a new verify address with serVerifyAddress"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "The signer is not fixed: serVerifyAddress (0xd15e90b6), callable by the live owner EOA, replaces it, so the key is rotated before it takes code: LOW under the rotation root issue."
---

## Summary

The token-sale signer is not fixed: verifyAddress (slot 1) is set by the owner-only serVerifyAddress(address) (selector 0xd15e90b6), and the owner EOA is live.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a token sale whose purchases need the server's signature (1.1 ETH). Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- heimdall: serVerifyAddress requires msg.sender == owner ('Ownable: caller is not the owner') and writes store_h (slot 1)
- verifyAddress() = owner() = 0x3a8F6808…D911 at 26438999, no code
- The selector is present in the deployed bytecode

## Impact and exposure

- Value held at block 26,438,999: $1,998 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner rotates verifyAddress before migrating the key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: the review found that root issue `eip-8151-rotate-signer-before-migrating` applies, not `eip-8151-fixed-signer`; filed under it.
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
