# Review notes: layer3-distributor-signer (2026-11-17, Review18)

## Source (Sourcify, `src/contracts/L3Distributor.sol`)

- Deployed in tx `0x4c8537ad…` (block 22,226,296) by `0x672541228e3469eb206caf04966db927b202d058`; header banner
  "LAYER3"; not a proxy; `Ownable2Step`; `renounceOwnership` overridden to do nothing.
- `_claim(amount, merkleProof, signature)`: `_messageHash = keccak256(bytes.concat(keccak256(abi.encode(msg.sender,
  amount))))`; `_messageHash.toEthSignedMessageHash().recover(signature)` must equal `s_signer` (line 123–124);
  `MerkleProof.verify(merkleProof, i_merkleRoot, _messageHash)` (line 127) against the immutable root; then
  `s_hasClaimed[msg.sender] = true`.
- `claim` records the claim and emits `SmartWalletClaim`; `claimAndStake` additionally stakes `amount` for 12 months
  in `i_staking` for `msg.sender` and transfers the L3 to the staking contract.
- `updateSigner`, `emergencyWithdraw`, `collectDust`: `onlyOwner`.
- Consequence for this registry: both the signature and the merkle leaf commit to `msg.sender` and `amount`, and the
  root is immutable, so a forged `s_signer` signature only lets an address that is already in the tree claim its own
  allocation without the operator's approval. It cannot redirect or enlarge anyone's allocation.

## On-chain reads (`cast`, https://ethereum-rpc.publicnode.com, block 26,431,747)

- `s_signer()` = `0x268bde7c8e2f4188ffbc0a482a641bd919c7c797`; `owner()` = Safe
  `0x49a941d7d7d40f340fabb17d25a9e2a76b72fac6` (3 of 5 at block 26,431,214, `onchain.json`); `pendingOwner()` = 0.
- `i_l3()` = L3 token `0x88909d489678dd17aa6d9609f89b0419bf78fd9a`; `i_staking()` = `0x8e02d37b…`.
- `L3.balanceOf(distributor)` = 0.087 L3 (dust); ETH 0.

## Activity (Blockscout)

- 20,453 transactions in total; the latest is `emergencyWithdraw` on 2025-08-30, before that `claim` /
  `claimAndStake` calls. Last `ecrecover` call in the precompile trace at block 22,773,373 (2025-06-24); 20,382
  `ecrecover` transactions over its life.
