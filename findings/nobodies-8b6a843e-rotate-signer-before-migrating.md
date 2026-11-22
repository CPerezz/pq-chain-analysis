---
id: nobodies-8b6a843e-rotate-signer-before-migrating
format: 2
title: 'Nobodies: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x8b6a843ef95bc85049df091cf4bf84acdef34cf3'
  name: Nobodies
  code: verified
  code_url: https://etherscan.io/address/0x8b6a843ef95bc85049df091cf4bf84acdef34cf3#code
  copies: 1
  upgradeable: 'no'
  admin: '0xe1432944a2fe49451131803646518022a2aa21fc'
value:
  usd: 7633
  basis: held
activity:
  txs_90d: 23
impact: liveness
action: Replace the signer with setDeployerAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x8b6a843ef95bc85049df091cf4bf84acdef34cf3'
  file: Nobodies.sol
  line: 1652
  has: address recoveredAddress = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hashedMessage)).reco
  says: mint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x8b6a843ef95bc85049df091cf4bf84acdef34cf3'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x8b6a843ef95bc85049df091cf4bf84acdef34cf3'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x8b6a843ef95bc85049df091cf4bf84acdef34cf3'
  file: Nobodies.sol
  line: 1653
  has: require(recoveredAddress == deployer, "Unauthorized signature");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x8b6a843ef95bc85049df091cf4bf84acdef34cf3'
  file: Nobodies.sol
  line: 1542
  has: function setDeployerAddress
  says: setDeployerAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x8b6a843ef95bc85049df091cf4bf84acdef34cf3'
  fn: deployer()(address)
  is: '0xe1432944a2fe49451131803646518022a2aa21fc'
  says: The signer it keeps in storage is 0xe1432944a2fe49451131803646518022a2aa21fc at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xe1432944a2fe49451131803646518022a2aa21fc'
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

Nobodies accepts a call to mint only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setDeployerAddress changes the signer.

## Evidence

- [mint](https://etherscan.io/address/0x8b6a843ef95bc85049df091cf4bf84acdef34cf3#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setDeployerAddress](https://etherscan.io/address/0x8b6a843ef95bc85049df091cf4bf84acdef34cf3#code) changes the signer; only the owner can call it.
- The signer at the block is [0xe143…21fc](https://etherscan.io/address/0xe1432944a2fe49451131803646518022a2aa21fc), an account without code.

## Reviewer notes

### Mechanism

mint (Nobodies.sol, line 1636) recovers a signer on line 1652 and tests it on line 1653 against the signer it keeps in storage (deployer() returns 0xe1432944a2fe49451131803646518022a2aa21fc). Neither isValidSignature selector is in the code, so that account is never asked. setDeployerAddress (Nobodies.sol, line 1542) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-09-20; 23 transactions called the address in the 90 days before the block. 28 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
