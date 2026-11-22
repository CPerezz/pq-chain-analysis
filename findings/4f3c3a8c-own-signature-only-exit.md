---
id: 4f3c3a8c-own-signature-only-exit
title: "0x4f3c3a8c: funds released only by the party's own signature"
status: confirmed
severity: LOW
patterns: [PQ-16]
impact: liveness
contracts:
- address: "0x4f3c3a8c6777bdb879b92ea8eec2be9232e43ae7"
  family: "d23dad95504c194ad73ed07a8ed90e43"
  upgradeable: "no"
  rating: LOW
  txs_90d: 142
  last_active: 2026-11-17
  recoveries_14d: 7
fix:
  layer: account-migration
  who_acts: "claimants claim before their key's account takes real code, or keep a 7702 delegation"
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
  note: "Not a fixed signer: each claim recovers the claimant's own key (Cosmos ownership). A claimant whose account takes real code cannot claim; claiming first or keeping a 7702 delegation avoids it, and the unclaimed stock is the operator's and recoverable (recoverUnclaimed): LOW under the own-signature root issue."
---

## Summary

The signature is not from a fixed party. In each claim, ecrecover returns a different address: the claimant's own key, which checks Cosmos ownership. The operator 0x9d80… can still take back the unclaimed stock with recoverUnclaimedTokens.

## Mechanism

PQ-16. Once the party's account has real code the signature recovers no address, and nobody else can act for it unless an administrator can.

## Evidence

- How it was placed: a Cosmos-address airdrop (7 recoveries); inferred: claims carry a signature checked against a fixed party; no setter by name. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Traces of 5 claim txs in the window: the recovered addresses all differ (0x6f8f…, 0x47a2…/0x89f1…, 0x6b35…/0x2245…, 0x0de2…, 0x27db…)
- Decompile: recoverUnclaimedTokens() is operator-only and sends the whole token balance to the operator; pause/unpause are operator-only

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 142 transactions called it in the 90 days before that block; last on 2026-11-17.
- 7 signature recoveries in the study's two-week trace window.

## Remediation

Act before migrating the address; new deployments accept ERC-1271 or a direct call.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: the review found that root issue `eip-8151-own-signature-only-exit` applies, not `eip-8151-fixed-signer`; filed under it.
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
