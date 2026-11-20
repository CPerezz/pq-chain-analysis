---
id: hyperloguecreator-ac49c7ee-rotate-signer-before-migrating
title: "HyperlogueCreator: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xac49c7ee67b6afe5f9693089e4b8f171d0432605"
  family: "e9541423ae5ab2ba6cc71ec757dc4703"
  copies: 2
  name: "HyperlogueCreator"
  upgradeable: "yes"
  rating: NONE
  txs_90d: 48985
  last_active: 2026-11-16
  recoveries_14d: 12
fix:
  layer: none
  who_acts: "none"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "The code accepts ERC-1271 for the stored signer, so a signer with code is handled; the definition rates this refuted. The study's replay presumably put code without 1271 at the signer."
---

## Summary

HyperlogueCreator (proxy, impl 0x631dd719…) checks its backend signer with OZ SignatureChecker.isValidSignatureNow(store.signer, …). When recovery fails, which is what EIP-8151 does for a signer with code, it falls back to ERC-1271 on that signer.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: SignatureChecker on a signer kept in storage (ECDSA, or its ERC-1271 if it is a contract). Read from source. Executed: a real transaction loses its effect with code at the signer.
- src/HyperlogueCreator.sol:128,199,243 use SignatureChecker.isValidSignatureNow(store.signer, digest, signature).
- The bundled SignatureChecker calls tryRecover and then isValidERC1271SignatureNow(signer, …), so a signer with code is asked through ERC-1271.
- Rotation also exists: setSigner (line 322) is onlyRole(DEFAULT_ADMIN_ROLE). I did not read the admin holder.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 48,985 transactions called it in the 90 days before that block; last on 2026-11-16.
- 12 signature recoveries in the study's two-week trace window.

## Remediation

If the signer migrates to code, that code must implement ERC-1271, or the admin calls setSigner first.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
