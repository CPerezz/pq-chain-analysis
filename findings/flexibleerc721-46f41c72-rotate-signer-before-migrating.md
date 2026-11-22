---
id: flexibleerc721-46f41c72-rotate-signer-before-migrating
format: 2
title: 'FlexibleERC721: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x46f41c72fa68e7ed7c56e642b782cf86c5794f77'
  name: FlexibleERC721
  code: verified
  code_url: https://etherscan.io/address/0x8d3d189caa268b670cd66190decbc5b1e6b432cd#code
  proxy_of: '0x8d3d189caa268b670cd66190decbc5b1e6b432cd'
  copies: 5
  family: bf19c28f926b20f135dcadf99e7c5bad
  admin: '0xf33a9b6b63ae95fde028e6bc2797805feaff3147'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Before a signer's account moves to real code, use grantRole so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x8d3d189caa268b670cd66190decbc5b1e6b432cd'
  file: contracts/mint-voucher/MintVoucherVerification.sol
  line: 94
  has: address recoveredSigner = ECDSA.recover(digest, signature);
  says: verifySignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x8d3d189caa268b670cd66190decbc5b1e6b432cd'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x8d3d189caa268b670cd66190decbc5b1e6b432cd'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x8d3d189caa268b670cd66190decbc5b1e6b432cd'
  file: contracts/mint-voucher/MintVoucherVerification.sol
  line: 96
  has: if (!hasRole(SIGNER_ROLE, recoveredSigner)) {
  says: the recovered address must be a holder of its signing role
  for:
  - evidence-1
  - justification
  - what
- id: setter
  selector: '0x8d3d189caa268b670cd66190decbc5b1e6b432cd'
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

FlexibleERC721 checks an ECDSA signature in verifySignature and accepts only a holder of its signing role. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. grantRole changes who may sign.

## Evidence

- [verifySignature](https://etherscan.io/address/0x8d3d189caa268b670cd66190decbc5b1e6b432cd#code) recovers the signature with ECDSA and accepts only a holder of its signing role; the code never asks that account.
- [grantRole](https://etherscan.io/address/0x8d3d189caa268b670cd66190decbc5b1e6b432cd#code) changes who may sign.

## Reviewer notes

### Mechanism

verifySignature (contracts/mint-voucher/MintVoucherVerification.sol, line 69) recovers a signer on line 94 and tests it on line 96 against a holder of its signing role. Neither isValidSignature selector is in the code, so that account is never asked. grantRole is in the code. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 5 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
