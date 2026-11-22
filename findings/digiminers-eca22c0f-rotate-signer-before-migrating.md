---
id: digiminers-eca22c0f-rotate-signer-before-migrating
format: 2
title: 'DigiMiners: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xeca22c0fd4ac62d81a5633eb547e6797c9579462'
  name: DigiMiners
  code: verified
  code_url: https://etherscan.io/address/0xeca22c0fd4ac62d81a5633eb547e6797c9579462#code
  copies: 1
  upgradeable: 'no'
  admin: '0xb3f7eabd1298299e5a2512afb5f5251e775021af'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 113
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xeca22c0fd4ac62d81a5633eb547e6797c9579462'
  file: main.sol
  line: 3010
  has: '_signerAddress == checkSign(signature, msg.sender), "DIGI: Invalid Signature"'
  says: publicMint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xeca22c0fd4ac62d81a5633eb547e6797c9579462'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xeca22c0fd4ac62d81a5633eb547e6797c9579462'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xeca22c0fd4ac62d81a5633eb547e6797c9579462'
  file: main.sol
  line: 2958
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews: []
related: []
---

## What happens

DigiMiners accepts a call to publicMint only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [publicMint](https://etherscan.io/address/0xeca22c0fd4ac62d81a5633eb547e6797c9579462#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0xeca22c0fd4ac62d81a5633eb547e6797c9579462#code) changes the signer; only the owner can call it.

## Reviewer notes

### Mechanism

publicMint (main.sol, line 3004) recovers a signer on line 3010 and tests it on line 3010 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setSigner (main.sol, line 2958) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 113 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
