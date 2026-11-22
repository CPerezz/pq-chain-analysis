---
id: mintcontroller-f7edd4be-rotate-signer-before-migrating
format: 2
title: 'MintController: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xf7edd4be8df6012ff421765702a29a62703bdb03'
  name: MintController
  code: verified
  code_url: https://etherscan.io/address/0xf7edd4be8df6012ff421765702a29a62703bdb03#code
  copies: 2
  family: d8dd00431903e059e839bd772ccf1696
  upgradeable: 'no'
  admin: '0x33fef7d4a004db13b0b98284466bb629bab2f202'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1
impact: liveness
action: Before a signer's account moves to real code, use setAttester so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0xf7edd4be8df6012ff421765702a29a62703bdb03'
  file: src/MintController.sol
  line: 104
  has: address signer = ECDSA.recover(id, sigs[i]);
  says: executeMint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xf7edd4be8df6012ff421765702a29a62703bdb03'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xf7edd4be8df6012ff421765702a29a62703bdb03'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xf7edd4be8df6012ff421765702a29a62703bdb03'
  file: src/MintController.sol
  line: 58
  has: function setAttester
  says: setAttester changes who may sign
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

MintController accepts a call to executeMint only with an ECDSA signature of an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setAttester changes who may sign.

## Evidence

- [executeMint](https://etherscan.io/address/0xf7edd4be8df6012ff421765702a29a62703bdb03#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [setAttester](https://etherscan.io/address/0xf7edd4be8df6012ff421765702a29a62703bdb03#code) changes who may sign; only the owner can call it.

## Reviewer notes

### Mechanism

executeMint (src/MintController.sol, line 97) recovers a signer on line 104 and tests it on line 104 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. setAttester (src/MintController.sol, line 58) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 1 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
