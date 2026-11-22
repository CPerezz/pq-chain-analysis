---
id: owangepod-7e000a4e-rotate-signer-before-migrating
format: 2
title: 'OwangePod: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7e000a4e2e840ca8ebd2a19738a67069bc04febe'
  name: OwangePod
  code: verified
  code_url: https://etherscan.io/address/0x7e000a4e2e840ca8ebd2a19738a67069bc04febe#code
  copies: 1
  upgradeable: 'no'
  admin: '0x3675eed7fdad3e510efd6b4ddd8e127511fdd377'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 3
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x7e000a4e2e840ca8ebd2a19738a67069bc04febe'
  file: src/OwangePod.sol
  line: 171
  has: return hash.toEthSignedMessageHash().recover(signature) == signer;
  says: verifySignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x7e000a4e2e840ca8ebd2a19738a67069bc04febe'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x7e000a4e2e840ca8ebd2a19738a67069bc04febe'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x7e000a4e2e840ca8ebd2a19738a67069bc04febe'
  file: src/OwangePod.sol
  line: 137
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x7e000a4e2e840ca8ebd2a19738a67069bc04febe'
  fn: signer()(address)
  is: '0x22bb7f78c51dc8283950ecd516e6da4e1f34ef9e'
  says: The signer it keeps in storage is 0x22bb7f78c51dc8283950ecd516e6da4e1f34ef9e at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x22bb7f78c51dc8283950ecd516e6da4e1f34ef9e'
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

OwangePod checks an ECDSA signature in verifySignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [verifySignature](https://etherscan.io/address/0x7e000a4e2e840ca8ebd2a19738a67069bc04febe#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0x7e000a4e2e840ca8ebd2a19738a67069bc04febe#code) changes the signer; only the owner can call it.
- The signer at the block is [0x22bb…ef9e](https://etherscan.io/address/0x22bb7f78c51dc8283950ecd516e6da4e1f34ef9e), an account without code.

## Reviewer notes

### Mechanism

verifySignature (src/OwangePod.sol, line 170) recovers a signer on line 171 and tests it on line 171 against the signer it keeps in storage (signer() returns 0x22bb7f78c51dc8283950ecd516e6da4e1f34ef9e). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (src/OwangePod.sol, line 137) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-12-12, recovering 0x22bb…ef9e; 3 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
