---
id: m4arena-afbfd4e7-signature-rechecked
title: "M4Arena: a signature checked again after others relied on it"
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0xafbfd4e71045a12ee032848d9f965efc16a7d2af"
  family: "33633495414af9738c8ea75b5a8086b3"
  name: "M4Arena"
  label: "deployed by M4 Rabbit: Deployer"
  upgradeable: "no"
  rating: CRITICAL
  txs_90d: 18
  last_active: 2026-11-17
  recoveries_14d: 40
fix:
  layer: new-deployment
  who_acts: "players (fight on chain with commit/reveal); owner (redeploy)"
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
  note: "A wrong verdict (an unprovable cheat) is possible and there is no update path. Narrow window: keys are per fight, and on-chain play limits the loss to the replayed outcome."
---

## Summary

M4Arena: two players stake an entry, play turns signed by per-fight browser keys (keyA/keyB), and settle, dispute or proveCheat later from those signatures. If a side's key address takes code, the opponent cannot settle from the turns it holds or prove that side's cheat, so a cheat goes unpunished and the on-chain result can differ from the signed play.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: a game settled by co-signed turns: each side registers a key for the fight; _cheat (read) makes a side lose when it signed a seal other than the one on chain, and _replay needs both sides' signatures…. Read by hand.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- M4Arena.sol:477-493 _replay: _signedBy(digest, sigA, keyA) and (sigB, keyB) for every turn; used by settle and dispute
- M4Arena.sol:535-543 _cheat: the side's own seal signature by keyA/keyB is the evidence; it fails if the key has code
- commit/reveal/timeout (300-363) let wallets finish on chain without key signatures; owner 0xbeed…f9ee2 can only pause and set entries (no upgrade); 18 txs in 90 days

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 18 transactions called it in the 90 days before that block; last on 2026-11-17.
- 40 signature recoveries in the study's two-week trace window.

## Remediation

Redeploy with a code check on keys or an ERC-1271 path; players can still finish on chain by commit/reveal.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry (D-025).
