# Review reads: fabric-robo-airdrop-signer (2026-11-17, Review07)

## Identity (Blockscout, 2026-11-17)

- `0xb8a4deb1c30404555ffeaf30e65b24339abbc2d8`: unverified; created 2026-02-26 by EOA
  `0x53e25a0123da7c5ed4fb8874c891211da1186181` (tx `0xa3160e1e…ede5`).
- The same EOA created token `0x32b4d049fe4c888d2b92eecaf729f44df6b1f36e` (verified `ERC20Token`; Blockscout token
  name "Fabric Protocol", symbol ROBO, 10,000,000,000 supply, market cap $8.9M, 18,638 holders).
- All token transfers out of the contract are ROBO: `claim` transfers to claimants in 2026-03, and on 2026-08-05 a
  transfer of 115,904,535.80 ROBO to the owner Safe `0x1e63183fb2123f0674582a5a2d251e72de0bd8bf`.

## Bytecode (`cast code`, block 26,431,597; 4,378 bytes)

- Selectors present: `claim(bytes32,uint256,address,bytes32[],bytes)` 0x877634db, `trustedSigner()` 0xf74d5480,
  `updateTrustedSigner(address)` 0x7530625f, `merkleRoot()` 0x2eb4a7ab, `owner()` 0x8da5cb5b, `token()` 0xfc0c546a.
- The "\x19Ethereum Signed Message:\n32" prefix is embedded, and a `staticcall` to precompile 0x01 (`6001…5afa`).
- Precompile trace (`data/report/curated_contracts.csv`): 23,088 transactions with `ecrecover` in the last year.

## On-chain reads (`cast`, publicnode, blocks 26,431,597–26,431,715)

- `trustedSigner()` = `0x10f0ccfdcf78a4cbbe7580e0427c23b7c8abcf19`; `owner()` = Safe `0x1e63…d8bf`, threshold 3 of
  5 (owners `0x0afd6db4…184c`, `0x9965b24d…d3d9`, `0x4e08e84f…dc78`, `0xdcfc3dd6…76fc`, `0x8636f27d…87ff`);
  `token()` = ROBO; `merkleRoot()` = `0xf44be381…f30e`.
- ROBO `balanceOf(contract)` = 0; ROBO `allowance` to the contract from the Safe and from the deployer = 0; ETH 0.
