---
id: transactionmanager-31efc4ae-signature-rechecked
title: "TransactionManager: a signature checked again after others relied on it"
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0x31efc4aeaa7c39e54a33fdc3c46ee2bd70ae0a09"
  family: "3d46cadfdece71e8d303e7683e9a218d"
  name: "TransactionManager"
  label: "xPollinate: Transaction Manager"
  upgradeable: "no"
  rating: CRITICAL
  value_usd: 4603
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "routers (stop serving users whose addresses may take code); Connext (redeploy)"
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
  note: "The router relied on a signature and loses its payout, and the timeout protects only the user; no update path."
---

## Summary

Connext NXTP TransactionManager: the user's fulfill signature releases the router's liquidity to the user on the receiving chain, and the router then presents the same signature on the sending chain to take the user's locked funds. If the user's address takes code in between, the sending-chain fulfill fails; after expiry anyone can cancel and refund the user, so the router loses the amount it already paid out.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: Connext NXTP fulfill: on the sending chain the router takes the user's locked funds by presenting the user's signature; on the receiving chain the same signature releases the router's funds to the…. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- TransactionManager.sol:497-507: sending-chain fulfill requires msg.sender == router and recoverFulfillSignature(...) == txData.user
- TransactionManager.sol:597-610: after expiry, sending-chain cancel returns the funds to sendingChainFallback with no signature
- no proxy slots and no upgrade function; txs_90d 0 (dormant), value $4,603

## Impact and exposure

- Value held at block 26,438,999: $4,603 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Routers should refuse transfers from users whose addresses may take code; a redeployment would need ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry (D-025).
