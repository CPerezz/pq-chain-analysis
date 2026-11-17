# Review reads: lido-wsteth-permit (2026-11-17, Review07)

- Source: Sourcify full match for `0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0` (WstETH.sol, OpenZeppelin 3.4 `ERC20Permit`).
  `permit` (line 961) -> `ECDSA.recover(hash, v, r, s)` (line 978, `ecrecover` at line 750) == `owner`, then `_approve`.
  No `isValidSignature`, no code check.
- Block 26,431,455 (`cast`, publicnode):
  - EIP-1967 implementation slot: `0x0` (not a proxy; `onchain.json` kind `none`, code 6,492 bytes).
  - `totalSupply()` = 3,754,770.456318660285688209 wstETH.
  - `stEthPerToken()` = 1.249382748367543997.
- Blockscout `tokens/0x7f39…2ca0` on 2026-11-17: `exchange_rate` $2,265.04, `circulating_market_cap` $8,547,006,138.
  Market cap used here: totalSupply × exchange_rate = $8,504,705,274 (cross-check: supply × stEthPerToken × ETH
  $1,811.62 = $8,498,572,888). The draft's $10.70B came from a stale cached market cap.
- Yearly pre-quantum use (`data/report/curated_contracts.csv`): `txs_y1` 32,688 `ecrecover` transactions,
  `usd_tx_y1` $17.2B.
