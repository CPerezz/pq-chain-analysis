---
id: tarazverifier-2cba4739-fixed-signer
title: "TarazVerifier: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x2cba4739a9703ba57d5f50476d51c3a9bcc86de8"
  family: "175db25666961515e6629b34119d15bf"
  copies: 6
  name: "TarazVerifier"
  upgradeable: "no"
  rating: LOW
  txs_90d: 106211
  last_active: 2026-11-18
  recoveries_14d: 13223
fix:
  layer: onchain-config
  who_acts: "guardian of the Swift contract"
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
  note: "A setter on the consumer replaces the verifier."
---

## Summary

TarazVerifier's tarazSigner 0x7aec…67ae is immutable. However, its only traced consumer 0xd78d…3bae stores the verifier in slot 1, and its guardian can replace it with setAuctionConfig.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: TarazVerifier: one signature, whose signer must be tarazSigner, fixed in the code. Read from source. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- TarazVerifier.sol:16 `address public immutable tarazSigner`; cast call tarazSigner() = 0x7aeC…67ae, cast code = 0x
- trace 0x05fd…bc08: 0xd78d…3bae STATICCALLs 0x2cba.parseAndVerifyVM; 0xd78d slot1 = …2cba4739…
- cast call --from guardian 0xb4cd…ca5a setAuctionConfig(new,1,…) succeeds; the guardian has no code

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 6 addresses).
- Activity: 106,211 transactions called it in the 90 days before that block; last on 2026-11-18.
- 13,223 signature recoveries in the study's two-week trace window.

## Remediation

Deploy a new verifier with a new signer and call setAuctionConfig on the consumer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
