---
id: paymentcontract-ec16e374-rotate-signer-before-migrating
format: 2
title: 'PaymentContract: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xec16e37473557dea8f4fcb43c220019c8668efd4'
  name: PaymentContract
  code: verified
  code_url: https://etherscan.io/address/0xec16e37473557dea8f4fcb43c220019c8668efd4#code
  copies: 1
  upgradeable: 'no'
  admin: '0x03b4b876cdffcc20d23290e96ed646e35bd84779'
value:
  usd: 9
  basis: held
activity:
  txs_90d: 10
impact: liveness
action: Replace the signer with setAuthorizedSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xec16e37473557dea8f4fcb43c220019c8668efd4'
  file: project/src/PaymentContract.sol
  line: 226
  has: if (_recover(digest, signature) != authorizedSigner) revert InvalidSignature();
  says: selfRegisterBeneficiaryWallet recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xec16e37473557dea8f4fcb43c220019c8668efd4'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xec16e37473557dea8f4fcb43c220019c8668efd4'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xec16e37473557dea8f4fcb43c220019c8668efd4'
  file: project/src/PaymentContract.sol
  line: 163
  has: function setAuthorizedSigner
  says: setAuthorizedSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xec16e37473557dea8f4fcb43c220019c8668efd4'
  fn: authorizedSigner()(address)
  is: '0x7a96c39da7fe9e2eb2ae63d9048da02b6a5ef6f9'
  says: The signer it keeps in storage is 0x7a96c39da7fe9e2eb2ae63d9048da02b6a5ef6f9 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x7a96c39da7fe9e2eb2ae63d9048da02b6a5ef6f9'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x8ab0dde5532744486a849b3f436dac1b50972c0c49f915e7772c652465ec584f'
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

PaymentContract accepts a call to selfRegisterBeneficiaryWallet only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setAuthorizedSigner changes the signer.

## Evidence

- [selfRegisterBeneficiaryWallet](https://etherscan.io/address/0xec16e37473557dea8f4fcb43c220019c8668efd4#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setAuthorizedSigner](https://etherscan.io/address/0xec16e37473557dea8f4fcb43c220019c8668efd4#code) changes the signer; only the owner can call it.
- The signer at the block is [0x7a96…f6f9](https://etherscan.io/address/0x7a96c39da7fe9e2eb2ae63d9048da02b6a5ef6f9), an account without code.

## Reviewer notes

### Mechanism

selfRegisterBeneficiaryWallet (project/src/PaymentContract.sol, line 199) recovers a signer on line 226 and tests it on line 226 against the signer it keeps in storage (authorizedSigner() returns 0x7a96c39da7fe9e2eb2ae63d9048da02b6a5ef6f9). Neither isValidSignature selector is in the code, so that account is never asked. setAuthorizedSigner (project/src/PaymentContract.sol, line 163) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-08-21, recovering 0x7a96…f6f9; 10 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
