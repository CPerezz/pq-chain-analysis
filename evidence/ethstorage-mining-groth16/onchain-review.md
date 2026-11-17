# On-chain reads (Review15, 2026-11-17)

RPC https://ethereum-rpc.publicnode.com, block 26,431,543. Proxy `0xf0193d6e8fc186e77b6e63af4151db07524f6a7a`.

| Read | Result |
|---|---|
| EIP-1967 implementation slot | `0x99f5cc6ad111584c88891b4c6fff5784a46adf33` |
| EIP-1967 admin slot | `0x654dd56444856e928917549263aac6f9d6a96372` |
| ProxyAdmin `owner()` | `0xa10d87502a0d8fce45610c6028f0756383649f3c` |
| Safe `getThreshold()` / `getOwners()` | 1 / `0x6fd772e4f7129c259a3c10650a24acc61802971f` (EOA, nonce 12), `0x905d49785b3d28714a9bc7532f74c5a2228e0602` (EOA, nonce 1) |
| `hasRole(DEFAULT_ADMIN_ROLE, Safe)` | true |
| `treasury()` | `0xa10d87502a0d8fce45610c6028f0756383649f3c` |
| `enforceMinerRole()` | true |
| `accPrepaidAmount()` / `prepaidAmount()` | 1.4723 ETH / 25.1658 ETH |
| ETH balance | 0.177249 ETH |
| `version()` | 0.2.1 |
