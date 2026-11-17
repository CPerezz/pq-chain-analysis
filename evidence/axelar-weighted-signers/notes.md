# Review notes: axelar-weighted-signers (2026-11-17, Review18)

## Auth module switch on 2026-11-12

- `AxelarGateway` proxy `0x4f4495243837681061c4743b74b3eedf548d56a5`:
  - `authModule()` = `0xe3b83f79fbf01b25659f8a814945ab82186a8ad0` and `implementation()` =
    `0x99b5fa03a5ea4315725c43346e55a6a6fbd94098` at block 26,395,160 (`cast`, eth.drpc.org);
  - `authModule()` = `0x3d3c73e91b1b0c243f1437f2d8363b1d5b093bd0` and `implementation()` =
    `0x16c22cbdd77350b1ac88adda344f691c12f41960` from block 26,395,170 (bisected) to 26,431,544 (latest read).
  - Upgrade: tx `0x412a5698beb96a03e4927b8cbedf35e3399699e0312a9d3b2bbaeab4dc1fd169` (2026-11-12 00:07 UTC), emits
    `Upgraded(0x16c22cbd…)`; sent by EOA `0xc8a8399c3d1207f4e109673be7047604737c1d56` calling
    `AxelarServiceGovernance(0x7acbae6cba67d78aaf69e47000884ae00f9b2525).executeOperatorProposal`.
- New auth module `0x3d3c73e9…`: `AxelarAuthWeighted`, created 2026-11-09 (block 26,378,185) by
  `0x98b2920d53612483f91f12ed7754e51b4a77919e`; `owner()` = gateway; `currentEpoch()` = 20.
  Sourcify exact match. Diff to the old module's `AxelarAuthWeighted.sol`: one line in `_transferOperatorship`
  (`newOperatorsHash = keccak256(abi.encode(newOperators, newWeights, newThreshold))` instead of `keccak256(params)`).
  `_validateSignatures` unchanged: `ECDSA.recover(messageHash, signatures[i])` (line 105), weighted threshold.
- Old module `0xe3b83f79…`: `owner()` = gateway, `currentEpoch()` = 1107; last called by the gateway 2026-11-12
  (Blockscout internal transactions, block 26,395,160). No longer reachable from the gateway.

## Governance (`cast`, block 26,431,544)

- `AxelarGateway.governance()` = `0x7acbae6cba67d78aaf69e47000884ae00f9b2525` (`AxelarServiceGovernance`):
  `governanceChain()` = "axelar", `governanceAddress()` = `axelar10d07y265gmmuvt4z0w9aw880jnsr700j7v9daj`,
  `minimumTimeLockDelay()` = 259,200 s (3 days), `operator()` = EOA `0xc8a8399c…`.
- `mintLimiter()` = `0xcc940ae49c78f20e3f13f3cf37e996b98ac3ec68`; `tokenDeployer()` = `0xb28478319b64f8d47e19a120209a211d902f8b8f`.

## Gateway source (`contracts/AxelarGateway.sol`, impl `0x16c22cbd…`, Sourcify exact match)

- `execute(input)` (line 512): `messageHash = toEthSignedMessageHash(keccak256(data))`;
  `IAxelarAuth(authModule).validateProof(messageHash, proof)` (line 519); then runs commands `deployToken`,
  `mintToken`, `approveContractCall`, `approveContractCallWithMint`, `burnToken`, and `transferOperatorship` (only
  when signed by the current operator set).
- `_mintToken` (line 735): External tokens → `IERC20.safeTransfer(account, amount)` from the gateway's balance
  (line 747); internal tokens → `mint`. Counted against `tokenMintLimit` per symbol (set by the mint limiter).
- `upgrade(...)` (line 435) `onlyGovernance`.

## Escrow (Blockscout `/token-balances` for the gateway, 2026-11-17, from the remote box)

- 135 token balances; priced total USD 39,497,609. Largest: ZIG 18.40M, USDC 13.31M, WBTC 3.14M, WETH 1.65M,
  BUSD 1.33M, USDT 0.68M, DAI 0.35M, EURC 0.27M.
- ETH balance 0.906 ETH (`cast balance`, block 26,431,544) = USD 1,642 at 1,811.62.
- Total used: USD 39,499,251 (`value_basis: escrow`).
- Not measured: tokens locked in Interchain Token Service token managers that release on `approveContractCall`
  messages, and the market value of internal Axelar tokens that a forged `mintToken` would mint.
