---
id: railgun-groth16-verifier
title: "Railgun: a forged Groth16 proof unshields any token from the RailgunSmartWallet pool (USD 103M); the fix is a DAO-voted upgrade"
project: railgun
status: confirmed
severity: MEDIUM
patterns: [PQ-7]
primitives: [bn254]
trigger: trusted-setup
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0xfa7093cdd9ee6932b4eb2c9e1cde7ce00b1fa4b9"
  implementation: "0xd662c4b1f22aceb0beacdf3a493de6f478686a0c"
  name: RailgunSmartWallet (PausableUpgradableProxy)
  upgradeable: "yes"
  admin: "ProxyAdmin 0x4f8e20f55f879bee7bc010bd6bd2138b34ac65c8 and contract owner both = Delegator 0xb6d513f6222ee92fff975e901bd792e2513fb53b, owned by Railgun Voting 0xc480f68a3dcc3edd82134fab45c14a0fcf1da3cc (read at block 26431725)"
  value_usd: 102510746
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 12373
families: []
fix:
  layer: contract-upgrade
  who_acts: "Railgun DAO: a proposal in Voting 0xc480f68a3dcc3edd82134fab45c14a0fcf1da3cc (2M RAIL quorum, about 7-14 days) executed through Delegator 0xb6d513f6222ee92fff975e901bd792e2513fb53b on ProxyAdmin 0x4f8e20f55f879bee7bc010bd6bd2138b34ac65c8; plus new circuits and a post-quantum verifier from the developers"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/railgun-groth16-verifier
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: review (Review01)
  ref: findings/railgun-groth16-verifier.md
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: []
---

## Summary

Railgun's shielded pool `RailgunSmartWallet` holds every shielded token itself (USD 103M on 2026-11-17, mostly WETH,
USDT and USDC) and releases it on a Groth16 proof over BN254 (PQ-7). A quantum attacker who recovers the setup
trapdoor from the verifying keys can prove a spend of notes that do not exist and unshield the whole pool to any
address. The verification scheme is fixed in the implementation; replacing it needs new circuits and a contract
upgrade, which only the Railgun DAO can pass by token vote. Rated MEDIUM (step 4: fix by a governance-voted upgrade).

## Mechanism

- `RailgunSmartWallet.transact(Transaction[])` loops over transactions, calls `RailgunLogic.validateTransaction`, then
  `accumulateAndNullifyTransaction` and, for an unshield, transfers the token out of the contract.
- `validateTransaction` → `Verifier.verify(_transaction)` (`contracts/logic/Verifier.sol` line 87) looks up the
  verifying key for the circuit size and calls `verifyProof` → `Snark.verify(vk, proof, inputs)`, a Groth16 check whose
  `pairing` calls the BN254 pairing precompile (`staticcall(..., 8, ...)`, `Snark.sol` line 132). Spend authority
  (the note owner's EdDSA/BabyJubJub signature) and Merkle membership are proved inside the circuit, so a forged proof
  bypasses both.
- `Verifier.setVerificationKey` (line 35, `onlyOwner`) can change the keys but not the proof system; new trusted-setup
  keys would be just as forgeable.

Source excerpts: [`source-excerpts.md`](#source-excerpts-railgun-groth16-verifier).

## Evidence

- CHECKED (verified source, Sourcify): implementation `0xd662c4b1…` (`RailgunSmartWallet`, `RailgunLogic`,
  `Verifier`, `Snark`) as quoted; Railgun `Voting` and `Delegator` (`0xc480f68a…`, `0xb6d513f6…`); `VKeySetter`.
- CHECKED (block 26,431,725): proxy implementation slot `0xd662c4b1…`, admin slot ProxyAdmin `0x4f8e20f5…`;
  `owner()` of the proxy and of the ProxyAdmin = Delegator `0xb6d513f6…`; Delegator `owner()` = Voting `0xc480f68a…`.
- CHECKED (Delegator `GrantPermission`/`RevokePermission` logs, eth_getLogs blocks 14,000,000–26,431,700): the only
  standing delegated permissions on this proxy are `setVerificationKey` for two `VKeySetter` contracts
  (`0x9086afc6…`, `0x64da0892…`); committing keys through them needs the Delegator (`stateToCommitting` is
  `onlyDelegator`). Pause/unpause permissions on the ProxyAdmin were revoked at block 14,737,691. No address other than
  Voting can upgrade.
- CHECKED (Voting source): proposals need a 500k RAIL sponsor, a 2M RAIL quorum, and execute 7–14 days after creation.
- CHECKED (block 26,431,214, [`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/railgun-groth16-verifier/onchain.json)): holdings USD 102.5M
  (WETH 40.0M, USDT 34.6M, USDC 16.1M, DAI 4.9M, NEAR 2.6M, others).
- CHECKED (Xatu, [`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/railgun-groth16-verifier/activity.json)): 12,373 transactions in
  2026-10-16 to 2026-11-16.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xfa7093cd…` RailgunSmartWallet | yes (DAO vote) | USD 102.5M (held) | 2026-11-16 | 12,373 |

The pool is its own escrow: shielded tokens sit in the proxy, so `held` is the exposure. Railgun forks (DOP,
`zkgarden-groth16-verifier`) are separate deployments with their own findings.

## Remediation

- Replacement: transaction circuits proved with a hash-based system (STARK/FRI or WHIR) and an on-chain verifier for
  it; spend authorisation inside the circuit moved off BabyJubJub EdDSA to a post-quantum scheme. New verifying keys
  alone do not help.
- Who acts: Railgun developers write the circuits and implementation; the DAO passes the upgrade through Voting
  `0xc480f68a3dcc3edd82134fab45c14a0fcf1da3cc` → Delegator `0xb6d513f6222ee92fff975e901bd792e2513fb53b` → ProxyAdmin
  `0x4f8e20f55f879bee7bc010bd6bd2138b34ac65c8`. Existing notes must be carried into the new proof system (or users
  unshield and reshield).
- No protocol change is needed. Users can only reduce their own exposure by unshielding.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review01): MEDIUM kept, step 4: upgrade path read on-chain (ProxyAdmin and owner = Delegator owned by DAO Voting; no other upgrader); scheme fixed in the implementation, so only an upgrade fixes it.

# Source excerpts: railgun-groth16-verifier

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xfa7093cdd9ee6932b4eb2c9e1cde7ce00b1fa4b9` — PausableUpgradableProxy (verified source via sourcify)

## Implementation `0xd662c4b1f22aceb0beacdf3a493de6f478686a0c` — RailgunSmartWallet (verified source via sourcify)

### `contracts/logic/RailgunLogic.sol`

```solidity
  468          return (false, "Invalid Note Ciphertext Array Length", "");
  469      }
  470  
  471      // Verify SNARK proof and get bound params hash
  472      (bool valid, bytes32 boundParamsHash) = Verifier.verify(_transaction);
  473      if (!valid) return (false, "Invalid Snark Proof", "");
  474  
  475      return (true, '', boundParamsHash);
  476    }
  ...
```

### `contracts/logic/Snark.sol`

```solidity
   86     * For example,
   87     * pairing([P1(), P1().negate()], [P2(), P2()]) should return true.
   88     * @return if pairing check passed
   89     */
   90    function pairing(
   91      G1Point memory _a1,
   92      G2Point memory _a2,
   93      G1Point memory _b1,
   94      G2Point memory _b2,
  ...
  132        success := staticcall(sub(gas(), 2000), 8, input, PAIRING_INPUT_WIDTH, out, 0x20)
  133      }
  134  
  135      // Check if operation succeeded
  136      require(success, "Snark: Pairing Verification Failed");
  137  
  138      return out[0] != 0;
  139    }
  140  
  ...
  143     * @param _vk - Verification Key
  144     * @param _proof - snark proof
  145     * @param _inputs - inputs
  146     */
  147    function verify(
  148      VerifyingKey memory _vk,
  149      SnarkProof memory _proof,
  150      uint256[] memory _inputs
  151    ) internal view returns (bool) {
  ...
  165      vkX = add(vkX, _vk.ic[0]);
  166  
  167      // Verify pairing and return
  168      return
  169        pairing(
  170          negate(_proof.a),
  171          _proof.b,
  172          _vk.alpha1,
  173          _vk.beta2,
  ...
```

### `contracts/logic/Verifier.sol`

```solidity
   70     * @param _proof - proof to verify
   71     * @param _inputs - input to verify
   72     * @return proof validity
   73     */
   74    function verifyProof(
   75      VerifyingKey memory _verifyingKey,
   76      SnarkProof calldata _proof,
   77      uint256[] memory _inputs
   78    ) public view returns (bool) {
   79      return Snark.verify(_verifyingKey, _proof, _inputs);
   80    }
   81  
   82    /**
   83     * @notice Verifies a transaction
   84     * @param _transaction to verify
   85     * @return transaction validity
   86     */
   87    function verify(Transaction calldata _transaction) public view returns (bool, bytes32) {
   88      uint256 nullifiersLength = _transaction.nullifiers.length;
   89      uint256 commitmentsLength = _transaction.commitments.length;
   90  
   91      // Retrieve verification key
  ...
  111        inputs[2 + nullifiersLength + i] = uint256(_transaction.commitments[i]);
  112      }
  113  
  114      // Verify snark proof
  115      bool validity = verifyProof(verifyingKey, _transaction.proof, inputs);
  116  
  117      // Always return true in gas estimation transaction
  118      // This is so relayer fees can be calculated without needing to compute a proof
  119      // solhint-disable-next-line avoid-tx-origin
  ...
```

### `@openzeppelin/contracts/token/ERC20/extensions/IERC20Permit.sol`

```solidity
   62       * section].
   63       *
   64       * CAUTION: See Security Considerations above.
   65       */
   66      function permit(
   67          address owner,
   68          address spender,
   69          uint256 value,
   70          uint256 deadline,
  ...
```

### `@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol`

```solidity
  102          bytes32 r,
  103          bytes32 s
  104      ) internal {
  105          uint256 nonceBefore = token.nonces(owner);
  106          token.permit(owner, spender, value, deadline, v, r, s);
  107          uint256 nonceAfter = token.nonces(owner);
  108          require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
  109      }
  110  
  ...
```
