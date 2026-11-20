---
id: spotfeed-77e16844-fixed-signer
title: "SpotFeed: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x77e1684402869bf2b7c70b8bf21e1c7ca7104951"
  family: "e99e561c14a946cda63bf64e09178a6a"
  name: "SpotFeed"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 823
  last_active: 2026-11-18
  recoveries_14d: 47
fix:
  layer: new-deployment
  who_acts: "the feed's operator deploys a new feed; consumers switch to it"
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
  note: "A price feed whose only updater is a fixed key with no setter: once that key has code the feed stops for good, and the feed itself holds nothing, so only a function stops: MEDIUM. Whether its consumers can switch feeds, or lock funds on a stale price, was not traced and belongs to the consumer."
---

## Summary

SwarmFeed SpotFeed, the same SwarmFeed.sol as 0x070e…: only the immutable attester 0x5598aa91… (no code) can update it, and there is no fallback.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: SwarmFeed: the attestation must be signed by `attester`, fixed in the code / SwarmFeed._recover: returns the signer. Read from source. Executed: a real transaction loses its effect with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- SwarmFeed.sol is identical to the 0x070e… dossier (diff); attester() = 0x5598…, which has no code
- isStale() = true at block 26438999
- feed holds 0 ETH

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 823 transactions called it in the 90 days before that block; last on 2026-11-18.
- 47 signature recoveries in the study's two-week trace window.

## Remediation

Redeploy the feeds and vault with a new attester.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
