---
id: vault-13166407-signature-rechecked
title: "Vault: a signature checked again after others relied on it"
status: not-affected
severity: NONE
patterns: [PQ-15]
impact: none
contracts:
- address: "0x13166407e8738cc6f25844d11c4a431777ac99c9"
  family: "ec3bbcc8509b0b554a6be5a672925a8d"
  copies: 18
  name: "Vault"
  upgradeable: "no"
  rating: NONE
  value_usd: 90
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody"
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
  verdict: refuted
  rating: NONE
  note: "The mechanism is real in the template (a market maker who delivered on the other chain loses when the timeout refund goes to the depositor), but this vault has expired, so EIP-8151 has nothing left to break here."
---

## Summary

BitFi per-trade Vault clone (EIP-1167 to 0xcf9786f1…): settlement() pays the market maker only on a presign by coreAddrs[1] plus an MPC signature by coreAddrs[0], and only before the timeout. This vault's timeout passed in January 2025, so no signature will ever be checked here again.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: per-trade Vault (18 clones): settlement pays out only with a presign of coreAddrs[1] and an MPC signature of coreAddrs[0], both fixed in the vault; after the timeout anyone can send the amount to…. Read by hand.
- Update path, read at block 26,438,999: delegates to a fixed address.
- Vault.sol settlement(): `if (block.timestamp > info.timeout) revert Timeout()`, then signer == coreAddrs[1] (presign) and == coreAddrs[0] (MPC); claim() after the timeout sends the amount to coreAddrs[3] with no signature
- getVaultInfo() at 26438999: timeout 1736505147 (2025-01-10), amount 0.03 ETH, mpc 0x5555…a726 and ephemeral 0x52eb…4de3 are both EOAs (cast code 0x)
- 45-byte minimal proxy to 0xcf9786f123f1071023db8049808c223e94c384be, no upgrade path

## Impact and exposure

- Value held at block 26,438,999: $90 (ETH and 49 priced tokens, over 18 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None needed for this vault: anyone can call claim() to refund the 0.03 ETH to the refund address.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
