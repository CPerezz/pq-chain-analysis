---
id: arcade8004-2ae8969d-rotate-signer-before-migrating
format: 2
title: 'Arcade8004: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2ae8969dddaf15e268792b4c361c45e20993cec0'
  name: Arcade8004
  code: verified
  code_url: https://etherscan.io/address/0x2ae8969dddaf15e268792b4c361c45e20993cec0#code
  copies: 2
  family: 4ca1082e81a19a7671d79b4eff6e92fc
  upgradeable: 'no'
  admin: '0xfd9081be00513fabde721dfefe20c4f6553fd35a'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 7
impact: liveness
action: Replace the signer with setGameAgent before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x2ae8969dddaf15e268792b4c361c45e20993cec0'
  file: contracts/Arcade8004.sol
  line: 74
  has: address signer = ethSignedMessageHash.recover(signature);
  says: mint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x2ae8969dddaf15e268792b4c361c45e20993cec0'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x2ae8969dddaf15e268792b4c361c45e20993cec0'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x2ae8969dddaf15e268792b4c361c45e20993cec0'
  file: contracts/Arcade8004.sol
  line: 76
  has: require(signer == gameAgent, "Invalid signature from game agent");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x2ae8969dddaf15e268792b4c361c45e20993cec0'
  file: contracts/Arcade8004.sol
  line: 110
  has: function setGameAgent
  says: setGameAgent changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x2ae8969dddaf15e268792b4c361c45e20993cec0'
  fn: gameAgent()(address)
  is: '0xfd9081be00513fabde721dfefe20c4f6553fd35a'
  says: The signer it keeps in storage is 0xfd9081be00513fabde721dfefe20c4f6553fd35a at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xfd9081be00513fabde721dfefe20c4f6553fd35a'
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

Arcade8004 accepts a call to mint only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setGameAgent changes the signer.

## Evidence

- [mint](https://etherscan.io/address/0x2ae8969dddaf15e268792b4c361c45e20993cec0#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setGameAgent](https://etherscan.io/address/0x2ae8969dddaf15e268792b4c361c45e20993cec0#code) changes the signer; only the owner can call it.
- The signer at the block is [0xfd90…d35a](https://etherscan.io/address/0xfd9081be00513fabde721dfefe20c4f6553fd35a), an account without code.

## Reviewer notes

### Mechanism

mint (contracts/Arcade8004.sol, line 50) recovers a signer on line 74 and tests it on line 76 against the signer it keeps in storage (gameAgent() returns 0xfd9081be00513fabde721dfefe20c4f6553fd35a). Neither isValidSignature selector is in the code, so that account is never asked. setGameAgent (contracts/Arcade8004.sol, line 110) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-02-22, recovering 0xfd90…d35a; 7 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
