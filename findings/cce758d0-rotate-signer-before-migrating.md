---
id: cce758d0-rotate-signer-before-migrating
title: "0xcce758d0: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xcce758d01775d6c9fc822a4e33b70f019dbdc963"
  family: "777461c44065ed66a9067bd46b330a4d"
  copies: 5
  upgradeable: "no"
  rating: LOW
  txs_90d: 22002
  last_active: 2026-11-18
  recoveries_14d: 5581
fix:
  layer: onchain-config
  who_acts: "DEFAULT_ADMIN_ROLE holder 0xf655…2226"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Anon's rule (2026-11-20): a key that has never sent a transaction is presumed live; inactivity does not show the key is lost. So the party that can rotate the signer or upgrade the code can act: LOW. Earlier doubt: The setter exists, but its only caller is an EOA that has never sent a transaction (nonce 0), so it is not proven live. If that key is lost the rating is MEDIUM: liveness only, deposits are not locked by the signer."
---

## Summary

ERC-4337 paymaster (no source, 5 copies). It checks sponsorship signatures against a signers mapping with plain ecrecover. Under EIP-8151 a signer that gets code stops working until it is replaced.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: paymaster: signers are added and removed by functions. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- addSigner(0xeb12d61e)/removeSigner check AccessControl roles[0].members[msg.sender] (slot 0xad3228b6… = DEFAULT_ADMIN_ROLE) (heimdall pm/decompiled.sol)
- Only RoleGranted events since deploy (block 26399820): DEFAULT_ADMIN_ROLE and MANAGER_ROLE both went to 0xf655f84f…2226; no RoleRevoked (log scan to 26438999)
- 0xf655…2226 at 26438999: nonce 0, no code, not a Safe; hasRole(0)=true

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 5 addresses).
- Activity: 22,002 transactions called it in the 90 days before that block; last on 2026-11-18.
- 5,581 signature recoveries in the study's two-week trace window.

## Remediation

The admin calls addSigner(new EOA) and removeSigner(old) before the signer account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
