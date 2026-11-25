---
id: contract-951a1ca3-signer-key
format: 2
title: Bot treasury swaps funds on ECDSA signatures a quantum attacker could forge
status: candidate
severity: MEDIUM
justification: One ECDSA verifier key authorizes swaps of the contract's funds; only the owner can fix it, by redeploying.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x951a1ca3ad7ad2e055226783d32c9e8a69188485'
  code: decompiled
  code_url: code/0x3bd98d9e987698eb3bb3930b8763ad4c331a9d58ed5c67e3ae1cf24d71968675.sol
  copies: 1
  upgradeable: 'no'
  admin: '0x3bf77324ec75c24107077d90275ddaa14efc866f'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Redeploy with a post-quantum signature verifier, or keep the contract's balances near zero.
evidence_level: bytecode
checks:
- id: b1
  bytecode: '0x951a1ca3ad7ad2e055226783d32c9e8a69188485'
  has: 60015afa
  says: The runtime code calls the ecrecover precompile.
  for:
  - evidence-1
  - justification
  - what
- id: sel-setverifier
  selector: '0x951a1ca3ad7ad2e055226783d32c9e8a69188485'
  fn: setVerifier(address)
  says: The code has the owner function that replaces the verifier key.
  for:
  - action
  - evidence-2
  - justification
- id: sel-swapenabled
  selector: '0x951a1ca3ad7ad2e055226783d32c9e8a69188485'
  fn: swapEnabled()
  says: The code has the swap on/off switch used by the signed-swap entry.
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
  who: Review09 (finding review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This contract holds tokens and swaps them when a caller submits parameters signed by its verifier key, checked with ECDSA recovery. A quantum attacker who recovers the verifier key can order swaps of whatever the contract holds on the attacker's terms.

## Evidence

- The [runtime code](https://etherscan.io/address/0x951a1ca3ad7ad2e055226783d32c9e8a69188485#code) calls the ecrecover precompile.
- The [code](https://etherscan.io/address/0x951a1ca3ad7ad2e055226783d32c9e8a69188485#code) has setVerifier, which swaps one key for another but keeps the scheme.

## Reviewer notes

### Mechanism

This contract is unverified bytecode, byte-identical to its sibling 0xff68a48e. The signed-swap entry (decompiled here as 0x347ae8d2; traced on the sibling as 0xa28c0efa) checks swapEnabled and a deadline. It then hashes the parameters and calls ecrecover (precompile 0x01, bytes 60015afa at offset 8313). It compares the recovered address with the stored verifier. If they match, the contract swaps its own token balance through a Uniswap V2 router. setVerifier (0x5437988d, onlyOwner) replaces the verifier address but keeps the ECDSA scheme. Withdrawals go through owner-whitelisted callers to withdrawRecipient. This contract currently holds about $0 and saw no calls in the 30-day window.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: setVerifier cannot change the signer to a non-ECDSA scheme.
- Ruled out: Whether the signed payload fixes the swap recipient is not established.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
