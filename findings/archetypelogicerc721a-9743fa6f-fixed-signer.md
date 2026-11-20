---
id: archetypelogicerc721a-9743fa6f-fixed-signer
title: "ArchetypeLogicErc721a: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x9743fa6fce7e50e182951dcfdac65c9d95494f97"
  family: "b05115a9ece0061e7fb0a5e9845238ce"
  copies: 511
  name: "ArchetypeLogicErc721a"
  upgradeable: "no"
  rating: LOW
  value_usd: 5340
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 6653
  last_active: 2026-11-18
  recoveries_14d: 12
fix:
  layer: none
  who_acts: "minters (mint without an affiliate)"
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
  note: "The same act (minting) stays open on the path without an affiliate; only affiliate attribution is lost."
---

## Summary

Archetype ERC721a collection (clone of 0xa4e86e9d…): only mints that name an affiliate need a signature from config.affiliateSigner. If that key takes code, affiliate mints fail; plain mints with no affiliate still work.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Archetype (older): the affiliate signature must come from the affiliate signer of the collection's fixed configuration; it only decides affiliate fees. Read by hand.
- Update path, read at block 26,438,999: delegates to a fixed address.
- ArchetypeLogicErc721a.validateMint: validateAffiliate(...) is called only if args.affiliate != address(0); it requires ECDSA.recover == affiliateSigner
- The rest of minting (invite/auth checks) does not depend on the affiliate signature; 45-byte clone, no EIP-1967 slot
- recoveries_14d = 12, txs_90d = 6653 (from the row)

## Impact and exposure

- Value held at block 26,438,999: $5,340 (ETH and 49 priced tokens, over 511 addresses).
- Activity: 6,653 transactions called it in the 90 days before that block; last on 2026-11-18.
- 12 signature recoveries in the study's two-week trace window.

## Remediation

Mint without an affiliate; affiliate fees need a collection with a new signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
