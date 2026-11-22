---
id: gobridgemanager-v1-3cf8f4ab-rotate-signer-before-migrating
format: 2
title: 'GoBridgeManager_V1: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x3cf8f4aba78848012d9ba3d4f3b543669287107b'
  name: GoBridgeManager_V1
  code: verified
  code_url: https://etherscan.io/address/0x3cf8f4aba78848012d9ba3d4f3b543669287107b#code
  copies: 1
  upgradeable: 'no'
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
  source: '0x3cf8f4aba78848012d9ba3d4f3b543669287107b'
  file: src/GoBridgeManager_V1.sol
  line: 518
  has: address signer = ECDSA.recover(digest, q.signature);
  says: _verifyFeeQuote recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x3cf8f4aba78848012d9ba3d4f3b543669287107b'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x3cf8f4aba78848012d9ba3d4f3b543669287107b'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x3cf8f4aba78848012d9ba3d4f3b543669287107b'
  file: src/GoBridgeManager_V1.sol
  line: 519
  has: if (!hasRole(OPS_ADMIN_ROLE, signer)) revert ErrBadSignature();
  says: the recovered address must be a holder of its signing role
  for:
  - evidence-1
  - justification
  - what
- id: setter
  selector: '0x3cf8f4aba78848012d9ba3d4f3b543669287107b'
  fn: grantRole(bytes32,address)
  says: the code has grantRole
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x4fcf369f63ad85e95994ebfe1f5e4287f005d550'
  is: delegation
  target: '0x63c0c19a282a1b52b07dd5a65b58948a07dae32b'
  says: 'the address recovered in the latest signature check on record holds an EIP-7702 delegation: an ECDSA key
    still controls it'
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

GoBridgeManager_V1 checks an ECDSA signature in _verifyFeeQuote and accepts only a holder of its signing role. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. grantRole changes who may sign.

## Evidence

- [_verifyFeeQuote](https://etherscan.io/address/0x3cf8f4aba78848012d9ba3d4f3b543669287107b#code) recovers the signature with ECDSA and accepts only a holder of its signing role; the code never asks that account.
- [grantRole](https://etherscan.io/address/0x3cf8f4aba78848012d9ba3d4f3b543669287107b#code) changes who may sign.
- The address recovered in its latest signature check on record is [0x4fcf…d550](https://etherscan.io/address/0x4fcf369f63ad85e95994ebfe1f5e4287f005d550), an account with an EIP-7702 delegation, which keeps working.

## Reviewer notes

### Mechanism

_verifyFeeQuote (src/GoBridgeManager_V1.sol, line 504) recovers a signer on line 518 and tests it on line 519 against a holder of its signing role. Neither isValidSignature selector is in the code, so that account is never asked. grantRole is in the code. The signer's account holds an EIP-7702 delegation to 0x63c0c19a282a1b52b07dd5a65b58948a07dae32b. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2025-11-03, recovering 0x4fcf…d550; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
