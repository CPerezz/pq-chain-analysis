---
id: feedistributor-d3cf8528-signed-shortcut-lost
title: "FeeDistributor: signed shortcut lost by users with code"
status: not-affected
severity: NONE
patterns: [PQ-19]
impact: none
contracts:
- address: "0xd3cf852898b21fc233251427c2dc93d3d604f3bb"
  family: "158b7318e5163313f9ad2cdc94b5cfe4"
  copies: 2
  name: "FeeDistributor"
  upgradeable: "no"
  rating: NONE
  value_usd: 11369
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 110
  last_active: 2026-11-16
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
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "Refuted: a signer with code is routed to ERC-1271 (if its code doesn't implement 1271, setOnlyCallerCheck still works directly). Value $11369, txs_90d 110 (not rating inputs)."
---

## Summary

Balancer v2 FeeDistributor: its only signed path, setOnlyCallerCheckWithSignature, goes through SignaturesValidator, which asks ERC-1271 when the account has code. EIP-8151's code-at-signer case never reaches ecrecover. It has no permit.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: permit or an approval by signature: the owner named in the call must equal the recovered address; the holder can call approve itself. Read from source.
- source @balancer-labs/v2-solidity-utils/helpers/SignaturesValidator.sol: if (account.isContract()) return IERC1271(account).isValidSignature(...) else ECDSA
- OptionalOnlyCaller is SignaturesValidator; setOnlyCallerCheck(bool) is also a direct msg.sender call
- the bytecode has no approve/permit selectors (0x095ea7b3/0xd505accf absent); the study's 'permit' reading does not match this contract

## Impact and exposure

- Value held at block 26,438,999: $11,369 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 110 transactions called it in the 90 days before that block; last on 2026-11-16.

## Remediation

None needed; an account with code uses ERC-1271 or the direct call.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
