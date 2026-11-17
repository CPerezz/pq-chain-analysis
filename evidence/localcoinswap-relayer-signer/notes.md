# Review notes: localcoinswap-relayer-signer (2026-11-17)

Reads with `cast` against https://ethereum-rpc.publicnode.com at block 26,431,454; source from Sourcify
(`contracts/localcoinswap/EthereumEscrow.sol`, `contracts/localcoinswap/LocalCoinSwapV2.sol`, Solidity 0.5.17).

## Roles

| Contract | `owner()` | `relayer()` | `arbitrator()` |
|---|---|---|---|
| `0x0e87bf5286c4091e0eeb7814d802115dfbb4c4cd` LocalCoinSwapEthereumEscrow | EOA `0x7ab685a614d0aac012e85f778fcc36913f3b2271` | EOA `0x877cf5f02497607e0b4e4e6aaf6c275648cd5ce5` | same EOA `0x877cf5f0…` |
| `0x3bae89b27cc92c8f3fc97617cdd0f196e992e4b2` LocalCoinSwapV2Escrow | EOA `0x7ab685a6…` | EOA `0x877cf5f0…` | same EOA `0x877cf5f0…` |

No proxies. Owner functions: `setRelayer`, `setArbitrator`, `setOwner`, `withdrawFees` (accrued fees only), V2
`setMinimumValue`, and in V1 the ERC-20 helpers `transferToken`/`transferTokenFrom`/`approveToken` (V1 escrows hold ETH).
The verification code cannot be changed. V1 `feesAvailableForWithdraw()` = 1.7777 ETH of its 17.19 ETH.

## Signature checks (V2; V1 is the same shape with ETH)

- `createEscrow` / `relayEscrow`: `recoverAddress(keccak256(tradeHash), v, r, s) == relayer` (invitation). The escrowed
  funds come from `msg.sender` (`safeTransferFrom` / `transferWithAuthorization`; V1 `msg.value`). A forged invitation
  only lets someone open an escrow with their own money.
- `relay` / `batchRelay`: `getRelayedSender` = `ecrecover` over `(tradeID, instructionByte, maximumGasPrice)`. If the
  signer is the seller and the instruction is `RELEASE_ESCROW`, the escrow is paid to the trade's buyer
  (`doRelease` → `transferMinusFees(…, _buyer, …)`); if the signer is the buyer and the instruction is `BUYER_CANCELS`,
  it is returned to the seller.
- `resolveDispute`: `onlyArbitrator` (`msg.sender == arbitrator`) plus an `ecrecover` signature by the buyer or the seller
  over `(tradeID, RESOLVE_DISPUTE)`; the arbitrator chooses `_buyerPercent` (0–100).
- `release` (seller) and `buyerCancel` (buyer) also exist as direct calls checked by `msg.sender`, so a contract account
  can act without ECDSA.

## Holdings

`onchain.json` (block 26,431,214): V1 17.186 ETH ($31,136); V2 $38,820 (USDT $24,647, USDC $12,871, LCS $981, DAI $298, …).
These are the funds of open trades plus accrued fees.
