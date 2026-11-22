---
id: metawallet-233c5370-rotate-signer-before-migrating
format: 2
title: 'MetaWallet: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x233c5370ccfb3cd7409d9a3fb98ab94de94cb4cd'
  name: MetaWallet
  code: verified
  code_url: https://etherscan.io/address/0x233c5370ccfb3cd7409d9a3fb98ab94de94cb4cd#code
  copies: 1
  upgradeable: 'no'
  admin: '0x88e48aeeceaafbda2640ba0f25e1fd2a79d07633'
value:
  usd: 211
  basis: held
activity:
  txs_90d: 4
impact: liveness
action: Replace the signer with changeVerifyAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x233c5370ccfb3cd7409d9a3fb98ab94de94cb4cd'
  file: contracts/MetaWallet.sol
  line: 258
  has: return ECDSA.recover(messageHash, signature) == verifyAddress;
  says: verify recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x233c5370ccfb3cd7409d9a3fb98ab94de94cb4cd'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x233c5370ccfb3cd7409d9a3fb98ab94de94cb4cd'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x233c5370ccfb3cd7409d9a3fb98ab94de94cb4cd'
  file: contracts/MetaWallet.sol
  line: 111
  has: function changeVerifyAddress
  says: changeVerifyAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x233c5370ccfb3cd7409d9a3fb98ab94de94cb4cd'
  fn: verifyAddress()(address)
  is: '0xbcfd8381fa8148d01fd7d5cbb0efcc96ce68176c'
  says: The signer it keeps in storage is 0xbcfd8381fa8148d01fd7d5cbb0efcc96ce68176c at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xbcfd8381fa8148d01fd7d5cbb0efcc96ce68176c'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xf4dc9cff8c22cde135d0f618cab493393082970a2b81f48125565cc837528218'
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

MetaWallet checks an ECDSA signature in verify and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. changeVerifyAddress changes the signer.

## Evidence

- [verify](https://etherscan.io/address/0x233c5370ccfb3cd7409d9a3fb98ab94de94cb4cd#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [changeVerifyAddress](https://etherscan.io/address/0x233c5370ccfb3cd7409d9a3fb98ab94de94cb4cd#code) changes the signer; only the owner can call it.
- The signer at the block is [0xbcfd…176c](https://etherscan.io/address/0xbcfd8381fa8148d01fd7d5cbb0efcc96ce68176c), an account without code.

## Reviewer notes

### Mechanism

verify (contracts/MetaWallet.sol, line 245) recovers a signer on line 258 and tests it on line 258 against the signer it keeps in storage (verifyAddress() returns 0xbcfd8381fa8148d01fd7d5cbb0efcc96ce68176c). Neither isValidSignature selector is in the code, so that account is never asked. changeVerifyAddress (contracts/MetaWallet.sol, line 111) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-10-31, recovering 0xbcfd…176c; 4 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
