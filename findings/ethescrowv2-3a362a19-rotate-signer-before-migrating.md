---
id: ethescrowv2-3a362a19-rotate-signer-before-migrating
title: "ETHEscrowV2: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x3a362a1966ff5aab35298e1565bda2c9fb124e41"
  family: "8343030030f4553952f8408c98f9bb4f"
  name: "ETHEscrowV2"
  upgradeable: "no"
  rating: LOW
  value_usd: 46197
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 25230
  last_active: 2026-11-18
  recoveries_14d: 5121
fix:
  layer: onchain-config
  who_acts: "owner 0x8e466cdd (EOA)"
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
  note: "Setter exists and the owner is a live EOA. The separate buyer/seller-signature dispute path is a different root issue, not rated here."
---

## Summary

ETHEscrowV2 trade escrow: relayed settlements need two signatures from relayerSigner1/2, recovered with ECDSA only. A relayer signer with code makes relayed settlement revert; parties' own calls (release, buyerCancel) remain.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: trade escrow in ETH (function map, resolveDispute and claimStuck read): seller and buyer settle by their own call (release, buyerCancel) or by a relayed signature; a dispute can be resolved by the…. Read by hand. Executed: a real transaction reverts with code at the signer.
- ETHEscrowV2.sol:463-477: signers compared with relayerSigner1/relayerSigner2 via ECDSA.recover
- ETHEscrowV2.sol:370 setRelayerSigners onlyOwner
- owner() at block 26438999 = 0x8e466cdd9508103c12731e9243e2926a829033c9, no code, nonce 22647

## Impact and exposure

- Value held at block 26,438,999: $46,197 (ETH and 49 priced tokens).
- Activity: 25,230 transactions called it in the 90 days before that block; last on 2026-11-18.
- 5,121 signature recoveries in the study's two-week trace window.

## Remediation

Owner calls setRelayerSigners with EOA keys.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
