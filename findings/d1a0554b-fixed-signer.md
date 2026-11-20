---
id: d1a0554b-fixed-signer
title: "0xd1a0554b: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd1a0554b7b9d0d1f214bc44dd1a114a6df3cabde"
  family: "2920e32f85e753b21fd056a030dde308"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The owner can call stepPhase to move on to the public sale (mintNFT, which needs no signature). Restoring a presale would need a new deployment."
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
  note: "The study_note's 'deposit and claim' wording is inaccurate. The signature gates only the presale mint, and payment happens in the same tx. The public sale and giveaway paths do not need a signature."
---

## Summary

The presale signer is a hardcoded constant address with no code today, and there is no upgrade path. If that account gets real code, presaleMintNFT stops working. Only the minting of new NFTs stops, and nothing already held is locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- verifySignature: addr = 0x9EB0F5610D94141c051E19A110FB725cc2493766 literal; no function writes a signer
- Row facts: constant 0x9eb0...3766 has code_bytes 0 and delegated false, so it is an EOA
- presaleMintNFT requires verifySignature(sig)==true and takes msg.value == BASE_PRICE*n in the same call
- withdraw() onlyOwner sends the balance to DEV addresses, so no funds are stuck

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner moves to the public sale with stepPhase, or deploys a new contract whose signer can be changed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
