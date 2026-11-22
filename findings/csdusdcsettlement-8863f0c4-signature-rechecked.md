---
id: csdusdcsettlement-8863f0c4-signature-rechecked
title: "CsdUsdcSettlement: a signature checked again after others relied on it"
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0x8863f0c477a30bb5a2077c813f42250d7fbefcb9"
  family: "e2498adf1736d7aadffa05685b634a4b"
  name: "CsdUsdcSettlement"
  upgradeable: "no"
  rating: CRITICAL
  txs_90d: 143
  last_active: 2026-11-16
  recoveries_14d: 63
fix:
  layer: new-deployment
  who_acts: "sellers (stop trading with buyers whose addresses may take code); deployer (redeploy)"
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
  note: "The seller relied on the locked authorization and loses; the timeout protects only the buyer, and there is no update path."
---

## Summary

CsdUsdcSettlement: the buyer's signed authorization locks USDC, the seller then pays CSD on the other chain, and settleCsdUsdc checks the buyer's signature again before releasing the USDC to the seller. If the buyer's address takes code after the lock, settlement fails and refundExpiredLock returns the USDC to the buyer after lockedUntil, so the seller loses the CSD it already paid.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: CsdUsdcSettlement _lock: the buyer named in the authorisation must have signed; the buyer's USDC is then locked for the trade / CsdUsdcSettlement address proof: a signature shows that the public key…. Read from source. Executed: a real transaction reverts with code at the signer. Executed by hand: see Evidence.
- CsdUsdcSettlement `0x8863f0c477a30bb5a2077c813f42250d7fbefcb9`: `settleCsdUsdc` L483 `if (_recover(authHash, authSig) != auth.buyer) revert BadSignature();`. Executed: settlement `0x55d7ee240594f01a2339416dc20362814d42e610ad3681f0b24d995ba38690fb` reverts with code at buyer `0xcfc25c23c39525875908865980d7ef905287a98c`; after expiry `refundExpiredLock` pays the buyer, who has the seller's coins (read).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- CsdUsdcSettlement.sol:483 settleCsdUsdc: `_recover(authHash, authSig) != auth.buyer` reverts BadSignature (also 319 at lock, 429 in releaseEarly)
- CsdUsdcSettlement.sol:367-391 refundExpiredLock: anyone, after lockedUntil, sends the USDC to auth.buyer with no signature
- no proxy, no upgrade; 143 txs in 90 days, last 2026-11-16; the row notes a real transaction was executed with code at the signer and reverted

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 143 transactions called it in the 90 days before that block; last on 2026-11-16.
- 63 signature recoveries in the study's two-week trace window.

## Remediation

Redeploy so that settlement does not recheck the buyer signature (it was already verified at lock) or accepts ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry.
