---
id: tamag-a6d82fc1-rotate-signer-before-migrating
format: 2
title: 'TAMAG: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa6d82fc1f99a868eaab5c935fe7ba9c9e962040e'
  name: TAMAG
  code: verified
  code_url: https://etherscan.io/address/0xa6d82fc1f99a868eaab5c935fe7ba9c9e962040e#code
  copies: 1
  upgradeable: 'no'
  admin: '0xc2884de64ceff15211bb884a1e84f5aead9fdc7c'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1
impact: liveness
action: Replace the signer with setSignerAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xa6d82fc1f99a868eaab5c935fe7ba9c9e962040e'
  file: TAMAG.sol
  line: 1836
  has: address signer = ecrecover(hashInSignature, v, r, s);
  says: setMetadataByUser recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xa6d82fc1f99a868eaab5c935fe7ba9c9e962040e'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xa6d82fc1f99a868eaab5c935fe7ba9c9e962040e'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xa6d82fc1f99a868eaab5c935fe7ba9c9e962040e'
  file: TAMAG.sol
  line: 1837
  has: require(signer == signerAddress, "Msg needs to be signed by valid signer!");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xa6d82fc1f99a868eaab5c935fe7ba9c9e962040e'
  file: TAMAG.sol
  line: 1848
  has: function setSignerAddress
  says: setSignerAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xa6d82fc1f99a868eaab5c935fe7ba9c9e962040e'
  fn: signerAddress()(address)
  is: '0x8ef9a1a12e0b7e92f11d112f51ae1054ddc0e37d'
  says: The signer it keeps in storage is 0x8ef9a1a12e0b7e92f11d112f51ae1054ddc0e37d at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x8ef9a1a12e0b7e92f11d112f51ae1054ddc0e37d'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
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

TAMAG accepts a call to setMetadataByUser only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSignerAddress changes the signer.

## Evidence

- [setMetadataByUser](https://etherscan.io/address/0xa6d82fc1f99a868eaab5c935fe7ba9c9e962040e#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSignerAddress](https://etherscan.io/address/0xa6d82fc1f99a868eaab5c935fe7ba9c9e962040e#code) changes the signer; only the owner can call it.
- The signer at the block is [0x8ef9…e37d](https://etherscan.io/address/0x8ef9a1a12e0b7e92f11d112f51ae1054ddc0e37d), an account without code.

## Reviewer notes

### Mechanism

setMetadataByUser (TAMAG.sol, line 1830) recovers a signer on line 1836 and tests it on line 1837 against the signer it keeps in storage (signerAddress() returns 0x8ef9a1a12e0b7e92f11d112f51ae1054ddc0e37d). Neither isValidSignature selector is in the code, so that account is never asked. setSignerAddress (TAMAG.sol, line 1848) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2021-02-27, recovering 0x8ef9…e37d; 1 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
