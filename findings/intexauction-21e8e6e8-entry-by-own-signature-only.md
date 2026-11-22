---
id: intexauction-21e8e6e8-entry-by-own-signature-only
title: "IntexAuction: entry only by one's own signature"
status: confirmed
severity: LOW
patterns: [PQ-21]
impact: liveness
contracts:
- address: "0x21e8e6e810fd86f99fcd87d515e2311b8bf4d670"
  family: "aabff2d6b82b17aeadcedfaf193b379d"
  copies: 2
  name: "IntexAuction"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 41
  last_active: 2026-10-06
fix:
  layer: offchain
  who_acts: "the bidder (bid from an EOA)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-entry-by-own-signature-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Entry only: the bond a code-holding bidder posts is recoverable without a signature (24h delay at worst). Missing read (node timed out, not decisive): cast nonce / hasRole(DEFAULT_ADMIN_ROLE) for admin 0xd01f5a8761f388797429c8c4957d9559ffde8b96 at 26438999."
---

## Summary

IntexAuction implementation (proxy 0x424d6f84...): revealBid needs the bidder's own EIP-712 signature (signer == msg.sender). A bidder with code can commit but cannot reveal.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: IntexAuction _verifyRevealSignature: the caller reveals its own committed signature; a caller with code cannot. Read (function text).
- IntexAuction.sol L297-321: commitBid needs no signature and locks a commit bond in escrow
- L324 cancelCommit (commit window) and L445 claimCommitBond (after revealEnd + 24h UNREVEALED_BOND_LOCK_PERIOD) return the bond with no signature, so nothing is forfeited
- Proxy 0x424d6f84adeca707b231b11b3b11897feb239e3f points at 0x21e8 (EIP-1967 slot); RoleGranted log: DEFAULT_ADMIN_ROLE to 0xd01f5a8761f388797429c8c4957d9559ffde8b96 (UUPS _authorizeUpgrade onlyRole DEFAULT_ADMIN_ROLE)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 41 transactions called it in the 90 days before that block; last on 2026-10-06.

## Remediation

None needed; bidders use EOAs. A contract bidder gets its bond back via claimCommitBond after 24h.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
