# Review reads: hyperbridge-sp1-verifier (2026-11-17, Review07)

## Current Ethereum consensus path (Hyperbridge docs, mainnet contract addresses; Blockscout verified source)

- `EvmHost` (IsmpHost) `0x620128e2b19193d6bd244a3ac8d3bba0541b19c3`: `consensusClient()` =
  `0x64094bb4bca533c8322a9e6d6ab88e9d2a36909a`; `admin()` = `0xd15007f5ff5c8c5ccc77339a03a3ea60d1ece854` (no code,
  nonce 485); `frozen()` = 0; EIP-1967 slot 0 (not a proxy). `cast`, block 26,431,692.
- `EvmHost.updateHostParams` (EvmHost.sol line 573) is `restrict(_hostParams.hostManager)`; `hostParams()` lists
  handler `0x3568374fa9fcb72ee232dcfff5569b3bf6c60726`, host manager `0x712515887e0dff042530a120dca9e8a3c90178a5`
  and consensus client `0x64094bb4…`.
- `OwnableHostManager` `0x7125…78a5` `owner()` = `0x08bcc96cec579ce2edb34e5c5d790e4a40c3e224` (Safe, threshold 2,
  owners `0x9ee556d23edf0a30d7c7152ef6643d98b51877bd`, `0x20dc8beb37323c2ede506d8f30beb0e42d38e886`), block 26,431,699.
- `OwnableHandler` `0x3568…0726` (a `HandlerV2`; source lines 25–46): message handling open to any relayer;
  `setConsensusState` is `onlyOwner`; `owner()` = the same Safe `0x08bcc96c…`. Last transactions
  `handleConsensus` on 2026-11-16 (Blockscout, first page).
- `ConsensusRouter` `0x64094bb4…` (constructor args): `sp1Beefy` = `0x3683cd18cdb7c5c223f9489ac33c9c97eb176cb1`,
  `ecdsaBeefy` = `0xaec9508513ff0a7c3c80c9bac204e572ed2d1233`, both immutable; the first byte of the proof selects
  0x00/0x01 (ECDSA BEEFY or SP1).
- `SP1Beefy` `0x3683…6cb1`: `verifier()` (immutable) = `0x70303aa3434e13b64f150ce72bad43e13c8ed186`;
  `verifyConsensus` → `verifier.verifyProof(verificationKey, publicInputs, proof.proof)` (line 155);
  `verificationKey()` = `0x007d1720…2f08`.
- `SP1Verifier` `0x70303aa3…d186`: Blockscout-verified `sp1-contracts/v6.1.0/SP1VerifierGroth16.sol`;
  `VERSION()` = "v6.1.0"; deployed 2026-05-12 (block 25,080,147) by `0xe8599c331dc16fe8e6ed264e332b0f5007d32b2e`
  (the same account that deployed `0x3794de28…`).
- `EcdsaBeefy` `0xaec9…1233`: `ECDSA.recover(commitmentHash, vote.signature)` over the BEEFY authority set (line 159).

## Drafted verifiers

- `0x3794de28…53d`: `VERSION()` = "v6.0.0"; precompile calls blocks 24,493,289–24,682,920 (321 pairings,
  `data/agg/alltime_caller.parquet`); last called 2026-05-15 (`activity.json`); not referenced by the current router.
- `0xe8bd3eee…098`: v4.0.0-rc.3; pairings blocks 21,679,783–24,318,221 (4,804); last active 2026-01-26.

## Escrow on Ethereum (Blockscout 2026-11-17, `cast` block 26,431,692)

- `IntentGatewayV2` proxy `0xae041f7b0cb581876832830baeb6a2aa2a3c9716`: 13.386109 USDC + 5.782953 USDT ≈ $19; 0 ETH.
- Deprecated `TokenGateway` `0xfd413e3afe560182c4471f4d143a96d3e259b6de`: 0.00994 ETH (≈ $18), 3 PHA (≈ $0.10), 0 USDC.
- EvmHost: 65,410 USDC units ($0.07).
- Not measured: issuer-owned HyperFungible tokens and LayerZero OApps using `HyperbridgeLzEndpoint`, whose minting or
  release on Ethereum follows Hyperbridge messages (addresses not enumerated).
