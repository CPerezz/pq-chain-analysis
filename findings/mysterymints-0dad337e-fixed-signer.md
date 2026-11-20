---
id: mysterymints-0dad337e-fixed-signer
title: "MysteryMints: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0dad337e30af2a196f04ec1efd21ad2d6553d5b8"
  family: "54a480b941c935af4b2b7b28e46e1205"
  name: "MysteryMints"
  upgradeable: "no"
  rating: LOW
  txs_90d: 4
  last_active: 2026-11-01
fix:
  layer: onchain-config
  who_acts: "nobody today (owner 0x1c90081c…, live EOA, only if they re-enable the whitelist)"
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
  note: "The same act (mintNFT at the same price) is open to everyone without a signature, and an owner setting controls whether the check runs at all: LOW."
---

## Summary

MysteryMints (TheEveryones idiom): mintNFT checks the constant WHITELIST_SIGNER only while block.timestamp < disableWhitelistTimestamp, an owner setting. That timestamp is 1637949600 (2021-11-26), so the same mint already runs without any signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: TheEveryones isWhitelisted: WHITELIST_SIGNER, a constant / PayToUnlock recoverSigner: returns the recovered address. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source MysteryMints.sol: isWhitelisted only inside `if (block.timestamp < disableWhitelistTimestamp)` in mintNFT; setDisableWhitelistTimestamp is onlyOwner
- disableWhitelistTimestamp = 1637949600, salePaused = false, totalSupply 644 of maxSupply 20000 (reserved 116) at block 26438999
- WHITELIST_SIGNER 0x8430e0b7… no code (nonce 1); owner 0x1c90081c… EOA nonce 155; contract holds 0 ETH, owner withdraw needs no signature

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 4 transactions called it in the 90 days before that block; last on 2026-11-01.

## Remediation

Nothing needed; if the owner ever re-enables the whitelist, setDisableWhitelistTimestamp to a past time reopens the unsigned mint.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
