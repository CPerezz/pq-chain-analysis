---
id: ethen-f4c27b8b-signed-shortcut-lost
title: "Ethen: signed shortcut lost by users with code"
status: confirmed
severity: MEDIUM
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xf4c27b8b002389864ac214cb13bfeef4cc5c4e8d"
  family: "778c4d91dfa2cc561e516cbb975c743b"
  name: "Ethen"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 78318
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 9
  last_active: 2026-10-29
fix:
  layer: none
  who_acts: "trader; owner for the signer"
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
  rating: MEDIUM
  note: "Withdrawal is direct and the platform signer can be rotated, but trading has no direct path for a trader with code: MEDIUM (function dies, nothing locked)."
---

## Summary

Ethen exchange: trades need the trader's order signature and the platform signer's signature; setCoeff needs the platform signer. A trader with code can no longer trade; deposits and withdrawals are direct.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Ethen setCoeff: signed by `signer`, the platform's stored address / Ethen trade: signed by `signer` / Ethen order: the trader named must have signed. Read from source.
- Ethen.sol:360-379 depositEther/withdrawEther/depositToken/withdrawToken by msg.sender
- Ethen.sol:423 trade: order owners must have signed; there is no on-chain order
- Ethen.sol:270 setSigner onlyOwner; owner 0x8A1fF1F8a84C78D89cbC3D2Fd4e6442e68aF4A9b is an EOA (nonce 58, no code at block 26438999)

## Impact and exposure

- Value held at block 26,438,999: $78,318 (ETH and 49 priced tokens).
- Activity: 9 transactions called it in the 90 days before that block; last on 2026-10-29.

## Remediation

Traders withdraw directly; the owner rotates a broken platform signer with setSigner.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
