---
id: channelhub-1a2f7501-signature-rechecked
title: "ChannelHub: a signature checked again after others relied on it"
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0x1a2f750170474d4c54f8d318d9d4343588b4c4d1"
  family: "9f007ee7a41b54e354830914447c53e6"
  name: "ChannelHub"
  upgradeable: "no"
  rating: CRITICAL
  value_usd: 200
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 3
  last_active: 2026-10-22
fix:
  layer: new-deployment
  who_acts: "users checkpoint their latest states on chain while NODE is still an EOA; the operator moves to a new deployment"
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
  rating: CRITICAL
  note: "Channel states are co-signed by the immutable NODE and checked again when a user challenges with a newer state; once NODE's account has code, a user holding a newer co-signed state (payments received) can only exit on the older stored state and loses the difference, though the user did nothing. No update path: CRITICAL, filed under the signature-rechecked root issue."
---

## Summary

NODE is an immutable with no upgrade path. With code at NODE, registerNodeValidator fails, and so does every node co-signature checked by the default validator (all ECDSA validators are pure). Users still exit without the node: challengeChannel with the stored state needs only the user's signature, then closeChannel after the timeout; the node withdraws by direct call.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: ChannelHub registerNodeValidator: needs a signature of NODE, an immutable; channels verify through registered validators; only new registrations stop (MEDIUM). Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Sourcify ChannelHub.sol: `address public immutable NODE`; registerNodeValidator calls EcdsaSignatureUtils.validateEcdsaSigner(…, NODE) with no code check; _validateSignatures validates nodeSig against NODE.
- challengeChannel accepts candidate.version == lastState.version without _validateSignatures and checks only the challenger's signature; closeChannel path 1 pays the stored allocations after the expiry.
- withdrawFromNode is gated by msg.sender == NODE (direct call); NODE 0xBffa…CCB6 has no code at block 26438999.
- DEFAULT_SIG_VALIDATOR 0x98de…bf8E and validator 1 at 0x8C00…2cC are pure ECDSA (selectors 0x600109bb/0xb0a14136 are pure; no 1626ba7e).

## Impact and exposure

- Value held at block 26,438,999: $200 (ETH and 49 priced tokens).
- Activity: 3 transactions called it in the 90 days before that block; last on 2026-10-22.

## Remediation

Before migrating NODE: close or checkpoint channels cooperatively and register an ERC-1271-capable validator; otherwise deploy a new hub.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: the review found that root issue `eip-8151-signature-rechecked` applies, not `eip-8151-fixed-signer`; filed under it.
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry (D-025).
