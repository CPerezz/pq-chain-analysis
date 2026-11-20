---
id: localcoinswaptetherescrow-9975e90f-own-signature-only-exit
title: "LocalCoinSwapTetherEscrow: funds released only by the party's own signature"
status: confirmed
severity: MEDIUM
patterns: [PQ-16]
impact: none
contracts:
- address: "0x9975e90fc7d9dc861a78b171428495e388468885"
  family: "1820f693ab9520e58f1dc197a5b98554"
  copies: 2
  name: "LocalCoinSwapTetherEscrow"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 11
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "owner 0x665f..36A7 (sweeps via transferToken)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-own-signature-only-exit"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "Dispute path dies for good (no update path); the money can still leave by the owner's transferToken sweep -> MEDIUM."
---

## Summary

P2P USDT escrow (LocalEthereum fork): a dispute is resolved by the arbitrator only with an ECDSA signature by the buyer or the seller, so a party with code can't start one. But the owner's transferToken(token,to,value) can move any USDT held, escrowed funds included, so the operator can pay out a stuck trade.

## Mechanism

PQ-16. Once the party's account has real code the signature recovers no address, and nobody else can act for it unless an administrator can.

## Evidence

- How it was placed: LocalCoinSwap escrow (LocalEthereum fork): the arbitrator resolves a dispute only with the buyer's or seller's signature; same design as the filed LocalEthereum entry. Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- LocalCoinSwapTetherEscrow.sol (resolveDispute L213-251, transferToken L711-717): resolveDispute requires recovered == buyer or seller; no ERC-1271
- transferToken(_tokenContract,_transferTo,_value) is onlyOwner and unrestricted, so it can move escrowed USDT; tokenContract()=0xdAC1..1ec7 (USDT)
- owner()=0x665f3E7a712C470C7c5036Ed0f762F936dFe36A7, an EOA (code 0x, nonce 13) at block 26438999
- row value $11, txs_90d=0

## Impact and exposure

- Value held at block 26,438,999: $11 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner pays stuck trades out with transferToken after an off-chain arbitration.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-own-signature-only-exit` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
