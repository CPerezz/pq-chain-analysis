---
id: hashflowpool-4c4c3e00-pool-quote-signer
format: 2
title: Hashflow pool accepts ECDSA-signed quotes that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Quotes are trusted on one ECDSA key that operations can only swap for another; Hashflow must ship
  a new pool.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4c4c3e005c6cb9ce249a267f28299293a628cf38'
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
  txs_90d: 492
impact: funds-loss
action: Ship a pool implementation that verifies quotes with a post-quantum signature and move liquidity and approvals
  to it.
evidence_level: source
checks:
- id: c1
  source: '0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1'
  file: contracts/pools/HashflowPool.sol
  line: 131
  has: quoteHash.recover(quote.signature) == signerConfig.signer,
  says: tradeRFQT requires the quote signature to ECDSA-recover to the signer.
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
  says: tradeRFQM requires the maker signature to ECDSA-recover to the signer.
  for:
  - what
- id: c6
  source: '0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: Recovery uses the ecrecover precompile (secp256k1).
  for:
  - what
- id: c7
  source: '0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1'
  file: contracts/pools/HashflowPool.sol
  line: 423
  has: function updateSigner(address newSigner)
  says: updateSigner sets a new signer address, keeping the ECDSA scheme.
  for:
  - action
  - evidence-3
  - justification
- id: ext
  source: '0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1'
  file: contracts/pools/HashflowPool.sol
  has: _transferFromExternalAccount(
  line: 156
  says: tradeRFQT pays the trader from the quote's external account.
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

This Hashflow pool pays out RFQ trades from itself or an approved external account when the quote recovers to its signer. A quantum attacker who recovers the signer key signs quotes that send approved tokens to themselves.

## Evidence

- [tradeRFQT](https://etherscan.io/address/0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1#code) accepts a quote only if ECDSA recovers the configured signer.
- [tradeRFQT](https://etherscan.io/address/0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1#code) pays from the quote's external account when one is named.
- [updateSigner](https://etherscan.io/address/0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1#code) only replaces the signer address.

## Reviewer notes

### Mechanism

tradeRFQT (lines 112-163), tradeRFQM (166-204), tradeXChainRFQT (207-251) and tradeXChainRFQM (282-309) are authorizedRouter and require quoteHash.recover(signature) == signerConfig.signer (lines 131, 176, 229, 295), using OpenZeppelin ECDSA tryRecover, which calls ecrecover (ECDSA.sol line 139). tradeRFQT and tradeRFQM then pay quoteTokenAmount via _transferFromPool or, if quote.externalAccount is set, _transferFromExternalAccount (lines 153-162, 190-203), so amounts and paying account are whatever the signer signed. isValidSignature (line 348) also accepts any signature recovering to the signer. updateSigner (lines 423-436, authorizedOperations) only replaces the address ecrecover must return; killswitchOperations (439-449) is router-only.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The pool itself holds no tokens; exposure is the external account's approvals.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
