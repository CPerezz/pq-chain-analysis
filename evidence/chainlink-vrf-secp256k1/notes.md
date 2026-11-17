# Review notes: chainlink-vrf-secp256k1 (2026-11-17)

Reads with `cast` against https://ethereum-rpc.publicnode.com at block 26,431,454; source from Sourcify.

## Who can change it

- VRFCoordinatorV2_5 `0xd7f86b4b8cae7d942340ff628f82735b7a20893a`: `owner()` = Safe `0xcc4b5b07316be81ed6edb44ca61e4cab28a1950d`
  (GnosisSafe 1.3.0, threshold 4 of 12). No proxy.
- VRFCoordinatorV2 `0x271682deb8c4e0901d1a1550ad2e64d568e69909`: `owner()` = `0x463219821e151c0c44364c27833e39386c48e64f`,
  an unverified contract (7,626 bytes, created by `0xab42d8b7cbef1e4fe568a6b4edc8ecccb6c86a49`) whose selectors include
  `owner()`, `acceptOwnership()`, `transferOwnership(address)`, `setAuthorizedSenders(address[])`; its `owner()` = the
  same Safe `0xcc4b5b07…`. [INFERENCE: Chainlink's VRFOwner wrapper.] No proxy.

## Mechanism (VRFCoordinatorV2_5.sol)

- `fulfillRandomWords(Proof proof, RequestCommitmentV2Plus rc, bool onlyPremium)` (line 445) has no caller check. It calls
  `_getRandomnessFromProof` (line 369): the proving key must be registered (`s_provingKeys[keyHash].exists`), the request
  commitment must match, the seed is mixed with the request block's hash, and `VRF._randomValueFromVRFProof` verifies the
  ECVRF proof on secp256k1 (ecrecover used as scalar multiplication, `modexp` for field square roots, VRF.sol).
- Payment is charged to the subscription (`_chargePayment`) and credited to the protocol, not to the caller.
- With a proving key's secret, anyone can compute the output for any pending request as soon as the request block's hash
  is known, before the oracle fulfils it. ECVRF outputs are unique per key and seed, so the attacker predicts the value but
  cannot choose it.

## Holdings (not the exposure)

From `onchain.json` (block 26,431,214): V2.5 $519k and V2 $571k (LINK and ETH subscription balances). Forging a VRF
proof does not move these balances to the attacker.
