---
id: whimsysisters-fc23f958-rotate-signer-before-migrating
format: 2
title: 'WhimsySisters: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xfc23f958c86d944418d7965a5f6582d1e96db1be'
  name: WhimsySisters
  code: verified
  code_url: https://etherscan.io/address/0xfc23f958c86d944418d7965a5f6582d1e96db1be#code
  copies: 1
  upgradeable: 'no'
  admin: '0xa12eeeaad1d13f0938febd6a1b0e8b10ab31dbd6'
value:
  usd: 40
  basis: held
activity:
  txs_90d: 2
impact: liveness
action: Replace the signer with configure before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xfc23f958c86d944418d7965a5f6582d1e96db1be'
  file: contracts/WhimsySisters.sol
  line: 71
  has: 'require(signature.length > 0 && recoverSignerAddress(_msgSender(), signature) == authorizedSigner, "tx sender '
  says: presale recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xfc23f958c86d944418d7965a5f6582d1e96db1be'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xfc23f958c86d944418d7965a5f6582d1e96db1be'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xfc23f958c86d944418d7965a5f6582d1e96db1be'
  file: contracts/WhimsySisters.sol
  line: 39
  has: function configure
  says: configure changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xfc23f958c86d944418d7965a5f6582d1e96db1be'
  fn: authorizedSigner()(address)
  is: '0xf89c869460aa20b8a0982a5d90f2470e8f6ebc65'
  says: The signer it keeps in storage is 0xf89c869460aa20b8a0982a5d90f2470e8f6ebc65 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xf89c869460aa20b8a0982a5d90f2470e8f6ebc65'
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

WhimsySisters accepts a call to presale only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. configure changes the signer.

## Evidence

- [presale](https://etherscan.io/address/0xfc23f958c86d944418d7965a5f6582d1e96db1be#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [configure](https://etherscan.io/address/0xfc23f958c86d944418d7965a5f6582d1e96db1be#code) changes the signer; only the owner can call it.
- The signer at the block is [0xf89c…bc65](https://etherscan.io/address/0xf89c869460aa20b8a0982a5d90f2470e8f6ebc65), an account without code.

## Reviewer notes

### Mechanism

presale (contracts/WhimsySisters.sol, line 69) recovers a signer on line 71 and tests it on line 71 against the signer it keeps in storage (authorizedSigner() returns 0xf89c869460aa20b8a0982a5d90f2470e8f6ebc65). Neither isValidSignature selector is in the code, so that account is never asked. configure (contracts/WhimsySisters.sol, line 39) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-06-05, recovering 0xf89c…bc65; 2 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
