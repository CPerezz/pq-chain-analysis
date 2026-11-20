---
id: 1bde6436-fixed-signer
title: "0x1bde6436 (tagged deployed by R Planet: Deployer): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x1bde6436f766ae99ca666be34d046fcd26059b78"
  family: "38c76842a920fc0942a16af3dc248f51"
  label: "deployed by R Planet: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 1
  last_active: 2026-09-26
fix:
  layer: new-deployment
  who_acts: "Project owner/operator"
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
  note: "legendaryWallet (code 171 bytes) is only the withdraw/mint recipient, not the signer."
---

## Summary

The signer is a hardcoded constant EOA (code_bytes 0) and nothing can replace it. If that key's account ever gets real code, signed public mints stop working. No funds are locked: withdraw() still works, and owner/crossmint minting does not need the signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- publicKey constant 0x91e5...AB21, code_bytes 0, not delegated
- verifySignedAddress: signer == publicKey, no code check and no ERC-1271
- mint requires verifySignedAddress
- withdraw() onlyOwner sends the balance to legendaryWallet without a signature

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-09-26.

## Remediation

Deploy a new contract (or add a setter for the signer), or move signed minting to the crossmint path, which uses a crossmintAddress the owner can change.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
