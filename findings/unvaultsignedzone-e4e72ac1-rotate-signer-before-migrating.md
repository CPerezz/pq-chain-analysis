---
id: unvaultsignedzone-e4e72ac1-rotate-signer-before-migrating
format: 2
title: 'UnVaultSignedZone: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe4e72ac12af07fa4e217157d9768b6c6f651928d'
  name: UnVaultSignedZone
  code: verified
  code_url: https://etherscan.io/address/0xe4e72ac12af07fa4e217157d9768b6c6f651928d#code
  copies: 1
  upgradeable: 'no'
  admin: '0x58d36cec908c95943537a14f99d7a7874700c0ce'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 6
impact: liveness
action: Replace the signer with setZoneSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xe4e72ac12af07fa4e217157d9768b6c6f651928d'
  file: ethereum/UnVaultSignedZone.sol
  line: 320
  has: if (digest.recover(auth.signature) != signer) revert InvalidAuthorization();
  says: _requireAuthorized recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xe4e72ac12af07fa4e217157d9768b6c6f651928d'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xe4e72ac12af07fa4e217157d9768b6c6f651928d'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xe4e72ac12af07fa4e217157d9768b6c6f651928d'
  file: ethereum/UnVaultSignedZone.sol
  line: 249
  has: function setZoneSigner
  says: setZoneSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xe4e72ac12af07fa4e217157d9768b6c6f651928d'
  fn: zoneSigner()(address)
  is: '0x976e4457c84fc19cb7989bbb7301a1a56cfcccbc'
  says: The signer it keeps in storage is 0x976e4457c84fc19cb7989bbb7301a1a56cfcccbc at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x976e4457c84fc19cb7989bbb7301a1a56cfcccbc'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x92a546d1063dad1b9d5f4316eef0cd0c87d886cf2746e4e9abbe50881db5944a'
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

UnVaultSignedZone checks an ECDSA signature in _requireAuthorized and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setZoneSigner changes the signer.

## Evidence

- [_requireAuthorized](https://etherscan.io/address/0xe4e72ac12af07fa4e217157d9768b6c6f651928d#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setZoneSigner](https://etherscan.io/address/0xe4e72ac12af07fa4e217157d9768b6c6f651928d#code) changes the signer; only the owner can call it.
- The signer at the block is [0x976e…ccbc](https://etherscan.io/address/0x976e4457c84fc19cb7989bbb7301a1a56cfcccbc), an account without code.

## Reviewer notes

### Mechanism

_requireAuthorized (ethereum/UnVaultSignedZone.sol, line 277) recovers a signer on line 320 and tests it on line 320 against the signer it keeps in storage (zoneSigner() returns 0x976e4457c84fc19cb7989bbb7301a1a56cfcccbc). Neither isValidSignature selector is in the code, so that account is never asked. setZoneSigner (ethereum/UnVaultSignedZone.sol, line 249) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-10-24, recovering 0x976e…ccbc; 6 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
