---
id: fairxyzdeployer-ca448190-rotate-signer-before-migrating
title: "FairXYZDeployer: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xca44819097bc0d4d385e83e9e0708d92a979b6e6"
  family: "af121be130519feca087249f60c10b19"
  copies: 841
  name: "FairXYZDeployer"
  upgradeable: "no"
  rating: LOW
  value_usd: 3248
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1348
  last_active: 2026-11-17
fix:
  layer: onchain-config
  who_acts: "FairXYZ wallets owner 0x1075266C…DBb7 (EOA)"
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
  note: "Shared signer registry with an owner-only setter, live EOA."
---

## Summary

FairXYZDeployer clone: mint and overrideVariables need signatures from the platform signer read from interfaceAddress.viewSigner().

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: FairXYZ overrideVariables: signed by the platform signer the deployer reports / FairXYZ mint: signed by the platform signer; the caller must be the transaction's origin. Read from source.
- FairXYZDeployer.sol:142/267 recover == viewSigner(); interfaceAddress() = 0x96fC21Ef…6866; viewSigner = 0xb403d779…
- heimdall on 0x96fC21Ef: changeSigner(address) requires msg.sender == owner
- wallets owner() = 0x1075266C86Cd9b1B021Af63e09102AF3D2DCBDb7, no code, nonce 422

## Impact and exposure

- Value held at block 26,438,999: $3,248 (ETH and 49 priced tokens, over 841 addresses).
- Activity: 1,348 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

The FairXYZ wallets owner calls changeSigner.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
