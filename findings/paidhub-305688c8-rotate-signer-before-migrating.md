---
id: paidhub-305688c8-rotate-signer-before-migrating
format: 2
title: 'PaidHub: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x305688c83216c2449782a7be48750c28841bb280'
  name: PaidHub
  code: verified
  code_url: https://etherscan.io/address/0xc5c73bf7d01073b32f2a78ba10320d854e1bba73#code
  proxy_of: '0xc5c73bf7d01073b32f2a78ba10320d854e1bba73'
  copies: 2
  family: 90e407aab646d41b63119485d8b397a1
  upgradeable: 'yes'
  admin: '0xfe83299a9928ce7449455fc4b3685ce7b934e088'
value:
  usd: 12
  basis: held
activity:
  txs_90d: 5
impact: liveness
action: Replace the signer with acceptAttester before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xc5c73bf7d01073b32f2a78ba10320d854e1bba73'
  file: src/PaidHub.sol
  line: 361
  has: if (ECDSA.recover(digest, signature) != attester) revert BadSignature();
  says: bind recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xc5c73bf7d01073b32f2a78ba10320d854e1bba73'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xc5c73bf7d01073b32f2a78ba10320d854e1bba73'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xc5c73bf7d01073b32f2a78ba10320d854e1bba73'
  file: src/PaidHub.sol
  line: 452
  has: function acceptAttester
  says: acceptAttester changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x305688c83216c2449782a7be48750c28841bb280'
  fn: attester()(address)
  is: '0xfe83299a9928ce7449455fc4b3685ce7b934e088'
  says: The signer it keeps in storage is 0xfe83299a9928ce7449455fc4b3685ce7b934e088 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xfe83299a9928ce7449455fc4b3685ce7b934e088'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xa392e486f71decfc434667d08ad2017beb6f0a38024fe21d796d21fc31e5c4aa'
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

PaidHub accepts a call to bind only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. acceptAttester changes the signer.

## Evidence

- [bind](https://etherscan.io/address/0xc5c73bf7d01073b32f2a78ba10320d854e1bba73#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [acceptAttester](https://etherscan.io/address/0xc5c73bf7d01073b32f2a78ba10320d854e1bba73#code) changes the signer.
- The signer at the block is [0xfe83…e088](https://etherscan.io/address/0xfe83299a9928ce7449455fc4b3685ce7b934e088), an account without code.

## Reviewer notes

### Mechanism

bind (src/PaidHub.sol, line 347) recovers a signer on line 361 and tests it on line 361 against the signer it keeps in storage (attester() returns 0xfe83299a9928ce7449455fc4b3685ce7b934e088). Neither isValidSignature selector is in the code, so that account is never asked. acceptAttester (src/PaidHub.sol, line 452) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-10-10, recovering 0xfe83…e088; 5 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
