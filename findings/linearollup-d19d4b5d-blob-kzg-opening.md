---
id: linearollup-d19d4b5d-blob-kzg-opening
format: 2
title: Linea's rollup relies on KZG blob openings that a quantum computer could forge
status: confirmed
severity: MEDIUM
justification: A false blob opening can withhold L2 data; the Security Council can fix it by upgrade, without a
  protocol change.
category: quantum-exposure
pattern: PQ-8
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd19d4b5d358258f05d7b411e21a1460d11b0876f'
  name: LineaRollup
  project: linea
  code: verified
  code_url: https://etherscan.io/address/0x052b73d934e9412045bf731574463fd026d74645#code
  proxy_of: '0x052b73d934e9412045bf731574463fd026d74645'
  copies: 1
  upgradeable: 'yes'
  admin: '0xf5058616517c068c7b8c7ebc69ff636ade9066d6'
value:
  usd: 35371732
  whose: users
  basis: held
activity:
  txs_90d: 7848
impact: funds-locked
action: Prepare an upgrade that posts L2 data as calldata and can switch off blob submission, for use before the
  KZG setup is at risk.
evidence_level: source
checks:
- id: kzg-call
  source: '0x052b73d934e9412045bf731574463fd026d74645'
  file: Eip4844BlobAcceptor.sol
  lines:
  - 114
  - 116
  has: POINT_EVALUATION_PRECOMPILE_ADDRESS.staticcall(
  says: _verifyPointEvaluation calls the point-evaluation precompile with the blob's versioned hash, point, claim,
    commitment and proof
  for:
  - evidence-1
  - justification
  - what
- id: precompile
  source: '0x052b73d934e9412045bf731574463fd026d74645'
  file: LineaRollupBase.sol
  line: 53
  has: POINT_EVALUATION_PRECOMPILE_ADDRESS = address(0x0a);
  says: the call goes to precompile 0x0a, point evaluation
  for:
  - evidence-1
  - what
- id: per-blob
  source: '0x052b73d934e9412045bf731574463fd026d74645'
  file: Eip4844BlobAcceptor.sol
  lines:
  - 60
  - 87
  has: _verifyPointEvaluation(
  says: _submitBlobs opens every blob before it records the resulting shnarf
  for:
  - what
- id: record
  source: '0x052b73d934e9412045bf731574463fd026d74645'
  file: Eip4844BlobAcceptor.sol
  line: 87
  has: _acceptShnarfData(_parentShnarf, _finalBlobShnarf, blobSubmission.finalStateRootHash);
  says: the shnarf built from the opened blobs is recorded
  for:
  - what
- id: shnarf-write
  source: '0x052b73d934e9412045bf731574463fd026d74645'
  file: ShnarfDataAcceptorBase.sol
  line: 27
  has: _blobShnarfExists[_shnarf] = SHNARF_EXISTS_DEFAULT_VALUE;
  says: _acceptShnarfData is where a submitted shnarf is marked as existing
  for:
  - what
- id: final-shnarf
  source: '0x052b73d934e9412045bf731574463fd026d74645'
  file: LineaRollupBase.sol
  lines:
  - 483
  - 485
  has: if (shnarfProvider.blobShnarfExists(finalShnarf) == 0) {
  says: finalizeBlocks reverts unless the final shnarf was recorded by a data submission
  for:
  - evidence-1
  - justification
  - what
- id: provider-self
  call: '0xd19d4b5d358258f05d7b411e21a1460d11b0876f'
  fn: shnarfProvider()(address)
  is: '0xd19d4b5d358258f05d7b411e21a1460d11b0876f'
  says: the shnarf provider finalization asks is this contract itself
  for:
  - evidence-1
  - what
- id: init-done
  storage: '0xd19d4b5d358258f05d7b411e21a1460d11b0876f'
  slot: 0
  is: 9
  says: initialized version is 9, so initialize (version 0 only), the other writer of a shnarf, can no longer run
  for:
  - what
- id: no-calldata
  selector: '0x052b73d934e9412045bf731574463fd026d74645'
  fn: submitDataAsCalldata((bytes32,bytes32,bytes),bytes32,bytes32)
  absent: true
  says: the running code has no calldata data submission
  for:
  - action
  - what
- id: has-submit
  selector: '0x052b73d934e9412045bf731574463fd026d74645'
  fn: submitBlobs((uint256,bytes,bytes,bytes32,bytes32)[],bytes32,bytes32)
  says: the running code has submitBlobs
  for:
  - evidence-3
- id: op-only
  source: '0x052b73d934e9412045bf731574463fd026d74645'
  file: Eip4844BlobAcceptor.sol
  line: 26
  has: onlyRole(OPERATOR_ROLE)
  says: submitBlobs is limited to OPERATOR_ROLE
  for:
  - evidence-2
  - what
- id: op-a-role
  call: '0xd19d4b5d358258f05d7b411e21a1460d11b0876f'
  fn: hasRole(bytes32,address)(bool)
  args:
  - '0x97667070c54ef182b0f5858b034beac1b6f3089aa2d3188bb1e8929f4fa9b929'
  - '0x46d2f319fd42165d4318f099e143dea8124e9e3e'
  is: true
  says: the sender of submitBlobs holds OPERATOR_ROLE
  for:
  - evidence-2
  - what
- id: op-b-role
  call: '0xd19d4b5d358258f05d7b411e21a1460d11b0876f'
  fn: hasRole(bytes32,address)(bool)
  args:
  - '0x97667070c54ef182b0f5858b034beac1b6f3089aa2d3188bb1e8929f4fa9b929'
  - '0x52ff08f313a00a54e3beffb5c4a7f7446efb6754'
  is: true
  says: the sender of finalizeBlocks holds OPERATOR_ROLE
  for:
  - evidence-2
  - what
- id: op-a-code
  code: '0x46d2f319fd42165d4318f099e143dea8124e9e3e'
  is: empty
  says: that operator account has no code
  for:
  - evidence-2
  - what
- id: op-b-code
  code: '0x52ff08f313a00a54e3beffb5c4a7f7446efb6754'
  is: empty
  says: that operator account has no code
  for:
  - evidence-2
  - what
- id: op-a-nonce
  nonce: '0x46d2f319fd42165d4318f099e143dea8124e9e3e'
  min: 1
  says: that operator account has signed transactions, so its public key is on chain
  for:
  - evidence-2
  - what
- id: op-b-nonce
  nonce: '0x52ff08f313a00a54e3beffb5c4a7f7446efb6754'
  min: 1
  says: that operator account has signed transactions, so its public key is on chain
  for:
  - evidence-2
  - what
- id: tx-submit
  tx: '0x69c6e6b2173adf682a80794e7bd85358afa1be5c5f618f63c74ebe02b71e700d'
  to: '0xd19d4b5d358258f05d7b411e21a1460d11b0876f'
  ok: true
  says: a submitBlobs call (selector 0x99467a35) from operator 0x46d2f319 succeeded at block 26,438,920
  for:
  - evidence-3
- id: tx-final
  tx: '0xb7f185e250324aa3e89e4e0e7f85e1454cb16414d768a66002ba45e32a92e3ce'
  to: '0xd19d4b5d358258f05d7b411e21a1460d11b0876f'
  ok: true
  says: a finalizeBlocks call from operator 0x52ff08f3 succeeded at block 26,438,921
  for:
  - evidence-2
- id: not-paused-general
  call: '0xd19d4b5d358258f05d7b411e21a1460d11b0876f'
  fn: isPaused(uint8)(bool)
  args:
  - 1
  is: false
  says: the general pause is off
  for:
  - what
- id: not-paused-data
  call: '0xd19d4b5d358258f05d7b411e21a1460d11b0876f'
  fn: isPaused(uint8)(bool)
  args:
  - 13
  is: false
  says: the state data submission pause is off
  for:
  - what
- id: proof-input
  source: '0x052b73d934e9412045bf731574463fd026d74645'
  file: LineaRollupBase.sol
  line: 642
  has: mstore(add(mPtr, 0x20), _finalShnarf)
  says: the proof's public input contains the final shnarf, so the proof binds the opened claim
  for:
  - what
- id: proof-call
  source: '0x052b73d934e9412045bf731574463fd026d74645'
  file: LineaRollupBase.sol
  lines:
  - 391
  - 402
  has: _verifyProof(
  says: finalizeBlocks verifies a proof for the state it finalizes
  for:
  - what
- id: roots
  source: '0x052b73d934e9412045bf731574463fd026d74645'
  file: LineaRollupBase.sol
  line: 487
  has: _addL2MerkleRoots(_finalizationData.l2MerkleRoots, _finalizationData.l2MerkleTreesDepth);
  says: finalization anchors the L2 message roots that withdrawals are proven against
  for:
  - what
- id: claim-root
  source: '0x052b73d934e9412045bf731574463fd026d74645'
  file: L1MessageService.sol
  lines:
  - 105
  - 136
  has: revert InvalidMerkleProof();
  says: claimMessageWithProof pays only with a Merkle proof against an anchored L2 root
  for:
  - what
- id: claim-pays
  source: '0x052b73d934e9412045bf731574463fd026d74645'
  file: L1MessageService.sol
  line: 140
  has: '_params.to.call{ value: _params.value }(_params.data);'
  says: a proven L2 to L1 message is paid out of the ETH this contract holds
  for:
  - what
  - whose
- id: send-payable
  source: '0x052b73d934e9412045bf731574463fd026d74645'
  file: L1MessageService.sol
  lines:
  - 53
  - 57
  has: external payable virtual whenTypeAndGeneralNotPaused(PauseType.L1_L2)
  says: users send ETH to L2 by paying it into sendMessage here
  for:
  - whose
- id: eth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0xd19d4b5d358258f05d7b411e21a1460d11b0876f'
  is: '19601305326751871868276'
  says: the contract holds 19,601.3 ETH
  for:
  - whose
- id: pa-owner
  call: '0xf5058616517c068c7b8c7ebc69ff636ade9066d6'
  fn: owner()(address)
  is: '0xd6b95c960779c72b8c6752119849318e5d550574'
  says: the ProxyAdmin is owned by TimeLock 0xd6b95c96
  for:
  - action
  - justification
- id: tl-delay
  call: '0xd6b95c960779c72b8c6752119849318e5d550574'
  fn: getMinDelay()(uint256)
  is: 0
  says: the TimeLock has no minimum delay
  for:
  - action
  - justification
- id: tl-proposer
  call: '0xd6b95c960779c72b8c6752119849318e5d550574'
  fn: hasRole(bytes32,address)(bool)
  args:
  - '0xb09aa5aeb3702cfd50b6b62bc4532604938f21248a27a1d5ca736082b6819cc1'
  - '0x892bb7eed71efb060ab90140e7825d8127991dd3'
  is: true
  says: Safe 0x892bb7ee holds the TimeLock's PROPOSER_ROLE
  for:
  - action
  - justification
- id: tl-executor
  call: '0xd6b95c960779c72b8c6752119849318e5d550574'
  fn: hasRole(bytes32,address)(bool)
  args:
  - '0xd8aa0f3194971a2a116679f7c2090f6939c8d4e01a2a8d7e41d55e5351469e63'
  - '0x892bb7eed71efb060ab90140e7825d8127991dd3'
  is: true
  says: Safe 0x892bb7ee holds the TimeLock's EXECUTOR_ROLE
  for:
  - action
  - justification
- id: safe-threshold
  call: '0x892bb7eed71efb060ab90140e7825d8127991dd3'
  fn: getThreshold()(uint256)
  is: 5
  says: the Safe needs 5 signatures
  for:
  - action
  - justification
- id: safe-owners
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
  - action
  - justification
- id: safe-admin
  call: '0xd19d4b5d358258f05d7b411e21a1460d11b0876f'
  fn: hasRole(bytes32,address)(bool)
  args:
  - '0x0000000000000000000000000000000000000000000000000000000000000000'
  - '0x892bb7eed71efb060ab90140e7825d8127991dd3'
  is: true
  says: the Safe holds DEFAULT_ADMIN_ROLE on the rollup
  for:
  - action
  - justification
- id: council
  source: '0x052b73d934e9412045bf731574463fd026d74645'
  file: LineaRollup.sol
  line: 34
  has: DEFAULT_ADMIN_ROLE is set for the security council.
  says: the source names the DEFAULT_ADMIN_ROLE holder the security council
  for:
  - action
  - justification
- id: tl-verifier
  call: '0xd19d4b5d358258f05d7b411e21a1460d11b0876f'
  fn: hasRole(bytes32,address)(bool)
  args:
  - '0x32937fd5162e282df7e9a14a5073a2425321c7966eaf70ed6c838a1006d84c4c'
  - '0xd6b95c960779c72b8c6752119849318e5d550574'
  is: true
  says: the TimeLock holds VERIFIER_SETTER_ROLE, so it can install a verifier for a new circuit
  for:
  - action
- id: op-role-admin
  call: '0xd19d4b5d358258f05d7b411e21a1460d11b0876f'
  fn: getRoleAdmin(bytes32)(bytes32)
  args:
  - '0x97667070c54ef182b0f5858b034beac1b6f3089aa2d3188bb1e8929f4fa9b929'
  is: '0x0000000000000000000000000000000000000000000000000000000000000000'
  says: DEFAULT_ADMIN_ROLE administers OPERATOR_ROLE
  for:
  - notes
- id: project
  source: '0x052b73d934e9412045bf731574463fd026d74645'
  file: LineaRollup.sol
  line: 17
  has: '@custom:security-contact security-report@linea.build'
  says: the verified source names Linea as the team
  for:
  - notes
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
reviews:
- who: r-d19d4b5d, the row's refuter
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Linea''s rollup (an upgradeable proxy holding 19,601 ETH) takes L2 data only as blobs: submitBlobs
    opens every blob at the point-evaluation precompile before recording it, finalizeBlocks reverts without a recorded
    final blob, and the running code has no calldata path; both need the operator role, held by two code-less accounts.
    MEDIUM, PQ-8: someone who breaks the KZG setup with a quantum computer and holds an operator key could finalize
    a state whose data is not on L1; the Security Council''s 5-of-9 Safe can upgrade through a timelock with no
    delay. Author A-d19d4b5d; refuter R-d19d4b5d agreed with no objection and corrected one check''s line numbers
    before accepting; the reader changed nothing. The card counts the proxy''s ETH only; the token bridge''s value
    was not re-read.'
related: []
---

## What happens

Linea's rollup finalizes L2 states only from blobs whose KZG openings pass the point-evaluation check. With the KZG setup broken by a quantum computer and an operator key, a false opening finalizes a proven state with no data on L1. Users then cannot rebuild it from L1 to prove withdrawals.

## Evidence

- [_verifyPointEvaluation](https://etherscan.io/address/0x052b73d934e9412045bf731574463fd026d74645#code) opens each blob at the point-evaluation precompile; finalizeBlocks needs the result.
- [submitBlobs](https://etherscan.io/address/0x052b73d934e9412045bf731574463fd026d74645#code) needs OPERATOR_ROLE; the accounts sending it and finalizeBlocks hold it, have no code and have signed.
- [A submitBlobs transaction](https://etherscan.io/tx/0x69c6e6b2173adf682a80794e7bd85358afa1be5c5f618f63c74ebe02b71e700d) at block 26,438,920 shows the path in use.

## Reviewer notes

### Mechanism

Proxy 0xd19d4b5d runs LineaRollup 0x052b73d9. submitBlobs (OPERATOR_ROLE) sets z = keccak(snarkHash, blobhash) per blob and _verifyPointEvaluation staticcalls precompile 0x0a with (versioned hash, z, y, commitment, proof), reverting unless it returns 4096 and the BLS modulus. _acceptShnarfData records the shnarf keccak(parent, snarkHash, root, z, y), the only live writer of _blobShnarfExists. finalizeBlocks (OPERATOR_ROLE) requires that shnarf from shnarfProvider (this proxy), anchors the L2 Merkle roots used by claimMessageWithProof and verifies a PLONK proof whose public input holds the shnarf. The opening is the only link between the proven data and the posted blob: with the setup trapdoor an operator opens any blob to the y the proof expects, so the state finalizes without its data on L1. The proof still binds an honest execution, so funds are not released by this alone. The Security Council Safe (5 of 9) proposes and executes on TimeLock 0xd6b95c96 (delay 0), owner of ProxyAdmin 0xf5058616; the TimeLock holds VERIFIER_SETTER_ROLE.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: a signature path: none here (scan.codes empty); no EIP-8151 issue on this card.
- Ruled out: another shnarf writer: initialize needs version 0, slot 0 holds 9; shnarfProvider is this proxy, no setter.
- Ruled out: a calldata path: absent from the running code; older LineaRollup code 0x04728bf7 has submitDataAsCalldata (0x6854f6bc); its use behind this proxy until block 24,778,478 rests on the first study's logs.
- Ruled out: a pause: GENERAL and STATE_DATA_SUBMISSION are off; submitBlobs and finalizeBlocks succeeded at blocks 26,438,920-921.
- Ruled out: theft by this check alone: the PLONK proof still binds the state; forging it is finding linea-plonk-verifier-bn254.
- Ruled out: a settings-only fix: the Safe administers OPERATOR_ROLE and can move it to post-quantum accounts, but a role holder can still open a blob falsely, so the rating rests on the upgrade.
- Ruled out: prover support for calldata batches is not established; the TimeLock can install a matching verifier.
- Ruled out: escrow: the first study added TokenBridge 0x051f1d88 ($10.6M); this card counts only the proxy's 19,601.3 ETH.
- Ruled out: OPERATOR_ROLE holders cannot be listed without logs; the two checked sent the latest submitBlobs and finalizeBlocks.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
