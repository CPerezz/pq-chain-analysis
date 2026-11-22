---
id: facetetherbridgev6shutdown-00000000-signer-upgrade-only
title: "FacetEtherBridgeV6Shutdown: signer replaceable only by an upgrade"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0000000000000b07ed001607f5263d85bf28ce4c"
  family: "944fdfe537e65dd5cd39efa42c6c7735"
  copies: 2
  name: "FacetEtherBridgeV6Shutdown"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 431
  last_active: 2026-11-13
  recoveries_14d: 8
fix:
  layer: new-deployment
  who_acts: "bridge admin"
evidence:
  level: source-read
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
  rating: MEDIUM
  note: "No update path, but an admin path still moves the money. I did not read the admin's liveness at 26438999 (settable; node down)."
---

## Summary

Facet bridge (shutdown): withdraw needs the hard-coded signer 0x314d660b…, and the ERC1967Factory admin of the proxy is zero, so no upgrade is possible. The admin still moves the funds through disburse and adminMarkComplete.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: Facet bridge (shutdown) withdraw: a hard-coded signer must sign each withdrawal. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- withdraw requires recovered == _hardCodedSignerAddress(); disburse and adminMarkComplete are onlyAdmin (dossier source)
- ERC1967Factory.adminOf(proxy) = 0x0, and getSigner() = 0x314d660b…, an EOA (latest block ~26452920; both constant)
- balance 0 (node, block 26438999)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 431 transactions called it in the 90 days before that block; last on 2026-11-13.
- 8 signature recoveries in the study's two-week trace window.

## Remediation

The admin pays out through disburse

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
