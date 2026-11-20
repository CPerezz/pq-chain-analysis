---
id: registry-0da26790-signer-upgrade-only
title: "Registry: signer replaceable only by an upgrade"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0da2679000ea5380d1361cc3cca7d4e8c881f766"
  family: "a276c3947624a00ebb087a852c2ad906"
  name: "Registry"
  label: "deployed by moneycanbuy.fun: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 90
  last_active: 2026-11-09
  recoveries_14d: 5
fix:
  layer: new-deployment
  who_acts: "deployer"
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
  note: "An oracle consumer: the function dies, nothing is locked"
---

## Summary

Registry (SWORN): oracle results must be signed by attester, set in the constructor with no setter and no proxy. If the attester takes code, every verdict is Missed. The registry holds no user deposits; request fees go to intake.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the recovered address must be the attester. Read from source. Executed: a real transaction loses its effect with code at the signer.
- Update path, read at block 26,438,999: upgrade(uint16[],uint256), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- attester assigned only in the constructor; _check requires recovered == attester (dossier source)
- attester() = 0x5598Aa91…, an EOA (latest block ~26452920; no setter)
- No proxy slot; upgrade(uint16[],uint256) is a business function, not a code upgrade (source)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 90 transactions called it in the 90 days before that block; last on 2026-11-09.
- 5 signature recoveries in the study's two-week trace window.

## Remediation

Deploy a new registry with a new attester

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
