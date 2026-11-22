---
id: bmasachievements-c4d2cc43-rotate-signer-before-migrating
format: 2
title: 'BMASAchievements: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc4d2cc4363a8a8a72c5fe35f53a56b095a29c7b0'
  name: BMASAchievements
  code: verified
  code_url: https://etherscan.io/address/0xc4d2cc4363a8a8a72c5fe35f53a56b095a29c7b0#code
  copies: 1
  upgradeable: 'no'
  admin: '0x25ded7f2beaa23e1477cab3c3dde57ed1e86b944'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 58
impact: liveness
action: Replace the signer with setClaimSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xc4d2cc4363a8a8a72c5fe35f53a56b095a29c7b0'
  file: src/BMASAchievements.sol
  line: 216
  has: ECDSA.recover(claimDigest(recipient, achievementKeys, nonce, deadline), signature);
  says: claim recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xc4d2cc4363a8a8a72c5fe35f53a56b095a29c7b0'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xc4d2cc4363a8a8a72c5fe35f53a56b095a29c7b0'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xc4d2cc4363a8a8a72c5fe35f53a56b095a29c7b0'
  file: src/BMASAchievements.sol
  line: 217
  has: if (recoveredSigner != claimSigner) revert InvalidClaimSigner(recoveredSigner);
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xc4d2cc4363a8a8a72c5fe35f53a56b095a29c7b0'
  file: src/BMASAchievements.sol
  line: 299
  has: function setClaimSigner
  says: setClaimSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xc4d2cc4363a8a8a72c5fe35f53a56b095a29c7b0'
  fn: claimSigner()(address)
  is: '0x93a159d40df1ab07e0f55ac5670d8713a5f14b19'
  says: The signer it keeps in storage is 0x93a159d40df1ab07e0f55ac5670d8713a5f14b19 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x93a159d40df1ab07e0f55ac5670d8713a5f14b19'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x95f66db2ce721cd0181d6291cd1655d374513cb5bdfb09626f5857f4f8dfea8a'
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

BMASAchievements accepts a call to claim only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setClaimSigner changes the signer.

## Evidence

- [claim](https://etherscan.io/address/0xc4d2cc4363a8a8a72c5fe35f53a56b095a29c7b0#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setClaimSigner](https://etherscan.io/address/0xc4d2cc4363a8a8a72c5fe35f53a56b095a29c7b0#code) changes the signer; only the owner can call it.
- The signer at the block is [0x93a1…4b19](https://etherscan.io/address/0x93a159d40df1ab07e0f55ac5670d8713a5f14b19), an account without code.

## Reviewer notes

### Mechanism

claim (src/BMASAchievements.sol, line 203) recovers a signer on line 216 and tests it on line 217 against the signer it keeps in storage (claimSigner() returns 0x93a159d40df1ab07e0f55ac5670d8713a5f14b19). Neither isValidSignature selector is in the code, so that account is never asked. setClaimSigner (src/BMASAchievements.sol, line 299) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-16, recovering 0x93a1…4b19; 58 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
