---
id: artificialutopia-36e6f2b2-fixed-signer
title: "ArtificialUtopia: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x36e6f2b227b7608f4e0e0e0dbc142e75247098d2"
  family: "a65fb81c228b6232528f857740c0b3e9"
  name: "ArtificialUtopia"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "project owner"
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
  rating: MEDIUM
  note: "Signed NFT mint, no update path, nothing locked: MEDIUM."
---

## Summary

ArtificialUtopia: claimMint and saleMint need a signature from the constant _signerAddress 0xa32D…8DBD. The public stage never ends and 363 of 1000 are minted, so minting dies if that key takes code. No money is held.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Helmets2117: signed by SIGNER_ADDRESS, fixed in the code. Rule: same text up to names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source: constant _signerAddress; _isTrustedSigner uses ECDSA.recover; no owner mint
- signer has no code (latest, block ~26453066)
- totalSupply 363 (latest, block ~26453066); balance 0 at block 26438999 (state.json)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new minter or collection.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
