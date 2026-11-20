---
id: paymentplanv2logic-a7a9ec4e-signer-upgrade-only
title: "PaymentPlanV2Logic: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xa7a9ec4e3ae6ec0ddb5841acd5164df6f9522516"
  family: "fc7c0b127371423b27634fc8c0200623"
  copies: 4
  name: "PaymentPlanV2Logic"
  label: "deployed by Cyan: Deployer"
  upgradeable: "yes"
  admin: "ProxyAdmin 0x891222addfaf54ab043152e651d7908433941374, owner EOA 0xdF57686394c637e38c05e595DF31c58D25d8e50C"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody: not affected"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signer-upgrade-only"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "This is an implementation no proxy uses, so it holds nothing. The same logic is live behind 0xe803684b, which is upgradeable by a live owner."
---

## Summary

Cyan PaymentPlanV2 implementation (initializers disabled) that delegates to logic 0xac0b1b9b. No proxy uses it: the live Cyan proxy 0xe803684b runs a different implementation, 0x4302e933, which can be upgraded by a ProxyAdmin owned by a live EOA.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: Cyan payment plan: signed by the signer its caller passes, the platform's / Cyan plan revival: signed by the platform signer / Cyan early unwind (OpenSea): signed by the platform signer / Cyan early…. Read from source.
- Update path, read at block 26,438,999: delegates to a fixed address.
- 0xa7a9ec4e: slot0 = 0xff (_disableInitializers), 23874 bytes, code embeds PUSH20 0xac0b1b9b68bd82efbddd7dabae9c517e1240392c (cast code @26438999)
- proxy 0xe803684b9e391d01dc1cdf76bac9ae3a596b2ae0: impl slot = 0x4302e933 (not 0xa7a9), admin 0x891222ad; 0x4302e933 also embeds 0xac0b1b9b @26438999
- ProxyAdmin 0x891222ad owner() = 0xdF576863 (EOA n=981) @26438999; facts: family has 1 'proxy slot, then constant delegate' address (0xe803684b)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None for this address. The live Cyan deployment is fixed by a ProxyAdmin upgrade (LOW).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
