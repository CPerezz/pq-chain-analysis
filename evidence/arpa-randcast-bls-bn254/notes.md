# Review reads: arpa-randcast-bls-bn254 (2026-11-17, Review07)

## Source (Sourcify, implementation `0x2b4045c4ad431cefeb93518ed2a87fecc03aeac3`, `Adapter`)

`src/Adapter.sol`:

- `fulfillRandomness(groupIndex, requestId, signature, requestDetail, partialSignatures)` (line 530): checks the
  stored request commitment (lines 539–562), then `_verifySignature(...)` (line 583): `BLS.verifySingle(
  BLS.decompress(signature), g.publicKey, BLS.hashToPoint(actualSeed))` (line 998) for the group's threshold
  signature and `BLS.verifyPartials(partials, pubkeys, message)` (line 1014) for members' partial signatures (BN254
  pairing, `src/libraries/BLS.sol`).
- `randomness = uint256(keccak256(abi.encode(signature)))` (line 587), delivered to the consumer callback (line 593);
  the subscription pays the participating members (lines 595–599).
- `_authorizeUpgrade(address) internal override onlyOwner` (line 187): UUPS, owner-only.

## On-chain reads (`cast`, publicnode, block 26,431,574)

- Proxy `0x4363154e1ec107f81239a4f0b1cb3ab5161129ca`: EIP-1967 implementation slot = `0x2b4045c4…aeac3`.
- `owner()` = `0xfdeede3aa92583a46a419190c3e58d035b1fe060`: no code (EOA), nonce 207; it deployed both the proxy
  and the implementation (Blockscout creator).
- `getRandomnessCount()` = 4 (randomness ever delivered on mainnet).
- ETH balance 0.10019141 ETH (subscription balances), $182.

## Activity (Blockscout `addresses/…/transactions`, 44 transactions, all pages)

- Successful `fulfillRandomness`: 2024-07-31, 2024-08-09, 2025-11-15, 2025-12-23; all for subscription 1, created
  by the owner on 2024-07-31, with consumers `0xa265737e4f76d38c1378049697005081599f3d43` and
  `0x8acfc64bf976488e9b83c517d4185fd4d8a9d683`, both created by the owner. Blockscout 2026-11-17: both hold 0 ETH and
  no ERC-20 tokens.
- 2026-11-14 to 2026-11-16: 11 new `createSubscription` + `fundSubscription` pairs from 11 EOAs; no consumer added
  and no request fulfilled for them yet.
