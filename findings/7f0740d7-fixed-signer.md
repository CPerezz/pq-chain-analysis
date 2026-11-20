---
id: 7f0740d7-fixed-signer
title: "0x7f0740d7: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x7f0740d7ff721758303869c542379e26e5050df8"
  family: "f767b566d94bbf9299c2c6f38b528814"
  copies: 3
  upgradeable: "no"
  rating: HIGH
  value_usd: 2070
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the wallet's signers move the funds out while enough keys are EOAs"
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
  rating: HIGH
  note: "Older BitGo-style wallet (3 copies): caller signer plus one recovered signer, three fixed signers with no setter. The set can never be replaced, so the owners' funds lock once the keys migrate. Same rating as the other fixed-signer wallets: HIGH."
---

## Summary

An older BitGo-style multisig (3 copies): three fixed signers (no setter), caller signer plus one recovered signer. One key with code leaves two.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: BitGo pattern (isSigner, signers). Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- signers(0..2): 0x023D…17F5, 0x45fF…8764, 0xf55a…50AF, all without code
- Selectors include isSigner, safeMode, getNextSequenceId; none sets signers
- balance 0.5 ETH; 5 historic recoveries

## Impact and exposure

- Value held at block 26,438,999: $2,070 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Keep two keys without real code, or move the funds first.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
