---
id: argentmodule-9d587793-rotate-signer-before-migrating
title: "ArgentModule: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x9d58779365b067d5d3fcc6e92d237acd06f1e6a1"
  family: "47e240776c35d767c057c558e132ca49"
  copies: 2
  name: "ArgentModule"
  label: "Argent: Argent Module"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1703
  last_active: 2026-11-18
  recoveries_14d: 259
fix:
  layer: account-migration
  who_acts: "each Argent wallet's owner (with guardians), or the guardians via recovery"
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
  note: "LOW holds by the account's own action: owner rotation, or guardian recovery as a fallback."
---

## Summary

Argent module. Relayed execution validates the wallet owner's signature and then guardian signatures; owner and guardians are kept per wallet. Under EIP-8151 an owner key that takes non-7702 code can no longer sign relayed actions for its wallet.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Argent module validateSignatures: the wallet owner's signature first when required, then guardians'; owner and guardians are kept by the wallet and the guardian storage / Argent module session: the…. Read from source. Executed: a real transaction reverts with code at the signer.
- SecurityManager.sol:172 transferOwnership(wallet,newOwner) is onlySelf (relayed, signed by owner plus guardians as required) and calls IWallet.setOwner
- SecurityManager.sol:127/140: guardians can executeRecovery and, after the delay, finalizeRecovery sets a new owner. RelayerManager.validateSignatures:263 checks the owner, then guardians
- Per-account design: there is no global admin key; each wallet's key holder rotates its own key

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1,703 transactions called it in the 90 days before that block; last on 2026-11-18.
- 259 signature recoveries in the study's two-week trace window.

## Remediation

The wallet owner calls transferOwnership to a fresh EOA before migrating, or the guardians run recovery.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
