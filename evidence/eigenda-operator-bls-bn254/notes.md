# Review notes (Review12, 2026-11-17)

- Source: Sourcify full source of implementation 0xae448d008b6f69033afda361b46b36c472b6fee0,
  `src/core/EigenDAServiceManager.sol`:
  - `onlyBatchConfirmer` (lines 40–43): `require(isBatchConfirmer[msg.sender])`.
  - `confirmBatch` (lines 88–140): `require(tx.origin == msg.sender)`; reference-block window; `checkSignatures(...)`
    (BLSSignatureChecker, BN254 pairing); per-quorum signed-stake threshold; stores `batchIdToBatchMetadataHash`;
    emits `BatchConfirmed`.
  - `setBatchConfirmer` (line 143): `onlyOwner`, toggles an address.
- cast (https://eth.drpc.org) at block 26,431,570 on proxy 0x870679e138bcdf293b7ff14dd44b70fc97e12fc0:
  - EIP-1967 implementation = 0xae448d008b6f69033afda361b46b36c472b6fee0.
  - `owner()` = 0x002721b4790d97dc140a049936aa710152ba92d5; ProxyAdmin 0x8247ef5705d3345516286b72bfe6d690197c2e99
    `owner()` = the same Safe; `getThreshold()` = 2; owners 0xb646a087…, 0x1b6cc4c0…, 0x403f4d49…, 0x891bbcfe….
  - `paused()` = 0; `taskNumber()` = 153,155.
- Census grouping: family `code:0x6fba24f6…` (proxy bytecode) has 3 members: 0x00a5fd09f6cee6ae9c8b0e5e33287f7c82880505,
  0x0baac79acd45a023e19345c352d8a7a83c4e5656 and this proxy; the other two were not checked.
- Recent `BatchConfirmed` events could not be listed: public RPC log ranges are limited and Blockscout rate-limited.
