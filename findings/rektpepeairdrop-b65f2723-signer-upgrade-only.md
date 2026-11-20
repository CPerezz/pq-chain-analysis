---
id: rektpepeairdrop-b65f2723-signer-upgrade-only
title: "RektPepeAirdrop: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: none
contracts:
- address: "0xb65f2723f179e1b57afd21c707999b9a1f0a6f78"
  family: "97919fe4baa5644922075c4512f51e81"
  name: "RektPepeAirdrop"
  upgradeable: "no"
  rating: LOW
  txs_90d: 0
fix:
  layer: none
  who_acts: "the admin upgrades the verification"
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
  note: "The only missing fact was whether the controlling party is live: its owner 0x99834733c91aae2f5bb0725105c9e843cb297a27 is a plain account (no code, nonce 3,667), read at the latest block (26,455,6xx; the node was down). Live by Anon's rule of 2026-11-20 (a key is presumed live unless shown lost), so it can rotate the signer or upgrade the code: LOW. Earlier doubt: Missing: nonce of 0x99834733C91aAE2f5BB0725105c9E843Cb297A27 at 26438999 (node timed out). A live owner makes this LOW (upgrade). Without one it is MEDIUM: an airdrop of the operator's own stock, which withdraw() by the owner can still recover."
---

## Summary

RektPepe airdrop UUPS implementation with a constant signer 0x8740928E. The live proxy 0x519166d8 is upgradeable by its owner 0x99834733 (onlyOwner), but I could not read that owner's liveness.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: RektPepeAirdrop claim: the stored signer must sign. Read (function text).
- Update path, read at block 26,438,999: upgradeTo(address), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- Airdrop.sol:17 signer = constant 0x8740928E2b362B2E0D1F61aEeECDE5aeA98c65A6; :33-35 _authorizeUpgrade onlyOwner; :75 withdraw onlyOwner
- proxy 0x519166d8db6902a7dc9620410551c8f28866f746: impl slot = 0xb65f2723, owner() = 0x99834733C91aAE2f5BB0725105c9E843Cb297A27 (cast @26438999)
- owner 0x99834733 has no code (publicnode, latest, block ~26452926)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The admin upgrades the verification, or the key holder keeps the key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
