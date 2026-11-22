---
id: hypersnapbridge-49b5a631-signed-shortcut-lost
title: "HypersnapBridge: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x49b5a631f54927c0007232844f06fe18cbf69786"
  family: "5fe4b0da0d53f256e93e305a83b3813e"
  copies: 2
  name: "HypersnapBridge"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 16799
  last_active: 2026-11-17
  recoveries_14d: 26
fix:
  layer: none
  who_acts: "the affected signer, by calling directly"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "LOW for the permit shortcut (approve stays open). The owner-signature paths only break if the threshold key itself puts code on its address, which it controls. Attention: owner key gates claims, rotation and upgrade by signature only; a separate fixed-signer-type issue if that address ever gets code."
---

## Summary

HypersnapBridge token: OZ 5 permit (pure ECDSA) with standard approve; it also checks the stored threshold ownerAddress by ECDSA for root advances, rotateOwner and proposeUpgrade.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call / a claim above the latest block must carry the signature of the stored owner address; rotateOwner replaces it /…. Read from source. Executed: a real transaction reverts with code at the signer.
- src/HypersnapBridge.sol: OZ ERC20PermitUpgradeable permit, ERC20 approve is the direct path for the holder
- claim (l.173-194) and rotateOwner (l.229-251) recover the ownerAddress (DKG threshold key) by ECDSA; rotateOwner needs the outgoing owner's signature
- proposeUpgrade (l.~276-286) is also authorised only by the ownerAddress signature

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 16,799 transactions called it in the 90 days before that block; last on 2026-11-17.
- 26 signature recoveries in the study's two-week trace window.

## Remediation

affected party uses the direct call

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
