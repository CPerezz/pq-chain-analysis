# Review reads: gala-bridge-authorities (2026-11-17, Review17)

Sourcify source of implementation `0xc664692f38d2528710edbb74f65db6599bc7dee6` (Bridge):

- `Authority.verifyMessage` (contracts/Authority.sol 20-44): requires `3 * signatures.length >= 2 * authoritiesLength()`,
  ascending signer indices, and `ECDSA.tryRecover(digest, v, r, s) == getAuthority(index)` for each signature.
- `BridgeIn.bridgeIn(VSM)` (contracts/BridgeIn.sol 29-96): `verifyMessage`, replay check, then releases or mints:
  `bridgeInERC20` mints the shortfall with `mintBulk` when the bridge balance is below the amount and transfers to the
  recipient; ERC-721 / ERC-1155 are minted or released likewise.
- `Governance.changeAuthorities(VSM)` and `Governance.upgrade(VSM)` (contracts/Governance.sol): both require
  `verifyGovernanceMessage` (emitter == `governanceContract()` plus the same authority quorum); `upgrade` calls
  `_upgradeToAndCall(newImplementation, init)`. Upgrades and key changes are therefore signed by the same ECDSA
  authority set.
- `Admin` (contracts/Admin.sol): `onlyOwner` token-bridge setup, enable/disable, destinations, `pause`/`unpause`.

On-chain reads at block 26,431,535 (2026-11-17, publicnode):

- EIP-1967 implementation slot = `0xc664692f…`; EIP-1967 admin slot = 0 (no ProxyAdmin; upgrades go through
  `upgrade(VSM)`).
- `owner()` = `0x7c63e722a7d3ca4fafc29270d82b07e6b07fc564` (no code: an EOA).
- `authoritiesLength()` = 1; `getAuthority(0)` = `0xf6901089c82b056858eea367bd252615b7634af0`. With one authority the
  quorum is one signature.
- `paused()` = false; `governanceContract()` = `0x159ae617db2bc67c1cef659ce3571b3de1236980c3a551e17ebae0674af60188`.
- GALA `0xd1d2eb1b1e90b638588728b4130137d262c87cae`: `isBurningBridge(GALA, 0)` = true, `getTokenType` = 1 (ERC20);
  `hasRole(keccak256("MINTER_ROLE"), bridge)` = true; `totalSupply()` = 46.09e9 GALA (8 decimals); bridge balance 0.
  Blockscout token page: price $0.001365, circulating market cap $70.05M.
- Holdings from onchain.json (block 26,431,214): $2.64M (WETH $884k, WBTC $748k, USDT $232k, WXRP $197k, USDC $156k).
