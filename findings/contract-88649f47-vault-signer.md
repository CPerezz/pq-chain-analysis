---
id: contract-88649f47-vault-signer
format: 2
title: Binance Wallet vault trusts ECDSA order signatures a quantum attacker can forge
status: candidate
severity: MEDIUM
justification: 'Vault inventory is spent on one ECDSA order signature; Binance Wallet can fix it by upgrading the
  proxy: medium.'
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x88649f4743a758171077b98ee2003f1989b1615a'
  project: binance-wallet
  code: decompiled
  code_url: code/0x814af4e7dae3c148e1a0c40206eb3c94a4f60067a7eef63b52ee81693a4407be.sol
  proxy_of: '0x471a8de3eec36775d230070f9704cc86bf0f360d'
  copies: 1
  upgradeable: 'yes'
value:
  usd: 622657
  basis: held
activity:
  txs_90d: 14925
impact: funds-loss
action: Upgrade the vault to require a post-quantum order signature for every swap that spends inventory.
evidence_level: bytecode
checks:
- id: b1
  bytecode: '0x471a8de3eec36775d230070f9704cc86bf0f360d'
  has: 600160a01b0386165afa
  says: the implementation calls the ecrecover precompile
  for:
  - evidence-1
  - justification
  - what
- id: sel-signer
  selector: '0x471a8de3eec36775d230070f9704cc86bf0f360d'
  fn: ROLE_SIGNER()
  says: the implementation defines a signer role
  for:
  - evidence-2
  - what
- id: sel-orderid
  selector: '0x471a8de3eec36775d230070f9704cc86bf0f360d'
  fn: orderIdUsed(uint256)
  says: the implementation tracks used order ids
  for:
  - evidence-2
  - what
- id: sel-router
  selector: '0x471a8de3eec36775d230070f9704cc86bf0f360d'
  fn: getRouter()
  says: the implementation has a configured swap router
  for:
  - what
- id: sel-upgrade
  selector: '0x471a8de3eec36775d230070f9704cc86bf0f360d'
  fn: upgradeToAndCall(address,bytes)
  says: the implementation is UUPS-upgradeable
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
  who: review (Review16)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not
    reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

This upgradeable vault swaps its own stablecoin inventory through a router for orders whose ECDSA signature it checks with ecrecover. A quantum attacker who recovers the signer and a relayer key can sign an order that swaps the inventory to an address they choose.

## Evidence

- The [implementation](https://etherscan.io/address/0x471a8de3eec36775d230070f9704cc86bf0f360d#code) calls the ecrecover precompile to check signatures.
- The [implementation](https://etherscan.io/address/0x471a8de3eec36775d230070f9704cc86bf0f360d#code) has a signer role and replay tracking for signed order ids.
- The [implementation](https://etherscan.io/address/0x471a8de3eec36775d230070f9704cc86bf0f360d#code) can be upgraded through upgradeToAndCall.

## Reviewer notes

### Mechanism

The implementation behind the proxy is unverified. The swap entry point 0x3271ba8d requires the caller to hold the relayer role. It recovers the EIP-712 order signer with ecrecover, which the bytecode calls at offset 2493. It then requires that signer to hold ROLE_SIGNER and checks orderIdUsed and the deadline. It approves tokenIn to getRouter() and calls the router with the order's calldata. The output goes to the order's recipient. A trace of a swap transaction showed ecrecover returning the single ROLE_SIGNER before the vault spent USDT. Replaying that call with one altered signature byte reverted InvalidSignature. The vault is paused today. ROLE_ADMIN can unpause it, and DEFAULT_ADMIN_ROLE can grant roles or call upgradeToAndCall.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Users cannot act: the funds are the vault's own inventory.
- Ruled out: EIP-8151 does not help: all keys are code-less EOAs.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
