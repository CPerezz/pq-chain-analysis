# Review00 notes: Aztec blob KZG (2026-11-17)

Sources: Rollup v3 `0xe37a2663cc9c119ba41572c40fab0bbb23a5402f` and v2 `0x91ff8bbd8ebb07893010d50a48a1609e5ebd8e34`
(Blockscout verified, solc 0.8.30); Rollup v0 `0x603bb2c05d474794ea97805e8de69bccfb3bca12` (Sourcify). The v3 build
remaps `@aztec-blob-lib/` to `src/mock/libraries/`, whose `BlobLib` forwards to the core `BlobLib` unless the Foundry
cheat-code address has code (never on mainnet).

## Propose (blob commitments)

- `RollupCore.propose` passes `checkBlob` (v3 `RollupCore.sol` line 601) to `ProposeLib`, which calls
  `BlobLib.validateBlobs(_blobsInput, checkBlob)` (`ProposeLib.sol` line 205).
- `BlobLib.validateBlobs` (v3 `BlobLib.sol` lines 80–112): for each 48-byte KZG commitment in the input,
  `calculateBlobHash(commitment)` must equal `blobhash(i)` of the transaction (lines 101–105). The commitments are
  accumulated into `blobCommitmentsHash`.
- `bool public checkBlob = true;` (v3 `RollupCore.sol` line 214; v0 line 198): no function writes it ("gets unset
  only via state overrides during offchain simulations"). There is no calldata path: every checkpoint must carry
  EIP-4844 blobs.

## Epoch proof (KZG opening)

- `EpochProofLib.verifyEpochRootProof` (v3 line 594; v0 line 365) calls `BlobLib.validateBatchedBlob(blobInputs)`
  before the Honk verifier.
- `BlobLib.validateBatchedBlob` (v3 lines 148–152; v2 line 149; v0 line 149): `staticcall` to the point-evaluation
  precompile `0x0a` with the batched commitment `C`, challenge `z`, value `y` and opening proof `Q`;
  `require(success, Rollup__InvalidBlobProof)`. `z`, `y` and `blobCommitmentsHash` are public inputs of the epoch
  proof, so the opening ties the transaction effects the circuit used to the blobs published on L1.
- `submitEpochRootProof` has no caller restriction (no `msg.sender` check in `EpochProofLib`): any prover submits.

## Effect of a forged opening

The SNARK still checks every state transition. A false opening only breaks the link between the proven data and the
published blobs: the checkpoint's blob publisher (the proposer, whose signature authorises `propose`, or the escape
hatch's designated proposer, who must send the transaction) can publish blobs without the real transaction effects,
and anyone holding the trapdoor can still prove the epoch. The chain then finalizes state that cannot be rebuilt from
L1 data (data withholding): funds locked, not taken.

## Fallback

None the admin can switch to: `checkBlob` has no setter, there is no calldata DA mode, and the verifier circuit
consumes blob commitments. Replacing blobs needs either an Ethereum protocol change (post-quantum data availability)
or a new rollup version with a different data-publication design and circuits, registered by Governance
`0x1102471eb3378fee427121c9efcea452e4b6b75e`.
