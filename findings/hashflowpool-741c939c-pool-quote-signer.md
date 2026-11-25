---
id: hashflowpool-741c939c-pool-quote-signer
format: 2
title: Hashflow pool pays out market makers' funds on quantum-forgeable ECDSA quotes
status: confirmed
severity: MEDIUM
justification: Signer rotates only to another ECDSA key, so Hashflow must ship a new pool implementation; MEDIUM.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x741c939c644576433ca03c368ade3352e3252b35'
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
  txs_90d: 54280
impact: funds-loss
action: Ship a pool implementation that verifies quotes with a post-quantum signature, and move liquidity and approvals
  to it.
evidence_level: source
checks:
- id: c1
  source: '0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1'
  file: contracts/pools/HashflowPool.sol
  line: 131
  has: quoteHash.recover(quote.signature) == signerConfig.signer,
  says: tradeRFQT accepts a quote only if ECDSA recovers the signer.
  for:
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1'
  file: contracts/pools/HashflowPool.sol
  line: 176
  has: quoteHash.recover(quote.makerSignature) == signerConfig.signer,
  says: tradeRFQM accepts a quote only if ECDSA recovers the signer.
  for:
  - what
- id: c6
  source: '0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: Recovery uses ecrecover (secp256k1 ECDSA).
  for:
  - what
- id: c7
  source: '0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1'
  file: contracts/pools/HashflowPool.sol
  line: 423
  has: function updateSigner(address newSigner)
  says: updateSigner exists to set a new signer address.
  for:
  - action
  - evidence-3
  - justification
- id: new-ext
  source: '0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1'
  file: contracts/pools/HashflowPool.sol
  has: _transferFromExternalAccount(
  line: 156
  says: tradeRFQT pays the trader from the quote's external account.
  for:
  - evidence-2
  - what
- id: new-swap
  source: '0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1'
  file: contracts/pools/HashflowPool.sol
  has: signerConfig.signer = newSigner;
  line: 434
  says: updateSigner only replaces the signer address.
  for:
  - action
  - evidence-3
  - justification
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

This Hashflow pool pays out quote tokens to traders on RFQ quotes, accepting a quote only if ECDSA recovers the pool's signer address. A quantum attacker who derives the signer key from its public signatures can sign quotes that send approved tokens from the quoted external account to themselves.

## Evidence

- [tradeRFQT](https://etherscan.io/address/0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1#code) requires the quote signature to recover to the configured signer.
- [tradeRFQT](https://etherscan.io/address/0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1#code) pays from the quote's external account when one is set.
- [updateSigner](https://etherscan.io/address/0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1#code) only swaps the address that ECDSA recovery must match.

## Reviewer notes

### Mechanism

tradeRFQT (line 131), tradeRFQM (176), tradeXChainRFQT (229) and tradeXChainRFQM (295) are authorizedRouter and require quoteHash.recover(signature) == signerConfig.signer, using OpenZeppelin ECDSA (ecrecover, ECDSA.sol line 139). tradeRFQT/tradeRFQM then pay quoteTokenAmount to quote.trader via _transferFromPool or, if quote.externalAccount != 0, _transferFromExternalAccount (lines 153-162, 190-203), spending approvals the external account gave the pool. isValidSignature (line 348) also accepts any signature recovering to the signer. updateSigner (423-436, authorizedOperations) only replaces the signer address (line 434); the clone's logic is fixed, so the scheme cannot change. killswitchOperations (439-449) is router-only and can disable the pool.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The pool itself holds about $0; exposure for this pool is via its signer/operations EOA's approvals.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
