---
id: personalbotvault-8cd055e9-fixed-signer
title: "PersonalBotVault: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x8cd055e9642f92021b75fe3098f6556a89648f98"
  family: "13627ae6d4302ec3107b9e705d2dab5d"
  copies: 12
  name: "PersonalBotVault"
  upgradeable: "no"
  rating: LOW
  value_usd: 1805
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "owner"
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
  rating: LOW
  note: "LOW: the same act (trading and withdrawing) stays open to the owner by direct call; only the off-chain 1271 order signing dies."
---

## Summary

PersonalBotVault: isValidSignature accepts hashes signed by `signer` 0xfEAB…69F6, set in the constructor with no setter, and is used for OpenSea orders. The immutable owner withdraws WETH and NFTs and calls the exchange directly with exchangeOpenSea.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: PersonalBotVault: ERC-1271 accepts hashes signed by `signer`, set in the constructor with no setter (used for marketplace orders); the immutable owner withdraws directly. A signer with code ends the…. Read by hand.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- PersonalBotVault.sol:21 signer, set only in the constructor; :67-71 recover == signer
- withdraw()/withdrawAsset()/exchangeOpenSea() are onlyOwner and need no signature
- signer 0xfEAB…69F6 has no code; owner 0xFFFB…f8DA; row code matches verified 0x6366ee5f… (same length, immutables differ)

## Impact and exposure

- Value held at block 26,438,999: $1,805 (ETH and 49 priced tokens, over 12 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None needed: the owner trades through exchangeOpenSea, for example by validating orders on-chain.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
