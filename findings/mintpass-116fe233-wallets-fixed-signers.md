---
id: mintpass-116fe233-wallets-fixed-signers
title: "Mintpass: wallet with signers fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x116fe2334fca73afee28c71f68b3ee6b679858b2"
  family: "c1fe78decb7ae3ba1af51c6e2c8ac9d2"
  name: "Mintpass"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 1805
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "project owner"
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
  note: "No update path for the signer, but nothing is locked: the signed path only authorizes burning passes (redemption), holders keep their passes and can burn them, and the owner withdraws the ETH. MEDIUM (the affected function dies for good). Value $1805, txs_90d 0; value does not lower the rating."
---

## Summary

Mintpass (ERC-1155): useAndBurn lets a contract authorized by an off-chain signature of the constant MSO_SIGNER_WALLET burn holders' passes. No function changes the signer. The sale ETH leaves through owner-only withdraw().

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: Mintpass: signed by MSO_SIGNER_WALLET, fixed in the code. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source contracts/Mintpass.sol: MSO_SIGNER_WALLET = 0xD806dCbC… is a private constant; signatureIsValid uses OZ ECDSA.recover only (no ERC-1271); no proxy (runtime identical to the dossier)
- withdraw() onlyOwner sends the whole balance; owner() = 0x4483793e… (batch facts at 26438999; latest shows a 171-byte contract, likely a Safe proxy); transferOwnership exists for the owner
- MSO_SIGNER_WALLET (latest, block ~26452952; constant): EOA, nonce 0

## Impact and exposure

- Value held at block 26,438,999: $1,805 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new redemption flow or mintpass contract with a replaceable signer or ERC-1271; holders' passes and the sale ETH are unaffected.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
