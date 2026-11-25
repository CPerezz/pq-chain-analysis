---
id: hashflowpool-478eca1b-pool-quote-signer
format: 2
title: Hashflow Kipseli pool pays out on quotes a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Signer rotates only to another ECDSA key; Hashflow must ship a new pool implementation and the maker
  must move.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x478eca1b93865dca0b9f325935eb123c8a4af011'
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
  txs_90d: 9791
impact: funds-loss
action: Deploy a pool implementation that verifies quotes with a post-quantum signature, then move liquidity and
  approvals to it.
evidence_level: source
checks:
- id: c1
  source: '0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1'
  file: contracts/pools/HashflowPool.sol
  line: 131
  has: quoteHash.recover(quote.signature) == signerConfig.signer,
  says: tradeRFQT requires ECDSA recovery to the configured signer.
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
  says: tradeRFQM requires ECDSA recovery to the configured signer.
  for:
  - what
- id: c6
  source: '0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: Recovery uses ecrecover (secp256k1).
  for:
  - what
- id: c7
  source: '0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1'
  file: contracts/pools/HashflowPool.sol
  line: 423
  has: function updateSigner(address newSigner)
  says: updateSigner sets a new signer address.
  for:
  - action
  - evidence-3
  - justification
- id: ext
  source: '0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1'
  file: contracts/pools/HashflowPool.sol
  has: _transferFromExternalAccount(
  line: 156
  says: tradeRFQT pays from the quote's external account.
  for:
  - evidence-2
  - what
- id: upd
  source: '0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1'
  file: contracts/pools/HashflowPool.sol
  has: signerConfig.signer = newSigner;
  line: 434
  says: updateSigner only replaces the signer address.
  for:
  - evidence-3
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

This pool pays out RFQ trades when the quote's ECDSA signature recovers to the configured signer. A quantum attacker who derives the signer key from its public signatures can sign quotes that send the pool's or an approving external account's tokens to themselves.

## Evidence

- [tradeRFQT](https://etherscan.io/address/0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1#code) requires the quote signature to recover to the configured signer.
- [tradeRFQT](https://etherscan.io/address/0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1#code) pays from the quote's external account when one is named.
- [updateSigner](https://etherscan.io/address/0xca310b1b942a30ff4b40a5e1b69ab4607ec79bc1#code) only swaps the signer address that ecrecover must return.

## Reviewer notes

### Mechanism

The router (authorizedRouter) calls tradeRFQT (line 131), tradeRFQM (176), tradeXChainRFQT (229) or tradeXChainRFQM (295). Each requires quoteHash.recover(signature) == signerConfig.signer, which is OpenZeppelin ECDSA built on ecrecover (ECDSA.sol line 139). tradeRFQT and tradeRFQM then pay quoteTokenAmount to quote.trader through _transferFromPool or, when quote.externalAccount is set, _transferFromExternalAccount (lines 153-161, 190-202). The amounts, the trader and the external account are all fields the signer signs. isValidSignature (line 348) accepts the same signer for ERC-1271. updateSigner (lines 423-436, operations only) only replaces the signer address. killswitchOperations (439-449) is router-only.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The pool itself holds no tokens; exposure is the external account's approvals.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
