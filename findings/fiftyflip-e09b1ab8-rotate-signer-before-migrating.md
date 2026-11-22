---
id: fiftyflip-e09b1ab8-rotate-signer-before-migrating
format: 2
title: 'FiftyFlip: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe09b1ab8111c2729a76f16de96bc86a7af837928'
  name: FiftyFlip
  code: verified
  code_url: https://etherscan.io/address/0xe09b1ab8111c2729a76f16de96bc86a7af837928#code
  copies: 1
  upgradeable: 'no'
  admin: '0xba21d01125d6932ce8abf3625977899fd2c7fa30'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 5
impact: liveness
action: Replace the signer with setSecretSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xe09b1ab8111c2729a76f16de96bc86a7af837928'
  file: FiftyFlip.sol
  line: 136
  has: require (secretSigner == ecrecover(signatureHash, v, r, s), "web3 vrs signature is not valid.");
  says: wager recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xe09b1ab8111c2729a76f16de96bc86a7af837928'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xe09b1ab8111c2729a76f16de96bc86a7af837928'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xe09b1ab8111c2729a76f16de96bc86a7af837928'
  file: FiftyFlip.sol
  line: 114
  has: function setSecretSigner
  says: setSecretSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xe09b1ab8111c2729a76f16de96bc86a7af837928'
  fn: secretSigner()(address)
  is: '0x42d42f53c20f2a1e745fdc1e2c350941a755976f'
  says: The signer it keeps in storage is 0x42d42f53c20f2a1e745fdc1e2c350941a755976f at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x42d42f53c20f2a1e745fdc1e2c350941a755976f'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xeeee595e0611fcbec3d1f075689777a4fb245c3b0e7bc42c7a03aec2c7189c10'
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

FiftyFlip accepts a call to wager only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSecretSigner changes the signer.

## Evidence

- [wager](https://etherscan.io/address/0xe09b1ab8111c2729a76f16de96bc86a7af837928#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSecretSigner](https://etherscan.io/address/0xe09b1ab8111c2729a76f16de96bc86a7af837928#code) changes the signer; only the owner can call it.
- The signer at the block is [0x42d4…976f](https://etherscan.io/address/0x42d42f53c20f2a1e745fdc1e2c350941a755976f), an account without code.

## Reviewer notes

### Mechanism

wager (FiftyFlip.sol, line 122) recovers a signer on line 136 and tests it on line 136 against the signer it keeps in storage (secretSigner() returns 0x42d42f53c20f2a1e745fdc1e2c350941a755976f). Neither isValidSignature selector is in the code, so that account is never asked. setSecretSigner (FiftyFlip.sol, line 114) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-09-16, recovering 0x42d4…976f; 5 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
