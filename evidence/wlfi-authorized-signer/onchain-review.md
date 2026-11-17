# On-chain reads (Review15, 2026-11-17)

RPC https://ethereum-rpc.publicnode.com, block 26,431,555. Proxy `0xda5e1988097297dcdc1f90d4dfe7909e847cbef6`.

| Read | Result |
|---|---|
| EIP-1967 implementation slot | `0x73fe14ff5a25e4363a72828cccd8444f0748fde7` |
| EIP-1967 admin slot | `0x7f533afa9e994b7e44673188034f9ce52886a0c0` |
| ProxyAdmin `owner()` | `0x5be9a4959308a0d0c7bc0870e319314d8d957dbb` |
| token `owner()` | `0x5be9a4959308a0d0c7bc0870e319314d8d957dbb` |
| Safe `getThreshold()` | 3 (5 owners, `onchain.json`) |
| `authorizedSigner()` | `0x006dad584e68225dae2a45731224b3b48ac57184` (code size 0, nonce 0) |
| `VESTER()` / `REGISTRY()` | `0x74b4f6a2e579d730aacb9dd23cfbbaeb95029583` / `0x4f61a99e42e21ea3c3eaf9b1b30fb80a7900d3ce` |
| `totalSupply()` | 96,722,743,250.5 WLFI |
