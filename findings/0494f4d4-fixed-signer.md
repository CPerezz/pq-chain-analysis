---
id: 0494f4d4-fixed-signer
title: "0x0494f4d4: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0494f4d4811f76654d45b68dd85d1c85e0126f84"
  family: "74648c0504e24ec9db8ed65765280bf3"
  upgradeable: "no"
  rating: LOW
  value_usd: 2705
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "owner 0x4abd…25d1"
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
  rating: LOW
  note: "LOW: the same acts (moving WETH, NFTs and calls) stay open to the owner by direct call; only off-chain 1271 signing is lost."
---

## Summary

A minimal smart wallet: isValidSignature returns the 1271 magic value for hashes signed by the constant 0x4abd…25d1, which is also the only caller allowed for execute() and withdraw(). If that key gets real code, 1271 signatures stop, but the owner still moves everything directly.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: ERC-1271 contract with four selectors answering for a signer that is a constant in its code. Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- heimdall: execute(address,uint256,bytes) and withdraw(uint256) require msg.sender == 0x4abd798b…25d1 ('oo')
- isValidSignature (1626ba7e) compares with the same constant; no setter exists (4 selectors)
- 0x4abd… is an EIP-7702 delegated EOA today (0xef0100…), which still recovers; it holds 1.4992 WETH at 26438999

## Impact and exposure

- Value held at block 26,438,999: $2,705 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None needed: the owner acts via execute().

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
