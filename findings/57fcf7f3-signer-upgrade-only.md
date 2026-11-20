---
id: 57fcf7f3-signer-upgrade-only
title: "0x57fcf7f3: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x57fcf7f386bb815fc3269d391783f028e1dec275"
  family: "d481b70522745e6a14b1be35264517e4"
  copies: 3
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "token holders"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signer-upgrade-only"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "Refuted: no fixed signer; the signed act is a shortcut, and the same act stays open by a direct call."
---

## Summary

ERC-865 token: the pre-signed transfer/approve functions recover the holder ('from') or spender named in the call, not a stored key; holders can still call transfer, approve and transferFrom directly.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (proxy). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- 5 ecrecover sites (0x1296830d, 0x617b390b, 0xbca50515, 0xf2959d6e, 0xf80801d0) use the recovered address as from/spender ('Invalid from address recovered') (decompile of the code read at the latest block, ~26452927)
- direct transfer 0xa9059cbb, approve 0x095ea7b3 and transferFrom 0x23b872dd are present (same decompile)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Holders call transfer/approve/transferFrom directly

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
