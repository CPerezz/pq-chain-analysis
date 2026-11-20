---
id: bootstrapballot-f1e667f4-fixed-signer
title: "BootstrapBallot: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf1e667f40460ec3327f1bb57d686f568d474b02c"
  family: "5374a10ad339a03f22fac72fe78db95c"
  name: "BootstrapBallot"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: none
  who_acts: "no funds held by this contract"
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
  note: "Downgraded from the study's HIGH per the rubric's own text: the contract holds no money by design, so the correct bucket is MEDIUM (function dies, nothing locked here), not HIGH."
---

## Summary

BootstrapBallot.vote/authorizeAirdrop2 require SigningTools._verifySignature against the constant EXPECTED_SIGNER, no setter. If it gets code, voting and airdrop2 authorization stop for good (the exchange bootstrap can never be finalized via this path) -- but this contract itself holds no funds; it only forwards authorizations to separate Airdrop/DAO contracts.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: SigningTools _verifySignature: EXPECTED_SIGNER, fixed in the code. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- BootstrapBallot.sol:29-66: vote()/authorizeAirdrop2() both gated by SigningTools._verifySignature(messageHash, signature) (dossier source)
- SigningTools.sol:9,28: EXPECTED_SIGNER constant 0x1234519DCA2ef23207E1CA7fd70b96f281893bAa, no setter
- BootstrapBallot has no payable function and holds no token/ETH balance field; it only calls airdrop1.authorizeWallet/exchangeConfig().dao().pools().startExchangeApproved()

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

DAO deploys a new BootstrapBallot (one-shot launch contract) if this hasn't finalized yet.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
