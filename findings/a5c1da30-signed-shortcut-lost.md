---
id: a5c1da30-signed-shortcut-lost
title: "0xa5c1da30 (tagged deployed by DINNGO: Deployer): signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xa5c1da300ddb955b3b9c6a175e9c67b0ff84c7df"
  family: "251c52993d9f16e42286edd1797aa2cb"
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

Not a BitFi Vault, and not a drainer: this is a second DINNGO exchange version (same logic as 0x3cd11ab1, with different storage layout and constants). User-signed orders and withdrawals are checked with ecrecover against the registered user. A user whose account gets non-7702 code loses the signed paths but keeps the signature-free exit: lock(), then withdraw(uint256) or withdrawToken (0x9e281a98) by msg.sender after the timer.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: per-trade Vault (18 clones): settlement pays out only with a presign of coreAddrs[1] and an MPC signature of coreAddrs[0], both fixed in the vault; after the timeout anyone can…. Same code idiom as template ec3bbcc8, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- decompile diff vs 0x3cd11ab1: same functions, only constants and slot names differ
- decompile: 0x9e281a98 checks only msg.sender's lock timestamp and balance, then transfers the token
- cast balance 0 ETH and USDT balanceOf 0 @26438999; ecrecover forwards all gas

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
