---
id: transitstation-49aaa987-rotate-signer-before-migrating
format: 2
title: 'TransitStation: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x49aaa987b1a7e9e4ae091dcd8332c39f322d7d28'
  name: TransitStation
  code: verified
  code_url: https://etherscan.io/address/0x49aaa987b1a7e9e4ae091dcd8332c39f322d7d28#code
  copies: 1
  upgradeable: 'no'
  admin: '0x0000000000417626ef34d62c4dc189b021603f2f'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 3690
impact: liveness
action: Replace the signer with setQuoteSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x49aaa987b1a7e9e4ae091dcd8332c39f322d7d28'
  file: src/transit/TransitStation.sol
  line: 595
  has: address signer = ECDSA.recover(digest, signature);
  says: _verifyAndCollect recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x49aaa987b1a7e9e4ae091dcd8332c39f322d7d28'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x49aaa987b1a7e9e4ae091dcd8332c39f322d7d28'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x49aaa987b1a7e9e4ae091dcd8332c39f322d7d28'
  file: src/transit/TransitStation.sol
  line: 596
  has: if (signer != quoteSigner) revert InvalidSigner(signer);
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x49aaa987b1a7e9e4ae091dcd8332c39f322d7d28'
  file: src/transit/TransitStation.sol
  line: 423
  has: function setQuoteSigner
  says: setQuoteSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x49aaa987b1a7e9e4ae091dcd8332c39f322d7d28'
  fn: quoteSigner()(address)
  is: '0xe4a40e9e04eb7f33368d998fd423073b778ce420'
  says: The signer it keeps in storage is 0xe4a40e9e04eb7f33368d998fd423073b778ce420 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xe4a40e9e04eb7f33368d998fd423073b778ce420'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xe11741d56ff561132c21bc76a5174af2de6535b0369bbdbcbef5f3aa8720c7a9'
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

TransitStation checks an ECDSA signature in _verifyAndCollect and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setQuoteSigner changes the signer.

## Evidence

- [_verifyAndCollect](https://etherscan.io/address/0x49aaa987b1a7e9e4ae091dcd8332c39f322d7d28#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setQuoteSigner](https://etherscan.io/address/0x49aaa987b1a7e9e4ae091dcd8332c39f322d7d28#code) changes the signer; only a role holder can call it.
- The signer at the block is [0xe4a4…e420](https://etherscan.io/address/0xe4a40e9e04eb7f33368d998fd423073b778ce420), an account without code.

## Reviewer notes

### Mechanism

_verifyAndCollect (src/transit/TransitStation.sol, line 570) recovers a signer on line 595 and tests it on line 596 against the signer it keeps in storage (quoteSigner() returns 0xe4a40e9e04eb7f33368d998fd423073b778ce420). Neither isValidSignature selector is in the code, so that account is never asked. setQuoteSigner (src/transit/TransitStation.sol, line 423) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-17, recovering 0xe4a4…e420; 3,690 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
