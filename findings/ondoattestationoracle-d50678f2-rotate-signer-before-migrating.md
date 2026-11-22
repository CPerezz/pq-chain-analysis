---
id: ondoattestationoracle-d50678f2-rotate-signer-before-migrating
title: "OndoAttestationOracle: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd50678f2763db502e9481f39315702aa7900198f"
  family: "88651170c5998bf3e912a3c76a46cd31"
  copies: 2
  name: "OndoAttestationOracle"
  upgradeable: "yes"
  admin: "ProxyAdmin 0xad17e502… owned by Safe 0x5a76f841… (threshold 3)"
  rating: LOW
  txs_90d: 1606
  last_active: 2026-11-18
  recoveries_14d: 1052
fix:
  layer: onchain-config
  who_acts: "Ondo GM token manager admin (TimelockController 0x3715B215…, proposer Safe 0x71A4d411…)"
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
  note: "Role grant by a working timelock plus Safe → LOW."
---

## Summary

Ondo attestation oracle (implementation behind proxy 0xd6049430ddfa9bcd1f33064bf697313a1a93ace9). updatePrices accepts quotes signed by a holder of ATTESTATION_SIGNER_ROLE in the GM token manager; a signer with code stops price updates.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Ondo attestation oracle: the signer must hold the attestation signer role in the GM token manager. Read from source.
- OndoAttestationOracle.sol:227-229: ECDSA.recover, then gmTokenManager.hasRole(ATTESTATION_SIGNER_ROLE, signer); no ERC-1271.
- Proxy state at 26438999: gmTokenManager=0x2c158BC4…, whose ATTESTATION_SIGNER_ROLE admin is DEFAULT_ADMIN (1 member: TimelockController 0x3715B215…, minDelay 7200). Its PROPOSER_ROLE member is Safe 0x71A4d411… (threshold 4).
- Proxy owner is Safe 0x5a76f841… (threshold 3), which can setGmTokenManager (onlyOwner, :162). The proxy is upgradeable through ProxyAdmin 0xad17e502… owned by the same Safe.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1,606 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,052 signature recoveries in the study's two-week trace window.

## Remediation

The GM manager admin grants ATTESTATION_SIGNER_ROLE to a fresh EOA through the timelock before the old signer takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
