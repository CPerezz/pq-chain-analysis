---
id: peniwalletstorage-d6fceb73-rotate-signer-before-migrating
format: 2
title: 'PeniwalletStorage: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd6fceb7328a6b24a2a17d3640d3875df636ffc3d'
  name: PeniwalletStorage
  code: verified
  code_url: https://etherscan.io/address/0xd6fceb7328a6b24a2a17d3640d3875df636ffc3d#code
  copies: 1
  upgradeable: 'no'
  admin: '0x43c2a3469d64da4695920eb78d62581811b0d14a'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 22
impact: liveness
action: Replace the signer with setRelayerAuthority before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xd6fceb7328a6b24a2a17d3640d3875df636ffc3d'
  file: contracts/multidex/peniwallet_storage.sol
  line: 129
  has: return _recoverRelayerPermit(p, signature) == authority;
  says: verifyRelayerPermit recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xd6fceb7328a6b24a2a17d3640d3875df636ffc3d'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xd6fceb7328a6b24a2a17d3640d3875df636ffc3d'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xd6fceb7328a6b24a2a17d3640d3875df636ffc3d'
  file: contracts/multidex/peniwallet_storage.sol
  line: 110
  has: function setRelayerAuthority
  says: setRelayerAuthority changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xd6fceb7328a6b24a2a17d3640d3875df636ffc3d'
  fn: relayerAuthority()(address)
  is: '0x9c7785a0bfac6485bb924744b39679f3be33e4dc'
  says: The signer it keeps in storage is 0x9c7785a0bfac6485bb924744b39679f3be33e4dc at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x9c7785a0bfac6485bb924744b39679f3be33e4dc'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xa712f341df00ec09fe4bfc9377fe8d2f0f85e84562ebbf6e9f296972c53cfe3f'
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

PeniwalletStorage checks an ECDSA signature in verifyRelayerPermit and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setRelayerAuthority changes the signer.

## Evidence

- [verifyRelayerPermit](https://etherscan.io/address/0xd6fceb7328a6b24a2a17d3640d3875df636ffc3d#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setRelayerAuthority](https://etherscan.io/address/0xd6fceb7328a6b24a2a17d3640d3875df636ffc3d#code) changes the signer; only the owner can call it.
- The signer at the block is [0x9c77…e4dc](https://etherscan.io/address/0x9c7785a0bfac6485bb924744b39679f3be33e4dc), an account without code.

## Reviewer notes

### Mechanism

verifyRelayerPermit (contracts/multidex/peniwallet_storage.sol, line 119) recovers a signer on line 129 and tests it on line 129 against the signer it keeps in storage (relayerAuthority() returns 0x9c7785a0bfac6485bb924744b39679f3be33e4dc). Neither isValidSignature selector is in the code, so that account is never asked. setRelayerAuthority (contracts/multidex/peniwallet_storage.sol, line 110) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-17, recovering 0x9c77…e4dc; 22 transactions called the address in the 90 days before the block. 3 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
