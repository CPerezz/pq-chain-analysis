---
id: testhack-1b639e1e-rotate-signer-before-migrating
format: 2
title: 'testhack: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1b639e1e56f19346296a4abc0c67b70de43eb74c'
  name: testhack
  code: verified
  code_url: https://etherscan.io/address/0x1b639e1e56f19346296a4abc0c67b70de43eb74c#code
  copies: 1
  admin: '0x1841b534f9cf6c80ef9d2f0563e1fe29de7b3a5b'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setAllowlistSignerAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x1b639e1e56f19346296a4abc0c67b70de43eb74c'
  file: contracts/testhack.sol
  line: 237
  has: if (recoverSigner(message, signature) != allowlistSignerAddress) revert InvalidAllowlistSignature();
  says: allowlistMint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x1b639e1e56f19346296a4abc0c67b70de43eb74c'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x1b639e1e56f19346296a4abc0c67b70de43eb74c'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x1b639e1e56f19346296a4abc0c67b70de43eb74c'
  file: contracts/testhack.sol
  line: 158
  has: function setAllowlistSignerAddress
  says: setAllowlistSignerAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x1b639e1e56f19346296a4abc0c67b70de43eb74c'
  fn: allowlistSignerAddress()(address)
  is: '0x4a09823f4408aa32c30d8ba722cedc7b5d1acf32'
  says: The signer it keeps in storage is 0x4a09823f4408aa32c30d8ba722cedc7b5d1acf32 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x4a09823f4408aa32c30d8ba722cedc7b5d1acf32'
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

testhack accepts a call to allowlistMint only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setAllowlistSignerAddress changes the signer.

## Evidence

- [allowlistMint](https://etherscan.io/address/0x1b639e1e56f19346296a4abc0c67b70de43eb74c#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setAllowlistSignerAddress](https://etherscan.io/address/0x1b639e1e56f19346296a4abc0c67b70de43eb74c#code) changes the signer; only the owner can call it.
- The signer at the block is [0x4a09…cf32](https://etherscan.io/address/0x4a09823f4408aa32c30d8ba722cedc7b5d1acf32), an account without code.

## Reviewer notes

### Mechanism

allowlistMint (contracts/testhack.sol, line 213) recovers a signer on line 237 and tests it on line 237 against the signer it keeps in storage (allowlistSignerAddress() returns 0x4a09823f4408aa32c30d8ba722cedc7b5d1acf32). Neither isValidSignature selector is in the code, so that account is never asked. setAllowlistSignerAddress (contracts/testhack.sol, line 158) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-07-09, recovering 0x4a09…cf32; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
