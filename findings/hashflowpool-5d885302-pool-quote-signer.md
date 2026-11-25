---
id: hashflowpool-5d885302-pool-quote-signer
format: 2
title: Hashflow kekpoolv5 pool pays out on ECDSA quotes a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Signer can only be rotated to another ECDSA key, so Hashflow must ship a new pool and the maker must
  move to it.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5d8853028fbf6a2da43c7a828cc5f691e9456b44'
  name: HashflowPool
  project: hashflow
  code: verified
  code_url: https://etherscan.io/address/0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1#code
  proxy_of: '0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1'
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a pool that verifies quotes with a post-quantum signature, move liquidity, and revoke approvals to
  this pool.
evidence_level: source
checks:
- id: c1
  source: '0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1'
  file: contracts/pools/HashflowPool.sol
  line: 131
  has: quoteHash.recover(quote.signature) == signerConfig.signer,
  says: tradeRFQT requires the ECDSA-recovered address to equal the signer.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1'
  file: contracts/pools/HashflowPool.sol
  line: 176
  has: quoteHash.recover(quote.makerSignature) == signerConfig.signer,
  says: tradeRFQM requires the ECDSA-recovered address to equal the signer.
  for:
  - evidence-2
  - what
- id: c6
  source: '0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: Recovery uses the ecrecover precompile (secp256k1).
  for:
  - evidence-1
  - what
- id: c7
  source: '0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1'
  file: contracts/pools/HashflowPool.sol
  line: 423
  has: function updateSigner(address newSigner)
  says: updateSigner only replaces the signer address.
  for:
  - action
  - evidence-3
  - justification
- id: x1
  source: '0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1'
  file: contracts/pools/HashflowPool.sol
  has: _transferFromExternalAccount(
  line: 197
  says: tradeRFQM pays from the external account named in the quote.
  for:
  - evidence-2
  - what
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
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This Hashflow pool pays traders from its own balance or an approved external account when a quote carries a valid ECDSA signature from its signer key. A quantum attacker who recovers that key can sign quotes that send approved tokens to themselves.

## Evidence

- [tradeRFQT](https://etherscan.io/address/0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1#code) accepts a quote only if ECDSA recovers the configured signer.
- [tradeRFQM](https://etherscan.io/address/0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1#code) pays the quoted amount from the external account named in the signed quote.
- [updateSigner](https://etherscan.io/address/0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1#code) only swaps the address that ecrecover must return.

## Reviewer notes

### Mechanism

tradeRFQT (line 112, authorizedRouter) hashes the quote and requires quoteHash.recover(quote.signature) == signerConfig.signer (line 131); tradeRFQM (176), tradeXChainRFQT (229) and tradeXChainRFQM (295) do the same. OpenZeppelin ECDSA.tryRecover calls ecrecover (line 139). tradeRFQT/tradeRFQM then pay quoteTokenAmount via _transferFromPool or _transferFromExternalAccount (lines 153-162, 190-203) using the externalAccount and amounts in the signed quote. isValidSignature (line 348) approves ERC-1271 signatures by the same key. updateSigner (423-436, authorizedOperations) only changes the expected address; the clone's logic is fixed. killswitchOperations (439) is router-only. This pool's external account and approvals were not measured.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The pool itself holds no tokens; exposure is via approvals to it, not measured for this pool.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
