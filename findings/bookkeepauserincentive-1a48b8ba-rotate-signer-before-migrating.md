---
id: bookkeepauserincentive-1a48b8ba-rotate-signer-before-migrating
format: 2
title: 'BookkeepaUserIncentive: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1a48b8ba4f8efb18b6eebc8b91ee551abe7956f7'
  name: BookkeepaUserIncentive
  code: verified
  code_url: https://etherscan.io/address/0x1a48b8ba4f8efb18b6eebc8b91ee551abe7956f7#code
  copies: 1
  upgradeable: 'no'
  admin: '0x731c9d7b8e01af44a0f4dce6df9ffe82076121f3'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 7
impact: liveness
action: Replace the signer with updateAdminSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x1a48b8ba4f8efb18b6eebc8b91ee551abe7956f7'
  file: BookkeepaUserIncentive.sol
  line: 3755
  has: address recoveredSigner = ECDSA.recover(digest, signature);
  says: claim recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x1a48b8ba4f8efb18b6eebc8b91ee551abe7956f7'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x1a48b8ba4f8efb18b6eebc8b91ee551abe7956f7'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x1a48b8ba4f8efb18b6eebc8b91ee551abe7956f7'
  file: BookkeepaUserIncentive.sol
  line: 3757
  has: require(recoveredSigner == adminSigner, "Invalid signature");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x1a48b8ba4f8efb18b6eebc8b91ee551abe7956f7'
  file: BookkeepaUserIncentive.sol
  line: 3775
  has: function updateAdminSigner
  says: updateAdminSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x1a48b8ba4f8efb18b6eebc8b91ee551abe7956f7'
  fn: adminSigner()(address)
  is: '0xfd03af2cd5168384e3a8a0f80e8a5b77647c6051'
  says: The signer it keeps in storage is 0xfd03af2cd5168384e3a8a0f80e8a5b77647c6051 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xfd03af2cd5168384e3a8a0f80e8a5b77647c6051'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x1b8e6970d31a31c2c9c259286a980a83263cf8eef5879a383f620b3d2636e0eb'
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

BookkeepaUserIncentive accepts a call to claim only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. updateAdminSigner changes the signer.

## Evidence

- [claim](https://etherscan.io/address/0x1a48b8ba4f8efb18b6eebc8b91ee551abe7956f7#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [updateAdminSigner](https://etherscan.io/address/0x1a48b8ba4f8efb18b6eebc8b91ee551abe7956f7#code) changes the signer; only the owner can call it.
- The signer at the block is [0xfd03…6051](https://etherscan.io/address/0xfd03af2cd5168384e3a8a0f80e8a5b77647c6051), an account without code.

## Reviewer notes

### Mechanism

claim (BookkeepaUserIncentive.sol, line 3737) recovers a signer on line 3755 and tests it on line 3757 against the signer it keeps in storage (adminSigner() returns 0xfd03af2cd5168384e3a8a0f80e8a5b77647c6051). Neither isValidSignature selector is in the code, so that account is never asked. updateAdminSigner (BookkeepaUserIncentive.sol, line 3775) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-13, recovering 0xfd03…6051; 7 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
