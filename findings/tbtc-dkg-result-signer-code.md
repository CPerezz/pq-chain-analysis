---
id: tbtc-dkg-result-signer-code
title: "tBTC v2 wallet registry: once EIP-8151 is active, a DKG result that carries a signature of an operator whose address has real code is rejected as malicious, so that group creates no wallet until clients leave such signatures out"
project: tbtc
status: confirmed
severity: LOW
patterns: [PQ-15]
impact: liveness
contracts:
- address: "0x46d52e41c2f300bc82217ce22b920c34995204eb"
  implementation: "0x14fad0c11c83ac736e5929d5661bba7e6bb9c0d6"
  name: WalletRegistry (tBTC v2, EIP-1967 transparent proxy, implementation "V2.1" with approval-time revalidation)
  upgradeable: "yes"
  admin: "ProxyAdmin 0x7affa05f726d293eb1193807a91617318292008e, owned by 0x92f2d8b72a7f6a551be60b9aa4194248e9b4913d (a contract); registry governance 0x6aed6cc30d1b2770771052555d257da86ed47fe8, owned by the Safe 0x9f6e831c8f8939dc0c830c6e492e7cef4f9c2f5f"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-14
  txs_30d: 4
- address: "0x1a5f4f753bd071c907714aefb6e0bcee32401406"
  implementation: null
  name: EcdsaDkgValidator (the "hardened" validator the registry uses at the pinned block)
  upgradeable: "no"
  admin: "none: its only immutable is the sortition pool 0xc2731fb2823af3efc2694c9bc86f444d5c5bb4dc; the registry's proxy admin can point the registry to another validator during an upgrade (initializeV2_1)"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
families: []
fix:
  layer: offchain
  who_acts: "the maintainers of the operator client (keep-core, Threshold Network): leave out signatures of members whose operator address has code, or check the result with isDkgResultValid before submitting it; each operator: move to a fresh operator address instead of putting code at the one it signs with"
evidence:
  level: executed
  block: 26438999
  raw: null
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (verified source read, state read and runs on the exact engine against an archive node; not reviewed by a person)"
  ref: "studies/eip-8151-impact, family c7877dc4 (EcdsaDkgValidator), 2026-11-19"
  date: 2026-11-19
  verdict: reported
  rating: LOW
related: []
---

## Summary

tBTC v2 creates each new Bitcoin wallet by a distributed key generation (DKG) among 100 seats held by operators drawn
from a sortition pool. The result counts only with the members' signatures, and the registry checks them again when
the result is challenged or approved. A result that fails that check is rejected and its submitter is punished. Under
EIP-8151 a member's valid signature recovers to no address once that member's operator address has real code. Run on
the last real result: the real approval reverts, and an approval or a challenge sent by anyone rejects the honest
result and punishes its submitter. Nothing is lost today, because the staking contract's `seize` is a stub that only
emits an event, and a client that leaves such signatures out still reaches the threshold. Until clients do that, a
group with such a member creates no wallet. Rated LOW.

## Mechanism

Pattern PQ-15: the members sign once, off chain; the registry recovers the signatures again at challenge and at
approval, after the submitter has staked its reputation on them.

- The validator recovers each supporting signature and compares it with the operator of the member at that seat. The
  validator in use at the pinned block uses `tryRecover` and returns `false` on any mismatch; the one used until block
  26,409,794 used `recover`, which reverts on a zero address.
- `EcdsaDkg.isResultValid` and `EcdsaDkg.challengeResult` call the validator inside `try`/`catch`; `false` and a revert
  both mean "invalid".
- `approveResult` (deployed implementation) revalidates first; an invalid result is rejected: the DKG goes back to
  awaiting a result and no wallet is created.
- `WalletRegistry.approveDkgResult` and `challengeDkgResult` then punish the submitter through
  `staking.seize(400 T, 100, msg.sender, [submitter's staking provider])`.
- Under EIP-8151 the precompile returns no address for a signer whose account has code other than a 7702 delegation.
  The only way an operator address (an EOA that signs DKG messages) gets such code is the account migration the EIP
  is designed for. From then on every result that carries one of its signatures is invalid, whoever submits it.
- The member can do this on purpose: sign, then migrate during the challenge period (11,520 blocks).

## Evidence

- CHECKED (verified source, Sourcify exact match, implementation `0x14fad0c11c83ac736e5929d5661bba7e6bb9c0d6`,
  `contracts/libraries/EcdsaDkg.sol`), in `approveResult` and `isResultValid`:

  ```
        (bool isValid, string memory errorMsg) = isResultValid(self, result);      // line 372
        if (!isValid) {
            rejectResultAtApproval(self, errorMsg);
            return misbehavedMembers;
        }
  ...
        try
            self.dkgValidator.validate(result, self.seed, self.startBlock)
        returns (bool isValid, string memory errorMsg) {
            return (isValid, errorMsg);
        } catch {
            return (false, "validation reverted");                                 // line 508
        }
  ```

  `challengeResult` (lines 440 to 465) reverts with "unjustified challenge" when the validator returns `true`, and
  emits `DkgResultChallenged` otherwise, including in its `catch`.
- CHECKED (same implementation, `contracts/WalletRegistry.sol`): `approveDkgResult` (line 944) calls
  `_punishMaliciousDkgResultSubmitter` when the DKG is back to `AWAITING_RESULT` after `approveResult` (line 948);
  `challengeDkgResult` (line 1035) always calls it; `_punishMaliciousDkgResultSubmitter` (line 1054) calls
  `staking.seize` with the slashing amount and `msg.sender` as notifier.
- CHECKED (verified source, Sourcify exact match, validator `0x1a5f4f753bd071c907714aefb6e0bcee32401406`,
  `contracts/EcdsaDkgValidator.sol` lines 289 to 297):

  ```
            (address recoveredAddress, ECDSA.RecoverError recoverError) = hash
                .tryRecover(current);

            if (
                recoverError != ECDSA.RecoverError.NoError ||
                signingMemberAddresses[i] != recoveredAddress
            ) {
                return false;
            }
  ```

  A result needs at least 51 signatures (`groupThreshold`), of 100 seats.
- CHECKED (verified source, Sourcify exact match, TokenStaking implementation
  `0x5a444db12705706bd7b24393f823f3a8c67d71fb`, read from the proxy `0x01b67b1194c75264d06f808a921228a95c765dd7` at the
  pinned block): `seize` (lines 486 to 498) only emits `NotificationReceived`. No token moves.
- CHECKED (state at block 26,438,999): registry implementation slot = `0x14fad0c1…`; DKG validator (storage slot 152)
  = `0x1a5f4f75…`, set at block 26,409,794 by the batch that approved the last result (`initializeV2_1`); before that
  it was `0x0125c8977a02b2fa3970b1ed9af02f5bedd4ef27`. `dkgParameters()` = seed timeout 11,520, challenge period
  11,520 blocks, challenge extra gas 50,000, submission timeout 536, submitter precedence 20; slashing amount 400 T.
- CHECKED (logs, one year to the pinned block): 24 DKG rounds started, 10 results submitted and approved, 10 wallets
  created, 14 timed out, no challenge. Last round: started at block 26,307,906, result submitted at 26,307,995
  (`0x993e0f5bad817702f29f292053f787990513d708eaebf0bc6f33836cd1abf151`, by operator
  `0x8bbc75caeafa3020298d924a0958a6a783584e21`), approved at 26,409,794
  (`0xdad127784152301e0be04a5d5bd40d676ab85f4a707331f0b82bd2323d9eab28`, a batch of the governance Safe). The result
  carries 100 signatures from 18 operators; the largest holds 9 seats.
- CHECKED (executed on the exact engine: the reference implementation of the fork with only the precompile changed;
  nothing was sent). One byte of code was placed at operator `0xb71c49e11048bf3d2bc0bab81252334295dee012` (3 seats,
  not the submitter; no code on chain). Rows 2 and 3 are calls that never happened, sent by
  `0x049c418f942c21f5382727c6020a137675059922`, an account outside the group; the result is the one the real
  submission carried. "Validator at the pinned block" places its runtime code at the old validator's address; both
  hold the same sortition pool as their only immutable.

  | Run | Validator | Today's rule | EIP-8151 | EIP-8151, code at one member |
  |---|---|---|---|---|
  | 1. Real approval, block 26,409,794 index 60 | then | success, wallet created (matches the receipt) | success, 84,600 gas more | reverts |
  | 1. Real approval | at the pinned block | success, wallet created | success | reverts |
  | 2. Challenge at block 26,307,996 | then | reverts ("unjustified challenge") | reverts | succeeds: `DkgResultChallenged("validation reverted")`, `DkgMaliciousResultSlashed(400 T, submitter)` |
  | 2. Challenge | at the pinned block | reverts | reverts | succeeds: `DkgResultChallenged("Invalid signatures")`, `DkgMaliciousResultSlashed(400 T, submitter)` |
  | 3. Approval by that account, block 26,409,794 | then | reverts ("Contract is not authorized for a refund") | reverts | succeeds: the same two events, no wallet |
  | 3. Approval by that account | at the pinned block | reverts | reverts | succeeds: the same two events, no wallet |

  The revert reasons of the two "today" calls were read with `eth_call` on the node. Row 3 fails today because the
  reimbursement pool refunds the approver; the real batch authorised the registry on the pool just before approving.
  The rejection path returns before the refund.
- INFERRED (client not read): the operator client checks the members' signatures off chain with plain secp256k1, so
  it would keep submitting a signature from a member whose address has code.

## Impact and exposure

- Nothing can be taken: at the pinned block `seize` moves no tokens and pays no notifier. TokenStaking is behind a
  proxy; if slashing is restored, each rejected result costs its honest submitter up to 400 T.
- Liveness: a group with one member whose operator address has real code gets every result rejected, at challenge or
  at approval, until the submitter leaves that member's signatures out. With them left out the result is valid as long
  as 51 signatures remain (the largest operator of the last group held 9 seats). The round otherwise ends by timeout
  and a new group is drawn.
- A member can turn an honest result into a rejected one by migrating after it signed, during the 11,520 blocks of
  the challenge period.
- Activity: about two DKG rounds a month (24 in the year to the pinned block); 4 transactions emitted a registry
  event in the last 30 days (calls that emit none are not counted). The registry holds no value; it decides which
  wallets the tBTC bridge creates.
- Today no operator address can have such code; it needs the account migration that EIP-8151 is built for.

## Remediation

- The operator client: before submitting, leave out the signatures of members whose operator address has code (or
  call `isDkgResultValid` first and drop failing members). This alone restores liveness.
- Operators: change the operator address to a fresh one instead of putting code at the address that signs DKG
  messages.
- The registry is upgradeable and its validator can be replaced during an upgrade; neither is needed.
- No protocol change is needed. The same remark applies to every protocol that checks a signature again after others
  relied on it: EIP-8151 moves the moment a signature stops counting from "never" to "when the signer migrates".

## History

- 2026-11-19: reported from study `eip-8151-impact`. Found by reading the validator family c7877dc4, then followed to
  the deployed registry and staking contracts; executed on the exact engine against the real last DKG result.
