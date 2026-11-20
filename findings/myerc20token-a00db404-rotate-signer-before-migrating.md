---
id: myerc20token-a00db404-rotate-signer-before-migrating
title: "MyERC20Token: signer key to rotate before its account takes code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xa00db4042b9537b8958289c7c68c5c74e341f766"
  family: "d8dfdd1b0fc4dee88b9f1361e59e96aa"
  name: "MyERC20Token"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 45836
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody (owner renounced)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "LOW fails: no live setter. Only the mint function dies; EIP-8151 locks nothing new (the ETH was already stuck), so MEDIUM."
---

## Summary

MyERC20Token Farcaster allowlist mint: mintWithFid needs a signature from signerAddress (ECDSA only). If that signer gets code, the signed mint dies.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- allowlist.sol:76-78 recover(signature)==signerAddress; setSignerAddress (line 145) is onlyOwner
- owner() at block 26438999 = 0x0: setter dead, no other update path
- Balance 25.376 ETH is withdrawable only by onlyOwner withdrawToPurple, already unreachable because of the renouncement, not because of EIP-8151; signer 0xdD94873D has no code today

## Impact and exposure

- Value held at block 26,438,999: $45,836 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None on-chain; the signer key holder must not move to code (keep EOA or 7702 delegation).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
