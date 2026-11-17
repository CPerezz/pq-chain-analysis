# Review notes (Review12, 2026-11-17)

- Both contracts are thirdweb clones (`0x3d3d3d3d363d3d37363d73<impl>5af43d3d93803e602a57fd5bf3`) of implementation
  0x4cb2e48b5235c0d1fd7ad1e3f7d7ff829c5b9392 (`contracts/prebuilts/token/TokenERC1155.sol`, Sourcify); no upgrade path.
- Source: `mintWithSignature` (lines 248–271) → `verifyRequest` (429–444) → `verify` (205–208):
  `recoverAddress` = `_hashTypedDataV4(keccak256(_encodeRequest(req))).recover(signature)` (OZ ECDSA, line 400–401) and
  `hasRole(MINTER_ROLE, signer)`; then `_mintTo(req.to, req.uri, tokenId, req.quantity)` and `collectPrice(req)` (the
  signed price, paid by the caller). `mintTo` (216–233) is `onlyRole(MINTER_ROLE)` on `_msgSender()` (ERC-2771 aware).
- cast (https://eth.drpc.org) at block 26,431,602:

| Clone | name() | owner() | DEFAULT_ADMIN_ROLE | MINTER_ROLE | nextTokenIdToMint |
|---|---|---|---|---|---|
| 0xde63b92033aa77b115db1cec612029625d1c8fa5 | Node Runner Glyphs | 0x60750ef4c25ec9cc4567807fe927a2b16d259f9f | 0x60750ef4… (EIP-7702 EOA, delegate 0x63c0c19a282a1b52b07dd5a65b58948a07dae32b) | 0x60750ef4…, 0xa845193f0a80fc904666ca2fd80ac41a8b247726 (EOA, nonce 146) | 5 |
| 0xcf068d287b206f20e64e9259f44c4f7130be7297 | Coingecko X Moonbirds | 0x2aa5ebd85ba9fbdc87a774c29cdad806d7892820 | 0x2aa5ebd8… (EOA) | 0x2aa5ebd8…, 0xa845193f… (EOA) | 1 |

- The same EOA 0xa845193f… holds MINTER_ROLE on both collections; Blockscout has no name or tag for it.
- Trusted ERC-2771 forwarders were not enumerated.
