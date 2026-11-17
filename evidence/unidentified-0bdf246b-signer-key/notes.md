# Review notes: unidentified-0bdf246b-signer-key (2026-11-17)

Reads with `cast` against https://ethereum-rpc.publicnode.com at block 26,431,557; source from Blockscout (verified,
Solidity 0.8.17, `src/PmmProtocol.sol`, `src/libraries/ECDSA.sol`).

## Code path

- `fillOrderRFQ…` (PmmProtocol.sol lines 112–128 and 171–182): if the taker sets `_SIGNER_SMART_CONTRACT_HINT` in
  `flagsAndAmount`, the maker signature goes to ERC-1271 only (`ECDSA.isValidSignature`; the `(r, vs)` entry forwards 64
  bytes, the `bytes signature` entry forwards the full signature); otherwise `ECDSA.recoverOrIsValidSignature`
  (ECDSA.sol lines 99–133) tries `ecrecover` first and falls back to ERC-1271. The flag is chosen by the caller.
- Maker funds move in `_fillOrderRFQTo`: with `usePermit2`, by `Permit2.permitWitnessTransferFrom` /
  `permitTransferFrom` with the maker's `permit2Signature` (lines 268–290), which Permit2 verifies itself (ERC-1271 for
  makers with code); otherwise by a Permit2 allowance transfer (line 293).
- No owner, no proxy, no admin functions (`onchain.json`: owner null, kind none).

## Makers and allowances

- Blockscout logs, latest 50 `OrderFilledRFQ` events (blocks 24,768,478–24,777,223): every fill has maker
  `0xb7131fc8cdc43060a6210257f537dba5fcae6aed` and `usePermit2 = true`.
- `0xb7131fc8…` is a Safe 1.4.1 (`getThreshold()` = 1, owners `0x388364512b2603eb2588ea12eda201423d5f7ffe`,
  `0x6e64095a0170b8c1721694b49fb58c974a4c45f0`), holding about $2.36M (Blockscout, WETH $321k, XAUT $206k, PENDLE $164k, …).
- Maker allowances to the PMM contract: ERC-20 `allowance(maker, PMM)` = 0 for USDC, WETH, USDT; Permit2
  `allowance(maker, token, PMM)` = 0 for the same three. The maker's unlimited approvals are to Permit2
  (`0x000000000022d473030f116ddee9f6b43ac78ba3`), whose signature transfers check ERC-1271 for the Safe.

## Deployer

- Creator `0xc64715599f5910ae6fd5c3900850c561a44bd413` (EOA, creation tx
  `0x650932e1bffb59b192b30940c7bbf03bceda1321f4abb08f351425e0212a4342`) also created verified `DexRouter` contracts
  `0xc6d05c8efb86b44612d2aec43d14b04635044c2a`, `0x156acd2bc5fc336d59baae602a2bd9b5e20d6672`,
  `0x5b4826f302d3043ab2b907f79c7e2e4e5cbc6aac`, `0x31756c38708c3571b771b00155a7fee9d75e36b2`, whose source has OKX DEX
  router function names (`smartSwapByOrderId`, `unxswapByOrderId`). `0x7d0ccaa3fac1e5a943c5168b6ced828691b46b36`, a
  `DexRouter` commonly listed as OKX DEX's router (listing not checked here), was created by a different address
  (`0xea522fe3a65874ba3cec38e912220282b7c71e97`). Attribution to OKX is plausible but not established.
