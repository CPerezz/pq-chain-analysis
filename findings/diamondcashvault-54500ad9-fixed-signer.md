---
id: diamondcashvault-54500ad9-fixed-signer
title: "DiamondCashVault: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x54500ad9781070c8da0b215b28f1e37fa644432d"
  family: "ef6872b127c7f784f167c73d65495e9a"
  copies: 19
  name: "DiamondCashVault"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 9
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 20
  last_active: 2026-09-08
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
  note: "Deposits die and nothing is locked, so MEDIUM."
---

## Summary

This is a clone of a fixed implementation where `pricer` is an immutable NAV signer. depositEth needs the pricer's ecrecover signature, so deposits stop once it has code. redeem() is a direct, oracle-free, unpausable call, so holders still exit.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: DiamondCashVault depositEth: the immutable pricer signs the NAV; redeem is a direct, oracle-free call, so only deposits stop (MEDIUM). Read.
- Update path, read at block 26,438,999: delegates to a fixed address.
- EIP-1167 clone of 0x66ff…90c2; `address public immutable pricer`; depositEth: `if (_recover(h, sig) != pricer) revert BadSig()`.
- redeem(shares,minAmounts,to) burns msg.sender's shares and pays pro rata, with no signature.
- pricer 0x5579…d50E has no code; totalSupply is 1e18.

## Impact and exposure

- Value held at block 26,438,999: $9 (ETH and 49 priced tokens, over 19 addresses).
- Activity: 20 transactions called it in the 90 days before that block; last on 2026-09-08.

## Remediation

None for funds; new deposits need a new vault.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
