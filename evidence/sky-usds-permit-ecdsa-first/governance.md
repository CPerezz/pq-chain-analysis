# Governance reads (Review15, 2026-11-17)

RPC: https://ethereum-rpc.publicnode.com, block 26,431,426 unless noted. Logs: Blockscout `module=logs&action=getLogs`.

| Read | Result |
|---|---|
| USDS `0xdc03…384f` EIP-1967 impl slot | `0x1923dfee706a8e78157416c29cbccfde7cdf4102` |
| USDS EIP-1967 admin slot | 0 (UUPS) |
| sUSDS `0xa393…7fbd` EIP-1967 impl slot | `0x4e7991e5c547ce825bdeb665ee14a3274f9f61e0` |
| sUSDS EIP-1967 admin slot | 0 (UUPS) |
| USDS `wards(0xbe8e3e3618f7474f8cb1d074a26affef007e98fb)` | 1 |
| USDS `wards(0x3c0f895007ca717aa01c8693e59df1e8c3777feb)` (UsdsJoin) | 1 |
| sUSDS `wards(0xbe8e3e3618f7474f8cb1d074a26affef007e98fb)` | 1 |
| sUSDS `wards(0x36b072ed8afe665e3aa6daba79decbec63752b22)` (SPBEAM) | 1 |
| pause proxy `owner()` | `0xbe286431454714f511008713973d3b053a2d38f3` (DSPause) |
| DSPause `authority()` | `0x929d9a1435662357f54adcf64dcee4d6b867a6f9` (Chief) |
| DSPause `delay()` | 172800 |
| Chief `hat()` | `0xabc702420dcc1868f7f8df06a89da766bcb01136` (DssSpell) |
| USDS `totalSupply()` | 5,234,715,755.42 |
| sUSDS `totalSupply()` / `totalAssets()` | 3,302,025,810.68 shares / 3,687,043,328.19 USDS |
| DAI `totalSupply()` | 4,435,351,448.85 |

`Rely(address)` logs: USDS: `0x4ec216c4…` (20,663,730), pause proxy (20,663,731), UsdsJoin (20,770,191);
`Deny`: `0x4ec216c4…` (20,663,732). sUSDS: `0xd6ec7a1b…` (20,677,434), pause proxy (20,677,435), SPBEAM (22,317,839);
`Deny`: `0xd6ec7a1b…` (20,677,436).

Source: `Usds.sol` line 73 and `SUsds.sol` line 132: `function _authorizeUpgrade(address newImplementation) internal
override auth {}`; `_isValidSignature` branch `if (signature.length == 65)` at lines 196 / 415.
