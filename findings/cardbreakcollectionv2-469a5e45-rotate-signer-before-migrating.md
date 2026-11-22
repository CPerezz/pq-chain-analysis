---
id: cardbreakcollectionv2-469a5e45-rotate-signer-before-migrating
format: 2
title: 'CardBreakCollectionV2: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x469a5e45d7fb407574c6ecdb7b10701d4bf54914'
  name: CardBreakCollectionV2
  code: verified
  code_url: https://etherscan.io/address/0x469a5e45d7fb407574c6ecdb7b10701d4bf54914#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1
impact: liveness
action: Before a signer's account moves to real code, use grantRole so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x469a5e45d7fb407574c6ecdb7b10701d4bf54914'
  file: src/CardBreakCollectionV2.sol
  line: 248
  has: if (!hasRole(ISSUER_ROLE, ECDSA.recover(_quoteDigest(quote, typeHash), signature))) {
  says: _mintAuthorizedClaim recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x469a5e45d7fb407574c6ecdb7b10701d4bf54914'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x469a5e45d7fb407574c6ecdb7b10701d4bf54914'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  selector: '0x469a5e45d7fb407574c6ecdb7b10701d4bf54914'
  fn: grantRole(bytes32,address)
  says: the code has grantRole
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

CardBreakCollectionV2 checks an ECDSA signature in _mintAuthorizedClaim and accepts only a holder of its signing role. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. grantRole changes who may sign.

## Evidence

- [_mintAuthorizedClaim](https://etherscan.io/address/0x469a5e45d7fb407574c6ecdb7b10701d4bf54914#code) recovers the signature with ECDSA and accepts only a holder of its signing role; the code never asks that account.
- [grantRole](https://etherscan.io/address/0x469a5e45d7fb407574c6ecdb7b10701d4bf54914#code) changes who may sign.

## Reviewer notes

### Mechanism

_mintAuthorizedClaim (src/CardBreakCollectionV2.sol, line 232) recovers a signer on line 248 and tests it on line 248 against a holder of its signing role. Neither isValidSignature selector is in the code, so that account is never asked. grantRole is in the code. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 1 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
