---
id: pricefeedoracle-a57016b1-rotate-signer-before-migrating
title: "PriceFeedOracle: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xa57016b153287da52b869f2a64dd73e7b97af6c6"
  family: "ef35b1fc5781b2f219cbf8df7d1e1ff0"
  copies: 2
  name: "PriceFeedOracle"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 2102
  last_active: 2026-11-18
  recoveries_14d: 259
fix:
  layer: onchain-config
  who_acts: "owner 0x1346186282517DBB4fbb7c39a51B8785Da2646e2"
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
  verdict: confirmed
  rating: LOW
  note: "A live owner can call the setter, so a config call fixes it: LOW."
---

## Summary

PriceFeedOracle checks signatures from a stored signer key with ecrecover; once that key's account holds code that is not a 7702 delegation, recovery returns nothing and the signed path stops until the key is replaced.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: SignatureChecker on a signer kept in storage (ECDSA, or its ERC-1271 if it is a contract). Read from source.
- setter setSigner(address) onlyOwner in verified source (ef35b1fc5781b2f219cbf8df7d1e1ff0/source)
- owner() at block 26438999 = 0x1346186282517DBB4fbb7c39a51B8785Da2646e2 EOA nonce=28
- txs_90d=2102, last_active=2026-11-18

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 2,102 transactions called it in the 90 days before that block; last on 2026-11-18.
- 259 signature recoveries in the study's two-week trace window.

## Remediation

Rotate the signer to a new EOA (or a key the signature check accepts) through the setter before the signing account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
