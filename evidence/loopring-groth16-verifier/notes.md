# Review notes (Review12, 2026-11-17)

- Source: Sourcify `BlockVerifier.sol` of 0x6150343e0f43a17519c0327c41edd9ebe88d01ef.
  - `verifyProofs(blockType, blockSize, blockVersion, publicInputs, proofs)` (lines 1220–1252): looks up the registered
    circuit's Groth16 verification key, then `Verifier.Verify` (ethsnarks, pairing `staticcall(…, 8, …)` at line 656)
    or `BatchVerifier.BatchVerify` (matter-labs, pairing at line 516). BN254.
  - `registerCircuit` / `disableCircuit` (lines 137–160) are owner-only (`Claimable`).
- cast (https://eth.drpc.org), block 26,431,597: BlockVerifier `owner()` = Safe 0xdd2a08a1c1a28c1a571e098914ca10f2877d9c97,
  `getThreshold()` = 2 (owners 0x0f026a3e…, 0x576abc47…, 0x1f28f101…, read at block 26,431,214 in onchain.json).
- Loopring exchange proxy 0x0baba1ad5be3a5c0a66e7ac838a129bf948f1ea4 (ZeppelinOS `OwnedUpgradabilityProxy`):
  `proxyOwner()` = the same Safe; implementation slot keccak("org.zeppelinos.proxy.implementation") =
  0x26d8ba776a067c5928841985bce342f75bae7e82 (Blockscout name `ExchangeV3`) up to block 25,421,920, and
  0xb2de2bff671b03612a0fa3340e0e0ee7e1c0a388 (`ProxyAdminExecutor`, verified; only `transact` and `sendNfts`, both
  restricted to the proxy owner) from block 25,421,921 (2026-06-29 07:46 UTC) to now (binary search over
  `eth_getStorageAt`).
- DepositContract 0x674bdf20a0f284d710bc40872100128e2d66bd3f (`DefaultDepositContract`, `exchange()` = 0x0baba1ad…):
  0 ETH and $2,152 in ERC-20s (BUSD $992, cETH $670, OVR $209, cDAI $62; Blockscout, 2026-11-17). Exchange proxy holds
  about $1.
- Last call of the verifier in the activity scan: block 25,405,609 (2026-06-27).
