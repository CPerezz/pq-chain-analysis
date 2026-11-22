---
id: plonkverifierfull-0b3943f4-bn254-plonk-proof
format: 2
title: Linea's rollup finalizes state on proofs a quantum computer could forge
status: confirmed
severity: LOW
justification: A forged proof could release bridged ETH and tokens; a 5-of-9 Safe can switch the verifiers by a
  setting.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0b3943f4b1397c7a9f268d8b84f127a78c66414c'
  name: PlonkVerifierFull
  project: linea
  code: verified
  code_url: https://etherscan.io/address/0x0b3943f4b1397c7a9f268d8b84f127a78c66414c#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  whose: users
  basis: held
activity:
  txs_90d: 12
impact: funds-loss
action: Replace or unset the verifier of every proof type that is set (0 and 1), with setVerifierAddress through
  the timelock.
evidence_level: source
checks:
- id: rmod
  source: '0x0b3943f4b1397c7a9f268d8b84f127a78c66414c'
  file: src/verifiers/PlonkVerifierFull.sol
  line: 25
  has: uint256 private constant R_MOD = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
  says: the verifier works over the BN254 scalar field
  for:
  - evidence-1
  - what
- id: srs
  source: '0x0b3943f4b1397c7a9f268d8b84f127a78c66414c'
  file: src/verifiers/PlonkVerifierFull.sol
  line: 35
  has: uint256 private constant G2_SRS_1_X_0 =
  says: the setup's public G2 point is a constant in the code
  for:
  - evidence-1
  - justification
  - what
- id: srs-use
  source: '0x0b3943f4b1397c7a9f268d8b84f127a78c66414c'
  file: src/verifiers/PlonkVerifierFull.sol
  line: 894
  has: the 4 lines are the canonical G2 point on BN254
  says: the final check uses the fixed setup points on BN254
  for:
  - evidence-1
  - what
- id: pairing
  source: '0x0b3943f4b1397c7a9f268d8b84f127a78c66414c'
  file: src/verifiers/PlonkVerifierFull.sol
  lines:
  - 914
  - 919
  has: let l_success := staticcall(gas(), 8, mPtr, 0x180, 0x00, 0x20)
  says: the proof is accepted by a pairing check (precompile 0x08), whose result is stored as the outcome
  for:
  - evidence-1
  - justification
  - what
- id: verdict
  source: '0x0b3943f4b1397c7a9f268d8b84f127a78c66414c'
  file: src/verifiers/PlonkVerifierFull.sol
  line: 231
  has: success := mload(add(mem, STATE_SUCCESS))
  says: Verify returns the pairing outcome
  for:
  - evidence-1
  - what
- id: in-use
  call: '0xd19d4b5d358258f05d7b411e21a1460d11b0876f'
  fn: verifiers(uint256)(address)
  args:
  - 0
  is: '0x0b3943f4b1397c7a9f268d8b84f127a78c66414c'
  says: LineaRollup's verifier for proof type 0 is this address
  for:
  - action
  - evidence-2
  - justification
  - what
- id: pick
  source: '0x052b73d934e9412045bf731574463fd026d74645'
  file: src/rollup/LineaRollupBase.sol
  line: 377
  has: address verifier = verifiers[_proofType];
  says: finalizeBlocks takes the verifier set for the proof type
  for:
  - evidence-2
  - what
- id: call-verify
  source: '0x052b73d934e9412045bf731574463fd026d74645'
  file: src/rollup/LineaRollupBase.sol
  line: 714
  has: abi.encodeCall(IPlonkVerifier.Verify, (_proof, publicInput))
  says: the rollup calls Verify with the proof
  for:
  - evidence-2
  - what
- id: need-true
  source: '0x052b73d934e9412045bf731574463fd026d74645'
  file: src/rollup/LineaRollupBase.sol
  lines:
  - 739
  - 741
  has: if (!proofSucceeded) {
  says: finalization reverts unless Verify returns true
  for:
  - justification
  - what
- id: operator-only
  source: '0x052b73d934e9412045bf731574463fd026d74645'
  file: src/rollup/LineaRollupBase.sol
  line: 363
  has: onlyRole(OPERATOR_ROLE)
  says: finalizeBlocks needs the operator role
  for:
  - what
- id: roots
  source: '0x052b73d934e9412045bf731574463fd026d74645'
  file: src/rollup/LineaRollupBase.sol
  line: 487
  has: _addL2MerkleRoots(_finalizationData.l2MerkleRoots, _finalizationData.l2MerkleTreesDepth);
  says: a finalization records the L2 withdrawal message roots it carries
  for:
  - what
- id: claim-root
  source: '0x052b73d934e9412045bf731574463fd026d74645'
  file: src/messaging/l1/L1MessageService.sol
  line: 105
  has: uint256 merkleDepth = l2MerkleRootsDepths[_params.merkleRoot];
  says: a claim is accepted against a recorded root
  for:
  - evidence-3
  - what
- id: claim-pay
  source: '0x052b73d934e9412045bf731574463fd026d74645'
  file: src/messaging/l1/L1MessageService.sol
  line: 140
  has: '_params.to.call{ value: _params.value }(_params.data);'
  says: a claim pays the message's ETH to its recipient
  for:
  - evidence-3
  - what
  - whose
- id: claim-limit
  source: '0x052b73d934e9412045bf731574463fd026d74645'
  file: src/messaging/l1/L1MessageService.sol
  line: 117
  has: _addUsedAmount(_params.fee + _params.value);
  says: each claim's ETH counts against the rate limit
  for:
  - evidence-3
- id: limit-code
  source: '0x052b73d934e9412045bf731574463fd026d74645'
  file: src/security/limiting/RateLimiter.sol
  lines:
  - 68
  - 69
  has: if (_usedAmount > limitInWei) {
  says: claims beyond the period's limit revert
  for:
  - evidence-3
- id: limit
  call: '0xd19d4b5d358258f05d7b411e21a1460d11b0876f'
  fn: limitInWei()(uint256)
  is: '10000000000000000000000'
  says: the limit is 10,000 ETH per period
  for:
  - evidence-3
- id: period
  call: '0xd19d4b5d358258f05d7b411e21a1460d11b0876f'
  fn: periodInSeconds()(uint256)
  is: 86400
  says: the period is 86,400 seconds, one day
  for:
  - evidence-3
- id: rollup-eth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0xd19d4b5d358258f05d7b411e21a1460d11b0876f'
  is: '19601305326751871868276'
  says: LineaRollup holds 19,601.3 ETH
  for:
  - what
- id: finalize-tx
  tx: '0xb7f185e250324aa3e89e4e0e7f85e1454cb16414d768a66002ba45e32a92e3ce'
  to: '0xd19d4b5d358258f05d7b411e21a1460d11b0876f'
  ok: true
  says: the latest finalization before the block (finalizeBlocks, proof type 0 in its calldata) succeeded
  for:
  - evidence-2
- id: operator-role
  call: '0xd19d4b5d358258f05d7b411e21a1460d11b0876f'
  fn: hasRole(bytes32,address)(bool)
  args:
  - '0x97667070c54ef182b0f5858b034beac1b6f3089aa2d3188bb1e8929f4fa9b929'
  - '0x52ff08f313a00a54e3beffb5c4a7f7446efb6754'
  is: true
  says: 0x52ff…6754, the sender of that finalization, holds the operator role
  for:
  - what
- id: operator-eoa
  code: '0x52ff08f313a00a54e3beffb5c4a7f7446efb6754'
  is: empty
  says: the operator is an account without code, so an ECDSA key
  for:
  - what
- id: operator-nonce
  nonce: '0x52ff08f313a00a54e3beffb5c4a7f7446efb6754'
  is: 7326
  says: the operator key has signed 7,326 transactions, so its public key is public
  for:
  - what
- id: setter
  source: '0x052b73d934e9412045bf731574463fd026d74645'
  file: src/rollup/LineaRollupBase.sol
  line: 288
  has: function setVerifierAddress(address _newVerifierAddress, uint256 _proofType) external onlyRole(VERIFIER_SETTER_ROLE)
    {
  says: the verifier setter role can set a proof type's verifier
  for:
  - action
  - evidence-2
  - justification
- id: setter-write
  source: '0x052b73d934e9412045bf731574463fd026d74645'
  file: src/rollup/LineaRollupBase.sol
  line: 295
  has: verifiers[_proofType] = _newVerifierAddress;
  says: setVerifierAddress replaces the verifier
  for:
  - action
  - evidence-2
- id: setter-role
  call: '0xd19d4b5d358258f05d7b411e21a1460d11b0876f'
  fn: hasRole(bytes32,address)(bool)
  args:
  - '0x32937fd5162e282df7e9a14a5073a2425321c7966eaf70ed6c838a1006d84c4c'
  - '0xd6b95c960779c72b8c6752119849318e5d550574'
  is: true
  says: the timelock 0xd6b9…0574 holds the verifier setter role
  for:
  - action
  - evidence-2
  - justification
- id: delay
  call: '0xd6b95c960779c72b8c6752119849318e5d550574'
  fn: getMinDelay()(uint256)
  is: 0
  says: the timelock's minimum delay is zero
  for:
  - action
  - evidence-2
  - justification
- id: proposer
  call: '0xd6b95c960779c72b8c6752119849318e5d550574'
  fn: hasRole(bytes32,address)(bool)
  args:
  - '0xb09aa5aeb3702cfd50b6b62bc4532604938f21248a27a1d5ca736082b6819cc1'
  - '0x892bb7eed71efb060ab90140e7825d8127991dd3'
  is: true
  says: the Safe can propose to the timelock
  for:
  - evidence-2
  - justification
- id: executor
  call: '0xd6b95c960779c72b8c6752119849318e5d550574'
  fn: hasRole(bytes32,address)(bool)
  args:
  - '0xd8aa0f3194971a2a116679f7c2090f6939c8d4e01a2a8d7e41d55e5351469e63'
  - '0x892bb7eed71efb060ab90140e7825d8127991dd3'
  is: true
  says: the Safe can execute through the timelock
  for:
  - evidence-2
  - justification
- id: threshold
  call: '0x892bb7eed71efb060ab90140e7825d8127991dd3'
  fn: getThreshold()(uint256)
  is: 5
  says: the Safe needs 5 signatures
  for:
  - evidence-2
  - justification
- id: owners
  call: '0x892bb7eed71efb060ab90140e7825d8127991dd3'
  fn: getOwners()(address[])
  is:
  - '0x1f0cdfb6aa74293e06f3a6d3b7958b6d36563c4f'
  - '0xd6481cc92ed746ebc679788654723ce49d45ebea'
  - '0xd30373335c6d71499ee6cdcf832b5bcb731bae8d'
  - '0x535de1e2a961529aa84ef208981f8cf4e7dcbdf5'
  - '0xc263178ac471c4411abaf5c22cd4d8d67033bc82'
  - '0x9376c137af5124ffc39bd8940a3d88d1cd508992'
  - '0x4cb4da1d1c198e506031c0aa8480ba8b57c0fad4'
  - '0x0f4df4939a6b126a088a40b4bbf9f30337acbfe4'
  - '0xb4daebe4d01f467701f95f0196fc29033c54dbcb'
  says: the Safe has 9 owners
  for:
  - evidence-2
  - justification
- id: unsetter
  call: '0xd19d4b5d358258f05d7b411e21a1460d11b0876f'
  fn: hasRole(bytes32,address)(bool)
  args:
  - '0x6b5661ddfbd1fbd525c902a513e0f47d9c74f1c1ee8a2d4f1937ad305fb8f41a'
  - '0x892bb7eed71efb060ab90140e7825d8127991dd3'
  is: true
  says: the Safe can also unset a verifier directly
  for:
  - notes
- id: project
  source: '0x0b3943f4b1397c7a9f268d8b84f127a78c66414c'
  file: src/verifiers/interfaces/IPlonkVerifier.sol
  line: 7
  has: security-report@linea.build
  says: the verified source names Linea as its security contact
  for:
  - notes
- id: no-ecrecover
  source: '0x0b3943f4b1397c7a9f268d8b84f127a78c66414c'
  file: src/verifiers/PlonkVerifierFull.sol
  lines:
  - 167
  - 171
  has: uint8 private constant EC_PAIR = 0x8;
  says: the precompiles it uses are SHA-256, modexp and the BN254 curve operations; it never recovers a signer
  for:
  - notes
- id: v1
  call: '0xd19d4b5d358258f05d7b411e21a1460d11b0876f'
  fn: verifiers(uint256)(address)
  args:
  - 1
  is: '0x1d930e3fac9fbc7026ec17962d2f57d558d37532'
  says: proof type 1 is set to another verifier
  for:
  - action
- id: v1-srs
  source: '0x1d930e3fac9fbc7026ec17962d2f57d558d37532'
  file: src/verifiers/PlonkVerifierFull.sol
  line: 35
  has: uint256 private constant G2_SRS_1_X_0 = 15805639136721018565402881920352193254830339253282065586954346329754995870280;
  says: type 1's verifier is a PlonkVerifierFull with the same G2 setup point
  for:
  - action
- id: v1-pair
  source: '0x1d930e3fac9fbc7026ec17962d2f57d558d37532'
  file: src/verifiers/PlonkVerifierFull.sol
  lines:
  - 914
  - 919
  has: let l_success := staticcall(gas(), 8, mPtr, 0x180, 0x00, 0x20)
  says: type 1's verifier also ends in a BN254 pairing
  for:
  - action
- id: type-arg
  source: '0x052b73d934e9412045bf731574463fd026d74645'
  file: src/rollup/LineaRollupBase.sol
  lines:
  - 361
  - 363
  has: uint256 _proofType, FinalizationDataV4 calldata _finalizationData ) external virtual whenTypeAndGeneralNotPaused(PauseType.FINALIZATION)
    onlyRole(OPERATOR_ROLE)
  says: the operator passes the proof type
  for:
  - action
- id: unset-fn
  source: '0x052b73d934e9412045bf731574463fd026d74645'
  file: src/rollup/LineaRollupBase.sol
  line: 303
  has: function unsetVerifierAddress(uint256 _proofType) external onlyRole(VERIFIER_UNSETTER_ROLE) {
  says: a proof type can be unset
  for:
  - action
- id: unsetter-role
  call: '0xd19d4b5d358258f05d7b411e21a1460d11b0876f'
  fn: hasRole(bytes32,address)(bool)
  args:
  - '0x6b5661ddfbd1fbd525c902a513e0f47d9c74f1c1ee8a2d4f1937ad305fb8f41a'
  - '0x892bb7eed71efb060ab90140e7825d8127991dd3'
  is: true
  says: the Safe can unset a proof type directly
  for:
  - action
- id: tb-ms
  call: '0x051f1d88f0af5763fb888ec4378b4d8b29ea3319'
  fn: messageService()(address)
  is: '0xd19d4b5d358258f05d7b411e21a1460d11b0876f'
  says: the TokenBridge trusts LineaRollup's messages
  for:
  - evidence-3
  - what
- id: tb-complete
  source: '0xf0e003f0de2d583ae28fa8cbf66aa096cdace3ff'
  file: src/bridging/token/TokenBridgeBase.sol
  lines:
  - 332
  - 339
  has: ) public virtual nonReentrant onlyMessagingService onlyAuthorizedRemoteSender whenTypeAndGeneralNotPaused(PauseType.COMPLETE_TOKEN_BRIDGING)
    {
  says: 'completeBridging is not payable: its message carries 0 ETH, nothing counted'
  for:
  - evidence-3
- id: tb-pay
  source: '0xf0e003f0de2d583ae28fa8cbf66aa096cdace3ff'
  file: src/bridging/token/TokenBridgeBase.sol
  line: 364
  has: IERC20Upgradeable(_nativeToken).safeTransfer(_recipient, _amount);
  says: it pays out held tokens
  for:
  - evidence-3
  - what
  - whose
- id: tb-nolimit
  selector: '0xf0e003f0de2d583ae28fa8cbf66aa096cdace3ff'
  fn: limitInWei()
  absent: true
  says: the TokenBridge has no rate limiter of its own
  for:
  - evidence-3
- id: tb-usdt
  call: '0xdac17f958d2ee523a2206206994597c13d831ec7'
  fn: balanceOf(address)(uint256)
  args:
  - '0x051f1d88f0af5763fb888ec4378b4d8b29ea3319'
  is: '6917913837545'
  says: 6.92M USDT in the TokenBridge
  for:
  - evidence-3
  - what
- id: tb-wsteth
  call: '0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0'
  fn: balanceOf(address)(uint256)
  args:
  - '0x051f1d88f0af5763fb888ec4378b4d8b29ea3319'
  is: '674111511271651093295'
  says: 674 wstETH in the TokenBridge
  for:
  - evidence-3
  - what
- id: tb-wbtc
  call: '0x2260fac5e5542a773aa44fbcfedf7c193bc2c599'
  fn: balanceOf(address)(uint256)
  args:
  - '0x051f1d88f0af5763fb888ec4378b4d8b29ea3319'
  is: '2896522871'
  says: 28.97 WBTC in the TokenBridge
  for:
  - evidence-3
  - what
- id: tb-dai
  call: '0x6b175474e89094c44da98b954eedeac495271d0f'
  fn: balanceOf(address)(uint256)
  args:
  - '0x051f1d88f0af5763fb888ec4378b4d8b29ea3319'
  is: '98806837576125836130743'
  says: 98.8K DAI in the TokenBridge
  for:
  - evidence-3
  - what
- id: ym
  call: '0xd19d4b5d358258f05d7b411e21a1460d11b0876f'
  fn: yieldManager()(address)
  is: '0xeb63cabdd78537b9b72a2afb573f7caa91bd8d94'
  says: the rollup's yield manager
  for:
  - evidence-3
- id: ym-funds
  call: '0xeb63cabdd78537b9b72a2afb573f7caa91bd8d94'
  fn: userFundsInYieldProvidersTotal()(uint256)
  is: '11812568382231569091716'
  says: 11,813 ETH of users' funds staked through it
  for:
  - evidence-3
  - what
  - whose
- id: lst-path
  source: '0x052b73d934e9412045bf731574463fd026d74645'
  file: src/rollup/LineaRollupYieldExtension.sol
  lines:
  - 147
  - 155
  has: IYieldManager(yieldManager()).withdrawLST(_yieldProvider, _params.value, _params.to);
  says: a claim beyond the rollup's balance is paid as LST
  for:
  - evidence-3
- id: claim-open
  source: '0x052b73d934e9412045bf731574463fd026d74645'
  file: src/messaging/l1/L1MessageService.sol
  lines:
  - 92
  - 94
  has: function claimMessageWithProof( ClaimMessageWithProofParams calldata _params ) public virtual nonReentrant
    distributeFees
  says: anyone can claim
  for:
  - evidence-3
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: review (Review12)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

Linea's rollup records L2 state and withdrawal roots once this contract accepts a BN254 PLONK proof. A quantum computer could derive the setup secret from points in its code; with it and an operator key, false withdrawals pass. At stake: the rollup's 19,601 ETH and the token bridge's tokens.

## Evidence

- [Verify](https://etherscan.io/address/0x0b3943f4b1397c7a9f268d8b84f127a78c66414c#code) ends in a pairing check against setup points fixed in its code, on the BN254 curve.
- LineaRollup uses it for proof type 0, the type of its [latest finalization](https://etherscan.io/tx/0xb7f185e250324aa3e89e4e0e7f85e1454cb16414d768a66002ba45e32a92e3ce); a 5-of-9 [Safe](https://etherscan.io/address/0x892bb7eed71efb060ab90140e7825d8127991dd3) sets verifiers through a timelock with no delay.
- Forged roots release ETH, capped at 10,000 a day, and the [token bridge](https://etherscan.io/address/0x051f1d88f0af5763fb888ec4378b4d8b29ea3319)'s tokens, with no cap: 6.92M USDT, 674 wstETH, 28.97 WBTC.

## Reviewer notes

### Mechanism

LineaRollup (proxy 0xd19d4b5d, implementation 0x052b73d9) finalizeBlocks (LineaRollupBase lines 359-403, onlyRole(OPERATOR_ROLE)) takes verifiers[_proofType] (line 377), computes one public input (reduced mod the BN254 field, line 698) and _verifyProof (lines 709-743) calls Verify on it, reverting unless it returns true. _finalizeBlocks records the L2 message roots (line 487) and state root (line 490). claimMessageWithProof (L1MessageService lines 92-150) accepts a Merkle proof against a recorded root and pays the message's ETH, counted against a 10,000 ETH per day limit (RateLimiter; claims carrying no ETH are not counted, line 61). This verifier (PlonkVerifierFull, gnark output, no admin, not a proxy) checks the proof over BN254 and ends in a KZG pairing check (line 914) against G2 setup points fixed as constants (lines 30-38). A quantum computer that derives the setup trapdoor from those public points can make a proof of a false public input pass; finalizeBlocks also needs the operator role, held by EOA 0x52ff08f3 (7,326 transactions sent, public key exposed). The verifier cannot change, but LineaRollup's VERIFIER_SETTER_ROLE (held by TimeLock 0xd6b95c96, delay 0, proposer and executor the Safe 0x892bb7ee, 5 of 9, v1.4.1) can repoint proof type 0, and the Safe holds VERIFIER_UNSETTER_ROLE to unset it at once.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an unused implementation or retired copy: verifiers(0) on LineaRollup is this address at the block, and the latest finalizeBlocks before it (tx 0xb7f185e2, block 26,438,921, calldata proof type 0) used it.
- Ruled out: an EIP-8151 effect: the code calls only SHA-256, modexp and the BN254 precompiles (lines 166-171, 478, 865, 914); it recovers no signer.
- Ruled out: a fault usable today: none found; forging needs the setup trapdoor, which takes a quantum computer.
- Ruled out: a second way to finalize: stateRootHashes and the L2 message roots are written only by _finalizeBlocks (called from finalizeBlocks) and by initialization; a proxy upgrade of LineaRollup is outside this card.
- Ruled out: rating: old MEDIUM rated LOW here, because the fix is one setting changed by one multisig (team multisig changing a setting is LOW).
- Ruled out: fixing type 0 alone: proof type 1 is set to a second PlonkVerifierFull (0x1d930e3f…) with the same G2 setup point, and the operator picks the type.
- Ruled out: a total cap: the daily limit counts only a claim's ETH; token claims through the TokenBridge are not limited, and ETH beyond the rollup's balance is paid as LST from 11,813 ETH staked through the YieldManager.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
