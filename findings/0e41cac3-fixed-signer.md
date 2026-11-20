---
id: 0e41cac3-fixed-signer
title: "0x0e41cac3: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0e41cac3f1bc0e2bc679467cd9420181aae9088b"
  family: "9a0236c63343bf96b0df1592ffd12999"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Owner/project would redeploy a sale contract with a new signer"
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
  note: "Rated MEDIUM because only the signed presale mint of new NFTs stops and no funds are locked. The study_note calls this a presale with deposit and claim, but this code only has a signed mint plus a public buy()."
---

## Summary

The presale signer is an immutable that is set to an EOA and has no setter, ERC-1271 check or code check. If that EOA gets real code, signed presale mints stop working. Nothing is held for users, so only the presale function is lost. The public buy() path still works after saleStart.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- verify(): recoverSigner(...) == verifyAddress, with verifyAddress immutable = 0xdFFf98Bdf70A814dF3333CbaA558161D35390044
- Bytecode facts: 0xdfff98bd... is an EOA with no code at block 26438999
- No function assigns verifyAddress; the only setters are setNewEthReceiver and transferOwnership
- presaleBuyWithSignature forwards the whole balance to ethReceiver via _safeTransferETH, so no deposits are held

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new sale contract whose signer can be changed or that supports ERC-1271, and authorize it as the NFT minter. Alternatively, keep the verifyAddress key as a plain EOA or 7702 account (EIP-7702 delegation).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
