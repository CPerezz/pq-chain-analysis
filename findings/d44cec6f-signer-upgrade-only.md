---
id: d44cec6f-signer-upgrade-only
title: "0xd44cec6f: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd44cec6ff5f85af999d1f56cce63031b07c8f0e1"
  family: "4cfc37473334b9bc94e3c88a682101ba"
  copies: 2
  upgradeable: "no"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "owner 0x870dc16249b860af63d671e02966b82ff44ac0a6"
evidence:
  level: bytecode
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
  note: "The only missing fact was whether the controlling party is live: its owner 0x870dc16249b860af63d671e02966b82ff44ac0a6 is a plain account with an EIP-7702 delegation (nonce 84), read at the latest block (26,455,6xx; the node was down). Live by Anon's rule of 2026-11-20 (a key is presumed live unless shown lost), so it can rotate the signer or upgrade the code: LOW. Earlier doubt: Missing read: cast nonce/code of owner 0x870dc16249b860af63d671e02966b82ff44ac0a6 at block 26438999 (reth timed out twice). If live (latest shows nonce 84, 7702-delegated), propose LOW via upgrade(uint16,address)."
---

## Summary

Wormhole ICCO TokenSaleContributor behind an EIP-1967 proxy (impl 0xd7b9d445...); contribute() checks ecrecover against the sale's authority, and the implementation's upgrade(uint16,address) is callable by a live owner.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: stored-key (by upgrade): the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgrade). Placed by a rule; copy of template ad8cefc3, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- EIP-1967 implementation slot = 0xd7b9d44592ebe64337ae55eb395a8232aaecb649 at 26438999 (batch said 'no proxy slot')
- decompile of impl: upgrade(uint16,address) requires msg.sender == owner (slot 4) and the chain id, then writes the 1967 slot
- owner() = 0x870dc16249b860af63d671e02966b82ff44ac0a6 at 26438999 (node); liveness read only at latest via publicnode (nonce 84, code 0xef0100...), not usable for settable state

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner upgrades the contributor to code that accepts a new authority or ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
