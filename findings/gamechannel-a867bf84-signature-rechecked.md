---
id: gamechannel-a867bf84-signature-rechecked
title: "GameChannel: a signature checked again after others relied on it"
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0xa867bf8447ec6f614ea996057e3d769b76a8aa0e"
  family: "47d929d2374952952f8869e62b148cca"
  copies: 2
  name: "GameChannel"
  upgradeable: "no"
  rating: CRITICAL
  value_usd: 212
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 458
  last_active: 2026-09-09
fix:
  layer: new-deployment
  who_acts: "Dicether (new deployment); players end sessions while the server key is an EOA"
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
  note: "The player's only proof of a session's result is the server-signed state (userEndGameConflict -> verifySig against the constructor-set serverAddress, no setter); without it, userCancelActiveGame then userForceGameEnd settle from the last on-chain state, so a player who did nothing loses the session's winnings: CRITICAL."
---

## Summary

Dicether GameChannel: game states signed by the server and the player are checked again at end or dispute. If either side's address takes code, signed states stop verifying, but both sides have timeout exits (userCancelActiveGame→userForceGameEnd, serverCancelActiveGame→serverForceGameEnd) that close the game on the stored state.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: Dicether GameChannel: game states signed by the server and the player are checked again when a game ends or is disputed. Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- GameChannelBase.sol:414-423 verify(): ecrecover(...) == expected; serverAddress is set only in the constructor (no setter)
- GameChannelConflict.sol:158-265: cancel and force-end paths need no counterparty signature; the owner also has withdrawAll after a 3-day pause
- serverAddress() at 26438999 = 0x437E…9f4d (EOA); owner 0x324e…5c77; 458 txs in 90 days

## Impact and exposure

- Value held at block 26,438,999: $212 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 458 transactions called it in the 90 days before that block; last on 2026-09-09.

## Remediation

End open games through the cancel/force-end timeout path; no contract change needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry.
