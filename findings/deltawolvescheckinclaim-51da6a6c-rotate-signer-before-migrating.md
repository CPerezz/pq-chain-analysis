---
id: deltawolvescheckinclaim-51da6a6c-rotate-signer-before-migrating
format: 2
title: 'DeltaWolvesCheckinClaim: replace the signer before its account moves to real cod'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x51da6a6c791ea58554e80e8dea5625d624c4353c'
  name: DeltaWolvesCheckinClaim
  code: verified
  code_url: https://etherscan.io/address/0x51da6a6c791ea58554e80e8dea5625d624c4353c#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setSourceWallet before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x51da6a6c791ea58554e80e8dea5625d624c4353c'
  file: DeltaWolvesCheckinClaim.sol
  line: 1342
  has: address signer = messagehash.toEthSignedMessageHash().recover(
  says: claim recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x51da6a6c791ea58554e80e8dea5625d624c4353c'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x51da6a6c791ea58554e80e8dea5625d624c4353c'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x51da6a6c791ea58554e80e8dea5625d624c4353c'
  file: DeltaWolvesCheckinClaim.sol
  line: 1346
  has: require(signer == sourceWallet, "Invalid signature provided!");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x51da6a6c791ea58554e80e8dea5625d624c4353c'
  file: DeltaWolvesCheckinClaim.sol
  line: 1331
  has: function setSourceWallet
  says: setSourceWallet changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x24f3f966ca35101db9baf125a8cd3db33b030724'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
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

DeltaWolvesCheckinClaim accepts a call to claim only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSourceWallet changes the signer.

## Evidence

- [claim](https://etherscan.io/address/0x51da6a6c791ea58554e80e8dea5625d624c4353c#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSourceWallet](https://etherscan.io/address/0x51da6a6c791ea58554e80e8dea5625d624c4353c#code) changes the signer.
- The address recovered in its latest signature check on record is [0x24f3…0724](https://etherscan.io/address/0x24f3f966ca35101db9baf125a8cd3db33b030724), an account without code.

## Reviewer notes

### Mechanism

claim (DeltaWolvesCheckinClaim.sol, line 1335) recovers a signer on line 1342 and tests it on line 1346 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setSourceWallet (DeltaWolvesCheckinClaim.sol, line 1331) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2025-03-02, recovering 0x24f3…0724; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
