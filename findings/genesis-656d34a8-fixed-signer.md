---
id: genesis-656d34a8-fixed-signer
format: 2
title: 'Genesis: its signer cannot be replaced and must not take real code'
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
  address: '0x656d34a8309363302e46de99853f4cef30b85a1d'
  name: Genesis
  code: verified
  code_url: https://etherscan.io/address/0x656d34a8309363302e46de99853f4cef30b85a1d#code
  copies: 1
  upgradeable: 'no'
  admin: '0x1ae98630d4b90661d9f17de73ebde17b544684ff'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 268
impact: liveness
action: Keep the signer's account free of real code, or deploy a replacement with a new signer first.
evidence_level: source
checks:
- id: recover
  source: '0x656d34a8309363302e46de99853f4cef30b85a1d'
  file: contracts/Genesis.sol
  line: 137
  has: address signer = ecrecover(prefixedHashMessage, _v, _r, _s);
  says: verifySignedAddress recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x656d34a8309363302e46de99853f4cef30b85a1d'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x656d34a8309363302e46de99853f4cef30b85a1d'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x656d34a8309363302e46de99853f4cef30b85a1d'
  file: contracts/Genesis.sol
  line: 138
  has: return signer == publicKey;
  says: the recovered address must be a signer fixed at deployment
  for:
  - evidence-1
  - justification
  - what
- id: written
  source: '0x656d34a8309363302e46de99853f4cef30b85a1d'
  file: contracts/Genesis.sol
  line: 31
  has: address internal constant publicKey = 0xFCDD24e44A8c669c2798394fc7091b84D360d916;
  says: the signer is written here, at deployment
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xfcdd24e44a8c669c2798394fc7091b84d360d916'
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

Genesis checks an ECDSA signature in verifySignedAddress and accepts only a signer fixed at deployment. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. The verified source has no function that replaces the signer.

## Evidence

- [verifySignedAddress](https://etherscan.io/address/0x656d34a8309363302e46de99853f4cef30b85a1d#code) recovers the signature with ECDSA and accepts only a signer fixed at deployment; the code never asks that account.
- The signer is written [at deployment](https://etherscan.io/address/0x656d34a8309363302e46de99853f4cef30b85a1d#code); the verified source has no function that writes it afterwards.
- The address recovered in its latest signature check on record is [0xfcdd…d916](https://etherscan.io/address/0xfcdd24e44a8c669c2798394fc7091b84d360d916), an account without code.

## Reviewer notes

### Mechanism

verifySignedAddress (contracts/Genesis.sol, line 123) recovers a signer on line 137 and tests it on line 138 against a signer fixed at deployment. Neither isValidSignature selector is in the code, so that account is never asked. publicKey is written on line 31 of contracts/Genesis.sol (at deployment); a search of every source file, libraries and constructors included, finds no other write, and the contract's own functions use no sstore and no delegatecall. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-11-05, recovering 0xfcdd…d916; 268 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
