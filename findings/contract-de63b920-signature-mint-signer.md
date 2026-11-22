---
id: contract-de63b920-signature-mint-signer
format: 2
title: Node Runner Glyphs mints for ECDSA vouchers a quantum attacker could forge
status: confirmed
severity: LOW
justification: A recovered minter key signs free unlimited mints; the admin can revoke ECDSA minters and mint via
  mintTo, so LOW.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xde63b92033aa77b115db1cec612029625d1c8fa5'
  project: thirdweb
  code: bytecode
  code_url: https://etherscan.io/address/0xde63b92033aa77b115db1cec612029625d1c8fa5#code
  copies: 1
  admin: '0x60750ef4c25ec9cc4567807fe927a2b16d259f9f'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 30
impact: funds-loss
action: Revoke MINTER_ROLE from the ECDSA signers and mint with mintTo from a post-quantum account.
evidence_level: source
checks:
- id: c1
  source: '0x4cb2e48b5235c0d1fd7ad1e3f7d7ff829c5b9392'
  file: contracts/prebuilts/token/TokenERC1155.sol
  line: 401
  has: return _hashTypedDataV4(keccak256(_encodeRequest(_req))).recover(_signature);
  says: The voucher signer is recovered with ECDSA over the EIP-712 hash.
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
  says: Recovery uses the ecrecover precompile.
  for:
  - evidence-1
  - justification
  - what
- id: l431
  source: '0x4cb2e48b5235c0d1fd7ad1e3f7d7ff829c5b9392'
  file: contracts/prebuilts/token/TokenERC1155.sol
  has: require(success, "invalid signature");
  line: 431
  says: Voucher accepted only if the signature check succeeds.
  for:
  - evidence-2
  - justification
  - what
- id: l438
  source: '0x4cb2e48b5235c0d1fd7ad1e3f7d7ff829c5b9392'
  file: contracts/prebuilts/token/TokenERC1155.sol
  has: require(_req.quantity > 0, "zero quantity");
  line: 438
  says: Quantity only needs to be non-zero.
  for:
  - evidence-2
- id: l418
  source: '0x4cb2e48b5235c0d1fd7ad1e3f7d7ff829c5b9392'
  file: contracts/prebuilts/token/TokenERC1155.sol
  has: _req.quantity,
  line: 418
  says: Quantity is part of the signed voucher.
  for:
  - evidence-3
  - what
- id: l394
  source: '0x4cb2e48b5235c0d1fd7ad1e3f7d7ff829c5b9392'
  file: contracts/prebuilts/token/TokenERC1155.sol
  has: _mint(_to, _tokenId, _amount, "");
  line: 394
  says: _mintTo mints the requested amount to the recipient.
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
  who: review (Review12)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This collection mints tokens to anyone holding a mint voucher whose signer ECDSA recovery ties to a minter address. A quantum attacker who recovers a minter's key can sign vouchers with any quantity and price and mint new tokens, diluting holders.

## Evidence

- [recoverAddress](https://etherscan.io/address/0x4cb2e48b5235c0d1fd7ad1e3f7d7ff829c5b9392#code) recovers the voucher signer with ECDSA over the EIP-712 hash.
- [verifyRequest](https://etherscan.io/address/0x4cb2e48b5235c0d1fd7ad1e3f7d7ff829c5b9392#code) rejects a voucher only on a failed signature check, expiry, zero recipient or zero quantity.
- The signed quantity and price are fields of the [voucher hash](https://etherscan.io/address/0x4cb2e48b5235c0d1fd7ad1e3f7d7ff829c5b9392#code), so the signer chooses both.

## Reviewer notes

### Mechanism

mintWithSignature(req, signature) calls verifyRequest (line 429), which calls verify; verify uses recoverAddress (line 401): _hashTypedDataV4(keccak256(_encodeRequest(req))).recover(signature), i.e. OZ ECDSAUpgradeable.tryRecover -> ecrecover (line 139), and requires the signer to hold MINTER_ROLE. verifyRequest then checks validity window, recipient, quantity>0 and marks the uid used (lines 431-440). The mint calls _mintTo (lines 389-397) for req.quantity, and collects req.pricePerToken in req.currency, both signer-chosen (lines 418-420). Per kev's review, MINTER_ROLE is held by the admin 0x60750ef4 and a minter EOA 0xa845193f shared with another collection; mintTo is onlyRole(MINTER_ROLE) on _msgSender() with no signature, the path a post-quantum minter can use. The clone is a fixed minimal proxy, so only roles can change.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract holds no pooled funds to drain.
- Ruled out: No upgrade path: the clone points at a fixed implementation.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
