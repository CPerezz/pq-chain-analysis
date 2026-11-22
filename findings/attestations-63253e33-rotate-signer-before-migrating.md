---
id: attestations-63253e33-rotate-signer-before-migrating
format: 2
title: 'Attestations: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x63253e3352c0cae9f6ee64e61ed461ae23f9c8b6'
  name: Attestations
  code: verified
  code_url: https://etherscan.io/address/0x0aafdb87208ac29409292583c52c73ff6b8426f1#code
  proxy_of: '0x0aafdb87208ac29409292583c52c73ff6b8426f1'
  copies: 2
  family: 399c108cfb4ca99fde30e300778a5f9d
  upgradeable: 'yes'
  admin: '0x628e19171bd68070636b47367220cf81b2d5d22f'
value:
  usd: 2942
  basis: held
activity:
  txs_90d: 63
impact: liveness
action: Replace the signer with setSignerPublicKey before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x0aafdb87208ac29409292583c52c73ff6b8426f1'
  file: contracts/Attestations.sol
  line: 157
  has: .recover(signature);
  says: checkPayloads recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x0aafdb87208ac29409292583c52c73ff6b8426f1'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x0aafdb87208ac29409292583c52c73ff6b8426f1'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x0aafdb87208ac29409292583c52c73ff6b8426f1'
  file: contracts/Attestations.sol
  line: 158
  has: if (recoveredSigner != signerPublicKey) revert InvalidSignature();
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x0aafdb87208ac29409292583c52c73ff6b8426f1'
  file: contracts/Attestations.sol
  line: 96
  has: function setSignerPublicKey
  says: setSignerPublicKey changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x63253e3352c0cae9f6ee64e61ed461ae23f9c8b6'
  fn: signerPublicKey()(address)
  is: '0xf5d7940e50230a054b930dbd8abfcca26b445f8c'
  says: The signer it keeps in storage is 0xf5d7940e50230a054b930dbd8abfcca26b445f8c at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xf5d7940e50230a054b930dbd8abfcca26b445f8c'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x5fc1bf8b01c995f1447594cbade978f9c7d1be600d3d4159c7d9e843b7b13700'
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

Attestations checks an ECDSA signature in checkPayloads and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSignerPublicKey changes the signer.

## Evidence

- [checkPayloads](https://etherscan.io/address/0x0aafdb87208ac29409292583c52c73ff6b8426f1#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSignerPublicKey](https://etherscan.io/address/0x0aafdb87208ac29409292583c52c73ff6b8426f1#code) changes the signer; only the owner can call it.
- The signer at the block is [0xf5d7…5f8c](https://etherscan.io/address/0xf5d7940e50230a054b930dbd8abfcca26b445f8c), an account without code.

## Reviewer notes

### Mechanism

checkPayloads (contracts/Attestations.sol, line 146) recovers a signer on line 157 and tests it on line 158 against the signer it keeps in storage (signerPublicKey() returns 0xf5d7940e50230a054b930dbd8abfcca26b445f8c). Neither isValidSignature selector is in the code, so that account is never asked. setSignerPublicKey (contracts/Attestations.sol, line 96) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-09-15, recovering 0xf5d7…5f8c; 63 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
