---
id: consortium-dad58dfa-rotate-signer-before-migrating
title: "Consortium: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xdad58dfa5c1a7a34419afdbe1f0d610efeea95e4"
  family: "72ce8e73c6a831bc95d3f21d179fe2b8"
  copies: 2
  name: "Consortium"
  label: "deployed by Lombard: Deployer"
  upgradeable: "yes"
  admin: "ProxyAdmin 0x1629ae77cc70daac95ec479caaea23ece77c67c5, owned by timelock 0x055E84e7FE8955E2781010B866f10Ef6E1E77e59 (86400 s delay)"
  rating: LOW
  txs_90d: 1729
  last_active: 2026-11-18
  recoveries_14d: 4993
fix:
  layer: onchain-config
  who_acts: "validator quorum, or timelock 0x055E…7e59 via ProxyAdmin"
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
  note: "Rotation by quorum plus a timelock-controlled proxy upgrade, so LOW holds. Validator keys come from pubkeys and are unlikely to ever hold code."
---

## Summary

Lombard Consortium: checkProof needs a weighted quorum of ECDSA signatures from the current validator set. A validator whose address holds code stops counting.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a loop of recoveries: each signer must be in the stored set (oracle, committee member, validator) and distinct; a quorum is needed. Read from source. Executed: a real transaction reverts with code at the signer.
- Consortium.sol:91 setNextValidatorSet is permissionless but needs a quorum proof from the current set; setInitialValidatorSet works only once (epoch==0)
- Consortium.sol:195-230 compares tryRecover against validators[i] with no code or ERC-1271 path; validator addresses come from Cosmos keyring pubkeys
- Ownable2Step owner and ProxyAdmin 0x1629…67c5 owner() are both timelock 0x055E…7e59, getMinDelay = 86400 at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1,729 transactions called it in the 90 days before that block; last on 2026-11-18.
- 4,993 signature recoveries in the study's two-week trace window.

## Remediation

The validator quorum rotates in a new set, or the timelock upgrades the proxy.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
