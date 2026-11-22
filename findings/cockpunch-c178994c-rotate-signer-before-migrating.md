---
id: cockpunch-c178994c-rotate-signer-before-migrating
format: 2
title: 'Cockpunch: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc178994cb9b66307cd62db8b411759dd36d9c2ee'
  name: Cockpunch
  code: verified
  code_url: https://etherscan.io/address/0xc178994cb9b66307cd62db8b411759dd36d9c2ee#code
  copies: 1
  upgradeable: 'no'
  admin: '0x70c71b539bdcb5b59edd42a500fd95bdec962650'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 369
impact: liveness
action: Replace the signer with setPremintSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xc178994cb9b66307cd62db8b411759dd36d9c2ee'
  file: lib/premint-connect/services/contracts/src/PremintReady.sol
  line: 154
  has: if (premintSigner() != ECDSA.recover(digest, signature)) {
  says: _premint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xc178994cb9b66307cd62db8b411759dd36d9c2ee'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xc178994cb9b66307cd62db8b411759dd36d9c2ee'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xc178994cb9b66307cd62db8b411759dd36d9c2ee'
  file: src/Cockpunch.sol
  line: 299
  has: function setPremintSigner
  says: setPremintSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xc178994cb9b66307cd62db8b411759dd36d9c2ee'
  fn: premintSigner()(address)
  is: '0xe04f2dce67621e337bb920ffc2575391d346cc26'
  says: The signer it keeps in storage is 0xe04f2dce67621e337bb920ffc2575391d346cc26 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xe04f2dce67621e337bb920ffc2575391d346cc26'
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

Cockpunch checks an ECDSA signature in _premint and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setPremintSigner changes the signer.

## Evidence

- [_premint](https://etherscan.io/address/0xc178994cb9b66307cd62db8b411759dd36d9c2ee#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setPremintSigner](https://etherscan.io/address/0xc178994cb9b66307cd62db8b411759dd36d9c2ee#code) changes the signer; only the owner can call it.
- The signer at the block is [0xe04f…cc26](https://etherscan.io/address/0xe04f2dce67621e337bb920ffc2575391d346cc26), an account without code.

## Reviewer notes

### Mechanism

_premint (lib/premint-connect/services/contracts/src/PremintReady.sol, line 19) recovers a signer on line 154 and tests it on line 154 against the signer it keeps in storage (premintSigner() returns 0xe04f2dce67621e337bb920ffc2575391d346cc26). Neither isValidSignature selector is in the code, so that account is never asked. setPremintSigner (src/Cockpunch.sol, line 299) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-12-18, recovering 0xe04f…cc26; 369 transactions called the address in the 90 days before the block. 5 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
