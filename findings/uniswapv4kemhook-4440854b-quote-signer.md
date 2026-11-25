---
id: uniswapv4kemhook-4440854b-quote-signer
format: 2
title: KyberSwap KEM hook trusts an ECDSA quote signer a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: A recovered quote-signer key lets swaps skip the LP surplus cap; the owner can switch to a post-quantum
  contract signer.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4440854b2d02c57a0dc5c58b7a884562d875c0c4'
  name: UniswapV4KEMHook
  project: kyberswap
  code: verified
  code_url: https://etherscan.io/address/0x4440854b2d02c57a0dc5c58b7a884562d875c0c4#code
  copies: 1
  upgradeable: 'no'
  admin: '0xbe2f0354d970265bfc36d383af77f72736b81b54'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 13930
impact: funds-loss
action: Call updateQuoteSigner with a contract signer that verifies a post-quantum signature through ERC-1271.
evidence_level: source
checks:
- id: c2
  source: '0x4440854b2d02c57a0dc5c58b7a884562d875c0c4'
  file: src/UniswapV4KEMHook.sol
  line: 131
  has: SignatureChecker.isValidSignatureNow(quoteSigner, digest, signature), InvalidSignature()
  says: beforeSwap requires a valid quoteSigner signature over the quote digest.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c3
  source: '0x4440854b2d02c57a0dc5c58b7a884562d875c0c4'
  file: lib/v4-periphery/lib/v4-core/lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 142
  has: address signer = ecrecover(hash, v, r, s);
  says: ECDSA.tryRecover uses ecrecover.
  for:
  - evidence-2
  - what
- id: c4
  source: '0x4440854b2d02c57a0dc5c58b7a884562d875c0c4'
  file: lib/v4-periphery/lib/v4-core/lib/openzeppelin-contracts/contracts/utils/cryptography/SignatureChecker.sol
  line: 22
  has: function isValidSignatureNow(address signer, bytes32 hash, bytes memory signature) internal view returns
    (bool) {
  says: SignatureChecker.isValidSignatureNow is the verifier, which also supports ERC-1271 signers.
  for:
  - action
- id: c5
  source: '0x4440854b2d02c57a0dc5c58b7a884562d875c0c4'
  file: lib/v4-periphery/lib/v4-core/lib/openzeppelin-contracts/contracts/utils/cryptography/SignatureChecker.sol
  line: 23
  has: (address recovered, ECDSA.RecoverError error, ) = ECDSA.tryRecover(hash, signature);
  says: SignatureChecker first tries ECDSA recovery.
  for:
  - evidence-2
  - justification
  - what
- id: c6
  source: '0x4440854b2d02c57a0dc5c58b7a884562d875c0c4'
  file: lib/v4-periphery/lib/v4-core/lib/openzeppelin-contracts/contracts/utils/cryptography/SignatureChecker.sol
  line: 25
  has: (error == ECDSA.RecoverError.NoError && recovered == signer) ||
  says: An ECDSA signature recovering to the signer is accepted.
  for:
  - evidence-2
  - justification
  - what
- id: s-maxout
  source: '0x4440854b2d02c57a0dc5c58b7a884562d875c0c4'
  file: src/UniswapV4KEMHook.sol
  has: int256 maxAmountOut = amountIn * maxExchangeRate / exchangeRateDenom;
  line: 162
  says: afterSwap caps output using the quote's signed exchange rate.
  for:
  - evidence-3
  - what
- id: s-eg
  source: '0x4440854b2d02c57a0dc5c58b7a884562d875c0c4'
  file: src/UniswapV4KEMHook.sol
  has: 'int256 egAmount = maxAmountOut < amountOut ? amountOut - maxAmountOut : int256(0);'
  line: 165
  says: Output above the cap is taken as surplus by the hook for LPs.
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
  who: Review13 (re-read KEM hook source on Sourcify; signer, owner and admin reads; executor call path)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

The hook lets a swap through its Uniswap v4 pools only with a quote signed by the quoteSigner key, checked with ECDSA recovery. The quote caps the exchange rate and the hook keeps output above the cap; a quantum attacker who forges quotes sets an unlimited rate and keeps that surplus.

## Evidence

- [beforeSwap](https://etherscan.io/address/0x4440854b2d02c57a0dc5c58b7a884562d875c0c4#code) requires SignatureChecker.isValidSignatureNow(quoteSigner, digest, signature).
- [SignatureChecker](https://etherscan.io/address/0x4440854b2d02c57a0dc5c58b7a884562d875c0c4#code) first accepts a signature if ECDSA recovery returns the signer.
- [afterSwap](https://etherscan.io/address/0x4440854b2d02c57a0dc5c58b7a884562d875c0c4#code) caps output at amountIn * maxExchangeRate / exchangeRateDenom, a rate taken from the signed quote.

## Reviewer notes

### Mechanism

beforeSwap (lines 93-135, onlyPoolManager) decodes maxAmountIn, maxExchangeRate, exchangeRateDenom, nonce, expiryTime and signature from hookData, checks expiry, amount and nonce, hashes them with sender and pool key, and requires SignatureChecker.isValidSignatureNow(quoteSigner, digest, signature) (lines 130-132). OpenZeppelin SignatureChecker tries ECDSA.tryRecover first (ecrecover, ECDSA.sol line 142) and accepts if the recovered address equals quoteSigner, an EOA per kev's reads. afterSwap (lines 137-176) computes maxAmountOut = amountIn * maxExchangeRate / exchangeRateDenom (line 162) and mints any excess output to the hook (lines 165-169), later sent to egRecipient by claimEgTokens. A quantum attacker who recovers the signer key from its on-chain signatures signs quotes with a huge maxExchangeRate, so egAmount is zero and they keep the stale-price arbitrage the hook exists to capture for LPs. Loss is bounded by price moves along the pool curve, not the pools' full liquidity. quoteSigner is changed by the owner via updateQuoteSigner (BaseKEMHook).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Pool liquidity is not released directly; the attacker still trades along the curve.
- Ruled out: The hook holds no funds itself.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
