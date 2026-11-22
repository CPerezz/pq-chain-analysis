---
id: gallerytwentyseven-25ef4d7f-rotate-signer-before-migrating
format: 2
title: 'GalleryTwentySeven: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x25ef4d7f1d2706808d67a7ecf577062b055afd4e'
  name: GalleryTwentySeven
  code: verified
  code_url: https://etherscan.io/address/0x25ef4d7f1d2706808d67a7ecf577062b055afd4e#code
  copies: 1
  admin: '0xb54af9163c0b5ee4166c5977e99b2ba8c57635f1'
value:
  usd: 632
  basis: held
activity:
  txs_90d: 12
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x25ef4d7f1d2706808d67a7ecf577062b055afd4e'
  file: contracts/GalleryTwentySeven.sol
  line: 148
  has: ECDSA.recover(signedData, signature) == _signer,
  says: initializeAuction recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x25ef4d7f1d2706808d67a7ecf577062b055afd4e'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x25ef4d7f1d2706808d67a7ecf577062b055afd4e'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x25ef4d7f1d2706808d67a7ecf577062b055afd4e'
  file: contracts/GalleryTwentySeven.sol
  line: 297
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x8e96a3315e8a8f8082334b0728b45737e65b70b2'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xe43c4fbfdc7d7b65c8f13ef6a4af27f19787c1a2a8c9440b4af2b4511b9603e5'
  ok: true
  says: a transaction in which this contract recovered a signature
  for:
  - evidence-3
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

GalleryTwentySeven accepts a call to initializeAuction only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [initializeAuction](https://etherscan.io/address/0x25ef4d7f1d2706808d67a7ecf577062b055afd4e#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0x25ef4d7f1d2706808d67a7ecf577062b055afd4e#code) changes the signer; only the owner can call it.
- Its latest signed [transaction](https://etherscan.io/tx/0xe43c4fbfdc7d7b65c8f13ef6a4af27f19787c1a2a8c9440b4af2b4511b9603e5) on record recovered [0x8e96…70b2](https://etherscan.io/address/0x8e96a3315e8a8f8082334b0728b45737e65b70b2), an account without code.

## Reviewer notes

### Mechanism

initializeAuction (contracts/GalleryTwentySeven.sol, line 130) recovers a signer on line 148 and tests it on line 148 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setSigner (contracts/GalleryTwentySeven.sol, line 297) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-07, recovering 0x8e96…70b2; 12 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
