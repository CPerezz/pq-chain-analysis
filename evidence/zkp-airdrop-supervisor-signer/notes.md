# Review00 notes: zkPass AirdropVault (2026-11-17)

Source: implementation `0x85050b0bf4e83f3a61af7fe4709b0ea44dc8aef2` verified on Blockscout as `AirdropVault`
(`src/AirdropVault.sol`, solc 0.8.30, version() "1.0.0").

- `claim(recipient, amount, orderId, signature)` (line 348) and `delegateClaim(...)` (line 364, SUPERVISOR_ROLE caller)
  → `processClaim` (line 408): requires `tgeBlock <= block.number < claimDeadLineBlock`, unused `orderId`, total
  within `totalAmount`, then `verifySupervisorSignature` (line 460): EIP-712 digest of
  `(recipient, amount, orderId)`, `ECDSA.tryRecover`, `hasRole(SUPERVISOR_ROLE, signer)`; then
  `zkpToken.safeTransfer(recipient, amount)` (line 444).
- `updateClaimDeadLineBlock`, `updateTGEBlock`, `updateSupervisor`: DEFAULT_ADMIN_ROLE. `emergencyWithdraw`: admin,
  only while paused.

On-chain reads (`eth_call`, block 26,431,459 unless stated):

| Read | Value |
|---|---|
| EIP-1967 implementation slot | `0x85050b0bf4e83f3a61af7fe4709b0ea44dc8aef2` |
| EIP-1967 admin slot | ProxyAdmin `0xf827bebef3815781995c548560d48d53b1a929d8` |
| ProxyAdmin `owner()` | `0x182085ce8b0faddc8503d9921df6af076281a6a9` (no code: EOA; also proxy deployer) |
| `hasRole(DEFAULT_ADMIN_ROLE, 0x182085ce…)` | true |
| `zkpToken()` | `0xe1be424f442d0687129128c6c38aace44f8c8dbc` (ZKPToken, symbol ZKP, name zkPass; Blockscout) |
| `totalAmount()` / `totalDeposited()` | 15,000,000 ZKP / 15,000,000 ZKP |
| `totalClaimed()` | 10,236,865 ZKP |
| `getZKPBalance()`, ETH balance | 0, 0 |
| `tgeBlock()` | 24,045,913 (2025-12-19) |
| `claimDeadLineBlock()` | 24,261,243 (2026-01-18) |
| `paused()` | true |
| `hasSupervisorRole(0x8b47684b9864e81d5a2795a50c516a8225e438ef)` (latest block) | true; no code (EOA) |

Events: RoleGranted at the creation block 24,045,534 (2025-12-19): DEFAULT_ADMIN_ROLE → `0x182085ce…`,
PAUSER_ROLE → `0x06700c6cb6b3487ad2a493025fbff8653e646c21`, SUPERVISOR_ROLE → `0x8b47684b…` (all granted by
`0x182085ce…`; eth.drpc.org `eth_getLogs`). `Paused` by `0x06700c6c…` at block 24,276,910 (2026-01-20);
`EmergencyWithdraw(ZKP, 0xc70e0056ca856a19186e2ce1039b716456c6bfe6)` at block 24,333,337 (2026-01-28)
(Blockscout logs). Proxy has 19,899 transactions in total (Blockscout counters).

ZKP price on Blockscout 2026-11-17: USD 0.02999 (circulating market cap USD 6.05M).
