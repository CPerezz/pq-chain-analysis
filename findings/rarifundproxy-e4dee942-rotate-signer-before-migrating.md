---
id: rarifundproxy-e4dee942-rotate-signer-before-migrating
format: 2
title: 'RariFundProxy: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe4dee94233dd4d7c2504744ee6d34f3875b3b439'
  name: RariFundProxy
  code: verified
  code_url: https://etherscan.io/address/0xe4dee94233dd4d7c2504744ee6d34f3875b3b439#code
  copies: 2
  family: c9d1511504f28c322bd4343ca382a206
  admin: '0x5ea4a9a7592683bf0bc187d6da706c6c4770976f'
value:
  usd: 2
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setGsnTrustedSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xe4dee94233dd4d7c2504744ee6d34f3875b3b439'
  file: home/david/rspc-v2.4.0/contracts/RariFundProxy.sol
  line: 397
  has: if (keccak256(blob).toEthSignedMessageHash().recover(approvalData) != _gsnTrustedSigner) return _rejectRelayed
  says: acceptRelayedCall recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xe4dee94233dd4d7c2504744ee6d34f3875b3b439'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xe4dee94233dd4d7c2504744ee6d34f3875b3b439'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xe4dee94233dd4d7c2504744ee6d34f3875b3b439'
  file: home/david/rspc-v2.4.0/contracts/RariFundProxy.sol
  line: 153
  has: function setGsnTrustedSigner
  says: setGsnTrustedSigner changes the signer
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

RariFundProxy checks an ECDSA signature in acceptRelayedCall and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setGsnTrustedSigner changes the signer.

## Evidence

- [acceptRelayedCall](https://etherscan.io/address/0xe4dee94233dd4d7c2504744ee6d34f3875b3b439#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setGsnTrustedSigner](https://etherscan.io/address/0xe4dee94233dd4d7c2504744ee6d34f3875b3b439#code) changes the signer; only the owner can call it.

## Reviewer notes

### Mechanism

acceptRelayedCall (home/david/rspc-v2.4.0/contracts/RariFundProxy.sol, line 375) recovers a signer on line 397 and tests it on line 397 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setGsnTrustedSigner (home/david/rspc-v2.4.0/contracts/RariFundProxy.sol, line 153) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
