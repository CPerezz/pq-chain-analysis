---
id: prtclcollections721v1-d9df2211-rotate-signer-before-migrating
format: 2
title: 'PRTCLCollections721V1: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd9df2211b576d430fab3bd93f915a1345974d797'
  name: PRTCLCollections721V1
  code: verified
  code_url: https://etherscan.io/address/0xd9df2211b576d430fab3bd93f915a1345974d797#code
  copies: 1
  upgradeable: 'no'
  admin: '0xe84b1be8848a390830d591331f67e4d56c98a19a'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 3
impact: liveness
action: Replace the signer with updateDelegationSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xd9df2211b576d430fab3bd93f915a1345974d797'
  file: contracts/v1/governance/PRTCLCoreERC721Votes.sol
  line: 93
  has: return block.number < _expirationBlock && delegateSigner == messageHash.toEthSignedMessageHash().recover(_sign
  says: verifyDelegation recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xd9df2211b576d430fab3bd93f915a1345974d797'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xd9df2211b576d430fab3bd93f915a1345974d797'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xd9df2211b576d430fab3bd93f915a1345974d797'
  file: contracts/v1/PRTCLCollections721V1.sol
  line: 165
  has: function updateDelegationSigner
  says: updateDelegationSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xd9df2211b576d430fab3bd93f915a1345974d797'
  fn: delegateSigner()(address)
  is: '0x2ddd8dbc81c0384af673cb46c849154253eb29aa'
  says: The signer it keeps in storage is 0x2ddd8dbc81c0384af673cb46c849154253eb29aa at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x2ddd8dbc81c0384af673cb46c849154253eb29aa'
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

PRTCLCollections721V1 checks an ECDSA signature in verifyDelegation and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. updateDelegationSigner changes the signer.

## Evidence

- [verifyDelegation](https://etherscan.io/address/0xd9df2211b576d430fab3bd93f915a1345974d797#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [updateDelegationSigner](https://etherscan.io/address/0xd9df2211b576d430fab3bd93f915a1345974d797#code) changes the signer (through _setDelegationSigner); only a role holder can call it.
- The signer at the block is [0x2ddd…29aa](https://etherscan.io/address/0x2ddd8dbc81c0384af673cb46c849154253eb29aa), an account without code.

## Reviewer notes

### Mechanism

verifyDelegation (contracts/v1/governance/PRTCLCoreERC721Votes.sol, line 90) recovers a signer on line 93 and tests it on line 93 against the signer it keeps in storage (delegateSigner() returns 0x2ddd8dbc81c0384af673cb46c849154253eb29aa). Neither isValidSignature selector is in the code, so that account is never asked. _setDelegationSigner (contracts/v1/governance/PRTCLCoreERC721Votes.sol, line 42) writes it, called by updateDelegationSigner. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2024-01-30, recovering 0x2ddd…29aa; 3 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
