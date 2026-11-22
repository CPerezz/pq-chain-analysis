---
id: contract-cf068d28-signature-mint-signer
format: 2
title: Coingecko X Moonbirds mints for ECDSA vouchers a quantum attacker could forge
status: confirmed
severity: LOW
justification: Forged minter vouchers mint unlimited tokens; LOW because the collection admin can revoke ECDSA minters.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xcf068d287b206f20e64e9259f44c4f7130be7297'
  project: thirdweb
  code: bytecode
  code_url: https://etherscan.io/address/0xcf068d287b206f20e64e9259f44c4f7130be7297#code
  copies: 1
  admin: '0x2aa5ebd85ba9fbdc87a774c29cdad806d7892820'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 87
impact: funds-loss
action: Revoke MINTER_ROLE from ECDSA signers, grant it to a post-quantum account and mint with mintTo.
evidence_level: source
checks:
- id: c1
  source: '0x4cb2e48b5235c0d1fd7ad1e3f7d7ff829c5b9392'
  file: contracts/prebuilts/token/TokenERC1155.sol
  line: 401
  has: return _hashTypedDataV4(keccak256(_encodeRequest(_req))).recover(_signature);
  says: recoverAddress recovers the signer of the EIP-712 mint request with ECDSA
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x4cb2e48b5235c0d1fd7ad1e3f7d7ff829c5b9392'
  file: lib/openzeppelin-contracts-upgradeable/contracts/utils/cryptography/ECDSAUpgradeable.sol
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: OZ tryRecover uses the ecrecover precompile
  for:
  - evidence-1
  - justification
  - what
- id: v1
  source: '0x4cb2e48b5235c0d1fd7ad1e3f7d7ff829c5b9392'
  file: contracts/prebuilts/token/TokenERC1155.sol
  has: require(success, "invalid signature");
  line: 431
  says: verifyRequest rejects requests whose signature check fails
  for:
  - evidence-2
  - justification
  - what
- id: e1
  source: '0x4cb2e48b5235c0d1fd7ad1e3f7d7ff829c5b9392'
  file: contracts/prebuilts/token/TokenERC1155.sol
  has: _req.quantity,
  line: 418
  says: The signed request includes the mint quantity
  for:
  - evidence-3
  - what
- id: p1
  source: '0x4cb2e48b5235c0d1fd7ad1e3f7d7ff829c5b9392'
  file: contracts/prebuilts/token/TokenERC1155.sol
  has: _req.pricePerToken,
  line: 419
  says: The signed request includes the price per token
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
  who: review (Review12)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This thirdweb ERC-1155 collection mints tokens for a voucher whose ECDSA signature recovers to a MINTER_ROLE holder. A quantum attacker who recovers a minter key signs vouchers with any quantity and price and mints tokens of this collection.

## Evidence

- [recoverAddress](https://etherscan.io/address/0x4cb2e48b5235c0d1fd7ad1e3f7d7ff829c5b9392#code) recovers the voucher signer with ECDSA over the EIP-712 hash.
- [verifyRequest](https://etherscan.io/address/0x4cb2e48b5235c0d1fd7ad1e3f7d7ff829c5b9392#code) accepts a request once the signature check succeeds.
- [The signed request](https://etherscan.io/address/0x4cb2e48b5235c0d1fd7ad1e3f7d7ff829c5b9392#code) carries the quantity and price set by the signer.

## Reviewer notes

### Mechanism

mintWithSignature calls verifyRequest (line 429), which calls verify; verify uses recoverAddress (line 400-401): _hashTypedDataV4(keccak256(_encodeRequest(req))).recover(signature), OZ ECDSAUpgradeable.tryRecover calling ecrecover (line 139), and requires hasRole(MINTER_ROLE, signer). verifyRequest then checks the validity window, recipient and quantity, and marks uid used (lines 431-440). The request encodes quantity, pricePerToken and currency (lines 418-420), all chosen by the signer, so a forged minter signature mints any quantity at any price. The clone is a fixed minimal proxy; the admin can only change roles, and mintTo lets a MINTER_ROLE caller mint without a signature.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The clone holds no pooled funds.
- Ruled out: The clone cannot be upgraded.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
