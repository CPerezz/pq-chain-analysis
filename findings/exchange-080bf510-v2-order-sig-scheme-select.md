---
id: exchange-080bf510-v2-order-sig-scheme-select
format: 2
title: 0x v2.1 Exchange accepts ECDSA order signatures a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged maker/taker ECDSA signatures spend proxy approvals; MEDIUM as 0x's governor can de-authorise
  this Exchange.
category: quantum-exposure
pattern: PQ-2
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x080bf510fcbf18b91105470639e9561022937712'
  name: Exchange
  project: 0x
  code: verified
  code_url: https://etherscan.io/address/0x080bf510fcbf18b91105470639e9561022937712#code
  copies: 1
  admin: '0x7d3455421bbc5ed534a83c88fd80387dc8271392'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 8151
impact: funds-loss
action: De-authorise this Exchange on the four 0x v2 asset proxies through ZeroExGovernor; tell users to revoke
  proxy approvals.
evidence_level: source
checks:
- id: c1
  source: '0x080bf510fcbf18b91105470639e9561022937712'
  file: Exchange.sol
  line: 2581
  has: recovered = ecrecover(
  says: EIP712 branch recovers the signer with ecrecover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x080bf510fcbf18b91105470639e9561022937712'
  file: Exchange.sol
  line: 2599
  has: recovered = ecrecover(
  says: EthSign branch recovers the signer with ecrecover.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: eip712-eq
  source: '0x080bf510fcbf18b91105470639e9561022937712'
  file: Exchange.sol
  has: isValid = signerAddress == recovered;
  line: 2587
  says: EIP712 branch accepts when the recovered address equals the signer.
  for:
  - evidence-1
  - what
- id: ethsign-eq
  source: '0x080bf510fcbf18b91105470639e9561022937712'
  file: Exchange.sol
  has: isValid = signerAddress == recovered;
  line: 2608
  says: EthSign branch accepts when the recovered address equals the signer.
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
  who: Review08 (verified source and on-chain reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (the study family's recovery functions read, a real transaction replayed four ways; not reviewed by
    a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: confirmed
  rating: ''
reviews: []
related: []
---

## What happens

The 0x v2.1 Exchange fills orders and runs 0x transactions for signers, accepting EIP712 or EthSign signatures when ecrecover returns the signer address. A quantum attacker who recovers a signer's key can sign orders for it and spend its token approvals to the 0x v2 asset proxies.

## Evidence

- [isValidSignature](https://etherscan.io/address/0x080bf510fcbf18b91105470639e9561022937712#code) treats an EIP712 signature as valid when ecrecover returns the signer address.
- [isValidSignature](https://etherscan.io/address/0x080bf510fcbf18b91105470639e9561022937712#code) does the same for EthSign signatures over the prefixed hash.

## Reviewer notes

### Mechanism

isValidSignature(bytes32 hash, address signerAddress, bytes signature) reads the last byte as SignatureType. For EIP712 (lines 2573-2588) it requires 65 bytes, runs ecrecover(hash, v, r, s) at line 2581 and returns signerAddress == recovered (line 2587). For EthSign (lines 2591-2609) it does the same over the eth_sign-prefixed hash (line 2599, result at 2608). No check on whether signerAddress has code precedes these branches, so an address that moved to Wallet, Validator or PreSigned authorisation is still accepted with an ECDSA signature. fillOrder validates the maker signature on the first fill and executeTransaction runs Exchange functions for the signer; tokens then move via the asset proxies' transferFrom on users' approvals. The Exchange is not upgradeable; the asset proxies' owner (ZeroExGovernor, 2 of 4) can remove it from their authorised addresses.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The Exchange itself holds no funds; the exposure is user approvals to the asset proxies.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
