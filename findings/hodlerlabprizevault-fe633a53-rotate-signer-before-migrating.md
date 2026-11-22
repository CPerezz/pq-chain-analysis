---
id: hodlerlabprizevault-fe633a53-rotate-signer-before-migrating
format: 2
title: 'HodlerLabPrizeVault: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xfe633a5374f21e1202133d6a0ef569407a9f97db'
  name: HodlerLabPrizeVault
  code: verified
  code_url: https://etherscan.io/address/0xfe633a5374f21e1202133d6a0ef569407a9f97db#code
  copies: 1
  upgradeable: 'no'
  admin: '0x418b9c0f89d1638c244a35ee489a1599842bcfbf'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 5
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xfe633a5374f21e1202133d6a0ef569407a9f97db'
  file: src/HodlerLabPrizeVault.sol
  line: 64
  has: if (_recover(digest, signature) != signer) revert InvalidSignature();
  says: claim recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xfe633a5374f21e1202133d6a0ef569407a9f97db'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xfe633a5374f21e1202133d6a0ef569407a9f97db'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xfe633a5374f21e1202133d6a0ef569407a9f97db'
  file: src/HodlerLabPrizeVault.sol
  line: 72
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xfe633a5374f21e1202133d6a0ef569407a9f97db'
  fn: signer()(address)
  is: '0xcbc0d6ce6dbb46b29e2710da863fbdf320df589c'
  says: The signer it keeps in storage is 0xcbc0d6ce6dbb46b29e2710da863fbdf320df589c at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xcbc0d6ce6dbb46b29e2710da863fbdf320df589c'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x1efa540334b1dcf47b702709595ad7b00590d86d915a45a905dc3a2ae0ac6193'
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

HodlerLabPrizeVault accepts a call to claim only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [claim](https://etherscan.io/address/0xfe633a5374f21e1202133d6a0ef569407a9f97db#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0xfe633a5374f21e1202133d6a0ef569407a9f97db#code) changes the signer (through _setSigner); only the owner can call it.
- The signer at the block is [0xcbc0…589c](https://etherscan.io/address/0xcbc0d6ce6dbb46b29e2710da863fbdf320df589c), an account without code.

## Reviewer notes

### Mechanism

claim (src/HodlerLabPrizeVault.sol, line 47) recovers a signer on line 64 and tests it on line 64 against the signer it keeps in storage (signer() returns 0xcbc0d6ce6dbb46b29e2710da863fbdf320df589c). Neither isValidSignature selector is in the code, so that account is never asked. _setSigner (src/HodlerLabPrizeVault.sol, line 103) writes it, called by setSigner. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-08, recovering 0xcbc0…589c; 5 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
