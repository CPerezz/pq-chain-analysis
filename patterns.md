# Patterns

A finding names one pattern id (`pattern` in format 2; `patterns` in format 1). Its category is the pattern's
category, and the card shows the pattern's **In words** line, never its id. To add a pattern or a category, add it
here in the same pull request as the finding that needs it. Ids are never renumbered or reused; new patterns continue
the numbering.

A pattern is defined by its **In words** line and its description. Its **Detection** notes say how a study finds and
confirms it (a scan, a replay); they are not conditions, and a finding may rest on source or bytecode without them.
When more than one pattern could fit a contract, "Choosing between patterns" below decides.

## Categories

What a reader sees instead of a class. The card shows the name in quotes; `<change>` is the change the study examines.

- **quantum-exposure** ("Forgeable by a quantum computer"): someone with a quantum computer could forge a signature
  or proof this contract trusts, on today's chain.
- **breaks-at-activation** ("Breaks when <change> goes live"): works today and fails for everyone the day the change
  activates, with nobody doing anything.
- **voided-by-migration** ("Breaks when another party migrates"): a signature someone already relies on stops
  counting if its signer moves its account to real code.
- **migration-notice** ("Check before you migrate"): works until a key holder moves its own account to real code;
  that key then stops counting here, so the holder acts first. Always `INFORMATIONAL`.

"Real code" is contract code. Under EIP-8151 an account that holds an EIP-7702 delegation still signs as before; only
an account with real code stops counting.

## Choosing between patterns

Decide by the code and the state at the finding's block, and say in the finding, with a check, the state that
decided. A path is closed for good only when no function and no live key can open it again (an unpause, a setter, an
upgrade); a contract that could be restarted keeps its finding and says it is dormant. A key left unset, or held by an
account with real code (not a delegation), cannot sign here today: unless a live key can set another, its path is
closed.

For EIP-8151 (PQ-14 to PQ-21), in this order:

1. Something fails with nobody migrating: a gas amount fixed in the code is PQ-14; a real transaction that fails only
   on its sender's gas limit is PQ-18.
2. Another party already holds a signature and has acted on it in a way it cannot undo (a service delivered against a
   voucher, a channel state it relies on instead of disputing, a submitted result, a fraud proof), and the contract
   checks that signature later, on chain: PQ-15. One on-chain check is enough; the first step can be off chain. A
   signature checked in the same call that uses it (a permit, a quote, a relayed call) is not this. Nor is it PQ-15
   when, at the block, the signer can already take back what that party relies on without migrating (a channel whose
   timeout has passed, so that the signer alone withdraws the balance; a voucher the signer can cancel): migrating
   then adds nothing, and it is a notice below.
3. Otherwise a key holder loses something only by moving its own account to real code: a migration notice, chosen by
   the code, whatever the holder would lose:
   - if the holder can still do the same act by a direct call (approve beside a permit, a Safe owner's approveHash):
     PQ-19;
   - else by what the code compares the recovered address with: a stored key, an immutable or a constant (a signer,
     an operator, a signer set, a wallet's owners), PQ-17; the user named in the call or the caller, PQ-16 when that
     releases the user's own funds or rights and PQ-21 when it only lets the account enter or register; the address
     the code runs at (an account's own logic, such as EIP-7702 delegate code), PQ-20.

For a user's signature exposed to a quantum computer, by the order of the checks on its path:

- the signer's code is checked first and ERC-1271 gets the full signature: PQ-13 (not affected); it gets only
  `(v, r, s)`: PQ-3;
- ECDSA is tried before ERC-1271, or the signer picks the scheme: PQ-2;
- ECDSA only: PQ-1.

When functions differ, the finding names the most exposed path (ECDSA only, then ECDSA first). For keys that sign
for others: one key that authorises value (quotes, claims, sponsorship, vouchers) is PQ-4; a set of keys with a
threshold that attests a message, a price or a report is PQ-5; the owner keys of a wallet that holds its own assets
are PQ-12, whatever its threshold.

## Classes (format 1, until every finding is converted)

- **exposure**: something a quantum attacker can do through a contract, or that post-quantum users cannot do, as the
  chain is today.
- **regression**: something that works today and breaks for everyone when a protocol change activates.
- **migration-hazard**: something an account loses by migrating once a protocol change is live.
- **protection-gap**: a path a protocol change is meant to protect and does not reach.
- **spec-issue**: a defect or an ambiguity in the text of a specification.

Each pattern has a **Category**, an **In words** line for readers, a **Class** (format 1) and **Detection** notes (how
a study finds it). Exposure patterns also have a **Trigger** (what a quantum attacker must break).

## PQ-1: User signature checked with ECDSA only

**Class:** exposure

**Category:** quantum-exposure

**In words:** Accepts a user's signature only in today's scheme (ECDSA), which a quantum computer could forge to act for that user.

**Trigger:** user-key

A user's offline signature (EIP-2612 `permit`, DAI-style permit, EIP-3009, signed orders, meta-transactions) is
accepted only through `ecrecover`. A new post-quantum account cannot use the path at all. For an address that later
migrates its own authorisation, the old ECDSA key keeps signing here; only EIP-8151 (with real account code) or moving
the funds to a fresh address stops that.

**Detection:** `ecrecover` calls in the precompile trace; verified source with `ecrecover`/`ECDSA.recover` and no
`isValidSignature` call on the path.

## PQ-2: ECDSA tried before ERC-1271, or the signer chooses the scheme

**Class:** exposure

**Category:** quantum-exposure

**In words:** Accepts newer signatures but still also accepts today's (ECDSA) ones, which a quantum computer could forge.

**Trigger:** user-key

The contract accepts contract signatures (ERC-1271), so post-quantum accounts can use it, but it still tries
`ecrecover` first for 65-byte signatures (older OpenZeppelin `SignatureChecker`, Seaport), or lets the signer pick
ECDSA. A migrated address stays forgeable with its old key.

**Detection:** verified source; `tryRecover` before `isValidSignature`, or a signature-type flag.

## PQ-3: ERC-1271 path limited to 65-byte signatures

**Class:** exposure

**Category:** quantum-exposure

**In words:** Passes only short, old-style signatures to smart accounts, so accounts with post-quantum keys cannot use it.

**Trigger:** none (liveness)

The contract forwards only `(v, r, s)` to ERC-1271, so a post-quantum signature (0.7–17 KB) cannot reach the
account. Post-quantum users are locked out of the path; nothing is forgeable beyond the account's own key.

**Detection:** verified source; interfaces taking `uint8 v, bytes32 r, bytes32 s`.

## PQ-4: One operator ECDSA key authorises value

**Class:** exposure

**Category:** quantum-exposure

**In words:** Trusts one operator's signing key to move value; a quantum computer could forge that key.

**Trigger:** operator-key

A single secp256k1 key signs quotes (RFQ, PMM), cosigns orders, approves sponsorship (paymasters), vouchers,
signed mints or claims, or relayed actions. The key has signed on-chain, so its public key is known. Rotating the key
does not help; the contract must verify a different scheme.

**Detection:** `ecrecover` against a stored signer; `setSigner`-style admin functions.

## PQ-5: Committee of ECDSA signers attests a fact

**Class:** exposure

**Category:** quantum-exposure

**In words:** Trusts a group of signers, such as a bridge or oracle committee; forging enough of their keys fakes its messages.

**Trigger:** committee-keys

An m-of-n set of secp256k1 keys attests a cross-chain message, a price or a report (bridge guardians and attesters,
LayerZero DVNs, oracle networks). Forging m keys releases or mints whatever the attestation controls.

**Detection:** loops of `ecrecover` against a signer set and a threshold.

## PQ-6: BLS aggregate signatures

**Class:** exposure

**Category:** quantum-exposure

**In words:** Trusts a committee's combined (BLS) signature, which a quantum computer could forge.

**Trigger:** committee-keys

A committee's aggregate BLS signature (BN254 or BLS12-381) is verified with a pairing check. BLS secret keys follow
from public keys, so any quorum can be forged.

**Detection:** pairing precompile calls with aggregate-key checks; EigenLayer `BLSSignatureChecker` and similar.

## PQ-7: SNARK verification over a pairing curve

**Class:** exposure

**Category:** quantum-exposure

**In words:** Trusts zero-knowledge proofs whose setup a quantum computer could break, so false proofs would pass.

**Trigger:** trusted-setup

Groth16, PLONK, fflonk, Halo2-KZG and Honk verifiers on BN254. The trusted-setup trapdoor follows from its public
parameters, so proofs of false statements verify: a rollup's state root, a privacy pool's withdrawal, a bridge's
light-client update. Most verifiers are standalone contracts the consumer can repoint; the replacement is a
hash-based (STARK/FRI or WHIR) verifier at several times the gas.

**Detection:** `ecadd`/`ecmul`/`ecpairing` precompile calls; BN254 field constants in bytecode.

## PQ-8: KZG blob commitment opening

**Class:** exposure

**Category:** quantum-exposure

**In words:** Relies on blob data commitments (KZG) whose setup a quantum computer could break.

**Trigger:** trusted-setup

The point-evaluation precompile (0x0a) opens EIP-4844 blob commitments under the KZG ceremony's setup. Blob data
availability as such has no post-quantum replacement without an Ethereum protocol change; a rollup whose contracts can
fall back to calldata data availability (switchable by its admin) can leave KZG without one, at higher cost.

**Detection:** `pointEval` precompile calls.

## PQ-9: P-256 passkeys

**Class:** exposure

**Category:** quantum-exposure

**In words:** Accepts passkey (P-256) signatures, which a quantum computer could forge.

**Trigger:** user-key

WebAuthn / passkey signatures on secp256r1, through the 0x100 precompile or a Solidity verifier. Post-quantum
(ML-DSA) passkeys exist but need a different on-chain verifier.

**Detection:** `p256verify` calls; P-256 modulus in `modexp` calls; P-256 constants in bytecode.

## PQ-10: RSA identity signatures

**Class:** exposure

**Category:** quantum-exposure

**In words:** Trusts RSA signatures from an outside issuer (email, passport, identity), which a quantum computer could forge.

**Trigger:** issuer-key

RSA signatures from an off-chain issuer (DKIM, JWT, passports, KYC providers) verified with `modexp`. The issuer
must move to post-quantum keys before the contract can.

**Detection:** `modexp` with a 1024-bit or larger modulus.

## PQ-11: secp256k1 algebra (VRF, Schnorr)

**Class:** exposure

**Category:** quantum-exposure

**In words:** Uses elliptic-curve maths for randomness or group signatures; a quantum computer could pick the result or sign for the group.

**Trigger:** operator-key

`ecrecover` or `modexp` used as a curve-arithmetic gadget: ECVRF randomness (Chainlink VRF), Schnorr or FROST
threshold signatures. Forging the key lets an attacker choose randomness or sign as the group.

**Detection:** `ecrecover` plus secp256k1-field `modexp` in one contract.

## PQ-12: Wallet owners are ECDSA keys

**Class:** exposure

**Category:** quantum-exposure

**In words:** A wallet controlled by owner keys in today's scheme; a quantum computer could forge an owner's key.

**Trigger:** owner-keys

A multisig or smart account (Safe, custody wallets, ERC-4337 accounts, EIP-7702 delegates) is controlled by
secp256k1 owner keys. The fix is owners moving to post-quantum signers: in place where the wallet supports contract
owners or modules, by moving funds where the signer set is fixed.

**Detection:** Safe and ERC-4337 selectors; `ecrecover` over an owner set.

## PQ-13: Account code checked before ECDSA (not affected)

**Class:** exposure

**Category:** quantum-exposure

**In words:** Asks smart accounts to check their own signatures first, so an account that moved to post-quantum keys is safe here.

**Trigger:** none

The contract asks whether the signer has code and, if so, verifies through ERC-1271 with the full signature; only
code-less addresses go to `ecrecover` (current OpenZeppelin `SignatureChecker`, Solady, Permit2). An account that
migrates to post-quantum authorisation with real code is not forgeable here, and a code-less address was only ever as
safe as its own key. Recorded so these contracts are not counted as exposed. If the ERC-1271 call passes only
`(v, r, s)`, it is PQ-3 instead.

**Detection:** verified source; `code.length > 0` (or `extcodesize`) checked before `ecrecover`, and the full signature
passed to ERC-1271 (only `(v, r, s)` makes it PQ-3).

## PQ-14: Fixed or capped gas on the way to `ecrecover`

**Class:** regression

**Category:** breaks-at-activation

**In words:** Gives the signature check a fixed amount of gas; once the check costs more, every signature fails.

The contract gives the `ecrecover` precompile a literal amount of gas, or caps the gas of a call that reaches it.
Under EIP-8151 a recovery that succeeds costs 3,200 gas when the recovered address is warm and 6,100 when it is cold,
instead of 3,000. A call that is given less fails for every valid signature. What follows depends on the code: a
revert, so that the function is dead; or a wrong verdict, when the code reads "no address came back" as a fact. No
account has to migrate for this: it starts on the day the change is active.

**Detection:** bytecode: the gas operand of a call to address `0x01` folds to a constant below 6,100; traces: the
same gas forwarded to `0x01` in unrelated transactions. Confirmed by replaying a real transaction with the new price.

## PQ-15: A signature checked again after others relied on it

**Class:** migration-hazard

**Category:** voided-by-migration

**In words:** Checks a signature again after others relied on it; if the signer moves its account to real code in between, whoever relied on it loses.

A party signs once. Later, when someone else has already acted on that signature, the contract recovers it: to
approve a group's result, to judge a challenge against it, to pay a seller who has already delivered. The first step
can be off chain: a voucher or a channel state that another party holds and acted on counts like a signature checked
on chain before, and one on-chain check, when that party redeems or answers, is enough. A signature checked in the
same call that uses it (a permit, a quote) is not this pattern. The later check reads the signer's account code at
that time. Under EIP-8151 it returns no address once the signer's account has real code, so a signature that was
valid when others relied on it fails afterwards. The loss falls on whoever relied on it: an honest submitter is judged
malicious, a seller who delivered is not paid while the buyer gets a refund, a payee's voucher no longer pays. The
signer can cause this on purpose by migrating between the two steps. Unlike PQ-14, nothing happens on activation day;
it starts when a signer's account takes real code. When the signer can already take back what the other party relies
on without migrating, migrating adds nothing: a migration notice ("Choosing between patterns").

**Detection:** the same signer's signature relied on at one step and checked on chain at a later one (lock and
settle, submit and approve or challenge, a voucher redeemed, a channel state disputed), often with a fallback when
the later check fails (a refund, a rejection, a punishment). Confirmed by replaying the later step with code at the
signer.

## PQ-16: One's own ECDSA signature is the only way out

**Class:** migration-hazard

**Category:** migration-notice

**In words:** Only the account's own signature releases its funds or rights; if the account moves to real code first, they stay locked.

A contract holds a user's own funds (a stake, a deposit, an escrowed amount) or a right of that user (to raise a
dispute, to change a payee) and lets the user act only with an ECDSA signature that must recover to the user's own
address. Calling the function directly is not enough, and there is no ERC-1271 path. Under EIP-8151 the signature
stops recovering once the user's account has real code. A user who migrates before acting loses the funds or the
right, and nobody can act for it unless an administrator can. Acting before migrating avoids it; the contract itself
changes only by an upgrade or an administrator.

**Detection:** a function that moves a user's own balance, or exercises a user's right, where the recovered address
must equal the user named in the call or the caller, and no other function reaches the same effect. Confirmed by
replaying a real call with code at the user.

## PQ-17: A trusted signer key its holder must rotate, or a new deployment replace, before migrating

**Class:** migration-hazard

**Category:** migration-notice

**In words:** Trusts one signing key, or a set of them; if a holder moves that account to real code, the contract refuses it until the key is replaced.

The contract accepts a signature only from a key it trusts: one stored and replaceable by a function, replaceable
only by an upgrade, or fixed in its code at deployment. A wallet's signer set, an operator that signs quotes, claims
or withdrawals. Under EIP-8151 that key stops working once its account takes real code. Where a function can replace
the key, its holder only has to rotate before migrating; otherwise the wallet locks or the service stops for everyone
who depends on it, until an upgrade or a new deployment.

**Detection:** the recovered address is compared with a stored value (and the function that writes it, if any), an
immutable, or a constant. Confirmed by replaying a real call with code at the signer.

## PQ-18: Gas limits chosen before the price changes

**Class:** regression

**Category:** breaks-at-activation

**In words:** A transaction or signed operation with a tight gas limit runs out of gas once each signature check costs more.

A transaction or a signed operation carries a gas limit chosen for today's price: a sender with no margin, a relayer's
fixed limit, an ERC-4337 verification limit the user signed. Under EIP-8151 each recovery costs up to 3,100 gas more,
and such a limit fails on activation day although the contract is unchanged. Whoever sets the limit fixes it; a signed
limit needs a new signature.

**Detection:** a real transaction that fails under EIP-8151 as sent and succeeds with a higher gas limit.

## PQ-19: A signed shortcut that a migrated signer loses

**Class:** migration-hazard

**Category:** migration-notice

**In words:** A signed shortcut (a permit, a signed order, a relayed call) stops working for an account with real code; the direct call still works.

A user can act through an ECDSA signature (a permit, a signed order, a relayed call) and the same act stays open by a
direct call. Under EIP-8151 a user whose account has real code loses the signed path and keeps the direct one. Nothing
is locked; gasless and relayed flows stop for that user.

**Detection:** a function whose recovered address must equal a named user, next to a direct function for the same
act.

## PQ-20: Account logic that accepts only the account's own key

**Class:** migration-hazard

**Category:** migration-notice

**In words:** An account's own logic accepts only its own key; once the account has real code, those signatures stop counting.

EIP-7702 delegate code that authorises an action only when the recovered address is the account itself. As a 7702
delegation it keeps working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code
can no longer authorise anything through it, and an account with code cannot send transactions (EIP-3607), so what it
holds is locked. The account avoids it by keeping the delegation, or by moving to logic with another key.

**Detection:** the recovered address is compared with the address the code runs at, and no stored key or ERC-1271
path stands beside it. Confirmed by replaying a real transaction with the delegate's code placed at the account.

## PQ-21: Entry only by one's own signature

**Class:** migration-hazard

**Category:** migration-notice

**In words:** Joining or registering needs the account's own signature; an account with real code can no longer join.

Registering, joining or placing an order requires an ECDSA signature of the entrant, and no direct call does the same.
Under EIP-8151 an account with real code can no longer enter. Nothing it already holds is affected.

**Detection:** a function whose recovered address becomes the participant, with no function that registers the caller.
