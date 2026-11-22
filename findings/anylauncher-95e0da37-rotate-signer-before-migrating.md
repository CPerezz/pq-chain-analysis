---
id: anylauncher-95e0da37-rotate-signer-before-migrating
format: 2
title: 'AnyLauncher: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x95e0da371711502eed78bcc3f17856b4415120ca'
  name: AnyLauncher
  code: verified
  code_url: https://etherscan.io/address/0x95e0da371711502eed78bcc3f17856b4415120ca#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 1
  basis: held
activity:
  txs_90d: 1408
impact: liveness
action: Replace the signer with setPriceSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x95e0da371711502eed78bcc3f17856b4415120ca'
  file: src/AnyLauncher.sol
  line: 300
  has: (address signer, ECDSA.RecoverError err,) = ECDSA.tryRecover(quoteDigest(pair, q.priceUsdE8, q.deadline),
    q.si
  says: _verifyQuote recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x95e0da371711502eed78bcc3f17856b4415120ca'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x95e0da371711502eed78bcc3f17856b4415120ca'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x95e0da371711502eed78bcc3f17856b4415120ca'
  file: src/AnyLauncher.sol
  line: 301
  has: require(err == ECDSA.RecoverError.NoError && signer == priceSigner, "bad price signature");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x95e0da371711502eed78bcc3f17856b4415120ca'
  file: src/AnyLauncher.sol
  line: 208
  has: function setPriceSigner
  says: setPriceSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x95e0da371711502eed78bcc3f17856b4415120ca'
  fn: priceSigner()(address)
  is: '0xfcd96cda50585dbc5f1753c1a4a1dc59a6d52eaf'
  says: The signer it keeps in storage is 0xfcd96cda50585dbc5f1753c1a4a1dc59a6d52eaf at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xfcd96cda50585dbc5f1753c1a4a1dc59a6d52eaf'
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

AnyLauncher checks an ECDSA signature in _verifyQuote and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setPriceSigner changes the signer.

## Evidence

- [_verifyQuote](https://etherscan.io/address/0x95e0da371711502eed78bcc3f17856b4415120ca#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setPriceSigner](https://etherscan.io/address/0x95e0da371711502eed78bcc3f17856b4415120ca#code) changes the signer.
- The signer at the block is [0xfcd9…2eaf](https://etherscan.io/address/0xfcd96cda50585dbc5f1753c1a4a1dc59a6d52eaf), an account without code.

## Reviewer notes

### Mechanism

_verifyQuote (src/AnyLauncher.sol, line 296) recovers a signer on line 300 and tests it on line 301 against the signer it keeps in storage (priceSigner() returns 0xfcd96cda50585dbc5f1753c1a4a1dc59a6d52eaf). Neither isValidSignature selector is in the code, so that account is never asked. setPriceSigner (src/AnyLauncher.sol, line 208) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 1,408 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
