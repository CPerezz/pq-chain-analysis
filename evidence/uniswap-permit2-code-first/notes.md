# Review reads: uniswap-permit2-code-first (2026-11-17, Review07)

## Source (Sourcify, both addresses)

`SignatureVerification.verify(signature, hash, claimedSigner)` (lines 21–46, identical in
`0x000000000022d473030f116ddee9f6b43ac78ba3` `src/libraries/SignatureVerification.sol` and
`0x31c2f6fcff4f8759b3bd5bf0e1084a055615c768` `contracts/libraries/SignatureVerification.sol`, solc 0.8.17):

```solidity
   26          if (claimedSigner.code.length == 0) {
   27              if (signature.length == 65) { ... } else if (signature.length == 64) { ... EIP-2098 ... }
   39              address signer = ecrecover(hash, v, r, s);
   41              if (signer != claimedSigner) revert InvalidSigner();
   42          } else {
   43              bytes4 magicValue = IERC1271(claimedSigner).isValidSignature(hash, signature);
   44              if (magicValue != IERC1271.isValidSignature.selector) revert InvalidContractSignature();
```

The ERC-1271 branch forwards the full `bytes signature`, so post-quantum smart accounts (and EIP-7702 accounts,
which have code) are verified by their own code; `ecrecover` is reached only for addresses without code.

## On-chain and explorer reads

- `onchain.json` (block 26,431,214): both contracts are not proxies (code 9,152 and 7,020 bytes), no owner.
- Blockscout: both deployed through the CREATE2 factory `0x4e59b448…956c`; canonical by
  tx `0xf2f1fe96…d377`; `0x31c2f6fc…` on 2023-09-27 by `0xa4c0028748d8f534e6d7bab20d9b696f750f114d` (deployer not
  identified; Uniswap's code, not Uniswap's canonical address).
- Yearly pre-quantum use (`data/report/curated_contracts.csv`): canonical 3,840,821 `ecrecover` transactions;
  `0x31c2f6fc…` 41,477.
