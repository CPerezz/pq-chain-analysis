---
id: 3cd1469d-wallets-fixed-signers
title: "0x3cd1469d: wallet with signers fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x3cd1469dd02062f1b0a48da745db04ed57175b33"
  family: "a01be424e443840f20b437c82d0b7fd4"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 4
  last_active: 2026-11-02
fix:
  layer: none
  who_acts: "any single owner can pause() directly (plain onlyOwner call, unaffected by 8151); only unpause(bytes[]) and enableToken(...) need an ecrecover-verified M-of-N owner signature"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-wallets-fixed-signers"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "refutes the claimed SimpleMultiSig-wallet/HIGH framing; the real mechanism is a fixed-owner signature gate with no funds held here, so rated liveness/MEDIUM rather than funds-locked/HIGH"
---

## Summary

Not a SimpleMultiSig copy -- entirely different selector set (owners()/isOwner/pause()/paused()/enabled(address)/enableToken/unpause(bytes[])/UNPAUSE_TYPEHASH). Fixed owner set (isOwner mapping), no setter found. pause() is a direct onlyOwner call unaffected by EIP-8151; unpause() and enableToken() use ecrecover over an EIP-712 digest and would become permanently unusable once an owner's key stops recovering. No deposit/withdraw/transfer selector found in the 17-selector dispatcher, so this contract does not appear to custody funds itself (likely a pause/allowlist config read by an external bridge/vault).

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- dispatcher (17 selectors): owners/nonce/0xcf9e41ef(enableToken)/0x561e8319(unpause(bytes[]))/0x3079f3c2(UNPAUSE_TYPEHASH)/pause()/enabled(address)/paused()/isOwner/DOMAIN_SEPARATOR -- no execute()/getOwners()/threshold(), i.e. not template 8f5fee6f
- decompile: pause() (selector 0x8456cb59) requires storage_map_e[msg.sender] directly with no ecrecover; unpause/enableToken branch through an ecrecover call over the EIP-712 digest
- no transfer()/withdraw selector present in the dispatcher despite the batch facts.exits lead ['transfer(address,uint256)']
- paused()==false at block 26438999 (cast call)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 4 transactions called it in the 90 days before that block; last on 2026-11-02.

## Remediation

none found (no setter for the owner set); if this gates an external vault that holds user funds, that vault needs its own review

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
