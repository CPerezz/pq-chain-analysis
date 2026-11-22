---
id: atsremotepaymaster-0a8cd7a0-rotate-signer-before-migrating
format: 2
title: 'ATSRemotePaymaster: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0a8cd7a0e3f70baa801acc2d576be05bfd8b4b1e'
  name: ATSRemotePaymaster
  code: verified
  code_url: https://etherscan.io/address/0x0a8cd7a0e3f70baa801acc2d576be05bfd8b4b1e#code
  copies: 1
  upgradeable: 'no'
  admin: '0xb42f545bf8ab1a1ba968e21a32e553d25fdf8e6d'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 6
impact: liveness
action: Replace the signer with setBackendSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x0a8cd7a0e3f70baa801acc2d576be05bfd8b4b1e'
  file: contracts/ATSRemotePaymaster.sol
  line: 126
  has: bool ok = backendSigner != address(0) && ECDSA.recover(h, pmData[76:]) == backendSigner;
  says: _validatePaymasterUserOp recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x0a8cd7a0e3f70baa801acc2d576be05bfd8b4b1e'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x0a8cd7a0e3f70baa801acc2d576be05bfd8b4b1e'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x0a8cd7a0e3f70baa801acc2d576be05bfd8b4b1e'
  file: contracts/ATSRemotePaymaster.sol
  line: 50
  has: function setBackendSigner
  says: setBackendSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x0a8cd7a0e3f70baa801acc2d576be05bfd8b4b1e'
  fn: backendSigner()(address)
  is: '0x76e67eb749409977db0c98e694b3b90eb5fdb1a0'
  says: The signer it keeps in storage is 0x76e67eb749409977db0c98e694b3b90eb5fdb1a0 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x76e67eb749409977db0c98e694b3b90eb5fdb1a0'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xb61574729bd2a8b482bcee0009ace0959c0e819baeb6fed60b6cdaf3324327e9'
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

ATSRemotePaymaster checks an ECDSA signature in _validatePaymasterUserOp and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setBackendSigner changes the signer.

## Evidence

- [_validatePaymasterUserOp](https://etherscan.io/address/0x0a8cd7a0e3f70baa801acc2d576be05bfd8b4b1e#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setBackendSigner](https://etherscan.io/address/0x0a8cd7a0e3f70baa801acc2d576be05bfd8b4b1e#code) changes the signer; only the owner can call it.
- The signer at the block is [0x76e6…b1a0](https://etherscan.io/address/0x76e67eb749409977db0c98e694b3b90eb5fdb1a0), an account without code.

## Reviewer notes

### Mechanism

_validatePaymasterUserOp (contracts/ATSRemotePaymaster.sol, line 99) recovers a signer on line 126 and tests it on line 126 against the signer it keeps in storage (backendSigner() returns 0x76e67eb749409977db0c98e694b3b90eb5fdb1a0). Neither isValidSignature selector is in the code, so that account is never asked. setBackendSigner (contracts/ATSRemotePaymaster.sol, line 50) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-17, recovering 0x76e6…b1a0; 6 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
