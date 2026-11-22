---
id: agentshareeth-b3617e96-fixed-signer
title: "AgentShareEth: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb3617e96ab2005af2bc33cc4d1665ba5a2a9a956"
  family: "2cc7b350f27d1b8c133cf60729a00de5"
  name: "AgentShareEth"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 5
  last_active: 2026-11-05
  recoveries_14d: 5
fix:
  layer: new-deployment
  who_acts: "treasury 0xB949617D… (live EOA)"
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
  note: "Treasury launch is the way out for users' ETH, so the function dies but nothing is locked: MEDIUM. ATTENTION: in today's state no share has been paid for (79,500 < 80,000 free), so launch() reverts 'no eth'; if the signer dies before any paid mint, the 79,500 free shares stay non-transferable forever (no ETH involved). That edge could argue HIGH."
---

## Summary

AgentShareEth: mint() needs a voucher signed by the immutable gateSigner 0xD44d5A8C…; if that key takes real code, minting stops. Paid ETH (once shares past FREE_SHARES are sold) is moved by the treasury's launch(), which needs no signature, adds the pool and unlocks transfers.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: AgentShareEth mint: the voucher must be signed by gateSigner, fixed in the code. Read from source. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source AgentShareEth.sol: gateSigner immutable; mint uses ECDSA.tryRecover == gateSigner; launch() callable by treasury, no signature; transfers locked until launched
- at block 26438999: totalMinted 79500, FREE_SHARES 80000, MAX_SUPPLY 100000, launched false, ETH balance 0; treasury 0xb949617d… EOA nonce 10; gateSigner no code, nonce 0
- cast call --from treasury launch() reverts 'no eth' today (paidShares = 0)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 5 transactions called it in the 90 days before that block; last on 2026-11-05.
- 5 signature recoveries in the study's two-week trace window.

## Remediation

Treasury launches once paid shares exist; otherwise redeploy with a new gate signer before the key takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
