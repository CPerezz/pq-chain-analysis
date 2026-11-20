---
id: bridgecontroller-a6571b73-signed-shortcut-lost
title: "BridgeController: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xa6571b73489d4ebfa269a107208665df7c80aef5"
  family: "87ffbc11da5a708dab38516eb7a86356"
  copies: 3
  name: "BridgeController"
  label: "deployed by PearlBridge Bridged WPRL (Ethereum): Deployer"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 4264
  last_active: 2026-11-18
  recoveries_14d: 1230
fix:
  layer: onchain-config
  who_acts: "DEFAULT_ADMIN_ROLE timelock"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Really a rotate-signer case: attesters replaceable by a timelock admin; LOW holds on that basis, not via a direct path. Timelock proposers not read."
---

## Summary

BridgeController (WPearl bridge): executeMint requires a quorum of ECDSA attester signatures from RELAYER_ROLE holders; an attester with code stops counting.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call / attester quorum: each recovered signer must hold RELAYER_ROLE, ascending order. Read from source. Executed: a real transaction reverts with code at the signer.
- contracts/BridgeController.sol:1492 ECDSA.recover then hasRole(RELAYER_ROLE) at :1493
- grantRole/revokeRole (:1587) via AccessControlDefaultAdminRules; DEFAULT_ADMIN_ROLE member 0xc07c5b10fa35c0db94ab47484b9f667b7b649762 is a timelock (getMinDelay=86400) at block 26438999
- RELAYER_ROLE member count = 3 at block 26438999; no approve/permit selector at this address (permit belongs to WPearl)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 4,264 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,230 signature recoveries in the study's two-week trace window.

## Remediation

Admin timelock rotates RELAYER_ROLE to EOA attesters.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
