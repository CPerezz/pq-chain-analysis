---
id: bktoken-916325fa-rotate-signer-before-migrating
format: 2
title: 'BKToken: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x916325fa4d914f39f0606528b65e6507637f9c37'
  name: BKToken
  code: verified
  code_url: https://etherscan.io/address/0x916325fa4d914f39f0606528b65e6507637f9c37#code
  copies: 1
  upgradeable: 'no'
  admin: '0xac73fa9649efd4838c756e7a408b58952351a34a'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1
impact: liveness
action: Replace the signer with setSignerAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x916325fa4d914f39f0606528b65e6507637f9c37'
  file: contracts/BKToken.sol
  line: 278
  has: return (ecrecover(_ethSignedMessageHash, _v, _r, _s) == signer);
  says: verifyMessage recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x916325fa4d914f39f0606528b65e6507637f9c37'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x916325fa4d914f39f0606528b65e6507637f9c37'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x916325fa4d914f39f0606528b65e6507637f9c37'
  file: contracts/BKToken.sol
  line: 91
  has: function setSignerAddress
  says: setSignerAddress changes the signer
  for:
  - action
  - evidence-2
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

BKToken checks an ECDSA signature in verifyMessage and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSignerAddress changes the signer.

## Evidence

- [verifyMessage](https://etherscan.io/address/0x916325fa4d914f39f0606528b65e6507637f9c37#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSignerAddress](https://etherscan.io/address/0x916325fa4d914f39f0606528b65e6507637f9c37#code) changes the signer; only the owner can call it.

## Reviewer notes

### Mechanism

verifyMessage (contracts/BKToken.sol, line 263) recovers a signer on line 278 and tests it on line 278 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setSignerAddress (contracts/BKToken.sol, line 91) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 1 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
