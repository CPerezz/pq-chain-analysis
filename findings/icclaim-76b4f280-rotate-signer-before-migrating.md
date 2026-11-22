---
id: icclaim-76b4f280-rotate-signer-before-migrating
format: 2
title: 'ICClaim: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x76b4f2802a23cd169ba94a3475d2f295e3b90f53'
  name: ICClaim
  code: verified
  code_url: https://etherscan.io/address/0xabec6633f70b9ad2bc34bada502592d654599dee#code
  proxy_of: '0xabec6633f70b9ad2bc34bada502592d654599dee'
  copies: 2
  family: 8ec0c09105ac54792b46d3f119d91b87
  upgradeable: 'yes'
  admin: '0x9742702192a5292d3001dad58a58f426c954ea2a'
value:
  usd: 250
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setSignerWallet before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xabec6633f70b9ad2bc34bada502592d654599dee'
  file: contracts/ICClaim.sol
  line: 426
  has: address signer = ECDSA.recover(hash, _v, _r, _s);
  says: _matchAddressSigner recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xabec6633f70b9ad2bc34bada502592d654599dee'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xabec6633f70b9ad2bc34bada502592d654599dee'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xabec6633f70b9ad2bc34bada502592d654599dee'
  file: contracts/ICClaim.sol
  line: 427
  has: return signer == signerWallet;
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xabec6633f70b9ad2bc34bada502592d654599dee'
  file: contracts/ICClaim.sol
  line: 199
  has: function setSignerWallet
  says: setSignerWallet changes the signer
  for:
  - action
  - evidence-2
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

ICClaim checks an ECDSA signature in _matchAddressSigner and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSignerWallet changes the signer.

## Evidence

- [_matchAddressSigner](https://etherscan.io/address/0xabec6633f70b9ad2bc34bada502592d654599dee#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSignerWallet](https://etherscan.io/address/0xabec6633f70b9ad2bc34bada502592d654599dee#code) changes the signer; only the owner can call it.

## Reviewer notes

### Mechanism

_matchAddressSigner (contracts/ICClaim.sol, line 406) recovers a signer on line 426 and tests it on line 427 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setSignerWallet (contracts/ICClaim.sol, line 199) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-03-19; 0 transactions called the address in the 90 days before the block. 54 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
