---
id: n2merc721ns-833bc44d-fixed-signer
title: "N2MERC721NS: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x833bc44d24afa21a8f9397fbf173f07dd7ea36b3"
  family: "ca275994a876f68e0fe58584491b162a"
  copies: 46
  name: "N2MERC721NS"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 65
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 25
  last_active: 2026-11-12
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
  rating: MEDIUM
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "A fee-waiver function dies and nothing is locked, so MEDIUM, as the row says."
---

## Summary

The clone delegates to a fixed N2M NS implementation where N2M_SIGNER is a constant. Only removeProtocolFee needs that signer alone; signed mints also accept the owner. Funds leave by owner withdraw and affiliateWithdraw without signatures.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: N2M collection: removeProtocolFee needs N2M_SIGNER (fixed in the code); the owner can also sign mints; no funds held, a fee function stops (MEDIUM). Read.
- Update path, read at block 26,438,999: delegates to a fixed address.
- Proxy delegates to the fixed 0x0000…ba1808. Storage.sol: N2M_SIGNER constant 0x0000…6a5ff2cBc9 (no code).
- NSMinting.sol:418 `signer != N2M_SIGNER && signer != owner()`; Common.sol:312 removeProtocolFee requires N2M_SIGNER.
- withdraw() is onlyOwner; owner 0xDc18…3DeA has no code; 0.0204 ETH held.

## Impact and exposure

- Value held at block 26,438,999: $65 (ETH and 49 priced tokens, over 46 addresses).
- Activity: 25 transactions called it in the 90 days before that block; last on 2026-11-12.

## Remediation

None for funds.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
