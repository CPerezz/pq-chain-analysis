---
id: 02f1fa8b-rotate-signer-before-migrating
title: "0x02f1fa8b: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x02f1fa8b196d21c7b733eb2700b825611d8a38e5"
  family: "1ab8ae0f47a1dc8f7a09cead8d1e746d"
  copies: 2
  upgradeable: "yes"
  admin: "ProxyAdmin 0xb819692a58db9dd4d3b403a875439b6ca155c610 owned by EOA 0x7747940aDBc7191f877a9B90596E0DA4f8deb2Fe"
  rating: LOW
  txs_90d: 1798
  last_active: 2026-10-30
fix:
  layer: onchain-config
  who_acts: "owner EOA"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Ownership is transferable by the live EOA owner, which also controls the ProxyAdmin."
---

## Summary

Transparent proxy (impl 0x2f67d98b…316d) whose signature check expects the owner; an owner with code would no longer be recovered.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one address in storage and the only such address the code names is its owner, which can be handed over (acceptOwnership, renounceOwnership, transferOwnership). Rule: stored-key (the owner).
- impl decompile: Ownable2Step; transferOwnership 0xf2fde38b requires msg.sender==owner, acceptOwnership by pendingOwner
- eth_call at block 26438999: transferOwnership from owner 0x7747…b2Fe succeeds, from 0xdead reverts 'Ownable: caller is not the owner'
- owner 0x7747940aDBc7191f877a9B90596E0DA4f8deb2Fe is an EOA, nonce 2269 (probe); ProxyAdmin 0xb819692a…c610 (EIP-1967 admin slot) has owner()=the same EOA

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1,798 transactions called it in the 90 days before that block; last on 2026-10-30.

## Remediation

Owner hands ownership to a plain key (two steps), or upgrades through ProxyAdmin.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
