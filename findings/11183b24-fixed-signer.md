---
id: 11183b24-fixed-signer
title: "0x11183b24: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x11183b24ebf76eefa7034fee6cc5a926a0dc819d"
  family: "f49dc75c458f8b27bf8e1c07a7052e80"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: offchain
  who_acts: "The owner, who withdraws the funds and pays users by hand; or the signer key, which must stay without code"
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
  note: "The bodies of claim and deposit are truncated in the decompilation. The signature gating is taken from the study note, and the signer address is matched to the decoded constant."
---

## Summary

The signer is a constant in the bytecode and is an EOA today. Nothing can replace it, and there is no code check and no ERC-1271 path. If the key's account gets code, signed deposits and claims stop. The owner can still withdraw all tokens and native coin, so funds are not stuck.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- constant cSigner = 617819881426188475051033623180339925278137581781 = 0x6c38006b1afec828ae73274c31c9b1f8804100d5, verified as an EOA (no code) at block 26438999
- The only setter is transferOwnership(address), which writes the owner in slot 0. No function writes the signer.
- withdraw(address,address): require(owner == msg.sender), then reads balanceOf and does a TransferHelper transfer
- withdrawEmergencyNative(address,uint256): onlyOwner, sends native coin

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Keep the signer key free of code (no real code; a 7702 delegation still works). If signing breaks, the owner withdraws funds with withdraw/withdrawEmergencyNative and settles with users off-chain or through a new deployment.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
