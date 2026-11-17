# Review notes (Review12, 2026-11-17)

- cast (https://eth.drpc.org) at block 26,431,619 on proxy 0x35d8949372d46b7a3d5a56006ae77b215fc69bc0:
  - EIP-1967 implementation slot = 0x9f2bd21bf8012fce0d5845537c1deff3a89bc85b; admin slot = 0x65a7042460932a8e7b6aa9c765c2bae5f4535c22.
  - ProxyAdmin `owner()` = 0xaada24358620d4638a2ee8788244c6f4b197ca16 (Safe; `getThreshold()` = 8; 15 owners).
  - `name()` = "Bond USD0", `symbol()` = "bUSD0", `totalSupply()` = 500077104376794414385378052 (18 decimals).
- Blockscout `/api/v2/tokens/0x35d8…`: exchange_rate 0.977828, circulating_market_cap 488989125, 2,652 holders.
- Sourcify sources of implementation 0x9f2bd21b…: no file contains `isValidSignature` or `SignatureChecker`;
  `src/token/Usd0PP.sol` has no `function permit` (inherited from OZ `ERC20PermitUpgradeable`).
