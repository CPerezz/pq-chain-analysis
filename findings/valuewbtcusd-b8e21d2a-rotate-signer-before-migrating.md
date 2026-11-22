---
id: valuewbtcusd-b8e21d2a-rotate-signer-before-migrating
title: "ValueWBTCUSD: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb8e21d2ad752c7fd562b95f84d61a377d7b1411a"
  family: "7f5c807702ed84ccbe3bf9ecea89bc25"
  copies: 2
  name: "ValueWBTCUSD"
  label: "deployed by USDD: Deployer 1"
  upgradeable: "no"
  rating: LOW
  txs_90d: 4334
  last_active: 2026-11-18
  recoveries_14d: 1670
fix:
  layer: onchain-config
  who_acts: "USDD governance: the DSPause authority, operated through DSPauseProxy 0x045a1b4c…"
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
  note: "A live governance path (an EOA that may plot/exec on DSPause with delay 0) can call lift/drop. Later Rely events were not scanned (log range limit), so other wards may also exist."
---

## Summary

ValueWBTCUSD is a Maker-style median oracle used by USDD. poke() needs bar=5 prices, each signed by a distinct oracle in the orcl set. Under EIP-8151 an oracle whose address takes non-7702 code no longer recovers, so its price can no longer be counted.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Maker-style BaseValue.recover: returns the signer of a price message / Maker-style BaseValue.poke: exactly `bar` messages, each signed by a distinct address of the oracle set (orcl) / Maker-style…. Read from source. Executed: a real transaction reverts with code at the signer.
- Source ValueWBTCUSD.sol:126/137: lift/drop (the oracle-set setters) and setBar are `auth`, which requires wards[msg.sender]==1
- Creation tx 0x54007fca… emitted Rely(0x045a1b4cc48483f55e2d266a601b683ed95aaa3c); wards(0x045a…)=1 at block 26438999. The factory 0x0ad81b3c… and tx sender 0x9c1a61a0… both read wards=0
- 0x045a… is a DSPauseProxy: owner()=DSPause 0xDFB2D51f…, delay()=0, authority()=0x3Ec9b1b5…
- At block 26438999 authority.canCall(0x09B1E13A…, pause, plot/exec)=true; 0x09B1… is the authority's owner, an EOA with a 7702 delegation (23-byte code) and nonce 857

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 4,334 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,670 signature recoveries in the study's two-week trace window.

## Remediation

Governance plots and executes, through the pause proxy, a spell that drops each oracle key before that key takes code and lifts its replacement.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
