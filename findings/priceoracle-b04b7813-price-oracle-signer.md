---
id: priceoracle-b04b7813-price-oracle-signer
format: 2
title: Mimic PriceOracle takes ECDSA-signed prices a quantum attacker can forge
status: confirmed
severity: MEDIUM
justification: Forged prices void vault swap floors; Mimic must deploy a new oracle or remove the signer.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb04b7813bf44fa7bb5c8e8cfc38cd770ffb3ca38'
  name: PriceOracle
  project: mimic
  code: verified
  code_url: https://etherscan.io/address/0xda17f000985b2795b7b6c48384ba877f317e7dc5#code
  proxy_of: '0xda17f000985b2795b7b6c48384ba877f317e7dc5'
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 2665
impact: funds-loss
action: Deploy an oracle verifying post-quantum signatures and repoint vaults, or remove the ECDSA signer after
  setting feeds.
evidence_level: source
checks:
- id: c1
  source: '0xda17f000985b2795b7b6c48384ba877f317e7dc5'
  file: contracts/PriceOracle.sol
  line: 307
  has: (address recovered, ECDSA.RecoverError error) = ECDSA.tryRecover(getPricesDigest(prices), signature);
  says: The price-list signer is recovered with ECDSA tryRecover.
  for:
  - evidence-1
  - what
- id: c2
  source: '0xda17f000985b2795b7b6c48384ba877f317e7dc5'
  file: contracts/PriceOracle.sol
  line: 309
  has: bool isSignerValid = error == ECDSA.RecoverError.NoError && isSignerAllowed(recovered);
  says: The recovered address must be an allowed signer.
  for:
  - evidence-1
  - justification
  - what
- id: c3
  source: '0xda17f000985b2795b7b6c48384ba877f317e7dc5'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 171
  has: address signer = ecrecover(hash, v, r, s);
  says: Recovery uses the ecrecover precompile.
  for:
  - what
- id: c4
  source: '0xda17f000985b2795b7b6c48384ba877f317e7dc5'
  file: contracts/PriceOracle.sol
  line: 193
  has: function setSigner(address signer, bool allowed) external override nonReentrant authP(authParams(signer,
    allowed)) {
  says: setSigner is gated by the Authorizer.
  for:
  - action
  - evidence-3
  - justification
- id: s-return
  source: '0xda17f000985b2795b7b6c48384ba877f317e7dc5'
  file: contracts/PriceOracle.sol
  has: return price.rate;
  line: 181
  says: The signed rate is returned unchanged for a matching pair.
  for:
  - evidence-2
  - what
- id: s-setfeed
  source: '0xda17f000985b2795b7b6c48384ba877f317e7dc5'
  file: contracts/PriceOracle.sol
  has: authP(authParams(base, quote, feed))
  line: 207
  says: setFeed is gated by the Authorizer.
  for:
  - action
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review16 (verified source of PriceOracle and ParaswapV6Swapper; on-chain reads at blocks 26,431,537 and 26,431,656)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This oracle returns any price list signed by an allowed ECDSA signer as the rate for a token pair, ahead of on-chain feeds. A quantum attacker who recovers the signer key can sign near-zero prices that tasks use as their swap floor.

## Evidence

- [_decodePricesData](https://etherscan.io/address/0xda17f000985b2795b7b6c48384ba877f317e7dc5#code) recovers the price-list signer with ECDSA and requires it to be an allowed signer.
- [getPrice](https://etherscan.io/address/0xda17f000985b2795b7b6c48384ba877f317e7dc5#code) returns the signed rate as is when the pair matches and the deadline has not passed.
- [setSigner](https://etherscan.io/address/0xda17f000985b2795b7b6c48384ba877f317e7dc5#code) lets an Authorizer-permitted caller add or remove signers.

## Reviewer notes

### Mechanism

getPrice(base, quote, data) (lines 172-186) calls _decodePricesData (303-312): it decodes (PriceData[], signature), runs ECDSA.tryRecover over getPricesDigest(prices) = toEthSignedMessageHash(keccak256(abi.encode(prices))) (137-139), which ends in ecrecover (ECDSA.sol 171), and reverts unless isSignerAllowed(recovered). If a signed entry matches the pair and its deadline is not past, price.rate is returned unchanged (line 181); only absent or malformed data falls back to getFeed. Per kev, the single allowed signer is also a Mimic Relayer executor, and swap tasks derive minAmountOut from this price, so a recovered key lets an attacker run swaps with a forged floor. setSigner (193) and setFeed (203) are authP via the Authorizer.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The oracle clone itself is not upgradeable; fixes are configuration or a new deployment.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
