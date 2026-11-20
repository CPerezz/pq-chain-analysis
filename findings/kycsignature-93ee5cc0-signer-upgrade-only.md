---
id: kycsignature-93ee5cc0-signer-upgrade-only
title: "KycSignature: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x93ee5cc08da79bf87d3e18c200458817ff83861a"
  family: "26cd16ced0243427544911c8dc04bd9b"
  name: "KycSignature"
  upgradeable: "yes"
  admin: "current owner of tokenId 0 of the `world` NFT contract (not identified by address)"
  rating: LOW
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "whoever owns tokenId 0 of the Monstrum 'world' NFT contract, by a normal NFT transfer"
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
  rating: LOW
  note: "The signer (sovereign) rotates automatically with ownership of a specific NFT, which is always transferable — that is itself the 'another path/setter' that makes this LOW; holds $0."
---

## Summary

Monstrum/KycSignature/Citizen: sovereign() is not a fixed address — it is read dynamically as ownerOf(0) on the Citizen's `world` NFT contract. upgradeTo(address) is gated by the same sovereign() check. The dossier's own facts confirm exactly one live Citizen proxy (an EIP-1967 minimal proxy deployed per NFT) delegates to this implementation.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: KycSignature submitKycSignature: sovereign() must sign. Read (function text).
- Update path, read at block 26,438,999: upgradeTo(address), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- source (Monstrum.sol): sovereign() = Citizen(address(this)).world().ownerOf(0); upgradeTo(impl) requires msg.sender == sovereign()
- source (Citizen.sol): each Citizen is its own ERC1967Proxy with its own `world` storage set at construction
- dossier facts.json (gate1/readings/26cd16ced0243427544911c8dc04bd9b): addresses_that_run_it=2, how_addresses_come_to_run_it={'proxy slot':1,'direct':1} — one live Citizen proxy exists besides the bare implementation; eth_at_pinned_block=0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Transferring the controlling NFT (tokenId 0 of `world`) to a fresh address immediately changes who can call submitKycSignature/upgradeTo — the row's 'no setter' is wrong, the setter is a standard NFT transfer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
