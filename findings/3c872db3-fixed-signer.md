---
id: 3c872db3-fixed-signer
title: "0x3c872db3: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x3c872db3345250dc33a4a26a0bb7c073f9a832c2"
  family: "333ec9a13628090892ddba87969e5ad1"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: offchain
  who_acts: "off-chain verifiers of song provenance"
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
  note: "MEDIUM (main reviewer's LOW/MEDIUM rule): the signed function dies for good; other parties' assets leave by separate paths (owner/depositor withdraw, rescue, timeout), not by the same act. The study note says 'presale deposit/claim', which is wrong: no deposit or claim functions exist. LOW is the lowest available rating for a confirmed row; the real impact is none."
---

## Summary

The signer is a constant and has no code today, so the fixed-signer claim holds. But the signature only feeds read-only provenance helpers. No funds or actions depend on it, so if the signer account gets code, only the provenance check stops working.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public constant signer = 0xD2aff...Bebb`; the signer has 0 code bytes and is not delegated
- verifySignature is `public pure` and compares ECDSA.recover(toEthSignedMessageHash(songHash), sig) with signer
- No mint or transfer function calls verifySignature; minting is the onlyOwner function mintLDAToOwner
- The only setter is transferOwnership, which does not change the signer

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Do the provenance check off-chain, or accept an ERC-1271 signature in a new deployment. Token functions are unaffected.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
