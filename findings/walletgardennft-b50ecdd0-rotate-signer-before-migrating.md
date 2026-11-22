---
id: walletgardennft-b50ecdd0-rotate-signer-before-migrating
format: 2
title: 'WalletGardenNFT: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb50ecdd02a79be4b8f8d1f1c0377d6c91f08862b'
  name: WalletGardenNFT
  code: verified
  code_url: https://etherscan.io/address/0x83b203ddad096ab8e69d0369be6af06be4c333cf#code
  proxy_of: '0x83b203ddad096ab8e69d0369be6af06be4c333cf'
  copies: 2
  family: b6a311a0dfe8661f89e74ab39f67db50
  upgradeable: 'yes'
  admin: '0x04c3c17d6b3ef95a0771bf21dee474c128c6132d'
value:
  usd: 108
  basis: held
activity:
  txs_90d: 52
impact: liveness
action: Replace the signer with setMintSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x83b203ddad096ab8e69d0369be6af06be4c333cf'
  file: src/WalletGardenNFT.sol
  line: 322
  has: ECDSAUpgradeable.recover(mintAuthDigest(to, rollNumber, deadline), signature) == signer,
  says: _mintTrunk recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x83b203ddad096ab8e69d0369be6af06be4c333cf'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x83b203ddad096ab8e69d0369be6af06be4c333cf'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x83b203ddad096ab8e69d0369be6af06be4c333cf'
  file: src/WalletGardenNFT.sol
  line: 430
  has: function setMintSigner
  says: setMintSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xb50ecdd02a79be4b8f8d1f1c0377d6c91f08862b'
  fn: mintSigner()(address)
  is: '0x314431057718d804b5b22cb86d545a07da6e5e83'
  says: The signer it keeps in storage is 0x314431057718d804b5b22cb86d545a07da6e5e83 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x314431057718d804b5b22cb86d545a07da6e5e83'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xb3c2cee0592580c34686f2693660026740cb1c557ccab0ab0a4e44d610402eaa'
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

WalletGardenNFT checks an ECDSA signature in _mintTrunk and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setMintSigner changes the signer.

## Evidence

- [_mintTrunk](https://etherscan.io/address/0x83b203ddad096ab8e69d0369be6af06be4c333cf#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setMintSigner](https://etherscan.io/address/0x83b203ddad096ab8e69d0369be6af06be4c333cf#code) changes the signer; only the owner can call it.
- The signer at the block is [0x3144…5e83](https://etherscan.io/address/0x314431057718d804b5b22cb86d545a07da6e5e83), an account without code.

## Reviewer notes

### Mechanism

_mintTrunk (src/WalletGardenNFT.sol, line 304) recovers a signer on line 322 and tests it on line 322 against the signer it keeps in storage (mintSigner() returns 0x314431057718d804b5b22cb86d545a07da6e5e83). Neither isValidSignature selector is in the code, so that account is never asked. setMintSigner (src/WalletGardenNFT.sol, line 430) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-13, recovering 0x3144…5e83; 52 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
