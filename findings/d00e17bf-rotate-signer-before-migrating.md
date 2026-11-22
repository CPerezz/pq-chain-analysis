---
id: d00e17bf-rotate-signer-before-migrating
title: "0xd00e17bf: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd00e17bfdc40d4bc9e54befd6f646c3e66a50100"
  family: "7b68e6042122e0ce6002b5695b5774c7"
  upgradeable: "no"
  rating: LOW
  txs_90d: 3546
  last_active: 2026-11-18
  recoveries_14d: 505
fix:
  layer: offchain
  who_acts: "the token holder signing the transfer intent (they can also transfer directly)"
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
  note: "LOW holds, but the root issue looks like signed-shortcut-lost rather than a stored key. The recovered address is the end user, while roles only gate the relayer. The decompile is murky, so the main reviewer should check whether any role-held signer is also recovered."
---

## Summary

Unverified relayer contract. 0x2f917b1c (relayed transfer) recovers a user's signature over a transfer intent and is submitted by the ROLE_OWNER holder 0x174ff657…. Under EIP-8151 a user whose address holds non-7702 code can no longer use the signed transfer.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (grantRole, revokeRole). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- txs.json: tx 0x1b89fb41… sent by 0x174ff657… recovered 0x83f20041…, which holds neither DEFAULT_ADMIN nor ROLE_OWNER at block 26438999 (hasRole false/false; EOA, nonce 4). The recovered signer is the user, not a role member
- Creation receipt: RoleGranted(DEFAULT_ADMIN) and RoleGranted(ROLE_OWNER=0x9f4e1c87…) to 0x174ff657…; at block 26438999 hasRole is true for both and 0x174ff… is an EOA with nonce 25172
- Contract ETH balance 0 at block 26438999 (state.json); exits list transfer/transferFrom

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 3,546 transactions called it in the 90 days before that block; last on 2026-11-18.
- 505 signature recoveries in the study's two-week trace window.

## Remediation

None needed in the contract: an affected user moves their tokens with a direct ERC-20 transfer, or keeps a 7702 delegation.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
