---
id: gigalegendnft-17501063-rotate-signer-before-migrating
format: 2
title: 'GigaLegendNFT: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x17501063de376195de2505ef561d9d44c26b4a58'
  name: GigaLegendNFT
  code: verified
  code_url: https://etherscan.io/address/0x17501063de376195de2505ef561d9d44c26b4a58#code
  copies: 1
  upgradeable: 'no'
  admin: '0x20702cefe728119830b76861e19f6f15e88724ed'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 548
impact: liveness
action: Replace the signer with setVoucherSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x17501063de376195de2505ef561d9d44c26b4a58'
  file: src/legends/GigaLegendNFT.sol
  line: 154
  has: (address recovered, ECDSA.RecoverError err) = ECDSA.tryRecover(digest, signature);
  says: _verifySignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x17501063de376195de2505ef561d9d44c26b4a58'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x17501063de376195de2505ef561d9d44c26b4a58'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x17501063de376195de2505ef561d9d44c26b4a58'
  file: src/legends/GigaLegendNFT.sol
  line: 155
  has: if (err != ECDSA.RecoverError.NoError || recovered != signer) revert InvalidSignature();
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x17501063de376195de2505ef561d9d44c26b4a58'
  file: src/legends/GigaLegendNFT.sol
  line: 253
  has: function setVoucherSigner
  says: setVoucherSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x17501063de376195de2505ef561d9d44c26b4a58'
  fn: voucherSigner()(address)
  is: '0xed97d561afbf7efb4934807f4c67aaa607e5c6b8'
  says: The signer it keeps in storage is 0xed97d561afbf7efb4934807f4c67aaa607e5c6b8 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xed97d561afbf7efb4934807f4c67aaa607e5c6b8'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xc757f157a2035ae8ca07cbab2b23844b04d2e2bc9b8379f2ddc9029f75907602'
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

GigaLegendNFT checks an ECDSA signature in _verifySignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setVoucherSigner changes the signer.

## Evidence

- [_verifySignature](https://etherscan.io/address/0x17501063de376195de2505ef561d9d44c26b4a58#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setVoucherSigner](https://etherscan.io/address/0x17501063de376195de2505ef561d9d44c26b4a58#code) changes the signer; only a role holder can call it.
- The signer at the block is [0xed97…c6b8](https://etherscan.io/address/0xed97d561afbf7efb4934807f4c67aaa607e5c6b8), an account without code.

## Reviewer notes

### Mechanism

_verifySignature (src/legends/GigaLegendNFT.sol, line 151) recovers a signer on line 154 and tests it on line 155 against the signer it keeps in storage (voucherSigner() returns 0xed97d561afbf7efb4934807f4c67aaa607e5c6b8). Neither isValidSignature selector is in the code, so that account is never asked. setVoucherSigner (src/legends/GigaLegendNFT.sol, line 253) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-18, recovering 0xed97…c6b8; 548 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
