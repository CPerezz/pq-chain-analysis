---
id: a333f972-fixed-signer
title: "0xa333f972 (tagged deployed by Mendel: Deployer): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xa333f9722b4980f4aca6e897f97193b25a719bf5"
  family: "a420f10eed75cac6c2adb526e1ad4c67"
  copies: 2
  label: "deployed by Mendel: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 25
  last_active: 2026-11-01
fix:
  layer: new-deployment
  who_acts: "Project owner (switch to public sale or redeploy for allowlist/free mints)"
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
  note: "The study note calls this a presale with deposit and claim, but it is actually an NFT signed-mint contract. It holds no user deposits waiting on a signature."
---

## Summary

I confirmed the finding. The signer is a hard-coded constant that the code cannot replace, and that address has no code today, so it is a plain EOA. If it ever got code, signed free mints and presale mints would stop working. Nothing is locked: payees can still withdraw through release(), and public mint doesn't need a signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- The signer is declared `address constant signer = 0x6a6b...3c42`, and the measured code_bytes for that address is 0.
- _verifySignature compares the result of ECDSA.recover with `signer` and has no ERC-1271 or code check.
- freeMint and presaleMint both require _verifySignature.
- No function sets the signer, and the contract is not upgradeable.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 25 transactions called it in the 90 days before that block; last on 2026-11-01.

## Remediation

The signer can't be changed in this contract, so the fix is a new deployment. The owner can call setMintDay(PUBLIC) so people can still mint, or redeploy with a signer that can be replaced or that accepts ERC-1271 signatures.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
