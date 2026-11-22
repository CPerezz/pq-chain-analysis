---
id: swaperc20-d82fa167-v4-maker-sig-ecdsa-only
format: 2
title: AirSwap SwapERC20 lets a quantum attacker sign orders spending maker approvals
status: confirmed
severity: HIGH
justification: Makers' approvals stay spendable by forged ECDSA orders in a contract that can't change; only makers
  can revoke.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd82fa167727a4dc6d6f55830a2c47abbb4b3a0f8'
  name: SwapERC20
  project: airswap
  code: verified
  code_url: https://etherscan.io/address/0xd82fa167727a4dc6d6f55830a2c47abbb4b3a0f8#code
  copies: 1
  admin: '0xf8bb149f9525875fa47b8cc632d368eb600faba3'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Tell makers to revoke token approvals to this contract and remove it from AirSwap tooling.
evidence_level: source
checks:
- id: c1
  source: '0xd82fa167727a4dc6d6f55830a2c47abbb4b3a0f8'
  file: contracts/SwapERC20.sol
  line: 254
  has: (address signatory, ) = ECDSA.tryRecover(
  says: swapLight recovers the order signer with ECDSA.tryRecover.
  for:
  - evidence-2
  - justification
  - what
- id: c3
  source: '0xd82fa167727a4dc6d6f55830a2c47abbb4b3a0f8'
  file: contracts/SwapERC20.sol
  line: 668
  has: (address signatory, ) = ECDSA.tryRecover(
  says: _check recovers the order signer with ECDSA.tryRecover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c4
  source: '0xd82fa167727a4dc6d6f55830a2c47abbb4b3a0f8'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 152
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover calls the ecrecover precompile.
  for:
  - evidence-1
  - what
- id: s-auth
  source: '0xd82fa167727a4dc6d6f55830a2c47abbb4b3a0f8'
  file: contracts/SwapERC20.sol
  has: if (signatory != signerWallet) revert Unauthorized();
  line: 693
  says: Order signatory must be the maker's own wallet when no delegate is set.
  for:
  - action
  - evidence-3
  - justification
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review17 (full Sourcify source and on-chain reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This contract settles a maker's signed order only if ECDSA recovers the maker or the maker's delegate. It then pulls the maker's tokens, so a quantum attacker who recovers a maker's key can sign orders that spend the maker's approvals.

## Evidence

- [_check](https://etherscan.io/address/0xd82fa167727a4dc6d6f55830a2c47abbb4b3a0f8#code) recovers the order signatory with ECDSA.tryRecover.
- [swapLight](https://etherscan.io/address/0xd82fa167727a4dc6d6f55830a2c47abbb4b3a0f8#code) uses the same ECDSA recovery on the order.
- [_check](https://etherscan.io/address/0xd82fa167727a4dc6d6f55830a2c47abbb4b3a0f8#code) requires the signatory to equal the signer wallet when no delegate is set.

## Reviewer notes

### Mechanism

swap/swapAnySender call _check (SwapERC20.sol 648-699): ECDSA.tryRecover(_getOrderHash(...), v, r, s) at line 668 (ecrecover at ECDSA.sol 152). The signatory must be non-zero (685) and equal authorized[signerWallet] if set (688-690), else signerWallet (693). swapLight (236-330) does the same at line 254 with checks at 281-292. After the check the contract moves signerToken from signerWallet via safeTransferFrom. There is no ERC-1271 path, so a quantum attacker with a maker's recovered secp256k1 key (or the delegate's) can produce valid orders draining any allowance the maker granted to this contract.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not an operator-key issue: the signer is the maker, not the owner Safe.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
