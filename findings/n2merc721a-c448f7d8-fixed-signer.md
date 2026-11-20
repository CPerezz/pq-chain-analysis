---
id: n2merc721a-c448f7d8-fixed-signer
title: "N2MERC721A: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc448f7d8745e6bc30bb2b54ffdc1b8f9534d2c6b"
  family: "82ef4795d9a1a7933140d72f821fa736"
  copies: 897
  name: "N2MERC721A"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 92
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 6
  last_active: 2026-09-25
fix:
  layer: none
  who_acts: "none"
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
  rating: MEDIUM
  note: "Only the fee-waiver function dies and nothing is locked, so MEDIUM. The row's HIGH is not supported."
---

## Summary

The clone delegates to a fixed N2M implementation where N2M_SIGNER is a constant. With code there, removeProtocolFee (an optional fee waiver) dies. mintWhitelist still accepts the collection owner's signature. Funds leave by owner withdraw/withdrawERC20 and affiliateWithdraw, none of which needs a signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: N2M removeProtocolFee: signed by N2M_SIGNER, fixed in the code / N2M mintWhitelist (variant): signed by the platform signer fixed in the code, or the owner. Read from source.
- Update path, read at block 26,438,999: delegates to a fixed address.
- Proxy 0x3d3d…: EIP-1167-style clone of 0x0000…a492d5 (no upgrade). Storage.sol: `address internal constant N2M_SIGNER = 0x0000…6a5ff2cBc9`, which has no code.
- Common.sol removeProtocolFee: `if (signer != N2M_SIGNER) revert`; ConsecutiveMinting mintWhitelist: `signer != N2M_SIGNER && signer != owner()`.
- withdraw()/withdrawERC20 are onlyOwner; affiliateWithdraw is callable by the affiliate. Owner 0x06c9…764d has no code; 0.015 ETH held.

## Impact and exposure

- Value held at block 26,438,999: $92 (ETH and 49 priced tokens, over 897 addresses).
- Activity: 6 transactions called it in the 90 days before that block; last on 2026-09-25.

## Remediation

None for funds; the owner signs whitelist mints itself.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
