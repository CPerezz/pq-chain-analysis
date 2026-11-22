---
id: tantinbridge-2274d462-rotate-signer-before-migrating
format: 2
title: 'TantinBridge: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2274d46263e29b24e0812e79590807dc838e7d11'
  name: TantinBridge
  code: verified
  code_url: https://etherscan.io/address/0x40b77fec326b2a3b3474d035048a21ec22bcb923#code
  proxy_of: '0x40b77fec326b2a3b3474d035048a21ec22bcb923'
  copies: 2
  family: 500baeb9296bde41bbbb182bad2145ab
  upgradeable: 'yes'
  admin: '0x54d4f6322ead19b103578029c42d41346ff2a58c'
value:
  usd: 690
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with adminSetEnv before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x40b77fec326b2a3b3474d035048a21ec22bcb923'
  file: contracts/TantinBridge.sol
  line: 332
  has: address recoverAddress = messageHash.toEthSignedMessageHash().recover(
  says: checkPriceSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x40b77fec326b2a3b3474d035048a21ec22bcb923'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x40b77fec326b2a3b3474d035048a21ec22bcb923'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x40b77fec326b2a3b3474d035048a21ec22bcb923'
  file: contracts/TantinBridge.sol
  line: 336
  has: return recoverAddress == serverAddress;
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x40b77fec326b2a3b3474d035048a21ec22bcb923'
  file: contracts/TantinBridge.sol
  line: 47
  has: function adminSetEnv
  says: adminSetEnv changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x2274d46263e29b24e0812e79590807dc838e7d11'
  fn: serverAddress()(address)
  is: '0x057875cc90ff3f56d1bcb0b60a98780b744c1c47'
  says: The signer it keeps in storage is 0x057875cc90ff3f56d1bcb0b60a98780b744c1c47 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x057875cc90ff3f56d1bcb0b60a98780b744c1c47'
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

TantinBridge checks an ECDSA signature in checkPriceSignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. adminSetEnv changes the signer.

## Evidence

- [checkPriceSignature](https://etherscan.io/address/0x40b77fec326b2a3b3474d035048a21ec22bcb923#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [adminSetEnv](https://etherscan.io/address/0x40b77fec326b2a3b3474d035048a21ec22bcb923#code) changes the signer; only a role holder can call it.
- The signer at the block is [0x0578…1c47](https://etherscan.io/address/0x057875cc90ff3f56d1bcb0b60a98780b744c1c47), an account without code.

## Reviewer notes

### Mechanism

checkPriceSignature (contracts/TantinBridge.sol, line 324) recovers a signer on line 332 and tests it on line 336 against the signer it keeps in storage (serverAddress() returns 0x057875cc90ff3f56d1bcb0b60a98780b744c1c47). Neither isValidSignature selector is in the code, so that account is never asked. adminSetEnv (contracts/TantinBridge.sol, line 47) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2025-12-02, recovering 0x0578…1c47; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
