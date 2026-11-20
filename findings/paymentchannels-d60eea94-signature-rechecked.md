---
id: paymentchannels-d60eea94-signature-rechecked
title: "PaymentChannels: a signature checked again after others relied on it"
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0xd60eea947aae39e507430b30ce11f142304d9cb1"
  family: "9299c0f31b2483e035bc87f424d5a94f"
  name: "PaymentChannels"
  upgradeable: "no"
  rating: CRITICAL
  value_usd: 6594
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 5589
  last_active: 2026-11-18
  recoveries_14d: 138
fix:
  layer: new-deployment
  who_acts: "SMG operator (new deployment); stakers must not take code while staked"
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
  verdict: confirmed
  rating: CRITICAL
  note: "The relying operator and claimers lose unsettled commitments and there is no update path; the stake itself is also locked (HIGH aspect)."
---

## Summary

SMG PaymentChannels: stakers pay for services with commitments co-signed by the staker and a notary, and the operator collects them later with settleStakeCommitments. If a staker's address takes code, those commitments stop verifying, so the operator and claimers lose unsettled spend, and the staker's own stake is locked because unstake also needs the staker's signature.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: PaymentChannels (newer, 138 recoveries in the window): as the older one: a staker starts or finishes an unstake only with its own ECDSA signature on a commitment; a staker whose account takes code…. Read by hand. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- PaymentChannels.sol:778-782 settleStakeCommitments: ECDSA.recover(...) == commitment.stakerAddress; the notary is checked at 784-788
- startTimelockedUnstake (853-857) and unstake (963-967) also require the staker's own signature, so the 7-day timelock gives no way out without it
- notaries can be rotated (setStakeNotaryAddress/setClaimNotaryAddress, onlyOperator, 642-680); recoverToken covers ERC20 only, not ETH
- 3.654 ETH held at 26438999; 5,589 txs in 90 days, last active 2026-11-18; not a proxy

## Impact and exposure

- Value held at block 26,438,999: $6,594 (ETH and 49 priced tokens).
- Activity: 5,589 transactions called it in the 90 days before that block; last on 2026-11-18.
- 138 signature recoveries in the study's two-week trace window.

## Remediation

Deploy a version that accepts ERC-1271 or a direct call from stakerAddress; until then, settle commitments promptly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry (D-025).
