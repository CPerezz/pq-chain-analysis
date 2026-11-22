---
id: stethtarget0-d7e47004-signed-shortcut-lost
title: "StETHTarget0: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xd7e470043241c10970953bd8374ee6238e77d735"
  family: "ba2762fbb52d3318e8c7fdb1d43fc341"
  copies: 2
  name: "StETHTarget0"
  upgradeable: "no"
  rating: LOW
  value_usd: 41505
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: offchain
  who_acts: "the holder"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Signed shortcut whose act stays open by a direct call for the same party → LOW. value $41505, txs_90d 0."
---

## Summary

Hyperdrive stETH pool target: permitForAll sets operator approval by signature; under EIP-8151 an owner with code cannot use it.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Hyperdrive permitForAll: the owner named must have signed. Read from source.
- permitForAll: ecrecover(structHash) must equal owner, no ERC-1271 (HyperdriveMultiToken.sol:~195-243)
- setApprovalForAll(operator,approved) sets _isApprovedForAll[msg.sender] directly (HyperdriveTarget0.sol:157)
- setApproval per token also direct (HyperdriveTarget0.sol:171)

## Impact and exposure

- Value held at block 26,438,999: $41,505 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner calls setApprovalForAll / setApproval itself.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
