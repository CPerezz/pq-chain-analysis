---
id: unitfacet-989a7efa-fixed-signer
title: "UnitFacet: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x989a7efabb9be76ac3424b940862d9cf55334873"
  family: "0076321e3e283da67da40885693d0551"
  name: "UnitFacet"
  upgradeable: "yes"
  admin: "LiFiDiamond timelock 0x55117ECcC867Db72aEb25f728CCf57C3C3B4faEe"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "LiFi ops via the LiFiDiamond Timelock (minDelay 10800s)"
evidence:
  level: source-read
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
  note: "A live diamondCut path exists via the diamond's timelock owner, overriding the study's 'no proxy slot, no upgrade function' claim (a facet isn't behind an EIP-1967 slot, but the diamond's own upgrade mechanism plays the same role and is confirmed live)."
---

## Summary

UnitFacet checks a BACKEND_SIGNER immutable, which has no setter. But the facet is live-wired into LiFiDiamond 0x1231deb6f5749ef6ce6943a275a1d3e7486f4eae: facetAddress() for both its real selectors (0x21a3af52, 0x64261d58) resolves to this exact address at the pinned block, and the diamond's owner() is a live TimelockController (getMinDelay=10800s). diamondCut by that timelock can replace the whole facet (and its baked-in signer), so this is a signer-upgrade-only case with a live admin, not a dead end.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: LI.FI Unit facet: signed by BACKEND_SIGNER, fixed in the facet's code. Read from source. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- UnitFacet.sol:34,206: BACKEND_SIGNER immutable, no setter (dossier source)
- LiFiDiamond.facetAddress(0x21a3af52) == LiFiDiamond.facetAddress(0x64261d58) == 0x989a7efa... at block 26438999 (cast call)
- LiFiDiamond.owner() == 0x55117ECcC867Db72aEb25f728CCf57C3C3B4faEe at block 26438999; that address is a contract (18,967 bytes) whose getMinDelay()==10800 succeeds (TimelockController), at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

LiFi ops: diamondCut a replacement UnitFacet (new signer) through the timelock.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
