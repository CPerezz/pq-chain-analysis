---
id: partyspudclub-991be426-fixed-signer
format: 2
title: 'PartySpudClub: its signer cannot be replaced and must not take real code'
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
  address: '0x991be42680e2546ec01ebeb6790baa522681bf61'
  name: PartySpudClub
  code: verified
  code_url: https://etherscan.io/address/0x991be42680e2546ec01ebeb6790baa522681bf61#code
  copies: 2
  family: 3b629cdc2190155b4c6d333dcdae5b37
  upgradeable: 'no'
value:
  usd: 2
  basis: held
activity:
  txs_90d: 1
impact: liveness
action: Keep the signer's account free of real code, or deploy a replacement with a new signer first.
evidence_level: source
checks:
- id: recover
  source: '0x991be42680e2546ec01ebeb6790baa522681bf61'
  file: contracts/PartySpudClub.sol
  line: 342
  has: address signer = ecrecover(digest, voucher.v, voucher.r, voucher.s);
  says: _isVerifiedVoucher recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x991be42680e2546ec01ebeb6790baa522681bf61'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x991be42680e2546ec01ebeb6790baa522681bf61'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x991be42680e2546ec01ebeb6790baa522681bf61'
  file: contracts/PartySpudClub.sol
  line: 343
  has: 'require(signer != address(0), ''ECDSA: invalid voucher'');'
  says: the recovered address must be a signer fixed at deployment
  for:
  - evidence-1
  - justification
  - what
- id: written
  source: '0x991be42680e2546ec01ebeb6790baa522681bf61'
  file: contracts/PartySpudClub.sol
  line: 87
  has: adminSigner = _adminSigner;
  says: the signer is written here, at deployment
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x991be42680e2546ec01ebeb6790baa522681bf61'
  fn: adminSigner()(address)
  is: '0xc1d7dbd73af45f7bcd5bed3049dc9da4c75c79a0'
  says: A signer fixed at deployment is 0xc1d7dbd73af45f7bcd5bed3049dc9da4c75c79a0 at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0xc1d7dbd73af45f7bcd5bed3049dc9da4c75c79a0'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
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

PartySpudClub checks an ECDSA signature in _isVerifiedVoucher and accepts only a signer fixed at deployment. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. The verified source has no function that replaces the signer.

## Evidence

- [_isVerifiedVoucher](https://etherscan.io/address/0x991be42680e2546ec01ebeb6790baa522681bf61#code) recovers the signature with ECDSA and accepts only a signer fixed at deployment; the code never asks that account.
- The signer is written [at deployment](https://etherscan.io/address/0x991be42680e2546ec01ebeb6790baa522681bf61#code); the verified source has no function that writes it afterwards.
- The signer at the block is [0xc1d7…79a0](https://etherscan.io/address/0xc1d7dbd73af45f7bcd5bed3049dc9da4c75c79a0), an account without code.

## Reviewer notes

### Mechanism

_isVerifiedVoucher (contracts/PartySpudClub.sol, line 337) recovers a signer on line 342 and tests it on line 343 against a signer fixed at deployment (adminSigner() returns 0xc1d7dbd73af45f7bcd5bed3049dc9da4c75c79a0). Neither isValidSignature selector is in the code, so that account is never asked. adminSigner is written on line 87 of contracts/PartySpudClub.sol (at deployment); a search of every source file, libraries and constructors included, finds no other write, and the contract's own functions use no sstore and no delegatecall. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2024-01-06, recovering 0xc1d7…79a0; 1 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
