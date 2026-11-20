---
id: directanylauncher-fe4a23bb-rotate-signer-before-migrating
title: "DirectAnyLauncher: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xfe4a23bbe27be16955f4d8599c73bac88ef647d1"
  family: "95d7ec16351bcd9465d53467d744eef2"
  name: "DirectAnyLauncher"
  upgradeable: "no"
  rating: LOW
  value_usd: 361
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 34450
  last_active: 2026-11-17
  recoveries_14d: 4
fix:
  layer: onchain-config
  who_acts: "controller"
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
  note: "Setter callable by a live 7702-delegated EOA."
---

## Summary

DirectAnyLauncher; launch prices need a signature from the stored priceSigner. Under EIP-8151 a signer that takes non-delegation code stops recovering, so this path stops until the key is rotated.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source. Executed: a real transaction reverts with code at the signer.
- DirectAnyLauncher.sol:357 setPriceSigner(address) onlyController (msg.sender == platformController)
- platformController() = 0x81EE2B6B…, EIP-7702-delegated EOA (code 0xef0100…), nonce 19166 at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $361 (ETH and 49 priced tokens).
- Activity: 34,450 transactions called it in the 90 days before that block; last on 2026-11-17.
- 4 signature recoveries in the study's two-week trace window.

## Remediation

Controller sets a new EOA price signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
