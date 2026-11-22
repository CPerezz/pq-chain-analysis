---
id: vault-9cde019f-fixed-signer
title: "Vault: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x9cde019f455b9a3c33d95912edceabbe0cad3444"
  family: "55f224ce07ce55357fda99d2adc39cf3"
  name: "Vault"
  label: "Harpie: Vault"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 6419
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Harpie (deployer of a new vault)"
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
  note: "No update path; only recipient rotation dies, and funds still leave through the recipient's direct withdraw, so nothing is locked."
---

## Summary

Harpie Vault (verified source): changeRecipientAddress needs a signature from the immutable serverSigner. If that key takes code, users cannot rotate their recipient; withdrawals by the registered recipient still work.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Vault changeRecipientAddress: signed by serverSigner, fixed in the code. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Selectors: changeRecipientAddress, setupRecipientAddress, withdrawERC20/721, logIncoming*, withdrawPayments; no EIP-1967 slot
- serverSigner is immutable (Vault.sol: recover(...) == serverSigner, no setter); value in runtime code 0x0f68b96058346da4e8e2403a3a0f971897f98916, cast code 0x (EOA)
- Way out without the signature: withdrawERC20/withdrawERC721 by the user's registered recipient (direct call); setupRecipientAddress (one-time) needs no signature

## Impact and exposure

- Value held at block 26,438,999: $6,419 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new vault whose server key can be rotated; existing deposits leave through the registered recipient.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
