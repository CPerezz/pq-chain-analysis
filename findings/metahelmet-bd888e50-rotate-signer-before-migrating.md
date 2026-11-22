---
id: metahelmet-bd888e50-rotate-signer-before-migrating
format: 2
title: 'Metahelmet: no signer is set; replace a later one before it takes real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing can break while no signer is set; one set later can be replaced before its account moves
  to real code.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xbd888e50969748805cdf77bcf283febe493f190c'
  name: Metahelmet
  code: verified
  code_url: https://etherscan.io/address/0xbd888e50969748805cdf77bcf283febe493f190c#code
  copies: 1
  upgradeable: 'no'
  admin: '0x468ccd8cda9d4f9414a41220f6b08e8d5e9f3d16'
value:
  usd: 4
  basis: held
activity:
  txs_90d: 43
impact: liveness
action: If a signer is set again, replace it with setWhiteListSigner before its account moves to real code.
evidence_level: source
checks:
- id: recover
  source: '0xbd888e50969748805cdf77bcf283febe493f190c'
  file: Metahelmet.sol
  line: 1506
  has: require(recover(hash,signature) == WHITELIST_SIGNER, "Invalid Signature");
  says: preMintMetahelmet recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xbd888e50969748805cdf77bcf283febe493f190c'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xbd888e50969748805cdf77bcf283febe493f190c'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xbd888e50969748805cdf77bcf283febe493f190c'
  file: Metahelmet.sol
  line: 1455
  has: function setWhiteListSigner
  says: setWhiteListSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xbd888e50969748805cdf77bcf283febe493f190c'
  fn: WHITELIST_SIGNER()(address)
  is: '0x0000000000000000000000000000000000000000'
  says: no signer is set at the block
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

Metahelmet accepts a call to preMintMetahelmet only with an ECDSA signature of the signer it keeps in storage. No signer is set at the block; setWhiteListSigner sets one. A signer set later is refused once its account takes real code; an EIP-7702 delegation keeps working.

## Evidence

- [preMintMetahelmet](https://etherscan.io/address/0xbd888e50969748805cdf77bcf283febe493f190c#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setWhiteListSigner](https://etherscan.io/address/0xbd888e50969748805cdf77bcf283febe493f190c#code) sets the signer; only the owner can call it.
- No signer is set at the block: [WHITELIST_SIGNER()](https://etherscan.io/address/0xbd888e50969748805cdf77bcf283febe493f190c#readContract) returns the zero address.

## Reviewer notes

### Mechanism

preMintMetahelmet (Metahelmet.sol, line 1490) recovers a signer on line 1506 and tests it on line 1506 against the signer it keeps in storage (WHITELIST_SIGNER() returns 0x0000000000000000000000000000000000000000). Neither isValidSignature selector is in the code, so that account is never asked. setWhiteListSigner (Metahelmet.sol, line 1455) writes it. No signer is set at the block. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2021-11-30, recovering 0xbd1e…ac45; 43 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
