---
id: signaturemerkledrop128-e570ed5e-own-signature-only-exit
title: "SignatureMerkleDrop128: funds released only by the party's own signature"
status: confirmed
severity: MEDIUM
patterns: [PQ-16]
impact: liveness
contracts:
- address: "0xe570ed5e3efff7bd706a8057b4dc37a3f0db6798"
  family: "c4830906b572de8b3f8722e3201f4d6e"
  copies: 7
  name: "SignatureMerkleDrop128"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 242
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: offchain
  who_acts: "owner 0x0bd6..b3a2"
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
  note: "Claim dies for good for a signer with code (no update path); the tokens can still leave by the owner's rescueFunds -> MEDIUM."
---

## Summary

1inch signature Merkle airdrop: claim() recovers the account from an ECDSA signature over the receiver and checks it against the Merkle leaf, so an account with code cannot claim its allocation. The owner's rescueFunds can withdraw the tokens, so the operator can deliver that allocation by hand.

## Mechanism

PQ-16. Once the party's account has real code the signature recovers no address, and nobody else can act for it unless an administrator can.

## Evidence

- How it was placed: 1inch SignatureMerkleDrop128 claim: the account in the tree must sign to claim to a receiver; no direct claim. Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- contracts/SignatureMerkleDrop128.sol claim L36-46: account = ECDSA.recover(...), leaf = keccak(account, amount); no direct-call or ERC-1271 path
- rescueFunds(token,amount) onlyOwner (L112) sends any token or ETH to the owner
- owner()=0x0bd61d605c64a857c3d94779aef7ca295702b3a2, an EOA (nonce 199) at block 26438999; token()=0x1111..C302 (1INCH)
- row value $242, txs_90d=0

## Impact and exposure

- Value held at block 26,438,999: $242 (ETH and 49 priced tokens, over 7 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner rescues and sends the allocation to affected claimers.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-own-signature-only-exit` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
