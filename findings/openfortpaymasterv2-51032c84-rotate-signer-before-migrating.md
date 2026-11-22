---
id: openfortpaymasterv2-51032c84-rotate-signer-before-migrating
format: 2
title: 'OpenfortPaymasterV2: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x51032c841e823bb487c33c9f1773b18c8d0e5209'
  name: OpenfortPaymasterV2
  code: verified
  code_url: https://etherscan.io/address/0x51032c841e823bb487c33c9f1773b18c8d0e5209#code
  copies: 1
  upgradeable: 'no'
  admin: '0xb25fe9d3e04fd2403bb3c31c76a8f8dc59ac7832'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 91
impact: liveness
action: Replace the signer with transferOwnership before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x51032c841e823bb487c33c9f1773b18c8d0e5209'
  file: contracts/paymaster/OpenfortPaymasterV2.sol
  line: 122
  has: if (owner() != ECDSA.recover(hash, signature)) {
  says: _validatePaymasterUserOp recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x51032c841e823bb487c33c9f1773b18c8d0e5209'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x51032c841e823bb487c33c9f1773b18c8d0e5209'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  selector: '0x51032c841e823bb487c33c9f1773b18c8d0e5209'
  fn: transferOwnership(address)
  says: the code has transferOwnership
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x51032c841e823bb487c33c9f1773b18c8d0e5209'
  fn: owner()(address)
  is: '0xb25fe9d3e04fd2403bb3c31c76a8f8dc59ac7832'
  says: Its owner is 0xb25fe9d3e04fd2403bb3c31c76a8f8dc59ac7832 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xb25fe9d3e04fd2403bb3c31c76a8f8dc59ac7832'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x0194b34d1f7436f4ace62178c3144538bb286330a94166293f7f7582cd9b49e6'
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

OpenfortPaymasterV2 checks an ECDSA signature in _validatePaymasterUserOp and accepts only its owner. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. transferOwnership changes the signer.

## Evidence

- [_validatePaymasterUserOp](https://etherscan.io/address/0x51032c841e823bb487c33c9f1773b18c8d0e5209#code) recovers the signature with ECDSA and accepts only its owner; the code never asks that account.
- [transferOwnership](https://etherscan.io/address/0x51032c841e823bb487c33c9f1773b18c8d0e5209#code) changes the signer.
- The signer at the block is [0xb25f…7832](https://etherscan.io/address/0xb25fe9d3e04fd2403bb3c31c76a8f8dc59ac7832), an account without code.

## Reviewer notes

### Mechanism

_validatePaymasterUserOp (contracts/paymaster/OpenfortPaymasterV2.sol, line 110) recovers a signer on line 122 and tests it on line 122 against its owner (owner() returns 0xb25fe9d3e04fd2403bb3c31c76a8f8dc59ac7832). Neither isValidSignature selector is in the code, so that account is never asked. transferOwnership is in the code. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-14, recovering 0xb25f…7832; 91 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
