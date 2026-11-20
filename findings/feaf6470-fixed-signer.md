---
id: feaf6470-fixed-signer
title: "0xfeaf6470: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xfeaf6470ace0c148469fd8990e069bdcc6b72f10"
  family: "b9588f8b08e769e8717f32f8b7d0f749"
  copies: 3
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 361
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "operator (factory/redeploy)"
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
  note: "MEDIUM: in new games only the operator's seed is stranded, because players cannot guess without the random. This instance's 0.2 ETH exit (startNewGame) does not depend on the callback."
---

## Summary

Eth17: the secret is set only in __callback (a failed proof sets gameAbandoned), and guessNumber requires randomNumberRetrieved, so no player can stake in a game without the random. Only the factory-funded seed sits in such games. This instance already has its random (nextGuess 2) and pays out via startNewGame, which does not need the callback.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Oraclize verifySig: the recovered address must be the address of the public key carried in the proof; the result flag of the precompile is ignored / Oraclize safer_ecrecover: a…. Same code idiom as template 0fa7b998, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- guessNumber: require(randomNumberRetrieved == true) before any stake; __callback sets random only when the proof passes, otherwise gameAbandoned=true [sourcify source L1565-1566, L1669-1690]
- State: randomNumberRetrieved 1, nextGuess 2, gameEnd 2021, lastGuessAddress 0xfB5136..., balance 0.2 ETH; startNewGame sends the balance to lastGuessAddress [cast call, source L1533-1549]
- Simulated startNewGame() reverts today because the factory's new spawn has too little ETH for the Oraclize fee (queryN OutOfFunds), a pre-existing condition unrelated to ecrecover [cast call --trace]

## Impact and exposure

- Value held at block 26,438,999: $361 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Operator redeploys or funds the factory; future spawns get no secret, so only the seed is affected.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
