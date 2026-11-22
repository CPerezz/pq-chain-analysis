---
id: 9f42a800-fixed-signer
title: "0x9f42a800: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x9f42a800c80c18646a9e9e475e6451196e16888e"
  family: "ef2d21577eb11b13fdb59c4c11cfb08f"
  copies: 3
  upgradeable: "no"
  rating: HIGH
  txs_90d: 34
  last_active: 2026-11-17
  recoveries_14d: 4
fix:
  layer: new-deployment
  who_acts: "the signers unlock the vault's funds while at least two keys are EOAs"
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
  note: "A 2-of-3 signer set fixed at construction gates completeUnlock, the only release of the vault's funds; a second key remains while one migrates, but the set can never be replaced, so the funds lock once two keys have code. Same rating as the other fixed-signer wallets and custodians: HIGH."
---

## Summary

Custodian with time-locked unlocks (Gemini-Custodian layout). completeUnlock recovers two signatures and checks both against a signer set of 3 that is fixed at construction (signerSet only has a getter). It releases funds from vault 0xd69b0089… (10,547 ETH), whose custodian is this contract. One signer taking code still leaves two others.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: time-locked vaults; same verdict as 42cce71f. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Creation tx 0xba170cdd… constructor args: primary 0x4c2f150f…, signers 0x7f669bfc…, 0xcf81afeb…, 0x2bdb56ed…; all three have signerSet=true and no code (cast).
- Trace of 0xfe146c18… (completeUnlock): two ecrecovers return 0x7f669bfc… and 0xcf81afeb…, then 0x2c8ef841 on vault 0xd69b… pays 15,000 ETH.
- Vault 0xd69b… has custodian()=0x9f42a800… (slot 1), and its release functions require msg.sender==custodian; the vault balance is 10,547.4 ETH (heimdall decompile, cast).
- No function writes the signer set; the ABI has only signerSet(address) view (heimdall).

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 34 transactions called it in the 90 days before that block; last on 2026-11-17.
- 4 signature recoveries in the study's two-week trace window.

## Remediation

Never let two of the three signer keys take code; migrate custody before the second key does.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
