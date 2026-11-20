---
id: bootstrapballot-1be728c9-fixed-signer
title: "BootstrapBallot: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x1be728c969142beea30201a609df9f3fa4caeef0"
  family: "e75524be0135bb92318fbea121330abb"
  copies: 2
  name: "BootstrapBallot"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "nobody can (no owner/admin on the ballot or Airdrop 2)"
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
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "Airdrop stock the protocol put there, existing authorizations and claims need no signature: MEDIUM. ATTENTION: an airdrop recipient holding an unsubmitted signed voucher loses its allocation, which resembles the 'voucher recipient loses' precedent (CRITICAL); I kept MEDIUM because the scale lists airdrop/claim stock as MEDIUM and nothing the recipient paid is at stake."
---

## Summary

Salty.io BootstrapBallot (redeploy): vote() is emptied, so the only signed path is authorizeAirdrop2, which needs a signature from SigningTools.EXPECTED_SIGNER 0x1234519D… (a library constant) to call airdrop2.authorizeWallet. If that key takes real code, users not yet authorized can never be added to Airdrop 2; their share of its 3M SALT stays in the contract with no rescue.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: SigningTools _verifySignature: EXPECTED_SIGNER, fixed in the code. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source BootstrapBallot.sol + SigningTools.sol: EXPECTED_SIGNER constant, recovered via ECDSA.recover; vote() body commented out; finalizeAirdrop2 is permissionless and unsigned
- Airdrop 2 0x6AA7751A… holds 3,000,000 SALT, claimingAllowed false (cast call at block 26438999); decompiled ABI shows only airdropForUser, allowClaiming, authorizeWallet, claimableAmount, claim, salt and getters, no withdraw/rescue
- supporting only, not relied on (latest, block ~26452910, public RPC; the node timed out): authorizeWallet from the ballot and finalizeAirdrop2 from a stranger both dry-run OK; Airdrop 2 previousDeployment() = 0 (no setter in its ABI)
- EXPECTED_SIGNER 0x1234519d… has no code, nonce 0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None on-chain; anyone can call finalizeAirdrop2 so already-authorized users claim, while missing users would need a new airdrop contract.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
