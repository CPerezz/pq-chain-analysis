---
id: kszaprouterv3-3bdb21ea-rotate-signer-before-migrating
format: 2
title: 'KSZapRouterV3: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x3bdb21ea8793acbf0ce18954865b7572694d037f'
  name: KSZapRouterV3
  code: verified
  code_url: https://etherscan.io/address/0x3bdb21ea8793acbf0ce18954865b7572694d037f#code
  copies: 2
  family: 2f9f33a9647afe936eb0bce6cfd15e7c
  admin: '0xbe2f0354d970265bfc36d383af77f72736b81b54'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 974
impact: liveness
action: Before a signer's account moves to real code, use grantRole so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x3bdb21ea8793acbf0ce18954865b7572694d037f'
  file: src/KSZapRouterV3.sol
  line: 107
  has: _checkRole(SIGNER_ROLE, ECDSA.recover(hash, signature));
  says: _verifySignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x3bdb21ea8793acbf0ce18954865b7572694d037f'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x3bdb21ea8793acbf0ce18954865b7572694d037f'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  selector: '0x3bdb21ea8793acbf0ce18954865b7572694d037f'
  fn: grantRole(bytes32,address)
  says: the code has grantRole
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xa7469b81833e5944883940ab99eea2fc7f096953'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x160efc2d9dee306a536d376ef1cacce4a7e7e34ce3334d9a90e1caf6620ccd38'
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

KSZapRouterV3 checks an ECDSA signature in _verifySignature and accepts only a holder of its signing role. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. grantRole changes who may sign.

## Evidence

- [_verifySignature](https://etherscan.io/address/0x3bdb21ea8793acbf0ce18954865b7572694d037f#code) recovers the signature with ECDSA and accepts only a holder of its signing role; the code never asks that account.
- [grantRole](https://etherscan.io/address/0x3bdb21ea8793acbf0ce18954865b7572694d037f#code) changes who may sign.
- Its latest signed [transaction](https://etherscan.io/tx/0x160efc2d9dee306a536d376ef1cacce4a7e7e34ce3334d9a90e1caf6620ccd38) on record recovered [0xa746…6953](https://etherscan.io/address/0xa7469b81833e5944883940ab99eea2fc7f096953), an account without code.

## Reviewer notes

### Mechanism

_verifySignature (src/KSZapRouterV3.sol, line 105) recovers a signer on line 107 against a holder of its signing role. Neither isValidSignature selector is in the code, so that account is never asked. grantRole is in the code. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-17, recovering 0xa746…6953; 974 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
