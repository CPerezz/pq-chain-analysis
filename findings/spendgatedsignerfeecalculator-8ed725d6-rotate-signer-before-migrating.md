---
id: spendgatedsignerfeecalculator-8ed725d6-rotate-signer-before-migrating
format: 2
title: 'This contract: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x8ed725d61aa687951f430dd6e76e3a0108436005'
  name: SpendGatedSignerFeeCalculator
  code: verified
  code_url: https://etherscan.io/address/0x8ed725d61aa687951f430dd6e76e3a0108436005#code
  copies: 1
  upgradeable: 'no'
  admin: '0x0646441c3ec556c1994420c3f9b0f31279befb6e'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 5
impact: liveness
action: Before a signer's account moves to real code, use addTrustedSigner so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x8ed725d61aa687951f430dd6e76e3a0108436005'
  file: src/contracts/fees/SpendGatedSignerFeeCalculator.sol
  line: 372
  has: (address recoveredSigner,,) = messageHash.tryRecover(signedMessage.signature);
  says: trackSwap recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x8ed725d61aa687951f430dd6e76e3a0108436005'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x8ed725d61aa687951f430dd6e76e3a0108436005'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x8ed725d61aa687951f430dd6e76e3a0108436005'
  file: src/contracts/fees/SpendGatedSignerFeeCalculator.sol
  line: 375
  has: if (recoveredSigner != poolSigner.signer) {
  says: the recovered address must be an address in the signer set it keeps
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x8ed725d61aa687951f430dd6e76e3a0108436005'
  file: src/contracts/fees/SpendGatedSignerFeeCalculator.sol
  line: 433
  has: function addTrustedSigner
  says: addTrustedSigner changes who may sign
  for:
  - action
  - evidence-2
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

This contract accepts a call to trackSwap only with an ECDSA signature of an address in the signer set it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. addTrustedSigner changes who may sign.

## Evidence

- [trackSwap](https://etherscan.io/address/0x8ed725d61aa687951f430dd6e76e3a0108436005#code) recovers the signature with ECDSA and accepts only an address in the signer set it keeps; the code never asks that account.
- [addTrustedSigner](https://etherscan.io/address/0x8ed725d61aa687951f430dd6e76e3a0108436005#code) changes who may sign; only the owner can call it.

## Reviewer notes

### Mechanism

trackSwap (src/contracts/fees/SpendGatedSignerFeeCalculator.sol, line 298) recovers a signer on line 372 and tests it on line 375 against an address in the signer set it keeps. Neither isValidSignature selector is in the code, so that account is never asked. addTrustedSigner (src/contracts/fees/SpendGatedSignerFeeCalculator.sol, line 433) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 5 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
