---
id: 7e36fea9-rotate-signer-before-migrating
title: "0x7e36fea9: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x7e36fea9672dff7965d155c29811eab235c113a1"
  family: "33df569b5ac4cbaf733ae441f364059b"
  upgradeable: "no"
  rating: LOW
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "current consuls (rotate to fresh keys via updateConsuls before migrating)"
evidence:
  level: source-read
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
  note: "LOW: the consul set is rotated by its own signers, so rotating before migrating avoids the problem. No funds are held."
---

## Summary

Not a BitFi Vault. This is a Gravity-style consul registry: updateConsuls(address[],uint8[],bytes32[],bytes32[],uint256 round) needs bftValue (3) signatures from the current consuls; bftValue(), getConsuls() and lastRound() are views. If a consul's account gets non-7702 code, that consul's signatures stop counting. The set can still be rotated while the threshold holds. The contract holds no money.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: per-trade Vault (18 clones): settlement pays out only with a presign of coreAddrs[1] and an MPC signature of coreAddrs[0], both fixed in the vault; after the timeout anyone can…. Same code idiom as template ec3bbcc8, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- decompile: updateConsuls requires round > lastRound and enough ecrecover matches against current consuls ("invalid bft count")
- cast call @26438999: lastRound=1066, bftValue=3, consuls 0x977fa57a…, 0xd13a6cd1…, 0x6ac9bd01… (no code) plus 2 zero entries
- balance 0; ecrecover forwards all gas

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The consuls sign an updateConsuls to fresh keys before any of them migrates their account.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: the review found that root issue `eip-8151-rotate-signer-before-migrating` applies, not `eip-8151-signature-rechecked`; filed under it.
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
- 2026-11-20: the same contract was also a row of triage entry `eip-8151-fixed-signer`; its reading as a fixed signer was wrong: updateConsuls lets the current consuls rotate the set, so it is filed here (D-025).
