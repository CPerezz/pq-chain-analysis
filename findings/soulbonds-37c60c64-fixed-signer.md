---
id: soulbonds-37c60c64-fixed-signer
format: 2
title: 'Soulbonds: its signer cannot be replaced and must not take real code'
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
  address: '0x37c60c642934d82c36f8d94f893c2acee90a6e5e'
  name: Soulbonds
  code: verified
  code_url: https://etherscan.io/address/0x37c60c642934d82c36f8d94f893c2acee90a6e5e#code
  copies: 2
  family: a2acc34d75b56cef5da2bbb3e97da545
  upgradeable: 'no'
  admin: '0x10f55205faaaed53b24accc6294730897d005acf'
value:
  usd: 485
  basis: held
activity:
  txs_90d: 3
impact: liveness
action: Keep the signer's account free of real code, or deploy a replacement with a new signer first.
evidence_level: source
checks:
- id: recover
  source: '0x37c60c642934d82c36f8d94f893c2acee90a6e5e'
  file: src/contracts/Soulbonds.sol
  line: 214
  has: (address recoveredSigner, ECDSA.RecoverError recoverError) = ethSignedMessageHash.tryRecover(signature);
  says: _verify recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x37c60c642934d82c36f8d94f893c2acee90a6e5e'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x37c60c642934d82c36f8d94f893c2acee90a6e5e'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x37c60c642934d82c36f8d94f893c2acee90a6e5e'
  file: src/contracts/Soulbonds.sol
  line: 215
  has: require(recoverError == ECDSA.RecoverError.NoError, "Error retrieving signature author");
  says: the recovered address must be a signer fixed at deployment
  for:
  - evidence-1
  - justification
  - what
- id: written
  source: '0x37c60c642934d82c36f8d94f893c2acee90a6e5e'
  file: src/contracts/Soulbonds.sol
  line: 13
  has: address constant public METADATA_SIGNER = 0x1F89047445b44708bDbb4fA1620eDb4dB9249D57;
  says: the signer is written here, at deployment
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x37c60c642934d82c36f8d94f893c2acee90a6e5e'
  fn: METADATA_SIGNER()(address)
  is: '0x1f89047445b44708bdbb4fa1620edb4db9249d57'
  says: A signer fixed at deployment is 0x1f89047445b44708bdbb4fa1620edb4db9249d57 at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0x1f89047445b44708bdbb4fa1620edb4db9249d57'
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
  rating: HIGH
reviews: []
related: []
---

## What happens

Soulbonds checks an ECDSA signature in _verify and accepts only a signer fixed at deployment. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. The verified source has no function that replaces the signer.

## Evidence

- [_verify](https://etherscan.io/address/0x37c60c642934d82c36f8d94f893c2acee90a6e5e#code) recovers the signature with ECDSA and accepts only a signer fixed at deployment; the code never asks that account.
- The signer is written [at deployment](https://etherscan.io/address/0x37c60c642934d82c36f8d94f893c2acee90a6e5e#code); the verified source has no function that writes it afterwards.
- The signer at the block is [0x1f89…9d57](https://etherscan.io/address/0x1f89047445b44708bdbb4fa1620edb4db9249d57), an account without code.

## Reviewer notes

### Mechanism

_verify (src/contracts/Soulbonds.sol, line 209) recovers a signer on line 214 and tests it on line 215 against a signer fixed at deployment (METADATA_SIGNER() returns 0x1f89047445b44708bdbb4fa1620edb4db9249d57). Neither isValidSignature selector is in the code, so that account is never asked. METADATA_SIGNER is written on line 13 of src/contracts/Soulbonds.sol (at deployment); a search of every source file, libraries and constructors included, finds no other write, and the contract's own functions use no sstore and no delegatecall. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-03-08, recovering 0x1f89…9d57; 3 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
