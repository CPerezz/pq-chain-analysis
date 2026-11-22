---
id: elhexaachievements-5901b15f-rotate-signer-before-migrating
format: 2
title: 'ElhexaAchievements: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5901b15fcde9b7d46b26bd22c7197a44494a9ced'
  name: ElhexaAchievements
  code: verified
  code_url: https://etherscan.io/address/0x5901b15fcde9b7d46b26bd22c7197a44494a9ced#code
  copies: 1
  upgradeable: 'no'
  admin: '0x36d43d2469df4f3866755675b34234fa246cf21b'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 6
impact: liveness
action: Before a signer's account moves to real code, use setSigner so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x5901b15fcde9b7d46b26bd22c7197a44494a9ced'
  file: contracts/ElhexaAchievements.sol
  line: 128
  has: address recovered = messageHash.toEthSignedMessageHash().recover(sig);
  says: mint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x5901b15fcde9b7d46b26bd22c7197a44494a9ced'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x5901b15fcde9b7d46b26bd22c7197a44494a9ced'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x5901b15fcde9b7d46b26bd22c7197a44494a9ced'
  file: contracts/ElhexaAchievements.sol
  line: 129
  has: if (!signers[recovered]) revert InvalidSignature();
  says: the recovered address must be an address on the signer list it keeps
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x5901b15fcde9b7d46b26bd22c7197a44494a9ced'
  file: contracts/ElhexaAchievements.sol
  line: 177
  has: function setSigner
  says: setSigner changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x2bb7f31f8ac9d6ba5d0b9de328a7327a2c5fc27a'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x74218fed8b320599b7f5f52bf594d14057e56b05150beff024aff6ab09156821'
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

ElhexaAchievements accepts a call to mint only with an ECDSA signature of an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes who may sign.

## Evidence

- [mint](https://etherscan.io/address/0x5901b15fcde9b7d46b26bd22c7197a44494a9ced#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [setSigner](https://etherscan.io/address/0x5901b15fcde9b7d46b26bd22c7197a44494a9ced#code) changes who may sign; only the owner can call it.
- Its latest signed [transaction](https://etherscan.io/tx/0x74218fed8b320599b7f5f52bf594d14057e56b05150beff024aff6ab09156821) on record recovered [0x2bb7…c27a](https://etherscan.io/address/0x2bb7f31f8ac9d6ba5d0b9de328a7327a2c5fc27a), an account without code.

## Reviewer notes

### Mechanism

mint (contracts/ElhexaAchievements.sol, line 106) recovers a signer on line 128 and tests it on line 129 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. setSigner (contracts/ElhexaAchievements.sol, line 177) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-05, recovering 0x2bb7…c27a; 6 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
