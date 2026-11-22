---
id: pmmadapter-4ecd468e-fixed-signer
format: 2
title: 'PMMAdapter: its signer cannot be replaced and must not take real code'
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
  address: '0x4ecd468e1010e006f768ec034e5a6d8803183469'
  name: PMMAdapter
  code: verified
  code_url: https://etherscan.io/address/0x4ecd468e1010e006f768ec034e5a6d8803183469#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 40164
impact: liveness
action: Keep the signer's account free of real code, or deploy a replacement with a new signer first.
evidence_level: source
checks:
- id: recover
  source: '0x4ecd468e1010e006f768ec034e5a6d8803183469'
  file: src/libraries/CallerAuth.sol
  line: 62
  has: address signer = ECDSA.recover(digest, r, vs);
  says: _verifyAuthCommon recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x4ecd468e1010e006f768ec034e5a6d8803183469'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x4ecd468e1010e006f768ec034e5a6d8803183469'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x4ecd468e1010e006f768ec034e5a6d8803183469'
  file: src/libraries/CallerAuth.sol
  line: 63
  has: if (signer != AUTH_SIGNER) revert AUTH_BadAuthSig();
  says: the recovered address must be a signer fixed at deployment
  for:
  - evidence-1
  - justification
  - what
- id: written
  source: '0x4ecd468e1010e006f768ec034e5a6d8803183469'
  file: src/libraries/CallerAuth.sol
  line: 26
  has: AUTH_SIGNER = authSigner;
  says: the signer is written here, at deployment
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x4ecd468e1010e006f768ec034e5a6d8803183469'
  fn: AUTH_SIGNER()(address)
  is: '0x9a2d7c63a53c9e40ababe7d285a971c11035d0e6'
  says: A signer fixed at deployment is 0x9a2d7c63a53c9e40ababe7d285a971c11035d0e6 at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0x9a2d7c63a53c9e40ababe7d285a971c11035d0e6'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x8e17dd48c26ad50d539870699dcebef0575de1e670bf50c2d35727f569c6b3cb'
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

PMMAdapter checks an ECDSA signature in _verifyAuthCommon and accepts only a signer fixed at deployment. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. The verified source has no function that replaces the signer.

## Evidence

- [_verifyAuthCommon](https://etherscan.io/address/0x4ecd468e1010e006f768ec034e5a6d8803183469#code) recovers the signature with ECDSA and accepts only a signer fixed at deployment; the code never asks that account.
- The signer is written [at deployment](https://etherscan.io/address/0x4ecd468e1010e006f768ec034e5a6d8803183469#code); the verified source has no function that writes it afterwards.
- The signer at the block is [0x9a2d…d0e6](https://etherscan.io/address/0x9a2d7c63a53c9e40ababe7d285a971c11035d0e6), an account without code.

## Reviewer notes

### Mechanism

_verifyAuthCommon (src/libraries/CallerAuth.sol, line 45) recovers a signer on line 62 and tests it on line 63 against a signer fixed at deployment (AUTH_SIGNER() returns 0x9a2d7c63a53c9e40ababe7d285a971c11035d0e6). Neither isValidSignature selector is in the code, so that account is never asked. AUTH_SIGNER is written on line 26 of src/libraries/CallerAuth.sol (at deployment); a search of every source file, libraries and constructors included, finds no other write, and the contract's own functions use no sstore and no delegatecall. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-17, recovering 0x9a2d…d0e6; 40,164 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
