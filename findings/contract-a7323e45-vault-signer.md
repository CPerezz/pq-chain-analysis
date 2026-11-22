---
id: contract-a7323e45-vault-signer
format: 2
title: Binance Wallet vault takes ECDSA orders a quantum attacker can forge
status: candidate
severity: MEDIUM
justification: 'Order signatures are ECDSA; a recovered signer key spends vault inventory. Binance can upgrade the
  proxy: MEDIUM.'
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa7323e4523959d03600c2c1fc1371320d800f872'
  project: binance-wallet
  code: decompiled
  code_url: code/0xeb18c11f8ec99b6ecac52cfa87b05b1601ebfc2f78fbfac8453061ca2b9a00fa.sol
  proxy_of: '0xc01af02cf17f3dee5857da085d5f58c28375d5d3'
  copies: 1
  upgradeable: 'yes'
value:
  usd: 27
  basis: held
activity:
  txs_90d: 62
impact: funds-loss
action: Upgrade the vault to verify a post-quantum order signature before spending inventory.
evidence_level: bytecode
checks:
- id: b1
  bytecode: '0xc01af02cf17f3dee5857da085d5f58c28375d5d3'
  has: 600160a01b0386165afa
  says: The implementation calls the ecrecover precompile at offset 5753.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: b2
  bytecode: '0xc01af02cf17f3dee5857da085d5f58c28375d5d3'
  has: 600160a01b0388165afa
  says: The implementation calls the ecrecover precompile at offset 11534.
  for:
  - evidence-1
  - justification
  - what
- id: b3
  bytecode: '0xc01af02cf17f3dee5857da085d5f58c28375d5d3'
  has: 600160a01b03165af1
  says: The implementation calls the ecrecover precompile at offset 16618.
  for:
  - evidence-2
- id: b4
  bytecode: '0xc01af02cf17f3dee5857da085d5f58c28375d5d3'
  has: 60015afa
  says: The implementation calls the ecrecover precompile at offset 20477.
  for:
  - evidence-2
- id: code
  code: '0xa7323e4523959d03600c2c1fc1371320d800f872'
  is: contract
  bytes: 130
  says: The vault address holds contract code (a proxy).
  for:
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

This Binance Wallet vault swaps its own stablecoin inventory for recipients named in backend-signed orders. It accepts an order when ecrecover returns the signer key, so a quantum attacker who derives that key forges orders sending inventory to themselves.

## Evidence

- The [vault code](https://etherscan.io/address/0xc01af02cf17f3dee5857da085d5f58c28375d5d3#code) calls the ecrecover precompile when checking signatures.
- The [vault code](https://etherscan.io/address/0xc01af02cf17f3dee5857da085d5f58c28375d5d3#code) contains further ecrecover precompile calls.

## Reviewer notes

### Mechanism

The address is a proxy whose implementation 0xc01af02c… is unverified bytecode. The runtime code calls the ecrecover precompile at offsets 5753, 11534, 16618 and 20477. Kev's trace of the swap entry point 0x3271ba8d on this vault (tx 0x03589cd9…) shows ecrecover returning the ROLE_SIGNER 0xd88165cc… before the vault approves its USDT to the router and calls it. The output goes to the order's recipient. A relayer role gates the caller, but relayers are ECDSA EOAs too. Signer rotation is a role grant. The scheme itself changes only through a UUPS upgrade by DEFAULT_ADMIN_ROLE 0xee7b429e….

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Holdings at this vault are small; the large inventory sits in the paused sibling vault.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
