---
id: bridgecontroller-a6571b73-rotate-signer-before-migrating
title: "BridgeController: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
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
  who_acts: "DEFAULT_ADMIN_ROLE holder: TimelockController 0xc07c5B10 (24h delay), with Safe 0x0f78d385 (2-of-3) as proposer"
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
  note: "The admin is a working timelock whose proposer is a live Safe, and the relayer set can be rotated by grantRole/revokeRole. The proxy can also be upgraded."
---

## Summary

BridgeController (PearlBridge, upgradeable proxy). Its attestation quorum requires every recovered signer to hold RELAYER_ROLE, so under EIP-8151 a relayer key with code stops counting toward the quorum.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call / attester quorum: each recovered signer must hold RELAYER_ROLE, ascending order. Read from source. Executed: a real transaction reverts with code at the signer.
- BridgeController.sol:1492-1493 ECDSA.recover then hasRole(RELAYER_ROLE, signer); _grantRole/_revokeRole overrides (1541-1571) keep standard AccessControl grantRole/revokeRole
- getRoleAdmin(RELAYER_ROLE)=0x0 at 26438999; 3 relayers; role0/owner = timelock 0xc07c5B10 getMinDelay=86400
- timelock hasRole(PROPOSER_ROLE, 0x0f78d385...)=true; that Safe getThreshold=2, owners [0xBd4Eb029,0x708b5c36,0x802864B6]

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 4,264 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,230 signature recoveries in the study's two-week trace window.

## Remediation

The timelock grants RELAYER_ROLE to a fresh EOA key and revokes the key with code, keeping the count at or above the threshold.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
