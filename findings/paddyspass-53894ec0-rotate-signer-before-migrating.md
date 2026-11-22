---
id: paddyspass-53894ec0-rotate-signer-before-migrating
format: 2
title: 'PaddysPass: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x53894ec021245adb6a7c556bb0f0ad83544c0e33'
  name: PaddysPass
  code: verified
  code_url: https://etherscan.io/address/0xc9546e05d2fdb6a81f5f9b7ebe2242056cd2e5ea#code
  proxy_of: '0xc9546e05d2fdb6a81f5f9b7ebe2242056cd2e5ea'
  copies: 2
  family: 9144c020946d0c4782a2d7e805e75511
  upgradeable: 'yes'
  admin: '0xd6dc5d560694609642e3ded3516c01a4b5703e48'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 56
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xc9546e05d2fdb6a81f5f9b7ebe2242056cd2e5ea'
  file: contracts/PaddysPass.sol
  line: 251
  has: return signer == MessageHashUtils.toEthSignedMessageHash(messageHash).recover(signature);
  says: _verifySig recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xc9546e05d2fdb6a81f5f9b7ebe2242056cd2e5ea'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xc9546e05d2fdb6a81f5f9b7ebe2242056cd2e5ea'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xc9546e05d2fdb6a81f5f9b7ebe2242056cd2e5ea'
  file: contracts/PaddysPass.sol
  line: 72
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x6b2341bf6d8e7f914a1afee9fbdc7449f875f61f'
  is: empty
  says: the address recovered in the latest signature check on record has no code
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

PaddysPass checks an ECDSA signature in _verifySig and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [_verifySig](https://etherscan.io/address/0xc9546e05d2fdb6a81f5f9b7ebe2242056cd2e5ea#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0xc9546e05d2fdb6a81f5f9b7ebe2242056cd2e5ea#code) changes the signer; only the owner can call it.
- The address recovered in its latest signature check on record is [0x6b23…f61f](https://etherscan.io/address/0x6b2341bf6d8e7f914a1afee9fbdc7449f875f61f), an account without code.

## Reviewer notes

### Mechanism

_verifySig (contracts/PaddysPass.sol, line 249) recovers a signer on line 251 and tests it on line 251 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setSigner (contracts/PaddysPass.sol, line 72) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2024-01-03, recovering 0x6b23…f61f; 56 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
