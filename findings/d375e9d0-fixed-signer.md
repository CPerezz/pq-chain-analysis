---
id: d375e9d0-fixed-signer
title: "0xd375e9d0: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd375e9d0cbc12813683ffb0ab9bf85fbf83aceaf"
  family: "08784ec6125e699d925bbabfee91c29b"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 407
  last_active: 2026-11-13
fix:
  layer: onchain-config
  who_acts: "The owner (0xff06e0b98e500c396884803d4a0c35511bd22c29) can call setSaleState(PUBLIC) so people mint through mintPublic without a signature."
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
  note: "I identified the SIGNER address by elimination among the address values pushed in the bytecode. The other three map to SANPASS, SANWEAR and the UNMUTOOOOR constant. Calling SIGNER() on-chain would confirm it directly. The study note calls this a presale, but the code is an NFT mint."
---

## Summary

The signer check compares against SIGNER, an immutable with no setter, and the code has no code check and no ERC-1271 path. If the signer key's account gets real code, signed allow-list and members-list mints stop working. No funds get locked: the ETH from mints can be withdrawn by the owner, and the owner can switch to the public mint, which needs no signature. Only the signed discounted mint stops.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- StatefulSale: `address public immutable SIGNER;` is assigned only in the constructor `SIGNER = _signer;`
- isValidSignature: `return SIGNER == ECDSA.recover(hash, _signature);`. There is no extcodesize check and no ERC-1271 path.
- _mintPrivate reverts with InvalidSignature unless isValidSignature passes. It is used by mintMembersList and mintAllowList.
- mintPublic calls _mintMain without a signature when saleState == PUBLIC. setSaleState is onlyOwner.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 407 transactions called it in the 90 days before that block; last on 2026-11-13.

## Remediation

Keep the SIGNER key's account as an EOA or a 7702-delegated account. If signed mints break, the owner calls setSaleState(PUBLIC) to use the mint path that needs no signature. Restoring the discounted allow-list mint would need a new deployment.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
