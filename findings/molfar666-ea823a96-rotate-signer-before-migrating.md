---
id: molfar666-ea823a96-rotate-signer-before-migrating
format: 2
title: 'MOLFAR666: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xea823a96eae4126353dc78a851a16b90ee793568'
  name: MOLFAR666
  code: verified
  code_url: https://etherscan.io/address/0xea823a96eae4126353dc78a851a16b90ee793568#code
  copies: 1
  upgradeable: 'no'
  admin: '0x867fbb4a36f57881091b04bac3d8767a0b12634e'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 15
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xea823a96eae4126353dc78a851a16b90ee793568'
  file: MOLFAR666.sol
  line: 139
  has: return ECDSA.recover(digest, signature) == _signer;
  says: verify recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xea823a96eae4126353dc78a851a16b90ee793568'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xea823a96eae4126353dc78a851a16b90ee793568'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xea823a96eae4126353dc78a851a16b90ee793568'
  file: MOLFAR666.sol
  line: 104
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x0b8623fd6f753952bdae909b9840079e38b8b892'
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

MOLFAR666 checks an ECDSA signature in verify and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [verify](https://etherscan.io/address/0xea823a96eae4126353dc78a851a16b90ee793568#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0xea823a96eae4126353dc78a851a16b90ee793568#code) changes the signer; only the owner can call it.
- The address recovered in its latest signature check on record is [0x0b86…b892](https://etherscan.io/address/0x0b8623fd6f753952bdae909b9840079e38b8b892), an account without code.

## Reviewer notes

### Mechanism

verify (MOLFAR666.sol, line 128) recovers a signer on line 139 and tests it on line 139 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setSigner (MOLFAR666.sol, line 104) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-10-11, recovering 0x0b86…b892; 15 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
