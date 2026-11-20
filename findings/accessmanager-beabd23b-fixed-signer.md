---
id: accessmanager-beabd23b-fixed-signer
title: "AccessManager: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xbeabd23b7e4899696dff26556c38b7394e27b8d6"
  family: "ebd442bbb0d2c9a706c1bdd03e3ce35d"
  copies: 4
  name: "AccessManager"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: none
  who_acts: "no funds involved"
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
  note: "Downgraded from the study's HIGH: the contract holds no money by design, so the correct bucket is MEDIUM (function dies, nothing locked) per the rubric's own text, not HIGH."
---

## Summary

AccessManager.grantAccess requires SigningTools._verifySignature against the constant EXPECTED_SIGNER (no setter, no proxy). This contract holds no funds by design -- it only flips a per-geoVersion access boolean. If the signer gets code, newly-arriving wallets can never be granted access again, but this is a pure access-list contract with zero value custody.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: SigningTools _verifySignature: EXPECTED_SIGNER, fixed in the code. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- AccessManager.sol:21-27: _verifyAccess calls SigningTools._verifySignature(messageHash, signature) (dossier source)
- SigningTools.sol:9,28: EXPECTED_SIGNER constant 0x1234519DCA2ef23207E1CA7fd70b96f281893bAa, no setter
- AccessManager.sol has no payable function and no balance/token field; it stores only _walletsWithAccess booleans

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Salty DAO proposes a new AccessManager via proposeSetAccessManager; existing accesses are unaffected.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
