---
id: burrbeardrop-bea2154c-rotate-signer-before-migrating
format: 2
title: 'BurrBearDrop: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xbea2154cb1b1ac9b9af184c9e0dcca8631aec7e4'
  name: BurrBearDrop
  code: verified
  code_url: https://etherscan.io/address/0xbea2154cb1b1ac9b9af184c9e0dcca8631aec7e4#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 322
impact: liveness
action: Replace the signer with setDropSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xbea2154cb1b1ac9b9af184c9e0dcca8631aec7e4'
  file: src/BurrBearDrop.sol
  line: 448
  has: address r = ecrecover(_voucherDigest(a.account, msg.sender, a.maxBears, a.deadline), a.v, a.r, a.s);
  says: _bind recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xbea2154cb1b1ac9b9af184c9e0dcca8631aec7e4'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xbea2154cb1b1ac9b9af184c9e0dcca8631aec7e4'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xbea2154cb1b1ac9b9af184c9e0dcca8631aec7e4'
  file: src/BurrBearDrop.sol
  line: 449
  has: if (r == address(0) || r != dropSigner) revert BadVoucher();
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xbea2154cb1b1ac9b9af184c9e0dcca8631aec7e4'
  file: src/BurrBearDrop.sol
  line: 411
  has: function setDropSigner
  says: setDropSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xbea2154cb1b1ac9b9af184c9e0dcca8631aec7e4'
  fn: dropSigner()(address)
  is: '0xcac1d06dcda6ba0d22fe4e8882ed3ec6f5205a97'
  says: The signer it keeps in storage is 0xcac1d06dcda6ba0d22fe4e8882ed3ec6f5205a97 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xcac1d06dcda6ba0d22fe4e8882ed3ec6f5205a97'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x2a58c1256d59741deb3e09d6a269129ff22b3d61166ae18ff051de78bf3b2579'
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

BurrBearDrop checks an ECDSA signature in _bind and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setDropSigner changes the signer.

## Evidence

- [_bind](https://etherscan.io/address/0xbea2154cb1b1ac9b9af184c9e0dcca8631aec7e4#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setDropSigner](https://etherscan.io/address/0xbea2154cb1b1ac9b9af184c9e0dcca8631aec7e4#code) changes the signer.
- The signer at the block is [0xcac1…5a97](https://etherscan.io/address/0xcac1d06dcda6ba0d22fe4e8882ed3ec6f5205a97), an account without code.

## Reviewer notes

### Mechanism

_bind (src/BurrBearDrop.sol, line 444) recovers a signer on line 448 and tests it on line 449 against the signer it keeps in storage (dropSigner() returns 0xcac1d06dcda6ba0d22fe4e8882ed3ec6f5205a97). Neither isValidSignature selector is in the code, so that account is never asked. setDropSigner (src/BurrBearDrop.sol, line 411) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-10-20, recovering 0xc8f6…262a; 322 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
