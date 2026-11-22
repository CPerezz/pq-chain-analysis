---
id: ey3k0nnft-1c410e4c-rotate-signer-before-migrating
format: 2
title: 'Ey3k0nNFT: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1c410e4c1701f88a2a504f4506251624e8166419'
  name: Ey3k0nNFT
  code: verified
  code_url: https://etherscan.io/address/0xac16699ee3b7a0744f8d4f9542bfb5f6105bf1cb#code
  proxy_of: '0xac16699ee3b7a0744f8d4f9542bfb5f6105bf1cb'
  copies: 2
  family: 61c1272d5bc0871993fe41bc508675df
  upgradeable: 'yes'
  admin: '0xb637b38a0c6b5488d59f5d3f7eaf2059055f381f'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 183
impact: liveness
action: Replace the signer with updateSignerAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xac16699ee3b7a0744f8d4f9542bfb5f6105bf1cb'
  file: contracts/Ey3k0nNFT.sol
  line: 125
  has: signerAddress == _messageHash.toEthSignedMessageHash().recover(signature),
  says: mint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xac16699ee3b7a0744f8d4f9542bfb5f6105bf1cb'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xac16699ee3b7a0744f8d4f9542bfb5f6105bf1cb'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xac16699ee3b7a0744f8d4f9542bfb5f6105bf1cb'
  file: contracts/Ey3k0nNFT.sol
  line: 74
  has: function updateSignerAddress
  says: updateSignerAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x1c410e4c1701f88a2a504f4506251624e8166419'
  fn: signerAddress()(address)
  is: '0xae76434f359c5adb3455c17ad0190129f5fdc774'
  says: The signer it keeps in storage is 0xae76434f359c5adb3455c17ad0190129f5fdc774 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xae76434f359c5adb3455c17ad0190129f5fdc774'
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

Ey3k0nNFT accepts a call to mint only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. updateSignerAddress changes the signer.

## Evidence

- [mint](https://etherscan.io/address/0xac16699ee3b7a0744f8d4f9542bfb5f6105bf1cb#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [updateSignerAddress](https://etherscan.io/address/0xac16699ee3b7a0744f8d4f9542bfb5f6105bf1cb#code) changes the signer; only the owner can call it.
- The signer at the block is [0xae76…c774](https://etherscan.io/address/0xae76434f359c5adb3455c17ad0190129f5fdc774), an account without code.

## Reviewer notes

### Mechanism

mint (contracts/Ey3k0nNFT.sol, line 104) recovers a signer on line 125 and tests it on line 125 against the signer it keeps in storage (signerAddress() returns 0xae76434f359c5adb3455c17ad0190129f5fdc774). Neither isValidSignature selector is in the code, so that account is never asked. updateSignerAddress (contracts/Ey3k0nNFT.sol, line 74) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-07-05, recovering 0x74d4…7b52; 183 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
