---
id: ammwrapperwithpath-4a143470-order-sig-ecdsa-first
format: 2
title: Tokenlon AMMWrapperWithPath accepts ECDSA swaps quantum attackers can forge
status: confirmed
severity: MEDIUM
justification: Signer-chosen ECDSA path survives key migration; immutable, but Tokenlon's multisig can replace and
  deauthorize it.
category: quantum-exposure
pattern: PQ-2
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4a14347083b80e5216ca31350a2d21702ac3650d'
  name: AMMWrapperWithPath
  project: tokenlon
  code: verified
  code_url: https://etherscan.io/address/0x4a14347083b80e5216ca31350a2d21702ac3650d#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 72166
  basis: held
activity:
  txs_90d: 19373
impact: funds-loss
action: Deploy a strategy that uses ERC-1271 for addresses with code, repoint UserProxy to it and deauthorize this
  one in Spender.
evidence_level: source
checks:
- id: c1
  source: '0x4a14347083b80e5216ca31350a2d21702ac3650d'
  file: contracts/utils/SignatureValidator.sol
  line: 123
  has: recovered = ecrecover(_hash, v, r, s);
  says: EIP712 type recovers the signer with ecrecover.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c2
  source: '0x4a14347083b80e5216ca31350a2d21702ac3650d'
  file: contracts/utils/SignatureValidator.sol
  line: 137
  has: recovered = ecrecover(
  says: EthSign type recovers the signer with ecrecover.
  for:
  - evidence-3
  - justification
  - what
- id: code
  code: '0x4a14347083b80e5216ca31350a2d21702ac3650d'
  is: contract
  bytes: 19897
  says: The address holds contract code.
  for:
  - what
- id: sel-type
  source: '0x4a14347083b80e5216ca31350a2d21702ac3650d'
  file: contracts/utils/SignatureValidator.sol
  has: uint8 signatureTypeRaw = uint8(_sig.popLastByte());
  line: 88
  says: The signature type is read from the signature's last byte.
  for:
  - action
  - evidence-1
  - justification
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review02 (registry review)
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

It runs signed user swaps that pull the user's approved tokens. The signature's last byte picks the scheme, so ECDSA passes even if the user address has code. A quantum attacker with a user's key signs a swap of those tokens to himself.

## Evidence

- [isValidSignature](https://etherscan.io/address/0x4a14347083b80e5216ca31350a2d21702ac3650d#code) takes the signature type from the last byte the signer supplies.
- [EIP712 branch](https://etherscan.io/address/0x4a14347083b80e5216ca31350a2d21702ac3650d#code) accepts the order if ecrecover returns the user address.
- [EthSign branch](https://etherscan.io/address/0x4a14347083b80e5216ca31350a2d21702ac3650d#code) also accepts a recovered ECDSA signer.

## Reviewer notes

### Mechanism

UserProxy.toAMM(payload) forwards to AMMWrapperWithPath.trade (onlyUserProxy). _verify builds the EIP-712 order digest (including receiverAddr) and calls isValidSignature(order.userAddr, digest, "", sig). SignatureValidator.isValidSignature (lines 67-174) pops the last byte as SignatureType (line 88); EIP712 (line 123) and EthSign (line 137) call ecrecover and compare with the signer address, without checking whether the address has code. WalletBytes/WalletBytes32/Wallet use ERC-1271, but the attacker chooses the type. _prepare then calls spender.spendFromUser(order.userAddr, ...) and _settle pays receiverAddr, so a forged ECDSA signature moves the user's approved tokens to an attacker-chosen receiver.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract is not a proxy; the signature check cannot be changed in place.
- Ruled out: Contract's own balance is not what a forged signature releases.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
