# Review notes: unidentified-bee3211a-signer-key (2026-11-17, Review18)

## On-chain reads (`cast`, https://ethereum-rpc.publicnode.com, block 26,431,737)

- `0xbee3211a…`: EIP-1967 implementation `0xe89e1c84076dbd917f6d71608db579d3f4995487`; EIP-1967 admin ProxyAdmin
  `0x29dfb2d5341fd10cb99f191970d8ac85948fbf44`, `owner()` = EOA `0x97f7d4093e5bdd0776e2ca90c90124c5e16ca569`
  (nonce 244). Logic `owner()` = the same EOA.
- `numberOperators()` = 3; `getAllOperators()` = `0xbeedd84b868a3282d9d2b724f0acbde280678888`,
  `0x97f7d409…` (the owner), `0xbee2dfb85726e3bdd40a23ffdfe49546a5926666`. `weth()` = WETH. ETH balance 0.
- Holdings (`onchain.json`, block 26,431,214): USD 10,724,262 of tokens (USDT 4.24M, WETH 2.75M, USDC 2.07M, BBTC
  0.30M, WBTC 0.23M).
- Deployment (Sourcify): tx `0x939b280d…`, block 22,304,481, deployer recorded as `0x97f7d409…`; Blockscout lists
  creator contract `0x79a8e2d1…` (unverified factory, itself created by `0x6513aedb…`): a vanity-address deployment.
- Sibling with the same proxy code (`data/families.parquet` family `code:0x18db792b…`):
  `0xbee0225697a311af58096ce2f03a2b65f1702f00`, same ProxyAdmin and owner, now implementation `0x4dffeb6b…`,
  operators `0xbee029ff…` and `0x97f7d409…`, ETH 0, priced tokens USD 0 (Blockscout), 861 `ecrecover` transactions
  in the year to March 2026 (last block 24,411,295).

## Implementation bytecode (`0xe89e1c84…`, 16,512 bytes; unverified)

- Selectors include `isValidSignature(bytes32,bytes)` (`0x1626ba7e`), `addOperators(address[])`,
  `removeOperators(address[])`, `isOperator(address)`, `operatorAt(uint256)`, `getAllOperators()`,
  `numberOperators()`, `setAllowance(address[],address,uint256)`, `emergencyWithdraw(address,uint256)`,
  `adminExecute(address,bytes)`, `convertETH(uint256)`, `weth()`, `MAX()`, `0x69328dec`
  (`withdraw(address,uint256,address)`), and unresolved `0x4cf3fe9c` and 15 others.
- Strings: "\x19Ethereum Signed Message:", "ECDSA: invalid signature", "ECDSA: invalid signature length", "Signature
  expired", "Signature does not match request", "Only forwarder allow", "Incorrect sender", "Not accepted dest",
  "destination is not approved", "caller is not operator", "Builder payment failed", "ReserveFund".
- Contains the secp256k1 `n/2` constant (OpenZeppelin `ECDSA`).
- INFERRED: `isValidSignature` recovers an ECDSA signer and accepts it if it is an operator, so RFQ/limit orders whose
  maker is this contract (filled through aggregator routers) are authorised by an operator key; a second path checks
  an operator-signed request ("Signature does not match request") before executing it against approved destinations.

## Activity

- Blockscout latest direct transactions: `0x4cf3fe9c` from several `0xbee…` vanity EOAs; `withdraw` (`0x69328dec`)
  from operator `0xbeedd84b…`.
- Xatu: 114,703 transactions touching the contract in 2026-10-16 to 2026-11-16 (39,504 direct).
- Precompile trace: 1,518,623 `ecrecover` calls in 1,407,957 transactions in the year to March 2026
  (`data/agg/y1_caller.parquet`, `curated_contracts.csv`).
- No ENS, tag, verified source or metadata identifies the operator.
