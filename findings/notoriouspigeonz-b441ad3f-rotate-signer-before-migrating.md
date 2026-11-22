---
id: notoriouspigeonz-b441ad3f-rotate-signer-before-migrating
format: 2
title: 'NotoriousPigeonz: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb441ad3fba218de23ac682d2263558ff1f7442cc'
  name: NotoriousPigeonz
  code: verified
  code_url: https://etherscan.io/address/0xb441ad3fba218de23ac682d2263558ff1f7442cc#code
  copies: 1
  upgradeable: 'no'
  admin: '0x00b3e78b691f8fcada3e74abf57c32dae3c89e7d'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 2
impact: liveness
action: Replace the signer with setWhitelistSignerAccount before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xb441ad3fba218de23ac682d2263558ff1f7442cc'
  file: contracts/4_Pigeonz.sol
  line: 122
  has: return ECDSA.recover(ethSignedMessageHash, signature) == whitelistSignerAccount;
  says: verifyWhitelistSpot recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xb441ad3fba218de23ac682d2263558ff1f7442cc'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xb441ad3fba218de23ac682d2263558ff1f7442cc'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xb441ad3fba218de23ac682d2263558ff1f7442cc'
  file: contracts/4_Pigeonz.sol
  line: 215
  has: function setWhitelistSignerAccount
  says: setWhitelistSignerAccount changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xb441ad3fba218de23ac682d2263558ff1f7442cc'
  fn: whitelistSignerAccount()(address)
  is: '0xea60106204c06f666859fb6860025b145da0fd7c'
  says: The signer it keeps in storage is 0xea60106204c06f666859fb6860025b145da0fd7c at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xea60106204c06f666859fb6860025b145da0fd7c'
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

NotoriousPigeonz checks an ECDSA signature in verifyWhitelistSpot and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setWhitelistSignerAccount changes the signer.

## Evidence

- [verifyWhitelistSpot](https://etherscan.io/address/0xb441ad3fba218de23ac682d2263558ff1f7442cc#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setWhitelistSignerAccount](https://etherscan.io/address/0xb441ad3fba218de23ac682d2263558ff1f7442cc#code) changes the signer; only the owner can call it.
- The signer at the block is [0xea60…fd7c](https://etherscan.io/address/0xea60106204c06f666859fb6860025b145da0fd7c), an account without code.

## Reviewer notes

### Mechanism

verifyWhitelistSpot (contracts/4_Pigeonz.sol, line 119) recovers a signer on line 122 and tests it on line 122 against the signer it keeps in storage (whitelistSignerAccount() returns 0xea60106204c06f666859fb6860025b145da0fd7c). Neither isValidSignature selector is in the code, so that account is never asked. setWhitelistSignerAccount (contracts/4_Pigeonz.sol, line 215) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-01-20, recovering 0xea60…fd7c; 2 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
