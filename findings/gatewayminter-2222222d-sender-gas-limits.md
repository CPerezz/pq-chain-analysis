---
id: gatewayminter-2222222d-sender-gas-limits
format: 2
title: Gateway mints sent with a tight gas limit fail under EIP-8151
status: confirmed
severity: LOW
justification: A real mint fails under EIP-8151 on its sender's gas limit alone; a higher limit makes it pass.
category: breaks-at-activation
pattern: PQ-18
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2222222d7164433c4c09b0b0d809a9b52c04c205'
  name: GatewayMinter
  project: circle
  code: verified
  code_url: https://etherscan.io/address/0xc2ff68068362aea1ca22a3896d05b2b812ce51b1#code
  proxy_of: '0xc2ff68068362aea1ca22a3896d05b2b812ce51b1'
  copies: 1
  upgradeable: 'yes'
  admin: '0x3c54ffa14d01ef3a555106007a4fed6e8964aab6'
value:
  usd: 0
  whose: users
  basis: held
activity: {}
impact: liveness
action: 'Tell gatewayMint senders to re-estimate gas under EIP-8151: this mint used 3,100 more, 726 above its limit.'
evidence_level: executed
checks:
- id: recover
  source: '0xc2ff68068362aea1ca22a3896d05b2b812ce51b1'
  file: src/modules/minter/Mints.sol
  line: 257
  has: address recoveredSigner = ECDSA.recover(keccak256(attestation).toEthSignedMessageHash(), signature);
  says: gatewayMint's signature check recovers the attestation signer with ECDSA
  for:
  - evidence-2
  - what
- id: signer-check
  source: '0xc2ff68068362aea1ca22a3896d05b2b812ce51b1'
  file: src/modules/minter/Mints.sol
  lines:
  - 258
  - 260
  has: if (!isAttestationSigner(recoveredSigner)) {
  says: the mint reverts unless the recovered address is an approved attestation signer
  for:
  - what
- id: builtin-recover
  source: '0xc2ff68068362aea1ca22a3896d05b2b812ce51b1'
  file: lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 148
  has: address signer = ecrecover(hash, v, r, s);
  says: the recovery is Solidity's built-in ecrecover, which fixes no gas amount in the code
  for:
  - action
  - evidence-2
  - what
- id: mint-to-recipient
  source: '0xc2ff68068362aea1ca22a3896d05b2b812ce51b1'
  file: src/modules/minter/Mints.sol
  line: 349
  has: IMintableToken(minter).mint(recipient, value);
  says: a mint sends the tokens to the recipient named in the attestation, not to the contract or its operator
  for:
  - whose
- id: holds-no-eth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x2222222d7164433c4c09b0b0d809a9b52c04c205'
  is: 0
  says: the contract itself holds no ETH; what is at stake is the recipients' mints
  for:
  - whose
- id: signer-approved
  call: '0x2222222d7164433c4c09b0b0d809a9b52c04c205'
  fn: isAttestationSigner(address)(bool)
  args:
  - '0x311ac5f3a327c18e27ea544694e20abd15caa85d'
  is: true
  says: the signer recovered in real mints is an approved attestation signer at the block
  for:
  - what
- id: signer-no-code
  code: '0x311ac5f3a327c18e27ea544694e20abd15caa85d'
  is: empty
  says: the attestation signer has no code, so the replay's failure is not the signer check
  for:
  - notes
- id: sender-no-code
  code: '0x9938b1571858d7ac066081a3e16fa663e3b895ca'
  is: empty
  says: 'the cited transaction''s sender has no code: it calls the contract directly, with no wallet step that checks
    a signature'
  for:
  - notes
- id: not-paused
  call: '0x2222222d7164433c4c09b0b0d809a9b52c04c205'
  fn: paused()(bool)
  is: false
  says: the contract is not paused at the block
  for:
  - what
- id: tx
  tx: '0x1b8227422fca3c0c3f2c45a4d86d5794e51efdfd8432c431a8ee7620a551dd8d'
  to: '0x2222222d7164433c4c09b0b0d809a9b52c04c205'
  ok: true
  says: a real transaction sent to this contract that succeeded on chain
  for:
  - evidence-1
  - justification
  - what
- id: replay-today
  replay: '0x1b8227422fca3c0c3f2c45a4d86d5794e51efdfd8432c431a8ee7620a551dd8d'
  run: today
  ok: true
  says: replayed with today's rules the transaction succeeds, as its receipt
  for:
  - action
  - evidence-1
  - justification
  - what
- id: replay-8151
  replay: '0x1b8227422fca3c0c3f2c45a4d86d5794e51efdfd8432c431a8ee7620a551dd8d'
  run: eip8151
  ok: false
  says: replayed under EIP-8151 as sent, the transaction fails
  for:
  - action
  - evidence-1
  - justification
  - what
- id: replay-more-gas
  replay: '0x1b8227422fca3c0c3f2c45a4d86d5794e51efdfd8432c431a8ee7620a551dd8d'
  run: eip8151_more_gas
  ok: true
  says: replayed under EIP-8151 with 300,000 more gas, the transaction succeeds, so the failure is the sender's
    gas limit
  for:
  - action
  - evidence-1
  - justification
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews: []
related: []
---

## What happens

GatewayMinter mints tokens when the caller presents an attestation signed by an approved signer. EIP-8151 makes that signature check cost more gas. A real mint sent with a tight gas limit fails under the change as sent and passes with a higher limit.

## Evidence

- [This mint](https://etherscan.io/tx/0x1b8227422fca3c0c3f2c45a4d86d5794e51efdfd8432c431a8ee7620a551dd8d) succeeded on chain. Replayed under EIP-8151 it fails as sent and passes with more gas.
- [gatewayMint](https://etherscan.io/address/0xc2ff68068362aea1ca22a3896d05b2b812ce51b1#code) recovers the attestation signer with ECDSA and writes no gas amount for the check.

## Reviewer notes

### Mechanism

gatewayMint (Mints.sol, lines 161-193) first calls _verifyAttestationSignature (lines 256-261), which recovers the signer of the payload with OpenZeppelin ECDSA.recover and reverts unless isAttestationSigner is true for it. ECDSA uses Solidity's built-in ecrecover (ECDSA.sol line 148), so no gas amount is fixed in the code and the recovery gets all remaining gas. It then validates each attestation and calls mint on the token (line 349). Transaction 0x1b8227… was sent by an account without code straight to this proxy with selector 0x9fb01cc5 and a gas limit of 154,379 (cast tx). The dossier's replays: 152,005 gas today (as the receipt), revert under EIP-8151 as sent, 155,105 with 300,000 more gas. The difference is 3,100, the cold surcharge of one recovery, and 155,105 is 726 above the limit. The recovered signer 0x311ac5…a85d has no code, so the failure is the price and not the signer check.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: a gas amount fixed in the code: the recovery is Solidity's built-in ecrecover (ECDSA.sol line 148), and the same transaction passes with a higher limit.
- Ruled out: another signed step in the cited transaction: its sender 0x9938b1…95ca has no code and calls this proxy directly; gatewayMint has one recovery (Mints.sol line 257), and the token's mint authority is unset (tokenMintAuthority(USDC) is zero), so mint is called on USDC itself.
- Ruled out: the signer having code: 0x311ac5f3a327c18e27ea544694e20abd15caa85d has empty code at the block and isAttestationSigner is true for it.
- Ruled out: every mint failing: the dossier's other replay, 0xdb952db6…, passes under EIP-8151 as sent (134,893 gas today, 137,993 under the change). Only limits with less than about 3,100 gas of margin fail.
- Ruled out: a paused or closed path: paused() is false at the block.
- Ruled out: A separate migration notice sits beside this card and is not folded in: the attestation signer is a stored ECDSA key with no ERC-1271 path (replay 0xdb952db6… run eip8151_signer_code reverts); the owner can add and remove signers (Mints.sol lines 231-248). It belongs to a rotate-signer-before-migrating row.
- Ruled out: funds lost when the mint fails: not established. The call reverts and the attestation can be sent again while it has not expired (Mints.sol lines 269-275); what happens off-chain after expiry is not readable here, so the card claims liveness only.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
