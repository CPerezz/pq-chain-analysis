---
id: contract-b141f554-swap-router-signer
format: 2
title: Bitget swap router lets one ECDSA signer key authorise vault payouts
status: candidate
severity: MEDIUM
justification: One operator ECDSA key signs every order; Bitget can only rotate it, so a fix needs a new deployment.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb141f554188cf306fde443f6e991949636f80e49'
  project: bitget
  code: decompiled
  code_url: code/0xaa18bd1ff2d2152bcf6540efba76808a1b2a2b6238d5818b751ee3d23166c759.sol
  copies: 1
  upgradeable: 'no'
  admin: '0x9287b8e84d972dd02f618bbed45b9a6d7ed16384'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 170
impact: funds-loss
action: Keep the router paused or revoke the vault's approvals; have any successor verify orders with a post-quantum
  signature.
evidence_level: bytecode
checks:
- id: b1
  bytecode: '0xb141f554188cf306fde443f6e991949636f80e49'
  has: 60015afa
  says: the runtime code calls the ecrecover precompile
  for:
  - evidence-1
  - justification
  - what
- id: sel-signer
  selector: '0xb141f554188cf306fde443f6e991949636f80e49'
  fn: signer()
  says: signer() selector is in the code
  for:
  - evidence-1
  - justification
  - what
- id: sel-manage
  selector: '0xb141f554188cf306fde443f6e991949636f80e49'
  fn: manageSigner(address)
  says: manageSigner(address) selector is in the code
  for:
  - evidence-2
  - justification
  - what
- id: sel-vault
  selector: '0xb141f554188cf306fde443f6e991949636f80e49'
  fn: vault()
  says: vault() selector is in the code
  for:
  - action
  - what
- id: sel-pause
  selector: '0xb141f554188cf306fde443f6e991949636f80e49'
  fn: pause()
  says: pause() selector is in the code
  for:
  - action
  - evidence-3
- id: sel-paused
  selector: '0xb141f554188cf306fde443f6e991949636f80e49'
  fn: paused()
  says: paused() selector is in the code
  for:
  - evidence-3
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: review (Review22)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

The router executes orders when an ECDSA signature recovers to its stored signer. A quantum attacker who derives the signer key could sign orders paying out tokens the vault approved. The owner can replace the signer, not the scheme.

## Evidence

- The [router code](https://etherscan.io/address/0xb141f554188cf306fde443f6e991949636f80e49#code) calls the ecrecover precompile and exposes signer().
- [manageSigner](https://etherscan.io/address/0xb141f554188cf306fde443f6e991949636f80e49#code) only swaps the signer address; the router is not a proxy.
- The [router](https://etherscan.io/address/0xb141f554188cf306fde443f6e991949636f80e49#code) has pause() and paused() to stop order execution.

## Reviewer notes

### Mechanism

The contract has no verified source, so this path comes from its bytecode. Order functions (e.g. selectors 0x01bbd2e2, 0x396fc311, 0x1cf3e2f5) check the Pausable flag and a reentrancy guard. Each then runs ecrecover(orderHash, v, r, s) (precompile call at byte offset 6296) and compares the result with signer() (storage slot 4) before calling transferFrom. The tokens come from the user or from the vault EOA returned by vault(). Traces in kev's review show the vault paying out to recipients named in the order. manageSigner(address), restricted to the owner Safe, only rewrites slot 4. The ECDSA scheme is fixed in the bytecode and there is no proxy. The router was paused by the operator and its ETH was rescued to the owner Safe. While it stays paused, a forged signer key alone cannot execute orders.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Upgrade to a new verifier: there is no proxy, so the scheme cannot be changed in place.
- Ruled out: Who may call unpause was not established from bytecode.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
