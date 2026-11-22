---
id: salespolicy-6e1a8f34-rotate-signer-before-migrating
format: 2
title: 'SalesPolicy: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x6e1a8f3466eb69eb298b62192414b267a47d701a'
  name: SalesPolicy
  code: verified
  code_url: https://etherscan.io/address/0x6e1a8f3466eb69eb298b62192414b267a47d701a#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 2
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x6e1a8f3466eb69eb298b62192414b267a47d701a'
  file: contracts/EIP712MetaTransaction.sol
  line: 79
  has: address signer = message.recover(sigV, sigR, sigS);
  says: verify recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x6e1a8f3466eb69eb298b62192414b267a47d701a'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x6e1a8f3466eb69eb298b62192414b267a47d701a'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x6e1a8f3466eb69eb298b62192414b267a47d701a'
  file: contracts/EIP712MetaTransaction.sol
  line: 80
  has: require(signer != address(0), "Invalid signature");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x6e1a8f3466eb69eb298b62192414b267a47d701a'
  file: contracts/SalesPolicy.sol
  line: 290
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x6e1a8f3466eb69eb298b62192414b267a47d701a'
  fn: signer()(address)
  is: '0x36896a884e970e38ed449ccaf591191817f2bff8'
  says: The signer it keeps in storage is 0x36896a884e970e38ed449ccaf591191817f2bff8 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x36896a884e970e38ed449ccaf591191817f2bff8'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x61a7260fa280a5c8737bb7c14f32801f17c560fce7138fe74dc91a2fdd3a0455'
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

SalesPolicy checks an ECDSA signature in verify and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [verify](https://etherscan.io/address/0x6e1a8f3466eb69eb298b62192414b267a47d701a#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0x6e1a8f3466eb69eb298b62192414b267a47d701a#code) changes the signer.
- The signer at the block is [0x3689…bff8](https://etherscan.io/address/0x36896a884e970e38ed449ccaf591191817f2bff8), an account without code.

## Reviewer notes

### Mechanism

verify (contracts/EIP712MetaTransaction.sol, line 71) recovers a signer on line 79 and tests it on line 80 against the signer it keeps in storage (signer() returns 0x36896a884e970e38ed449ccaf591191817f2bff8). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (contracts/SalesPolicy.sol, line 290) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-08-25, recovering 0x1957…1052; 2 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
