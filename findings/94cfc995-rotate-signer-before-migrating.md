---
id: 94cfc995-rotate-signer-before-migrating
title: "0x94cfc995: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x94cfc9954948b7dddfb4af79e5df48b4379ff27d"
  family: "910c41c1d5fc720f765cd738254fe9a9"
  upgradeable: "yes"
  admin: "Hub owner EOA 0x599C59081d9B673BBDdAfbc933B669aA84eA3eE1 (repoints 'Holding' in Hub)"
  rating: LOW
  txs_90d: 3
  last_active: 2026-11-16
  recoveries_14d: 3
fix:
  layer: onchain-config
  who_acts: "the holder adds another key to its identity"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signature-rechecked"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Not a recheck: the expected signer is any key the holder's ERC-725 identity approves, and the holder can add one, so it rotates before the key takes code: LOW under the rotation root issue."
---

## Summary

OriginTrail Holding contract (createOffer/payOut/finalizeOffer 0x1f0a07df). finalizeOffer recovers each holder's confirmation signature, then requires the recovered wallet to hold purpose 4 (encryption) on the holder's ERC-725 identity. That key is replaceable by the holder, and the Hub owner can repoint 'Holding' to a new contract.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: offers signed by their parties and settled later (3 recoveries). Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- decompiled 0x1f0a07df: after ecrecover, identity.keyHasPurpose(keccak(wallet),4) (0xd202158d) with revert 'Wallet from holder 1 does not have encryption approval!'
- hub() = 0x89777F4D16F0a263F47EaD07cbCAb9497861aa79; Hub.getContractAddress('Holding') = this contract; Hub owner 0x599C59081d9B673BBDdAfbc933B669aA84eA3eE1 is an EOA, nonce 988 at 26438999 (live)
- No funds are committed before finalizeOffer succeeds (stake is reserved at finalize); payOut does not use ecrecover

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 3 transactions called it in the 90 days before that block; last on 2026-11-16.
- 3 signature recoveries in the study's two-week trace window.

## Remediation

The holder adds a non-migrated key with purpose 4 to its identity, or the Hub owner points 'Holding' at a code-aware version.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: the review found that root issue `eip-8151-rotate-signer-before-migrating` applies, not `eip-8151-signature-rechecked`; filed under it.
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
