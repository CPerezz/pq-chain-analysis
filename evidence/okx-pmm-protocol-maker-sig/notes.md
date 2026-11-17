# Review notes (Review12, 2026-11-17)

- Source: Sourcify `src/PmmProtocol.sol` of 0x2bd541ab3b704f7d4c9dff79efadeaa85ec034f1 (contract `PMMProtocol`, solc
  0.8.17; deployment tx 0xacda054964ef9ea825c54badd4e2790260ebab4d9d9c01abab3e95889d65025f, block 23,395,278, deployer
  0xf7745296976daeeed7b0143e212885af7bca6a10, an EIP-7702 EOA).
  - EIP-712 domain: `_NAME = "OKX Lab PMM Protocol"`, `_VERSION = "1.0"` (lines 49–50).
  - `fillOrderRFQTo` (lines 198–251) and `fillOrderRFQCompact` (110–173): if the caller sets `_SIGNER_SMART_CONTRACT_HINT`
    (bit 254 of `flagsAndAmount`), `ECDSA.isValidSignature` (ERC-1271 with the full signature); otherwise
    `ECDSA.recoverOrIsValidSignature` (`src/libraries/ECDSA.sol` lines 118–131): `ecrecover` first for 64/65-byte
    signatures, ERC-1271 if that fails. `flagsAndAmount` is chosen by the filler (taker), not by the maker.
  - `_fillOrderRFQTo` (253 ff.): `safeTransferFrom(maker → taker)` of `makerAsset` (or through Permit2 if
    `order.usePermit2`), then taker → maker of `takerAsset`.
  - No owner, no proxy, no admin function.
- Blockscout `/api/v2/addresses/<pmm>/logs` (latest page, read 2026-11-17): 50 `OrderFilledRFQ` events in blocks
  26,381,407–26,386,162; makers 0x67336cec42645f55059eff241cb02ea5cc52ff86 (48; EIP-7702 EOA, delegate
  0x63c0c19a282a1b52b07dd5a65b58948a07dae32b, nonce 810) and 0xce79b081c0c924cb67848723ed3057234d10fc6b (2; EOA,
  nonce 38,313).
- cast (https://eth.drpc.org) at block 26,431,692: maker 0x67336cec has max (2^256-1, or close to it) `allowance` to
  PMMProtocol and to Permit2 for USDT, USDC, WETH and cbBTC; maker 0xce79b081 has 0 allowance to PMMProtocol for its two
  largest holdings (TBLLX, SPYX).
- Blockscout tokens (first page, 2026-11-17): maker 0x67336cec holds USDT $1,618,442, USDC $235,943, WETH $202,184,
  cbBTC $181,766 (sum $2,238,335 for these four approved tokens; $2.68M on the first page, more pages exist).
