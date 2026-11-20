---
id: a0a1b0a2-fixed-signer
title: "0xa0a1b0a2: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xa0a1b0a2a2737f521edd31530d9f2481fd399633"
  family: "e3f522c3cf2350c34948b5a400b1c7ee"
  upgradeable: "no"
  rating: HIGH
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The owner of the signer key 0x820a... (keep it free of non-7702 code). Otherwise the operator must deploy a new contract, but USDT already deposited cannot be recovered."
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
  note: "Another address, 0x0081a996f71d46f98538eda45a32ed2121807344 (an EOA), also appears in the bytecode. Its role is not visible in the decompilation, and it does not change the verdict."
---

## Summary

The signer is a hard-coded constant EOA with no setter, no code check and no ERC-1271 path. Signed withdrawal is the only way user-deposited USDT can leave, and there is no rescue function. If the signer account gets real code, all deposits are locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- The constant Finance_Manager = 0x820adcee9b6ad12359543e13d0881de0728dbe9f has no code today (code_bytes 0, not delegated).
- In 0x737a9ed6 the recovered address is compared to 0x820a... with the message "Invalid signature", followed by the "Deadline expired" check. The function then transfers USDT to msg.sender and emits Withdrawal.
- deposit(uint256) (0xb6b55f25) calls transferFrom on USDT 0xdac17f... to pull funds from msg.sender. It is not gated by a signature.
- The only other functions are transferOwnership and renounceOwnership. Neither moves tokens or changes the signer.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Keep the Finance_Manager key as an EOA or a 7702-delegated account. A future version should have a signer setter, ERC-1271 support, or an owner/user rescue path.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
