---
id: cctpbridge-c51397b7-sender-gas-limits
format: 2
title: Bridge deliveries sent with a tight gas limit fail once EIP-8151 is live
status: confirmed
severity: LOW
justification: A real delivery fails only on its sender's gas limit; the same call passes with a higher limit.
category: breaks-at-activation
pattern: PQ-18
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc51397b75b783e31469bfaade79913f3f82210d6'
  name: CctpBridge
  code: verified
  code_url: https://etherscan.io/address/0xc51397b75b783e31469bfaade79913f3f82210d6#code
  copies: 1
  upgradeable: 'no'
  admin: '0x01a494079dcb715f622340301463ce50cd69a4d0'
value:
  usd: 27
  whose: operator
  basis: held
activity: {}
impact: liveness
action: 'Re-estimate gas limits for receiveTokens under EIP-8151: this delivery used 6,200 more gas, 3,730 above
  its limit.'
evidence_level: executed
checks:
- id: recv
  source: '0xc51397b75b783e31469bfaade79913f3f82210d6'
  file: contracts/CctpBridge.sol
  lines:
  - 172
  - 173
  has: 'require(cctpTransmitter.receiveMessage(message, signature), "CCTP: Receive message failed");'
  says: receiveTokens, open to any caller, passes the message and signatures to the transmitter and reverts if it
    fails
  for:
  - evidence-1
  - what
- id: transmitter
  bytecode: '0xc51397b75b783e31469bfaade79913f3f82210d6'
  has: 0a992d191deec32afe36203ad87d7d289a738f81
  says: the runtime code holds the CCTP MessageTransmitter's address as a constant
  for:
  - evidence-1
  - what
- id: verify-first
  source: '0x0a992d191deec32afe36203ad87d7d289a738f81'
  file: MessageTransmitter.sol
  lines:
  - 3399
  - 3406
  has: _verifyAttestationSignatures(message, attestation);
  says: the transmitter's receiveMessage checks the attestation signatures first
  for:
  - what
- id: loop
  source: '0x0a992d191deec32afe36203ad87d7d289a738f81'
  file: MessageTransmitter.sol
  lines:
  - 3137
  - 3155
  has: address _recoveredAttester = _recoverAttesterSignature(
  says: one recovery per required signature, each recovered address must be an enabled attester
  for:
  - evidence-1
  - what
- id: ecrecover
  source: '0x0a992d191deec32afe36203ad87d7d289a738f81'
  file: MessageTransmitter.sol
  line: 2880
  has: address signer = ecrecover(hash, v, r, s);
  says: the recovery is the ecrecover built-in, with no gas amount set
  for:
  - what
- id: threshold
  call: '0x0a992d191deec32afe36203ad87d7d289a738f81'
  fn: signatureThreshold()(uint256)
  is: 2
  says: two attester signatures are required at the block
  for:
  - evidence-1
  - what
- id: open
  call: '0x0a992d191deec32afe36203ad87d7d289a738f81'
  fn: paused()(bool)
  is: false
  says: the transmitter is not paused at the block
  for:
  - notes
- id: to-here
  tx: '0xd4f4c8b1b1b8697b96de27e5bd1373c2490c45e016f102d07e8e1e4f5a09649d'
  to: '0xc51397b75b783e31469bfaade79913f3f82210d6'
  ok: true
  says: the real transaction calls this address and succeeded
  for:
  - action
  - evidence-2
  - justification
  - what
- id: today
  replay: '0xd4f4c8b1b1b8697b96de27e5bd1373c2490c45e016f102d07e8e1e4f5a09649d'
  run: today
  ok: true
  says: replayed under today's rules it succeeds, as its receipt
  for:
  - evidence-2
  - justification
  - what
- id: fails
  replay: '0xd4f4c8b1b1b8697b96de27e5bd1373c2490c45e016f102d07e8e1e4f5a09649d'
  run: eip8151
  ok: false
  says: replayed under EIP-8151 as sent it fails
  for:
  - action
  - evidence-2
  - justification
  - what
- id: more-gas
  replay: '0xd4f4c8b1b1b8697b96de27e5bd1373c2490c45e016f102d07e8e1e4f5a09649d'
  run: eip8151_more_gas
  ok: true
  says: under EIP-8151 with 300,000 more gas it succeeds
  for:
  - action
  - evidence-2
  - justification
  - what
- id: burns
  source: '0xc51397b75b783e31469bfaade79913f3f82210d6'
  file: contracts/CctpBridge.sol
  lines:
  - 105
  - 115
  has: uint64 nonce = cctpMessenger.depositForBurn(amountToSend, destinationDomain, recipient, address(token));
  says: a user's tokens are burned in the same call; only the relayer fee and admin fee stay in the contract
  for:
  - whose
- id: fees-out
  source: '0xc51397b75b783e31469bfaade79913f3f82210d6'
  file: contracts/CctpBridge.sol
  lines:
  - 210
  - 215
  has: token.safeTransfer(msg.sender, toWithdraw);
  says: the owner withdraws the whole token balance as fees
  for:
  - whose
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews:
- who: r-c51397b7, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: 'kept: LOW (PQ-18, liveness): a CCTP V1 relay contract whose receiveTokens forwards to the MessageTransmitter
    with no gas cap; a real delivery passes today, fails as sent under EIP-8151 and passes with 300,000 more gas,
    so it is the sender''s limit, not a gas amount fixed in the code, and the message stays deliverable. The refuter
    agrees with no objection; Claude read the card and the answer.'
related: []
---

## What happens

This bridge completes transfers by passing each message to the CCTP message transmitter, which recovers two attester signatures. Under EIP-8151 each recovery costs more, so a real delivery sent with a tight gas limit fails; with a higher limit it passes.

## Evidence

- [receiveTokens](https://etherscan.io/address/0xc51397b75b783e31469bfaade79913f3f82210d6#code) hands the message to the transmitter, which recovers one signature per attester; two are required.
- [This delivery](https://etherscan.io/tx/0xd4f4c8b1b1b8697b96de27e5bd1373c2490c45e016f102d07e8e1e4f5a09649d) fails under EIP-8151 as sent and passes with a higher gas limit.

## Reviewer notes

### Mechanism

receiveTokens (CctpBridge.sol line 172-173) is open to any caller and calls cctpTransmitter.receiveMessage with all remaining gas; cctpTransmitter is an immutable, 0x0a992d19… in the runtime code. MessageTransmitter.receiveMessage (line 3406) first runs _verifyAttestationSignatures, which loops signatureThreshold times (2 at the block) over ECDSA.recover and requires each recovered address to be an enabled attester. Neither contract gives the precompile a fixed gas amount, so the only limit is the transaction's. Transaction 0xd4f4c8b1… (block 26,395,877, to this address, selector 0x1e976500, gas limit 166,603) used 164,133 gas: a margin of 2,470. Replayed under EIP-8151 it fails as sent; with 300,000 more gas it passes using 170,333, that is 6,200 more than today and 3,730 above its limit. A failed delivery consumes no CCTP nonce, so it can be sent again with a higher limit. The transmitter's own notice is a separate row (0x0a992d19…).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: a fixed gas amount in code: receiveTokens makes a plain external call (line 173) and the transmitter uses the ecrecover built-in (line 2880); the replay with more gas passes, so the limit is the sender's.
- Ruled out: the replay failing on another signed step: the transaction calls only receiveTokens on this address; its calldata carries one message and a 130-byte attestation (two signatures), and the path has no other signature check (the message's destinationCaller field is zero).
- Ruled out: a closed path: the transmitter's paused() is false and signatureThreshold() is 2 at the block; the transaction is 43,122 blocks before the pinned block.
- Ruled out: code that is not this address's: the contract is not a proxy and its runtime code holds the transmitter's address as a constant.
- Ruled out: a direct call to MessageTransmitter.receiveMessage instead: it runs the same two recoveries and needs the same extra gas.
- Ruled out: who the sender 0xb7c522ad… is: an account without code, nonce 2,284 at the block; nothing read shows whether it is the team's relayer, so the action does not name it.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
