---
id: fnxai-93906972-rotate-signer-before-migrating
format: 2
title: 'FNXAI: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x939069722d568b5498ccba4356e800eaefefd2a5'
  name: FNXAI
  code: verified
  code_url: https://etherscan.io/address/0x939069722d568b5498ccba4356e800eaefefd2a5#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 37
impact: liveness
action: Replace the signer with setServerSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x939069722d568b5498ccba4356e800eaefefd2a5'
  file: FNXAI/FNXAI.sol
  line: 63
  has: messageHash.recover(signature) == serverSigner,
  says: redeem recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x939069722d568b5498ccba4356e800eaefefd2a5'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x939069722d568b5498ccba4356e800eaefefd2a5'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x939069722d568b5498ccba4356e800eaefefd2a5'
  file: FNXAI/FNXAI.sol
  line: 22
  has: function setServerSigner
  says: setServerSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x3690e852257efcfee18bb3d2104382a988b81a98'
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

FNXAI accepts a call to redeem only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setServerSigner changes the signer.

## Evidence

- [redeem](https://etherscan.io/address/0x939069722d568b5498ccba4356e800eaefefd2a5#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setServerSigner](https://etherscan.io/address/0x939069722d568b5498ccba4356e800eaefefd2a5#code) changes the signer; only the owner can call it.
- The address recovered in its latest signature check on record is [0x3690…1a98](https://etherscan.io/address/0x3690e852257efcfee18bb3d2104382a988b81a98), an account without code.

## Reviewer notes

### Mechanism

redeem (FNXAI/FNXAI.sol, line 40) recovers a signer on line 63 and tests it on line 63 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setServerSigner (FNXAI/FNXAI.sol, line 22) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2025-05-19, recovering 0x3690…1a98; 37 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
