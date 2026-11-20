---
id: accredifymultisigdocstore-d44b18d2-wallets-fixed-signers
title: "AccredifyMultiSigDocStore: wallet with signers fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd44b18d21ac6ffdcb835d496ee5184a5274d47db"
  family: "9034690620f82bb24d45bf05d66f76a9"
  copies: 93
  name: "AccredifyMultiSigDocStore"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 123
  last_active: 2026-11-17
  recoveries_14d: 8
fix:
  layer: new-deployment
  who_acts: "Accredify (custodian signers[2] plus signers[1])"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-wallets-fixed-signers"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "No update path for the signer set; if signers[0] gets code, issuing and revoking die for good, but nothing is locked and signers[1] can still move the store to a new owner: function dies, no money by design = MEDIUM."
---

## Summary

AccredifyMultiSigDocStore issues and revokes certificate hashes on a DocumentStore it owns. The signers are fixed (signers[0] for issue/revoke, signers[1] for transfer/changeStore) and the contract holds no money.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: Accredify document store multisig: the custodian submits, and a signature must recover to signers[0] (issue, revoke) or signers[1] (change store); the three signers are set in the constructor with no…. Read by hand. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- dossier source: signers[] set in the constructor only; onlyCustodian (signers[2]) plus ecrecover == signers[0] (issue/bulkIssue/revoke/bulkRevoke) or signers[1] (transfer/changeStore); the fallback reverts (no funds)
- documentStore() = 0xA46A9196… ("Civil Aviation Authority of Singapore"), owner() = this contract; balance 0 (latest)
- Signers 0xC53C130D81898B9B26D81dBD393A7b33dCace53D, 0x6755A9ce28225E01242d8fa4Cf18F53a74631b56, 0x01b2156C5BeE35503923c9b712d7C08B88e828f9: EOAs (latest, block ~26452917)
- value_usd None, txs_90d 123, last_active 2026-11-17 (row)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 93 addresses).
- Activity: 123 transactions called it in the 90 days before that block; last on 2026-11-17.
- 8 signature recoveries in the study's two-week trace window.

## Remediation

While signers[1] is still an EOA, transfer the DocumentStore ownership to a new multisig with replaceable or PQ-ready signers.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
