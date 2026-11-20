---
id: 3cd11ab1-signed-shortcut-lost
title: "0x3cd11ab1 (tagged deployed by DINNGO: Deployer): signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x3cd11ab189af4f9b627547283f03e73ede433127"
  family: "b18eec72278a78a2c918c1f792da56aa"
  label: "deployed by DINNGO: Deployer"
  upgradeable: "no"
  rating: LOW
  txs_90d: 0
fix:
  layer: none
  who_acts: "affected users (withdraw via lock() + withdraw/withdrawToken)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signature-rechecked"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "A user's signed orders and withdrawals stop once the user's account has code, but the same exit stays open by direct call (lock, then withdraw or withdrawToken by msg.sender): LOW under the signed-shortcut root issue, not a recheck that costs anyone money."
---

## Summary

Not a BitFi Vault, and not a drainer: this is the DINNGO exchange (deployer is labelled DINNGO). The names OwnerTransfer…, transfer_attention_tg… and unlock are selector-database collisions. 0x39bc1afe and 0x49fa92cb check that ecrecover(sig) equals the registered user ("sig failed" / "nonce invalid"); these are the user's signed orders and withdrawals, which the operator submits later. A user whose account gets non-7702 code can no longer get signed orders or withdrawals through. Their funds still leave by another path: lock() (0xf83d08ba), wait for the timer, then withdraw(uint256) or withdrawToken (0x9e281a98), both by msg.sender with no signature.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: per-trade Vault (18 clones): settlement pays out only with a presign of coreAddrs[1] and an MPC signature of coreAddrs[0], both fixed in the vault; after the timeout anyone can…. Same code idiom as template ec3bbcc8, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- decompile: require(user[...] == ecrecover(...), "sig failed") in 0x39bc1afe and 0x49fa92cb
- decompile: withdraw(uint256) and 0x9e281a98 pay msg.sender after block.timestamp passes the lock set by 0xf83d08ba; no signature needed
- cast balance = 0 ETH and USDT balanceOf = 0 @26438999; ecrecover forwards all gas

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

An affected user exits with lock() and then withdraw/withdrawToken.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: the review found that root issue `eip-8151-signed-shortcut-lost` applies, not `eip-8151-signature-rechecked`; filed under it.
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
- 2026-11-20: the same contract was also a row of triage entry `eip-8151-fixed-signer`; its reading as a fixed signer was wrong: each order is signed by its own user, who can also exit directly (D-025).
