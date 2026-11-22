---
id: surreals-a4064893-fixed-signer
format: 2
title: 'Surreals: its signer cannot be replaced and must not take real code'
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
  address: '0xa406489360a47af2c74fc1004316a64e469646a5'
  name: Surreals
  code: verified
  code_url: https://etherscan.io/address/0xa406489360a47af2c74fc1004316a64e469646a5#code
  copies: 1
  upgradeable: 'no'
  admin: '0xe20a4f1e92dc89c17388886d37b2ed58f07e2f29'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 208
impact: liveness
action: Keep the signer's account free of real code, or deploy a replacement with a new signer first.
evidence_level: source
checks:
- id: recover
  source: '0xa406489360a47af2c74fc1004316a64e469646a5'
  file: Surreals.sol
  line: 36
  has: require(hash.recover(signature) == _signer, "INVALID_SIGNATURE");
  says: mint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xa406489360a47af2c74fc1004316a64e469646a5'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xa406489360a47af2c74fc1004316a64e469646a5'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: written
  source: '0xa406489360a47af2c74fc1004316a64e469646a5'
  file: Surreals.sol
  line: 18
  has: address internal constant _signer = 0x0190501d46a402020c75C2bD626c9b104DcC89a7;
  says: the signer is written here, at deployment
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x0190501d46a402020c75c2bd626c9b104dcc89a7'
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
  rating: HIGH
reviews: []
related: []
---

## What happens

Surreals accepts a call to mint only with an ECDSA signature of a signer fixed at deployment. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. The verified source has no function that replaces the signer.

## Evidence

- [mint](https://etherscan.io/address/0xa406489360a47af2c74fc1004316a64e469646a5#code) recovers the signature with ECDSA and accepts only a signer fixed at deployment; the code never asks that account.
- The signer is written [at deployment](https://etherscan.io/address/0xa406489360a47af2c74fc1004316a64e469646a5#code); the verified source has no function that writes it afterwards.
- The address recovered in its latest signature check on record is [0x0190…89a7](https://etherscan.io/address/0x0190501d46a402020c75c2bd626c9b104dcc89a7), an account without code.

## Reviewer notes

### Mechanism

mint (Surreals.sol, line 33) recovers a signer on line 36 and tests it on line 36 against a signer fixed at deployment. Neither isValidSignature selector is in the code, so that account is never asked. _signer is written on line 18 of Surreals.sol (at deployment); a search of every source file, libraries and constructors included, finds no other write, and the contract's own functions use no sstore and no delegatecall. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2021-12-29, recovering 0x0190…89a7; 208 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
