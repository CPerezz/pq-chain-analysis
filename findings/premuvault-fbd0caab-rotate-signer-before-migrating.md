---
id: premuvault-fbd0caab-rotate-signer-before-migrating
format: 2
title: 'PremuVault: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xfbd0caabcfbcf1cd4e1c6c4bee710bb7ff8da2f6'
  name: PremuVault
  code: verified
  code_url: https://etherscan.io/address/0xfbd0caabcfbcf1cd4e1c6c4bee710bb7ff8da2f6#code
  copies: 1
  upgradeable: 'no'
  admin: '0xc307c7d81b4267daebbc8f41933c9cde39a4d8e4'
value:
  usd: 60
  basis: held
activity:
  txs_90d: 243
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xfbd0caabcfbcf1cd4e1c6c4bee710bb7ff8da2f6'
  file: src/PremuVault.sol
  line: 149
  has: address recovered = ECDSA.recover(digest, signature);
  says: withdraw recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xfbd0caabcfbcf1cd4e1c6c4bee710bb7ff8da2f6'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xfbd0caabcfbcf1cd4e1c6c4bee710bb7ff8da2f6'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xfbd0caabcfbcf1cd4e1c6c4bee710bb7ff8da2f6'
  file: src/PremuVault.sol
  line: 150
  has: if (recovered != signer) revert InvalidSignature();
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xfbd0caabcfbcf1cd4e1c6c4bee710bb7ff8da2f6'
  file: src/PremuVault.sol
  line: 158
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xfbd0caabcfbcf1cd4e1c6c4bee710bb7ff8da2f6'
  fn: signer()(address)
  is: '0xc307c7d81b4267daebbc8f41933c9cde39a4d8e4'
  says: The signer it keeps in storage is 0xc307c7d81b4267daebbc8f41933c9cde39a4d8e4 at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0xc307c7d81b4267daebbc8f41933c9cde39a4d8e4'
  is: delegation
  target: '0x63c0c19a282a1b52b07dd5a65b58948a07dae32b'
  says: 'the signer''s account holds an EIP-7702 delegation: an ECDSA key still controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x43d828efb9e58fba2649fc3880f72fbc60d44b038bb27afe1408c539a967dc6d'
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

PremuVault accepts a call to withdraw only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [withdraw](https://etherscan.io/address/0xfbd0caabcfbcf1cd4e1c6c4bee710bb7ff8da2f6#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0xfbd0caabcfbcf1cd4e1c6c4bee710bb7ff8da2f6#code) changes the signer; only the owner can call it.
- The signer at the block is [0xc307…d8e4](https://etherscan.io/address/0xc307c7d81b4267daebbc8f41933c9cde39a4d8e4), an account with an EIP-7702 delegation, which keeps working.

## Reviewer notes

### Mechanism

withdraw (src/PremuVault.sol, line 130) recovers a signer on line 149 and tests it on line 150 against the signer it keeps in storage (signer() returns 0xc307c7d81b4267daebbc8f41933c9cde39a4d8e4). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (src/PremuVault.sol, line 158) writes it. The signer's account holds an EIP-7702 delegation to 0x63c0c19a282a1b52b07dd5a65b58948a07dae32b. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-17, recovering 0xc307…d8e4; 243 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
