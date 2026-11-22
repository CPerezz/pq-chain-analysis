---
id: fairwin-7f6f3012-rotate-signer-before-migrating
format: 2
title: 'FairWin: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7f6f3012373b4fc7c33812402a880407eeac317c'
  name: FairWin
  code: verified
  code_url: https://etherscan.io/address/0x7f6f3012373b4fc7c33812402a880407eeac317c#code
  copies: 11
  family: a0ab4c690757f3549d3a7ccdfaa737d0
  upgradeable: 'no'
  admin: '0x360778032e302a6a7a537071c5fd6b0f4e5af07b'
value:
  usd: 1714
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setSecretSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x7f6f3012373b4fc7c33812402a880407eeac317c'
  file: FairWin.sol
  line: 229
  has: require (secretSigner == ecrecover(signatureHash, 27, r, s), "ECDSA signature is not valid.");
  says: placeBet recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x7f6f3012373b4fc7c33812402a880407eeac317c'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x7f6f3012373b4fc7c33812402a880407eeac317c'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x7f6f3012373b4fc7c33812402a880407eeac317c'
  file: FairWin.sol
  line: 150
  has: function setSecretSigner
  says: setSecretSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x7f6f3012373b4fc7c33812402a880407eeac317c'
  fn: secretSigner()(address)
  is: '0xc891500ba615f153167897568e475d99a0a4f6bc'
  says: The signer it keeps in storage is 0xc891500ba615f153167897568e475d99a0a4f6bc at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xc891500ba615f153167897568e475d99a0a4f6bc'
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

FairWin accepts a call to placeBet only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSecretSigner changes the signer.

## Evidence

- [placeBet](https://etherscan.io/address/0x7f6f3012373b4fc7c33812402a880407eeac317c#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSecretSigner](https://etherscan.io/address/0x7f6f3012373b4fc7c33812402a880407eeac317c#code) changes the signer; only the owner can call it.
- The signer at the block is [0xc891…f6bc](https://etherscan.io/address/0xc891500ba615f153167897568e475d99a0a4f6bc), an account without code.

## Reviewer notes

### Mechanism

placeBet (FairWin.sol, line 215) recovers a signer on line 229 and tests it on line 229 against the signer it keeps in storage (secretSigner() returns 0xc891500ba615f153167897568e475d99a0a4f6bc). Neither isValidSignature selector is in the code, so that account is never asked. setSecretSigner (FairWin.sol, line 150) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 11 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2020-05-02, recovering 0xc891…f6bc; 0 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
