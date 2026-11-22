---
id: smartwalletupgradeablev2-468ac716-rotate-signer-before-migrating
format: 2
title: 'SmartWalletUpgradeableV2: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x468ac716493c51184162681130035b61baff040b'
  name: SmartWalletUpgradeableV2
  code: verified
  code_url: https://etherscan.io/address/0xdef3c1e9ec7e90ee5d0e2a114470c258a2cd3eba#code
  proxy_of: '0xdef3c1e9ec7e90ee5d0e2a114470c258a2cd3eba'
  copies: 2
  family: b57e40770f9472d9d55d7ec50adf6d58
  upgradeable: 'yes'
  admin: '0x8ca471ca2a0d9b26dce045a42ed49efaba40430f'
value:
  usd: 92086
  basis: held
activity:
  txs_90d: 1989
impact: liveness
action: Before a signer's account moves to real code, use grantRole so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0xdef3c1e9ec7e90ee5d0e2a114470c258a2cd3eba'
  file: project:/contracts/SmartWalletUpgradeable.sol
  line: 139
  has: address signer = recoverSigner(hash, signature);
  says: verifySignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xdef3c1e9ec7e90ee5d0e2a114470c258a2cd3eba'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xdef3c1e9ec7e90ee5d0e2a114470c258a2cd3eba'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xdef3c1e9ec7e90ee5d0e2a114470c258a2cd3eba'
  file: project:/contracts/SmartWalletUpgradeable.sol
  line: 140
  has: 'require(signer != address(0) && hasRole(MODERATOR_ROLE, signer), "SmartWalletUpgradeable: unauthorized");'
  says: the recovered address must be a holder of its signing role
  for:
  - evidence-1
  - justification
  - what
- id: setter
  selector: '0xdef3c1e9ec7e90ee5d0e2a114470c258a2cd3eba'
  fn: grantRole(bytes32,address)
  says: the code has grantRole
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x7d8c603307490db85850f4d2365c0fc50bf5bcdb'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x59213c5513622a187a0675258d47abfddd5181c3905f35c5619154e08ef7cf56'
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

SmartWalletUpgradeableV2 accepts a call to verifySignature only with an ECDSA signature of a holder of its signing role. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. grantRole changes who may sign.

## Evidence

- [verifySignature](https://etherscan.io/address/0xdef3c1e9ec7e90ee5d0e2a114470c258a2cd3eba#code) recovers the signature with ECDSA and accepts only a holder of its signing role; the code never asks that account.
- [grantRole](https://etherscan.io/address/0xdef3c1e9ec7e90ee5d0e2a114470c258a2cd3eba#code) changes who may sign.
- Its latest signed [transaction](https://etherscan.io/tx/0x59213c5513622a187a0675258d47abfddd5181c3905f35c5619154e08ef7cf56) on record recovered [0x7d8c…bcdb](https://etherscan.io/address/0x7d8c603307490db85850f4d2365c0fc50bf5bcdb), an account without code.

## Reviewer notes

### Mechanism

verifySignature (project:/contracts/SmartWalletUpgradeable.sol, line 130) recovers a signer on line 139 and tests it on line 140 against a holder of its signing role. Neither isValidSignature selector is in the code, so that account is never asked. grantRole is in the code. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-18, recovering 0x7d8c…bcdb; 1,989 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
