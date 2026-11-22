---
id: contract-5cf33bab-signer-key
format: 2
title: Market maker's quotes rest on an ECDSA key a quantum attacker could recover
status: candidate
severity: MEDIUM
justification: Forged quotes sell the maker's inventory; admin can only swap ECDSA keys, so the maker must deploy
  a new validator.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5cf33bab94f5daeabf04a7636856c951ed78ac07'
  code: decompiled
  code_url: code/0xc34341be7e9175274dfb230884ebc0d9a1e284b934ed91dfe67ec6029bd67f7d.sol
  copies: 1
  upgradeable: 'no'
  admin: '0x143395428158a57d17bcd8899770460656de98e4'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a validator that verifies quotes with a post-quantum signature and register it for the maker in place
  of this one.
evidence_level: bytecode
checks:
- id: sel-isvalid
  selector: '0x5cf33bab94f5daeabf04a7636856c951ed78ac07'
  fn: isValidSignature(bytes32,bytes)
  says: ERC-1271 isValidSignature selector is in the code
  for:
  - action
  - evidence-1
  - justification
  - what
- id: sel-setsigner
  selector: '0x5cf33bab94f5daeabf04a7636856c951ed78ac07'
  fn: setSigner(address)
  says: setSigner selector is in the code
  for:
  - action
  - evidence-2
  - justification
- id: sel-signer
  selector: '0x5cf33bab94f5daeabf04a7636856c951ed78ac07'
  fn: SIGNER()
  says: SIGNER getter selector is in the code
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
reviews: []
related: []
---

## What happens

This validator answers isValidSignature for a market maker's quotes and approves a quote when ECDSA recovers its stored signer key. A quantum attacker who recovers that key can sign quotes at any price and sell the maker's inventory.

## Evidence

- [isValidSignature](https://etherscan.io/address/0x5cf33bab94f5daeabf04a7636856c951ed78ac07#code) is in the bytecode and checks quotes against the stored signer.
- [setSigner](https://etherscan.io/address/0x5cf33bab94f5daeabf04a7636856c951ed78ac07#code) lets the admin replace the signer address, which is another ECDSA key.
- [SIGNER](https://etherscan.io/address/0x5cf33bab94f5daeabf04a7636856c951ed78ac07#code) exposes the stored signer key address.

## Reviewer notes

### Mechanism

Unverified bytecode. The decompiled isValidSignature (0x1626ba7e) parses the signature bytes and requires SIGNER != 0. It checks maxGasPrice against tx.gasprice and a fee factor below 10000. It then calls ecrecover on keccak256 of the quote data and requires the result to equal the stored SIGNER ("INVALID_MMP_SIGNATURE") before returning the ERC-1271 magic value. Tokenlon's PMM settles maker quotes through a 0x-style Exchange that calls this validator. setSigner (admin-only) only replaces the ECDSA address. Operators can only move minNonce (0xea5cc585) and set maxGasPrice.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Takers are not exposed: they sign their own orders.
- Ruled out: Not upgradeable; only the signer address is settable.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
