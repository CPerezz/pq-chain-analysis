---
id: lootadog-68b9c676-rotate-signer-before-migrating
format: 2
title: 'LOOTaDOG: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x68b9c676b21e24b7bda336fc048021339bbb3382'
  name: LOOTaDOG
  code: verified
  code_url: https://etherscan.io/address/0x68b9c676b21e24b7bda336fc048021339bbb3382#code
  copies: 1
  upgradeable: 'no'
  admin: '0x01c6117707847f28eccb0547a2e4e7c4e3df3704'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 9
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x68b9c676b21e24b7bda336fc048021339bbb3382'
  file: contracts/LOOTaDOG.sol
  line: 174
  has: address signer = ecrecover(_hashVoucher(voucher), v, r, s);
  says: _verifySign recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x68b9c676b21e24b7bda336fc048021339bbb3382'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x68b9c676b21e24b7bda336fc048021339bbb3382'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x68b9c676b21e24b7bda336fc048021339bbb3382'
  file: contracts/LOOTaDOG.sol
  line: 175
  has: require(_signer == signer, "Invalid signer");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x68b9c676b21e24b7bda336fc048021339bbb3382'
  file: contracts/LOOTaDOG.sol
  line: 151
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x68b9c676b21e24b7bda336fc048021339bbb3382'
  fn: getSigner()(address)
  is: '0x1d47fdce93661c67ed3973ce65311b4146e43930'
  says: The signer it keeps in storage is 0x1d47fdce93661c67ed3973ce65311b4146e43930 at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0x1d47fdce93661c67ed3973ce65311b4146e43930'
  is: delegation
  target: '0x2e13de8763a53a6af340930fadcad966ee79c845'
  says: 'the signer''s account holds an EIP-7702 delegation: an ECDSA key still controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x78934d946f69b3f131f3d6be8ec4be5cc668ba60df4122e9c5d2f3e40355b4da'
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

LOOTaDOG checks an ECDSA signature in _verifySign and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [_verifySign](https://etherscan.io/address/0x68b9c676b21e24b7bda336fc048021339bbb3382#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0x68b9c676b21e24b7bda336fc048021339bbb3382#code) changes the signer; only the owner can call it.
- The signer at the block is [0x1d47…3930](https://etherscan.io/address/0x1d47fdce93661c67ed3973ce65311b4146e43930), an account with an EIP-7702 delegation, which keeps working.

## Reviewer notes

### Mechanism

_verifySign (contracts/LOOTaDOG.sol, line 168) recovers a signer on line 174 and tests it on line 175 against the signer it keeps in storage (getSigner() returns 0x1d47fdce93661c67ed3973ce65311b4146e43930). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (contracts/LOOTaDOG.sol, line 151) writes it. The signer's account holds an EIP-7702 delegation to 0x2e13de8763a53a6af340930fadcad966ee79c845. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-10-17, recovering 0x1d47…3930; 9 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
