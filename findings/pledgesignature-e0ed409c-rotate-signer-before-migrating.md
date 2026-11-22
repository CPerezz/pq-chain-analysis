---
id: pledgesignature-e0ed409c-rotate-signer-before-migrating
format: 2
title: 'PledgeSignature: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe0ed409c0071a9350044554d130737314b6de680'
  name: PledgeSignature
  code: verified
  code_url: https://etherscan.io/address/0xe0ed409c0071a9350044554d130737314b6de680#code
  copies: 2
  family: a55b3aa714343372c3d91815b143f543
  upgradeable: 'no'
value:
  usd: 1
  basis: held
activity:
  txs_90d: 4
impact: liveness
action: Before a signer's account moves to real code, use grantRole so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0xe0ed409c0071a9350044554d130737314b6de680'
  file: contracts/src/PledgeSignature.sol
  line: 170
  has: address signer = digest.recover(signature);
  says: _verifySignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xe0ed409c0071a9350044554d130737314b6de680'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xe0ed409c0071a9350044554d130737314b6de680'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xe0ed409c0071a9350044554d130737314b6de680'
  file: contracts/src/PledgeSignature.sol
  line: 173
  has: return hasRole(SIGNER_ROLE, signer);
  says: the recovered address must be a holder of its signing role
  for:
  - evidence-1
  - justification
  - what
- id: setter
  selector: '0xe0ed409c0071a9350044554d130737314b6de680'
  fn: grantRole(bytes32,address)
  says: the code has grantRole
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xb36a162cc0a18e958ebe87bb4f6ed1e4bb6d65f8'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x347775718ca1fed0d3d9a59cf56ddcd8eddd09d1c9dd3a54872ab8a1f5c155ef'
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

PledgeSignature checks an ECDSA signature in _verifySignature and accepts only a holder of its signing role. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. grantRole changes who may sign.

## Evidence

- [_verifySignature](https://etherscan.io/address/0xe0ed409c0071a9350044554d130737314b6de680#code) recovers the signature with ECDSA and accepts only a holder of its signing role; the code never asks that account.
- [grantRole](https://etherscan.io/address/0xe0ed409c0071a9350044554d130737314b6de680#code) changes who may sign.
- Its latest signed [transaction](https://etherscan.io/tx/0x347775718ca1fed0d3d9a59cf56ddcd8eddd09d1c9dd3a54872ab8a1f5c155ef) on record recovered [0xb36a…65f8](https://etherscan.io/address/0xb36a162cc0a18e958ebe87bb4f6ed1e4bb6d65f8), an account without code.

## Reviewer notes

### Mechanism

_verifySignature (contracts/src/PledgeSignature.sol, line 140) recovers a signer on line 170 and tests it on line 173 against a holder of its signing role. Neither isValidSignature selector is in the code, so that account is never asked. grantRole is in the code. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-10-02, recovering 0xb36a…65f8; 4 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
