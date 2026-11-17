# Review reads: bitpay-invoice-signer (2026-11-17, Review07)

## Identity

- Etherscan public label for `0x34e158883efc81c5d92fde785fba48db738711ee`: "BitPay: Invoice" (web search result,
  etherscan.io address page). Verified contract name `Invoice` (Sourcify, solc 0.4.x). Deployed 2022-12-19 by
  `0xad4eb3c32785e0edd88261d2d6fcc3acb02ad430` (tx `0xba333614…6b4d`, Blockscout). The same address hosts a
  contract on Polygon (Polygonscan).

## Source (Sourcify, `Invoice.sol`)

- `pay(value, gasPrice, expiration, payload, hash, v, r, s, tokenContract)` (lines 64–85): calls `validatePayment`
  (lines 42–61), which requires `ecrecover(prefixed keccak(value, gasPrice, expiration, payload, tokenContract), v, r,
  s) == quoteSigner`, an unexpired quote and an unpaid `payload`; ETH (`msg.value`) or the token amount is taken from
  the payer; `isPaid[payload] = true`; `PaymentAccepted` emitted.
- `withdraw(tokenContract)` (lines 92–100), `setSigner` (102–104), `setAdmin` (105–107): `isAdmin` (owner only).

## On-chain reads (`cast`, publicnode, block 26,431,592)

- `owner()` = `quoteSigner()` = `0x2730ef3c0c180e7f7bcfca249c757421b208e333` (no code, nonce 27,550). ETH balance 0.

## Activity (Blockscout, latest pages)

- 2026-07-22: last `pay` calls; three `withdraw` calls by the owner, the largest sending 566,825.02 USDT and
  351,123.58 USDC to `0x2730ef3c…`.
- 2026-07-23: `setSigner` by the owner, after which `quoteSigner` equals the owner address; no `pay` since.
- Remaining tokens (Blockscout): dust (0.007 stETH and unpriced or spam tokens); onchain.json: $14 held.
- Yearly pre-quantum use (`data/report/curated_contracts.csv`): `txs_y1` 44,598, `usd_tx_y1` $67.3M (payment flow,
  not an exposure).
