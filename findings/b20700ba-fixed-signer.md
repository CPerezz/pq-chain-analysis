---
id: b20700ba-fixed-signer
title: "0xb20700ba (tagged deployed by The Everyones: Deployer): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb20700ba8001e94948cfc21fa024eb6eb65ec45c"
  family: "8b1c0c65873ead9957b7c309638e543a"
  label: "deployed by The Everyones: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "Owner: calls setPhase(3) to switch to the public mint, which needs no signature"
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
  rating: MEDIUM
  note: "The study note calls this a presale with deposit and claim, but the source is an NFT allowlist mint. There are no deposits or claims. A third constant (0x14d8...) is not the signer (likely an operator-filter or registry address)."
---

## Summary

The allowlist mint checks signatures against two constant signer addresses. No setter can change them and both have no code today. If a signer key's account gets code, only the allowlist mint stops. Nothing is locked, because the owner can still withdraw and can open the public mint.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- PHASE_1_SIGNER and PHASE_2_SIGNER are declared `public constant`
- isAllowlistedPhase1/2 compare the ecrecover result to these constants, with no code check and no ERC-1271
- Row facts: both constants have code_bytes 0 and delegated false
- withdraw() is onlyOwner and sends the balance to the owner

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner calls setPhase(3) to use the public mint, with setPrice/setMaxPerTx as needed, or uses airdrop() for allowlisted users. Keep the signer keys as plain EOAs.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
