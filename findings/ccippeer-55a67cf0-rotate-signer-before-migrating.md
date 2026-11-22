---
id: ccippeer-55a67cf0-rotate-signer-before-migrating
format: 2
title: 'CCIPPeer: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x55a67cf07b8a9a09fb6d565279287cfe4ab60edc'
  name: CCIPPeer
  code: verified
  code_url: https://etherscan.io/address/0xd498e4aee5585ff8099158e641c025a761acc656#code
  proxy_of: '0xd498e4aee5585ff8099158e641c025a761acc656'
  copies: 4
  family: 4fa06057ae8c55744ffbb2e15257dafd
  upgradeable: 'yes'
  admin: '0x029e4fbdaa31de075dd74b2238222a08233978f6'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setSysSinger before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xd498e4aee5585ff8099158e641c025a761acc656'
  file: src/ccipPeer.sol
  line: 499
  has: address signer = ECDSA.recover(_digest, _signature);
  says: _verifySendTokenSign recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xd498e4aee5585ff8099158e641c025a761acc656'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xd498e4aee5585ff8099158e641c025a761acc656'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xd498e4aee5585ff8099158e641c025a761acc656'
  file: src/ccipPeer.sol
  line: 500
  has: return signer == sysSigner;
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xd498e4aee5585ff8099158e641c025a761acc656'
  file: src/ccipPeer.sol
  line: 232
  has: function setSysSinger
  says: setSysSinger changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x55a67cf07b8a9a09fb6d565279287cfe4ab60edc'
  fn: sysSigner()(address)
  is: '0x9ffb3befbfbe535e68b2d1ddd79aa0e1ef8dc863'
  says: The signer it keeps in storage is 0x9ffb3befbfbe535e68b2d1ddd79aa0e1ef8dc863 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x9ffb3befbfbe535e68b2d1ddd79aa0e1ef8dc863'
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

CCIPPeer checks an ECDSA signature in _verifySendTokenSign and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSysSinger changes the signer.

## Evidence

- [_verifySendTokenSign](https://etherscan.io/address/0xd498e4aee5585ff8099158e641c025a761acc656#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSysSinger](https://etherscan.io/address/0xd498e4aee5585ff8099158e641c025a761acc656#code) changes the signer; only a role holder can call it.
- The signer at the block is [0x9ffb…c863](https://etherscan.io/address/0x9ffb3befbfbe535e68b2d1ddd79aa0e1ef8dc863), an account without code.

## Reviewer notes

### Mechanism

_verifySendTokenSign (src/ccipPeer.sol, line 498) recovers a signer on line 499 and tests it on line 500 against the signer it keeps in storage (sysSigner() returns 0x9ffb3befbfbe535e68b2d1ddd79aa0e1ef8dc863). Neither isValidSignature selector is in the code, so that account is never asked. setSysSinger (src/ccipPeer.sol, line 232) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 4 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2025-11-07, recovering 0x9ffb…c863; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
