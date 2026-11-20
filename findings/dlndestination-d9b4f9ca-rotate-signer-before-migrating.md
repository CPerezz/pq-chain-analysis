---
id: dlndestination-d9b4f9ca-rotate-signer-before-migrating
title: "DlnDestination: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xd9b4f9cacffb59f2b982ad3c45096e3aa4b4020e"
  family: "7a473fd10c836db1bbfbe8ec3a162b75"
  copies: 2
  name: "DlnDestination"
  upgradeable: "yes"
  rating: NONE
  txs_90d: 53899
  last_active: 2026-11-18
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
  note: "No signature check runs in this address's code, so the rotate-signer claim does not apply to it."
---

## Summary

deBridge DlnDestination implementation (behind proxy 0xe7351fd7…). Its bytecode never calls ecrecover. The study matched SignatureVerifier/DeBridgeToken sources that ship in the source bundle but are not compiled into this contract.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: permit: the named owner must sign; the holder can call approve itself / deBridge SignatureVerifier.submit: signatures of valid oracles are counted, required oracles must all be present, a minimum of…. Rule: standard permit text.
- Dossier facts.json (7a473fd1): kind '5 or 6: no recovery found in its bytecode', 0 recoveries in the window.
- Source contracts/DLN: no ecrecover. Permits are forwarded to the token's own permit via executePermit (DlnDestination.sol:239), so any signature check lives in the token contract, not here.
- The ecrecover calls are only in @debridge-finance SignatureVerifier.sol:75/142 and DeBridgeToken.sol:136, which are separate deployed contracts.
- Proxy state.json: eip1967_admin 0xa7b88a746fa457578d5abd6234471f07d895f46b.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 53,899 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

None here. Oracle-key rotation is handled at deBridge's SignatureVerifier, which is a separate contract and a separate row.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
