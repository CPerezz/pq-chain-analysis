---
id: xethergames-0c073c92-rotate-signer-before-migrating
format: 2
title: 'XetherGames: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0c073c92e7684031cfc297b83ecc33619e864d18'
  name: XetherGames
  code: verified
  code_url: https://etherscan.io/address/0x0c073c92e7684031cfc297b83ecc33619e864d18#code
  copies: 3
  family: 44ed8a9e1809898264da5986c86ab2cd
  upgradeable: 'no'
  admin: '0x46d0cf1545bb9342a67275ea4fca9d3403af9872'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setAddresses before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x0c073c92e7684031cfc297b83ecc33619e864d18'
  file: XetherGames.sol
  line: 282
  has: secretSigner == ecrecover(keccak256(abi.encodePacked(uint40(commitLastBlock), commit)), 27, r, s) ||
  says: placeBet recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x0c073c92e7684031cfc297b83ecc33619e864d18'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x0c073c92e7684031cfc297b83ecc33619e864d18'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x0c073c92e7684031cfc297b83ecc33619e864d18'
  file: XetherGames.sol
  line: 172
  has: function setAddresses
  says: setAddresses changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x0c073c92e7684031cfc297b83ecc33619e864d18'
  fn: secretSigner()(address)
  is: '0x86bd1e26332a4e639a3a9b6f8bdbb2417b4568b2'
  says: The signer it keeps in storage is 0x86bd1e26332a4e639a3a9b6f8bdbb2417b4568b2 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x86bd1e26332a4e639a3a9b6f8bdbb2417b4568b2'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews: []
related: []
---

## What happens

XetherGames accepts a call to placeBet only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setAddresses changes the signer.

## Evidence

- [placeBet](https://etherscan.io/address/0x0c073c92e7684031cfc297b83ecc33619e864d18#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setAddresses](https://etherscan.io/address/0x0c073c92e7684031cfc297b83ecc33619e864d18#code) changes the signer; only the owner can call it.
- The signer at the block is [0x86bd…68b2](https://etherscan.io/address/0x86bd1e26332a4e639a3a9b6f8bdbb2417b4568b2), an account without code.

## Reviewer notes

### Mechanism

placeBet (XetherGames.sol, line 261) recovers a signer on line 282 and tests it on line 282 against the signer it keeps in storage (secretSigner() returns 0x86bd1e26332a4e639a3a9b6f8bdbb2417b4568b2). Neither isValidSignature selector is in the code, so that account is never asked. setAddresses (XetherGames.sol, line 172) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 3 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2021-06-13; 0 transactions called the address in the 90 days before the block. 33284 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
