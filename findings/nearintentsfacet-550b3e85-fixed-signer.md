---
id: nearintentsfacet-550b3e85-fixed-signer
title: "NEARIntentsFacet: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x550b3e858066461c3a2aaf9e9b8696b84345845c"
  family: "a0904570ca0105e3807bd9ff7b3f77b6"
  copies: 2
  name: "NEARIntentsFacet"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: none
  who_acts: "no funds held by this facet"
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
  rating: MEDIUM
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "Could not establish the same live-upgrade escape found for UnitFacet, so this stays at the study's MEDIUM (no funds held, only this route dies)."
---

## Summary

LiFi NEARIntentsFacet: BACKEND_SIGNER immutable, no setter (identical pattern to UnitFacet). Unlike UnitFacet, I could not confirm this facet is live-wired into the main LiFiDiamond (0x1231deb6...): facetAddress() there for its own real selectors (0x3110c7b9, 0x5cf8113b) returns the zero address, and 0xcc67a1aa resolves to an unrelated facet, both at block 26438999. txs_90d=0 and no caller/delegatecall was observed for this code in the corpus either. The facet itself holds no funds regardless.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: LiFi NEARIntentsFacet: BACKEND_SIGNER (immutable) signs each NEAR-intents bridge quote; the facet holds no funds, only this route stops (MEDIUM). Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- NEARIntentsFacet.sol:39,109,295,297: BACKEND_SIGNER immutable, ECDSA.recover==BACKEND_SIGNER required (dossier source)
- LiFiDiamond(0x1231deb6...).facetAddress(0x3110c7b9)==0x0, facetAddress(0x5cf8113b)==0x0, facetAddress(0xcc67a1aa)==0x8f00E690a45e75D7A1A765163829Ad33244a1C33 (a different facet) at block 26438999 (cast call)
- facts.json: how_addresses_come_to_run_it={direct:1}, who_depends_on_it.codes_that_hold_or_call_its_address=0; txs_90d=0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy/diamondCut a replacement facet with a new signer if and when this one is wired into a live diamond.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
