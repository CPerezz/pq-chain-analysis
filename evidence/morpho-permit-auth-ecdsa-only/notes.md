# Review notes (Review23, 2026-11-17)

## Morpho Blue `0xbbbbbbbbbb9cc5e90e3b3af64bdaf62c37eeffcb` (verified source, Sourcify `src/Morpho.sol`)

- `setAuthorizationWithSig(Authorization, Signature)` (line 446): deadline, `nonce[authorizer]++`,
  `ecrecover(digest, v, r, s)`, requires `signatory != 0 && signatory == authorization.authorizer`, then sets
  `isAuthorized[authorizer][authorized]`. No ERC-1271, no code check. `setAuthorization` (line 437) is the
  msg.sender alternative.
- `_isSenderAuthorized(onBehalf)` = `msg.sender == onBehalf || isAuthorized[onBehalf][msg.sender]` gates exactly
  `withdraw` (line 212), `borrow` (line 247) and `withdrawCollateral` (line 331); each acts on `position[id][onBehalf]`
  and sends to an arbitrary `receiver`.
- `borrow` and `withdrawCollateral` require `_isHealthy(marketParams, id, onBehalf)`: the debt is the authorizer's and
  is bounded by the authorizer's collateral times LLTV; `withdraw` is bounded by the authorizer's supply shares (and
  market liquidity). So a forged authorization takes at most that user's own positions (supply + collateral);
  other users' supply is only lent against the victim's collateral under the normal health check.
- Owner-only functions (`setOwner`, `enableIrm`, `enableLltv`, `setFee`, `setFeeRecipient`) cannot change the
  signature check. Not a proxy. Owner Safe `0xcba28b38…` (6 of 10, onchain.json).

## MetaMorpho vaults (OpenZeppelin v5 `ERC20Permit.permit`: `ECDSA.recover(hash, v, r, s) == owner`)

Reads at block 26,431,500 (2026-11-17 01:32 UTC), https://ethereum-rpc.publicnode.com:

| Vault | name() | asset | totalAssets (USDC) | owner() |
|---|---|---|---|---|
| 0xd63070114470f685b75b74d60eec7c1113d33a3d | Usual Boosted USDC | USDC | 1,804,165.58 | 0x38afc3aa… (Safe 2/5) |
| 0x777791c4d6dc2ce140d00d2828a7c93503c67777 | Hyperithm USDC Apex | USDC | 1,207,041.11 | 0xee7e9bb2… (Safe 2/3) |
| 0xbeefff209270748ddd194831b3fa287a5386f5bc | Smokehouse USDC | USDC | 10,453,910.41 | 0x0a0e559b… (Safe 5/10) |
| 0xbeef01735c132ada46aa9aa4c54623caa92a64cb | Steakhouse USDC | USDC | 71,854,433.22 | 0x0a0e559b… (Safe 5/10) |

A forged `permit` gives the attacker an allowance over the holder's vault shares; `transferFrom` + `redeem` takes
them. The vaults' USDC sits in Morpho Blue as the vault's own supply positions (the vault is a contract and signs
nothing), so the vault value overlaps with Morpho Blue's holdings and is not additive.

Yearly pre-quantum use (`data/report/curated_contracts.csv`, `txs_y1` ecrecover transactions):
Morpho 11,559; 0xd6307011 5,632; 0x777791c4 2,385; 0xbeefff20 2,368; 0xbeef0173 1,811.
