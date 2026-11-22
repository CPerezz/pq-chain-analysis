---
id: sharkoutlawsquad-a4eacdf4-rotate-signer-before-migrating
format: 2
title: 'SharkOutlawSquad: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa4eacdf4af749060a22aefe06337cb9fb96d45fb'
  name: SharkOutlawSquad
  code: verified
  code_url: https://etherscan.io/address/0xa4eacdf4af749060a22aefe06337cb9fb96d45fb#code
  copies: 1
  upgradeable: 'no'
  admin: '0x57b22ac54bf6a086c7ed79e3a8794029703611cd'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 13
impact: liveness
action: Replace the signer with setWhitelistSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xa4eacdf4af749060a22aefe06337cb9fb96d45fb'
  file: contracts/SharkOutlawSquad.sol
  line: 77
  has: getSigner(msg.sender, _signedQty, _signature) == whitelistSigner,
  says: presalesMint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xa4eacdf4af749060a22aefe06337cb9fb96d45fb'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xa4eacdf4af749060a22aefe06337cb9fb96d45fb'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xa4eacdf4af749060a22aefe06337cb9fb96d45fb'
  file: contracts/SharkOutlawSquad.sol
  line: 51
  has: function setWhitelistSigner
  says: setWhitelistSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xa4eacdf4af749060a22aefe06337cb9fb96d45fb'
  fn: whitelistSigner()(address)
  is: '0xa0ad823af66d3efa1deea15dfc4a7f138785d52c'
  says: The signer it keeps in storage is 0xa0ad823af66d3efa1deea15dfc4a7f138785d52c at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xa0ad823af66d3efa1deea15dfc4a7f138785d52c'
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

SharkOutlawSquad accepts a call to presalesMint only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setWhitelistSigner changes the signer.

## Evidence

- [presalesMint](https://etherscan.io/address/0xa4eacdf4af749060a22aefe06337cb9fb96d45fb#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setWhitelistSigner](https://etherscan.io/address/0xa4eacdf4af749060a22aefe06337cb9fb96d45fb#code) changes the signer; only the owner can call it.
- The signer at the block is [0xa0ad…d52c](https://etherscan.io/address/0xa0ad823af66d3efa1deea15dfc4a7f138785d52c), an account without code.

## Reviewer notes

### Mechanism

presalesMint (contracts/SharkOutlawSquad.sol, line 66) recovers a signer on line 77 and tests it on line 77 against the signer it keeps in storage (whitelistSigner() returns 0xa0ad823af66d3efa1deea15dfc4a7f138785d52c). Neither isValidSignature selector is in the code, so that account is never asked. setWhitelistSigner (contracts/SharkOutlawSquad.sol, line 51) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-01-17, recovering 0xa0ad…d52c; 13 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
