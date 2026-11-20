---
id: 8a5273af-fixed-signer
title: "0x8a5273af (tagged deployed by Myanmar community Token: Deployer): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x8a5273afabc1205b594d6dcf90fdbfbbe653af7a"
  family: "6b92a4524f3966d1273646073af53b89"
  label: "deployed by Myanmar community Token: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "campaignAdmin 0x771375f4… (contract)"
evidence:
  level: bytecode
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
  rating: MEDIUM
  note: "No update path; claims die but the tokens leave through the admin's close + reclaimRemainingMDC."
---

## Summary

MDC airdrop campaign: claims must be signed by the immutable authorizedSigner. If it takes code, claims die; the campaign admin can close the campaign and reclaim the remaining MDC.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: EthBridge bridgeIn: the voucher must be signed by CANISTER, an address fixed in the code. Same code idiom as template 496eb5b1, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Not EthBridge: selectors claim (EIP-712), authorizedSigner, campaignAdmin, close, pause/resume, reclaimRemainingMDC; no EIP-1967 slot
- authorizedSigner() at 26438999 = 0xeb68AEA5Dc1da1832eC12eDBf1B5362dF912dc7f, an immutable in the code with no setter; cast code 0x (EOA)
- close() and reclaimRemainingMDC() require msg.sender == 0x771375f4696649b59ddcf7111c73a8c0bf03f4b5 (contract) and send the MDC balance (token 0xd6b16067…) to 0x623d3b10…

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The admin closes the campaign, reclaims the MDC and runs a new campaign with a replaceable signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
