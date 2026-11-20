---
id: foreignbridgeerctoerc-125ab2ca-rotate-signer-before-migrating
title: "ForeignBridgeErcToErc: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x125ab2ca5071b60433d90bce2dfc8e1e83adad2b"
  family: "5193733693f25da9a6dfd9b866a02f71"
  copies: 4
  name: "ForeignBridgeErcToErc"
  upgradeable: "yes"
  admin: "0x2578ed7f82494be69bdd517abf87e5f2c14ae650 (EOA)"
  rating: LOW
  value_usd: 573670
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 3
  last_active: 2026-09-29
fix:
  layer: contract-upgrade
  who_acts: "upgradeabilityOwner of the bridge proxy (EOA 0x2578…e650)"
evidence:
  level: source-read
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
  note: "Live update path: the funded copy is a proxy upgradeable by an EOA. The validator contract's owner() at the block could not be read (node timeouts), and the upgrade path is enough for LOW. The Upgraded-log scan for the other proxy copy covered blocks 13153934–16153934 only and was stopped on the reviewer's instruction."
---

## Summary

Implementation of the POA ForeignBridgeErcToErc. At this address it is uninitialised (owner, validatorContract and erc20token are 0; isInitialized false) and holds nothing. The funded copy is the EternalStorage proxy 0xe470198c…5917 (implementation() = this address; 361,357 USDT at block), whose release signatures come from validator contract 0x644e3cbc…492b.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: POA/Gnosis bridge: requiredSignatures distinct signers that the validators contract accepts (isValidator); the set is kept and changed in that other contract (not read here). Read from source.
- Before the node saturated, at block 26438999: this address had owner()=0, validatorContract()=0, isInitialized()=false, 0 ETH and none of the 49 priced tokens
- Upgraded(uint256,address indexed impl=this) log at block 13153936 from proxy 0xe470198cda121da5b6ad349d3577b166e5985917. At block 26438999: implementation()=0x125a…, upgradeabilityOwner()=0x2578ed7f82494be69bdd517abf87e5f2c14ae650, owner()=0x2c1686fb…9ec0, validatorContract()=0x644e…492b, requiredSignatures()=1, erc20token()=USDT, 361,356.5 USDT
- 0x2578…e650 has no code, nonce 5, and 0x2c16…9ec0 has no code, nonce 23 (latest, block ~26452988, publicnode)

## Impact and exposure

- Value held at block 26,438,999: $573,670 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 3 transactions called it in the 90 days before that block; last on 2026-09-29.

## Remediation

The proxy's upgradeabilityOwner upgrades, or the validators-contract owner replaces a validator that took code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
