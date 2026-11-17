# Patterns

Findings are grouped by class and pattern. A finding names one or more pattern ids in `patterns`; its class is the
class of the first one. To add a pattern, or a class, add it here in the same pull request as the finding that needs
it. Ids are never renumbered or reused; new patterns continue the numbering.

## Classes

- **exposure**: something a quantum attacker can do through a contract, or that post-quantum users cannot do, as the
  chain is today.
- **regression**: something that works today and breaks for everyone when a protocol change activates.
- **migration-hazard**: something an account loses by migrating once a protocol change is live.
- **protection-gap**: a path a protocol change is meant to protect and does not reach.
- **spec-issue**: a defect or an ambiguity in the text of a specification.

Each pattern has a **Class**. Exposure patterns also have a **Trigger** (what a quantum attacker must break). All have
**Detection** notes (how a study finds it).

## PQ-1: User signature checked with ECDSA only

**Class:** exposure

**Trigger:** user-key

A user's offline signature (EIP-2612 `permit`, DAI-style permit, EIP-3009, signed orders, meta-transactions) is
accepted only through `ecrecover`. A new post-quantum account cannot use the path at all. For an address that later
migrates its own authorisation, the old ECDSA key keeps signing here; only EIP-8151 (with real account code) or moving
the funds to a fresh address stops that.

**Detection:** `ecrecover` calls in the precompile trace; verified source with `ecrecover`/`ECDSA.recover` and no
`isValidSignature` call on the path.

## PQ-2: ECDSA tried before ERC-1271, or the signer chooses the scheme

**Class:** exposure

**Trigger:** user-key

The contract accepts contract signatures (ERC-1271), so post-quantum accounts can use it, but it still tries
`ecrecover` first for 65-byte signatures (older OpenZeppelin `SignatureChecker`, Seaport), or lets the signer pick
ECDSA. A migrated address stays forgeable with its old key.

**Detection:** verified source; `tryRecover` before `isValidSignature`, or a signature-type flag.

## PQ-3: ERC-1271 path limited to 65-byte signatures

**Class:** exposure

**Trigger:** none (liveness)

The contract forwards only `(v, r, s)` to ERC-1271, so a post-quantum signature (0.7–17 KB) cannot reach the
account. Post-quantum users are locked out of the path; nothing is forgeable beyond the account's own key.

**Detection:** verified source; interfaces taking `uint8 v, bytes32 r, bytes32 s`.

## PQ-4: One operator ECDSA key authorises value

**Class:** exposure

**Trigger:** operator-key

A single secp256k1 key signs quotes (RFQ, PMM), cosigns orders, approves sponsorship (paymasters), vouchers,
signed mints or claims, or relayed actions. The key has signed on-chain, so its public key is known. Rotating the key
does not help; the contract must verify a different scheme.

**Detection:** `ecrecover` against a stored signer; `setSigner`-style admin functions.

## PQ-5: Committee of ECDSA signers attests a fact

**Class:** exposure

**Trigger:** committee-keys

An m-of-n set of secp256k1 keys attests a cross-chain message, a price or a report (bridge guardians and attesters,
LayerZero DVNs, oracle networks). Forging m keys releases or mints whatever the attestation controls.

**Detection:** loops of `ecrecover` against a signer set and a threshold.

## PQ-6: BLS aggregate signatures

**Class:** exposure

**Trigger:** committee-keys

A committee's aggregate BLS signature (BN254 or BLS12-381) is verified with a pairing check. BLS secret keys follow
from public keys, so any quorum can be forged.

**Detection:** pairing precompile calls with aggregate-key checks; EigenLayer `BLSSignatureChecker` and similar.

## PQ-7: SNARK verification over a pairing curve

**Class:** exposure

**Trigger:** trusted-setup

Groth16, PLONK, fflonk, Halo2-KZG and Honk verifiers on BN254. The trusted-setup trapdoor follows from its public
parameters, so proofs of false statements verify: a rollup's state root, a privacy pool's withdrawal, a bridge's
light-client update. Most verifiers are standalone contracts the consumer can repoint; the replacement is a
hash-based (STARK/FRI or WHIR) verifier at several times the gas.

**Detection:** `ecadd`/`ecmul`/`ecpairing` precompile calls; BN254 field constants in bytecode.

## PQ-8: KZG blob commitment opening

**Class:** exposure

**Trigger:** trusted-setup

The point-evaluation precompile (0x0a) opens EIP-4844 blob commitments under the KZG ceremony's setup. Blob data
availability as such has no post-quantum replacement without an Ethereum protocol change; a rollup whose contracts can
fall back to calldata data availability (switchable by its admin) can leave KZG without one, at higher cost.

**Detection:** `pointEval` precompile calls.

## PQ-9: P-256 passkeys

**Class:** exposure

**Trigger:** user-key

WebAuthn / passkey signatures on secp256r1, through the 0x100 precompile or a Solidity verifier. Post-quantum
(ML-DSA) passkeys exist but need a different on-chain verifier.

**Detection:** `p256verify` calls; P-256 modulus in `modexp` calls; P-256 constants in bytecode.

## PQ-10: RSA identity signatures

**Class:** exposure

**Trigger:** issuer-key

RSA signatures from an off-chain issuer (DKIM, JWT, passports, KYC providers) verified with `modexp`. The issuer
must move to post-quantum keys before the contract can.

**Detection:** `modexp` with a 1024-bit or larger modulus.

## PQ-11: secp256k1 algebra (VRF, Schnorr)

**Class:** exposure

**Trigger:** operator-key

`ecrecover` or `modexp` used as a curve-arithmetic gadget: ECVRF randomness (Chainlink VRF), Schnorr or FROST
threshold signatures. Forging the key lets an attacker choose randomness or sign as the group.

**Detection:** `ecrecover` plus secp256k1-field `modexp` in one contract.

## PQ-12: Wallet owners are ECDSA keys

**Class:** exposure

**Trigger:** owner-keys

A multisig or smart account (Safe, custody wallets, ERC-4337 accounts, EIP-7702 delegates) is controlled by
secp256k1 owner keys. The fix is owners moving to post-quantum signers: in place where the wallet supports contract
owners or modules, by moving funds where the signer set is fixed.

**Detection:** Safe and ERC-4337 selectors; `ecrecover` over an owner set.

## PQ-13: Account code checked before ECDSA (not affected)

**Class:** exposure

**Trigger:** none

The contract asks whether the signer has code and, if so, verifies through ERC-1271 with the full signature; only
code-less addresses go to `ecrecover` (current OpenZeppelin `SignatureChecker`, Solady, Permit2). An account that
migrates to post-quantum authorisation with real code is not forgeable here, and a code-less address was only ever as
safe as its own key. Recorded so these contracts are not counted as exposed. If the ERC-1271 call passes only
`(v, r, s)`, it is PQ-3 instead.

**Detection:** verified source; `code.length > 0` (or `extcodesize`) checked before `ecrecover`.
