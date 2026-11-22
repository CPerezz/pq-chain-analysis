---
id: campaignrewarddistribution-717d0bf9-rotate-signer-before-migrating
title: "CampaignRewardDistribution: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x717d0bf97ce58e14945f5e0320ee98381aeaddaf"
  family: "6c04e80702e231938199ca271b17ab9b"
  copies: 2
  name: "CampaignRewardDistribution"
  upgradeable: "yes"
  admin: "ProxyAdmin 0xc2c8ede80bb5aeb883077ece496b0c374549d092 owned by Safe 0x520Cf70a2D0B3dfB7386A2Bc9F800321F62a5c3a"
  rating: LOW
  value_usd: 558692
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 220
  last_active: 2026-11-06
  recoveries_14d: 1
fix:
  layer: onchain-config
  who_acts: "owner Safe 0x520C…5c3a"
evidence:
  level: executed
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
  note: "Setter with live Safe owner."
---

## Summary

Campaign reward distributor paying vouchers signed by stored masterSigner; a masterSigner with code breaks claims.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source. Executed: a real transaction reverts with code at the signer.
- updateSignerAddress(address) onlyOwner (reading.keys)
- live proxy 0x78890d74…eac0: owner()=0x520Cf70a…5c3a, a 2-of-3 Safe; masterSigner=0xD2aE…7610
- proxy admin 0xc2c8ede8…d092 (ProxyAdmin) owned by the same Safe; 0x717d… itself is the uninitialised implementation (owner 0)

## Impact and exposure

- Value held at block 26,438,999: $558,692 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 220 transactions called it in the 90 days before that block; last on 2026-11-06.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

Owner Safe calls updateSignerAddress.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
