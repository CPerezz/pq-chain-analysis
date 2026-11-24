---
id: contract-5ca1ed24-7702-own-key-only
format: 2
title: Gasless delegate account stops accepting its own key if it takes real code
status: confirmed
severity: INFORMATIONAL
justification: Works while the account keeps its EIP-7702 delegation; breaks only if its holder moves it to real
  code.
category: migration-notice
pattern: PQ-20
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5ca1ed2406c79c2bb8c466dd13d54e14ad22c72b'
  code: verified
  code_url: https://etherscan.io/address/0x0000fb7702036ff9f76044a501ac1aa74cbab16b#code
  copies: 299854
  family: d9ec0f2ed1bbb6286d942e2197fa8630
value:
  usd: 9715475
  basis: held
activity: {}
impact: funds-locked
action: Keep the EIP-7702 delegation, or move the funds out, before this account takes real code that checks only
  its own key.
evidence_level: executed
checks:
- id: code
  code: '0x5ca1ed2406c79c2bb8c466dd13d54e14ad22c72b'
  is: delegation
  target: '0x0000fb7702036ff9f76044a501ac1aa74cbab16b'
  says: the account is an EOA delegated to the UniversalGaslessDelegate logic
  for:
  - evidence-3
  - justification
  - what
- id: nonce
  nonce: '0x5ca1ed2406c79c2bb8c466dd13d54e14ad22c72b'
  is: 245
  says: the account has sent 245 transactions
  for:
  - evidence-3
- id: eth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x5ca1ed2406c79c2bb8c466dd13d54e14ad22c72b'
  is: '3860747023826157104701'
  says: the account holds 3,860.75 ETH
  for:
  - what
- id: paused
  call: '0x0000fb7702036ff9f76044a501ac1aa74cbab16b'
  fn: isPaused()(bool)
  is: 'false'
  says: the delegate logic's kill switch is not engaged
  for:
  - evidence-3
- id: author
  source: '0x0000fb7702036ff9f76044a501ac1aa74cbab16b'
  file: src/UniversalGaslessDelegate.sol
  line: 2
  has: Copyright (C) 2025 Fireblocks
  says: the delegate logic is Fireblocks' code
  for:
  - what
- id: self-single
  source: '0x0000fb7702036ff9f76044a501ac1aa74cbab16b'
  file: src/UniversalGaslessDelegate.sol
  line: 263
  has: require(address(this) == ECDSA.recover(sDigest, signature), LibErrors.UnauthorizedExecution());
  says: a relayed single call needs a signature recovering to the account itself
  for:
  - action
  - evidence-1
  - what
- id: self-batch
  source: '0x0000fb7702036ff9f76044a501ac1aa74cbab16b'
  file: src/UniversalGaslessDelegate.sol
  line: 275
  has: require(address(this) == ECDSA.recover(bDigest, signature), LibErrors.UnauthorizedExecution());
  says: a relayed batch needs a signature recovering to the account itself
  for:
  - action
  - evidence-1
  - what
- id: self-call
  source: '0x0000fb7702036ff9f76044a501ac1aa74cbab16b'
  file: src/UniversalGaslessDelegate.sol
  line: 283
  has: require(msg.sender == address(this), LibErrors.UnauthorizedCaller());
  says: without a signature, only a call from the account itself executes
  for:
  - what
- id: replay-ok
  replay: '0x7ebeee3f86c1437282cbbc2cd37f87f547431a1c8aed33e184c7be727ac15825'
  run: eip8151
  ok: true
  says: a relayed transfer of a delegated account still passes under EIP-8151
  for:
  - evidence-2
  - justification
  - what
- id: replay-real
  replay: '0x7ebeee3f86c1437282cbbc2cd37f87f547431a1c8aed33e184c7be727ac15825'
  run: eip8151_self_real_code
  ok: false
  says: the same transfer reverts when the account holds the logic as real code
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
reviews:
- who: r-5ca1ed24, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: INFORMATIONAL notice (PQ-20): an account (3,860 ETH and tokens) delegated via EIP-7702 to Fireblocks''
    UniversalGaslessDelegate, whose every path requires the recovered signer to be the account itself; the delegation
    keeps working under EIP-8151, but taking that logic as real code would lock it (a real transaction passes under
    eip8151 and reverts under eip8151_self_real_code). Refuter agrees; Claude read the sheet.'
related: []
---

## What happens

This account holds 3,860 ETH and runs Fireblocks' gasless delegate logic through an EIP-7702 delegation, which keeps working. Besides its own transactions, it acts only on signatures that recover to the account itself. If it takes this logic as real code, they stop counting.

## Evidence

- [execute](https://etherscan.io/address/0x0000fb7702036ff9f76044a501ac1aa74cbab16b#code) runs a relayed single or batch call only when its signature recovers to the account itself.
- [A relayed USDC transfer](https://etherscan.io/tx/0x7ebeee3f86c1437282cbbc2cd37f87f547431a1c8aed33e184c7be727ac15825) of another account with this logic passes under the change, and reverts once that account holds it as real code.
- [The account](https://etherscan.io/address/0x5ca1ed2406c79c2bb8c466dd13d54e14ad22c72b) is delegated to this logic and has sent 245 transactions; the logic is not paused.

## Reviewer notes

### Mechanism

The account 0x5ca1ed24 is an EOA with an EIP-7702 delegation to UniversalGaslessDelegate (0x0000fb77). execute (lines 239-292): with opData (nonce, deadline, 65-byte signature) it hashes an EIP-712 AuthorizedExecutions struct bound to the relayer and requires ECDSA.recover(digest, signature) == address(this) (single call line 263, batch line 275) before running the calls. Without opData it requires msg.sender == address(this) (line 283), i.e. a transaction the account sends itself. isValidSignature (ERC-1271, lines 371-385) uses _isValidRawSignature (lines 672-675), again recovered == address(this). No stored key, owner or second signer exists. Under EIP-8151 a delegated account still recovers, so nothing changes today (replay eip8151 ok). If the account ever holds this logic as real code, the recovery returns nothing for it, so relayed calls and ERC-1271 answers fail; and an account with real code cannot send transactions (EIP-3607), which closes the self-call path, so nothing moves out (receive/fallback only take ETH in). Replay 0x7ebeee3f: relayer 0x0440e61b calls execute on 0x8a6b97e0 (same delegation) in single-call opData mode, one call to USDC transfer; the only recovery is this own-key check, which runs before the transfer, and it reverts under eip8151_self_real_code.

### Checks

- Header facts: this address alone, at block 26,438,999; 299,854 addresses run this code.
- Ruled out: an ERC-1271 or second-key path: isValidSignature uses the same own-key check (line 674); no stored signer or owner exists in the source.
- Ruled out: a break under EIP-8151 alone: both family replays (0x7ebeee3f single-call, 0xf670bcb1) pass under eip8151; the second also passes the tight-gas run, and the precompile gets all gas through ECDSA.recover.
- Ruled out: an unused or paused address: the account has nonce 245 and is delegated to this logic at the block; isPaused() returns false.
- Ruled out: a replay that bundles another signer's check: the cited transaction makes one USDC transfer from the account, which checks no signature.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
