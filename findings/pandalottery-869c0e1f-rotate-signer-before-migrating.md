---
id: pandalottery-869c0e1f-rotate-signer-before-migrating
format: 2
title: 'PandaLottery: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x869c0e1f2eef63b6b4578c8769233946353ec1b4'
  name: PandaLottery
  code: verified
  code_url: https://etherscan.io/address/0x869c0e1f2eef63b6b4578c8769233946353ec1b4#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 38
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setPermitSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x869c0e1f2eef63b6b4578c8769233946353ec1b4'
  file: src/PandaLottery.sol
  line: 547
  has: return ECDSA.recover(digest, _signature) == permitSigner;
  says: isValidPurchaseSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x869c0e1f2eef63b6b4578c8769233946353ec1b4'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x869c0e1f2eef63b6b4578c8769233946353ec1b4'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x869c0e1f2eef63b6b4578c8769233946353ec1b4'
  file: src/PandaLottery.sol
  line: 198
  has: function setPermitSigner
  says: setPermitSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x869c0e1f2eef63b6b4578c8769233946353ec1b4'
  fn: permitSigner()(address)
  is: '0x93e1c0525e59c8795b69730dd93d0fe64422c11d'
  says: The signer it keeps in storage is 0x93e1c0525e59c8795b69730dd93d0fe64422c11d at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0x93e1c0525e59c8795b69730dd93d0fe64422c11d'
  is: delegation
  target: '0xd2e28229f6f2c235e57de2ebc727025a1d0530fb'
  says: 'the signer''s account holds an EIP-7702 delegation: an ECDSA key still controls it'
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

PandaLottery checks an ECDSA signature in isValidPurchaseSignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setPermitSigner changes the signer.

## Evidence

- [isValidPurchaseSignature](https://etherscan.io/address/0x869c0e1f2eef63b6b4578c8769233946353ec1b4#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setPermitSigner](https://etherscan.io/address/0x869c0e1f2eef63b6b4578c8769233946353ec1b4#code) changes the signer; only a role holder can call it.
- The signer at the block is [0x93e1…c11d](https://etherscan.io/address/0x93e1c0525e59c8795b69730dd93d0fe64422c11d), an account with an EIP-7702 delegation, which keeps working.

## Reviewer notes

### Mechanism

isValidPurchaseSignature (src/PandaLottery.sol, line 529) recovers a signer on line 547 and tests it on line 547 against the signer it keeps in storage (permitSigner() returns 0x93e1c0525e59c8795b69730dd93d0fe64422c11d). Neither isValidSignature selector is in the code, so that account is never asked. setPermitSigner (src/PandaLottery.sol, line 198) writes it. The signer's account holds an EIP-7702 delegation to 0xd2e28229f6f2c235e57de2ebc727025a1d0530fb. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
