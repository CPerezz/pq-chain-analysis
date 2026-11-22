---
id: contract-ff68a48e-signer-key
format: 2
title: Bot treasury swaps its funds on ECDSA orders a quantum attacker could forge
status: candidate
severity: MEDIUM
justification: The owner must redeploy with a post-quantum verifier; setVerifier rotates the ECDSA key, not the
  scheme.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xff68a48e8f7b9cfcf2fb5f418ec9bbfc2203dff7'
  code: decompiled
  code_url: code/0x3bd98d9e987698eb3bb3930b8763ad4c331a9d58ed5c67e3ae1cf24d71968675.sol
  copies: 1
  upgradeable: 'no'
  admin: '0x3bf77324ec75c24107077d90275ddaa14efc866f'
value:
  usd: 28146
  basis: held
activity:
  txs_90d: 1629
impact: funds-loss
action: Redeploy with a post-quantum verifier (ERC-7913 with an ML-DSA or hash-based key), or keep balances near
  zero.
evidence_level: bytecode
checks:
- id: b1
  bytecode: '0xff68a48e8f7b9cfcf2fb5f418ec9bbfc2203dff7'
  has: 60015afa
  says: The runtime code calls the ecrecover precompile.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: sel-setverifier
  selector: '0xff68a48e8f7b9cfcf2fb5f418ec9bbfc2203dff7'
  fn: setVerifier(address)
  says: setVerifier(address) selector is present.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: sel-swapenabled
  selector: '0xff68a48e8f7b9cfcf2fb5f418ec9bbfc2203dff7'
  fn: swapEnabled()
  says: swapEnabled() selector is present.
  for:
  - evidence-3
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

This unverified contract holds tokens and swaps them on Uniswap when a caller submits swap parameters signed by its verifier key, checked with ECDSA. A quantum attacker who recovers the verifier key can order swaps of the contract's funds on the attacker's terms.

## Evidence

- The [runtime code](https://etherscan.io/address/0xff68a48e8f7b9cfcf2fb5f418ec9bbfc2203dff7#code) calls the ecrecover precompile to check swap signatures.
- [setVerifier](https://etherscan.io/address/0xff68a48e8f7b9cfcf2fb5f418ec9bbfc2203dff7#code) lets the owner replace the verifier address but keeps the ECDSA check.
- [swapEnabled](https://etherscan.io/address/0xff68a48e8f7b9cfcf2fb5f418ec9bbfc2203dff7#code) gates the signed swap entry.

## Reviewer notes

### Mechanism

Unverified bytecode. Kev's trace shows that the signed swap entry 0xa28c0efa(router, amountOut, amountInMax, path[], to, deadline, signature) does the following. It checks the deadline and swapEnabled, then hashes the parameters and calls ecrecover (precompile 0x01, bytes at offset 8313). It compares the recovered address with verifier(). It then calls UniswapV2Router02.swapTokensForExactTokens, spending the contract's own token balance. setVerifier(address) is owner-only and only stores a new address. The classifier found no ERC-1271 path. Withdrawals go through owner-configured setWithdrawRecipient and a whitelist (0x0c9708cb, 0x6209b13d). Whether `to` is bound in the signed digest is not established.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No ERC-1271 contract-signature path found in the bytecode.
- Ruled out: Rotating the key with setVerifier does not change the signature scheme.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
