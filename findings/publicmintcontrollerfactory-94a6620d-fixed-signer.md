---
id: publicmintcontrollerfactory-94a6620d-fixed-signer
format: 2
title: 'This contract: its signer cannot be replaced and must not take real code'
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
  address: '0x94a6620daeb4b426d05feeb3000548dc5dcf825f'
  name: PublicMintControllerFactory
  code: verified
  code_url: https://etherscan.io/address/0x94a6620daeb4b426d05feeb3000548dc5dcf825f#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 2
impact: liveness
action: Keep the signer's account free of real code, or deploy a replacement with a new signer first.
evidence_level: source
checks:
- id: recover
  source: '0x94a6620daeb4b426d05feeb3000548dc5dcf825f'
  file: fees/MintFeeAuthority.sol
  line: 26
  has: if (ECDSA.recover(digest, signature) != mintFeeSigner) revert InvalidMintFee();
  says: collectMintFee recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x94a6620daeb4b426d05feeb3000548dc5dcf825f'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x94a6620daeb4b426d05feeb3000548dc5dcf825f'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: written
  source: '0x94a6620daeb4b426d05feeb3000548dc5dcf825f'
  file: fees/MintFeeAuthority.sol
  line: 15
  has: mintFeeSigner = signer;
  says: the signer is written here, at deployment
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x94a6620daeb4b426d05feeb3000548dc5dcf825f'
  fn: mintFeeSigner()(address)
  is: '0x67f88866331cc75b2fa0776cc24fe7adc03e04f2'
  says: A signer fixed at deployment is 0x67f88866331cc75b2fa0776cc24fe7adc03e04f2 at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0x67f88866331cc75b2fa0776cc24fe7adc03e04f2'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x9ccb41bef7c7a0eb09a4d2eae1777224f3dae647a5897aa22b516ed0979fa3ee'
  ok: true
  says: a transaction in which this contract recovered a signature
  for:
  - evidence-3
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews: []
related: []
---

## What happens

This contract accepts a call to collectMintFee only with an ECDSA signature of a signer fixed at deployment. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. The verified source has no function that replaces the signer.

## Evidence

- [collectMintFee](https://etherscan.io/address/0x94a6620daeb4b426d05feeb3000548dc5dcf825f#code) recovers the signature with ECDSA and accepts only a signer fixed at deployment; the code never asks that account.
- The signer is written [at deployment](https://etherscan.io/address/0x94a6620daeb4b426d05feeb3000548dc5dcf825f#code); the verified source has no function that writes it afterwards.
- The signer at the block is [0x67f8…04f2](https://etherscan.io/address/0x67f88866331cc75b2fa0776cc24fe7adc03e04f2), an account without code.

## Reviewer notes

### Mechanism

collectMintFee (fees/MintFeeAuthority.sol, line 18) recovers a signer on line 26 and tests it on line 26 against a signer fixed at deployment (mintFeeSigner() returns 0x67f88866331cc75b2fa0776cc24fe7adc03e04f2). Neither isValidSignature selector is in the code, so that account is never asked. mintFeeSigner is written on line 15 of fees/MintFeeAuthority.sol (at deployment); a search of every source file, libraries and constructors included, finds no other write, and the contract's own functions use no sstore and no delegatecall. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-10-10, recovering 0x67f8…04f2; 2 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
