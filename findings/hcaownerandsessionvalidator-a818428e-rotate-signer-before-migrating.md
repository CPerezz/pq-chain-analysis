---
id: hcaownerandsessionvalidator-a818428e-rotate-signer-before-migrating
title: "HCAOwnerAndSessionValidator: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xa818428ed2f3f949bdc71b8a15bdd7b5d27ce938"
  family: "cb5932cdd1eda7f1022f87c0dfb1621c"
  name: "HCAOwnerAndSessionValidator"
  label: "ENS: HCA Owner And Session Validator"
  upgradeable: "no"
  rating: LOW
  txs_90d: 8128
  last_active: 2026-11-18
  recoveries_14d: 6647
fix:
  layer: account-migration
  who_acts: "each HCA account's owner, acting before its key takes code"
evidence:
  level: source-read
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
  note: "The owner key itself cannot be rotated in the registry, but the per-account escape (install another validator) is open to the key holder, so LOW holds."
---

## Summary

ENS HCA validator module: every owner and session check is ecrecover against the owner the calling account reports (ownerAndSessionNonce), with no ERC-1271. An owner key that takes code can no longer authorize.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: HCA validator module ERC-1271: the signer must be the owner that the calling account itself reports (ownerAndSessionNonce), or a session is validated / HCA validator module: the session key named in…. Read from source. Executed: a real transaction reverts with code at the signer.
- HCAOwnerAndSessionValidator.sol:238-240 recover(hash,data) != _ownerAndSessionNonce(msg.sender) → revert; no 1271 call to the owner
- sample account 0xb1c9e5ca…d425 (caller in tx 0x891c64…63b6): owner 0x59a358c1…acb5 comes from OWNER_REGISTRY 0x742bf218…e561, which has no owner-change function (decompiled ABI: deploy, setImplementationApproval, hcaOwners, authorizedOwnerOf)
- account impl 0x116f462f…c4f4 exposes installModule 0x9517e29f / uninstallModule 0xa71763a8 and UUPS upgrade, so the owner can install another validator while it is still an EOA

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 8,128 transactions called it in the 90 days before that block; last on 2026-11-18.
- 6,647 signature recoveries in the study's two-week trace window.

## Remediation

Before migrating, the owner installs a different validator module (or upgrades to an approved implementation) through its account.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
