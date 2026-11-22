---
id: reachtreasuryredemption-64ec3852-fixed-signer
format: 2
title: 'ReachTreasuryRedemption: its fixed signer must not take real code'
status: confirmed
severity: INFORMATIONAL
justification: Breaks only if a signer's account takes real code; the signer is fixed, so a new contract is then
  needed.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x64ec3852be38ee1252d828f55c9c898e1c132172'
  name: ReachTreasuryRedemption
  code: verified
  code_url: https://etherscan.io/address/0x64ec3852be38ee1252d828f55c9c898e1c132172#code
  copies: 1
  upgradeable: 'no'
  admin: '0xda68602c9d65337c75bf0593972d9731895592e3'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 6
impact: liveness
action: Keep the signer's account free of real code, or deploy a replacement with a new signer first.
evidence_level: source
checks:
- id: recover
  source: '0x64ec3852be38ee1252d828f55c9c898e1c132172'
  file: contracts/ReachTreasuryRedemption.sol
  line: 81
  has: if (ECDSA.recover(digest, signature) != quoteSigner) revert InvalidQuote();
  says: redeem recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x64ec3852be38ee1252d828f55c9c898e1c132172'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x64ec3852be38ee1252d828f55c9c898e1c132172'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: written
  source: '0x64ec3852be38ee1252d828f55c9c898e1c132172'
  file: contracts/ReachTreasuryRedemption.sol
  line: 53
  has: quoteSigner = quoteSigner_;
  says: the signer is written here, at deployment
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x64ec3852be38ee1252d828f55c9c898e1c132172'
  fn: quoteSigner()(address)
  is: '0xa26c71326fac07469c2af7cfea49641660ab66dc'
  says: A signer fixed at deployment is 0xa26c71326fac07469c2af7cfea49641660ab66dc at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0xa26c71326fac07469c2af7cfea49641660ab66dc'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x0a1924b64c26fbe8712a5ca7a0645dc0f41a401d0a3ad7dc2ed297abe2102f83'
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
  rating: HIGH
reviews: []
related: []
---

## What happens

ReachTreasuryRedemption accepts a call to redeem only with an ECDSA signature of a signer fixed at deployment. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. The verified source has no function that replaces the signer.

## Evidence

- [redeem](https://etherscan.io/address/0x64ec3852be38ee1252d828f55c9c898e1c132172#code) recovers the signature with ECDSA and accepts only a signer fixed at deployment; the code never asks that account.
- The signer is written [at deployment](https://etherscan.io/address/0x64ec3852be38ee1252d828f55c9c898e1c132172#code); the verified source has no function that writes it afterwards.
- The signer at the block is [0xa26c…66dc](https://etherscan.io/address/0xa26c71326fac07469c2af7cfea49641660ab66dc), an account without code.

## Reviewer notes

### Mechanism

redeem (contracts/ReachTreasuryRedemption.sol, line 60) recovers a signer on line 81 and tests it on line 81 against a signer fixed at deployment (quoteSigner() returns 0xa26c71326fac07469c2af7cfea49641660ab66dc). Neither isValidSignature selector is in the code, so that account is never asked. quoteSigner is written on line 53 of contracts/ReachTreasuryRedemption.sol (at deployment); a search of every source file, libraries and constructors included, finds no other write, and the contract's own functions use no sstore and no delegatecall. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-09-28, recovering 0xa26c…66dc; 6 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
