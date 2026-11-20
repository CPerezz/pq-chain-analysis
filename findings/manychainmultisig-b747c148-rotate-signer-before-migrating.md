---
id: manychainmultisig-b747c148-rotate-signer-before-migrating
title: "ManyChainMultiSig: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb747c1486d8aca1d13018b574701f325f497d198"
  family: "3d9e34b4d74e3ebbf6bb19faeb3e49d5"
  copies: 78
  name: "ManyChainMultiSig"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1699
  last_active: 2026-11-17
  recoveries_14d: 203
fix:
  layer: onchain-config
  who_acts: "owner RBACTimelock 0x2669…7178 via its proposer MCMS 0x3d54…DA91"
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
  note: "Live governance path: timelock with a working proposer MCMS. Its own signers face the same issue and must also rotate early."
---

## Summary

Chainlink ManyChainMultiSig: setRoot needs a quorum of ECDSA signatures from the stored signer set. Signers that get code drop out of the quorum.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a loop of recoveries: each signer must be in the stored set (validator, attester, author, oracle), distinct or ordered; a quorum or weight is needed. Read from source. Executed: a real transaction reverts with code at the signer.
- source ManyChainMultiSig.sol:393 setConfig(signers, groups, quorums, parents, clearRoot) onlyOwner (OZ Ownable2Step)
- owner at block 26438999 = 0x266990f0…7178, timelock minDelay 0; PROPOSER_ROLE count 1 = 0x3d54fF2F…DA91 (MCMS, 19.6 kB, owned by the same timelock, opCount 1); EXECUTOR_ROLE count 1 = 0x981c2b5C…9EA9 (609 B)
- 1699 txs in 90d (row)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 78 addresses).
- Activity: 1,699 transactions called it in the 90 days before that block; last on 2026-11-17.
- 203 signature recoveries in the study's two-week trace window.

## Remediation

Timelock (proposed via the proposer MCMS quorum) calls setConfig with fresh signer EOAs before the old ones migrate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
