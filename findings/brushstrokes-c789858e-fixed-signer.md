---
id: brushstrokes-c789858e-fixed-signer
format: 2
title: 'BrushStrokes: its signer cannot be replaced and must not take real code'
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
  address: '0xc789858e3b777aa6b7b209921d9368c4e898167e'
  name: BrushStrokes
  code: verified
  code_url: https://etherscan.io/address/0xc789858e3b777aa6b7b209921d9368c4e898167e#code
  copies: 1
  upgradeable: 'no'
  admin: '0xe38b594bf7e0e65eb091b57715ee3059de596bc2'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 19
impact: liveness
action: Keep the signer's account free of real code, or deploy a replacement with a new signer first.
evidence_level: source
checks:
- id: recover
  source: '0xc789858e3b777aa6b7b209921d9368c4e898167e'
  file: contracts/BrushStrokes.sol
  line: 68
  has: require(messageHash.recover(signature) == _signatureVerifier, "Unrecognizable Hash");
  says: earlyMint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xc789858e3b777aa6b7b209921d9368c4e898167e'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xc789858e3b777aa6b7b209921d9368c4e898167e'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: written
  source: '0xc789858e3b777aa6b7b209921d9368c4e898167e'
  file: contracts/BrushStrokes.sol
  line: 29
  has: address private _signatureVerifier = 0x805c057A31B31c84F7759698298aD4dC6F8fA622;
  says: the signer is written here, at deployment
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x805c057a31b31c84f7759698298ad4dc6f8fa622'
  is: empty
  says: 'the address recovered in the latest signature check on record has no code: an ECDSA key controls it'
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

BrushStrokes accepts a call to earlyMint only with an ECDSA signature of a signer fixed at deployment. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. The verified source has no function that replaces the signer.

## Evidence

- [earlyMint](https://etherscan.io/address/0xc789858e3b777aa6b7b209921d9368c4e898167e#code) recovers the signature with ECDSA and accepts only a signer fixed at deployment; the code never asks that account.
- The signer is written [at deployment](https://etherscan.io/address/0xc789858e3b777aa6b7b209921d9368c4e898167e#code); the verified source has no function that writes it afterwards.
- The address recovered in its latest signature check on record is [0x805c…a622](https://etherscan.io/address/0x805c057a31b31c84f7759698298ad4dc6f8fa622), an account without code.

## Reviewer notes

### Mechanism

earlyMint (contracts/BrushStrokes.sol, line 60) recovers a signer on line 68 and tests it on line 68 against a signer fixed at deployment. Neither isValidSignature selector is in the code, so that account is never asked. _signatureVerifier is written on line 29 of contracts/BrushStrokes.sol (at deployment); a search of every source file, libraries and constructors included, finds no other write, and the contract's own functions use no sstore and no delegatecall. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2021-12-05, recovering 0x805c…a622; 19 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
