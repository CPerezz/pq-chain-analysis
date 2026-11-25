---
id: messagetransmitter-0a992d19-attester-committee
format: 2
title: Forged attester keys let Circle's CCTP V1 mint USDC to any address
status: confirmed
severity: MEDIUM
justification: Two forged attester keys mint USDC; this code cannot change, so the fix is moving users to another
  contract.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0a992d191deec32afe36203ad87d7d289a738f81'
  name: MessageTransmitter
  project: circle
  code: verified
  code_url: https://etherscan.io/address/0x0a992d191deec32afe36203ad87d7d289a738f81#code
  copies: 1
  upgradeable: config-only
  admin: '0x4aa5bf962852dcc59695f600d346d3f751b0d920'
value:
  usd: 0
  basis: held
activity: {}
impact: funds-loss
action: Pause this transmitter once V1 traffic has moved to a post-quantum attested contract; replacing attesters
  does not help.
evidence_level: source
checks:
- id: verify-call
  source: '0x0a992d191deec32afe36203ad87d7d289a738f81'
  file: MessageTransmitter.sol
  line: 3406
  has: _verifyAttestationSignatures(message, attestation);
  says: receiveMessage checks the attestation before anything else
  for:
  - evidence-1
  - what
- id: not-paused-mod
  source: '0x0a992d191deec32afe36203ad87d7d289a738f81'
  file: MessageTransmitter.sol
  line: 3402
  has: whenNotPaused
  says: receiveMessage runs only while the transmitter is not paused
  for:
  - action
- id: sig-count
  source: '0x0a992d191deec32afe36203ad87d7d289a738f81'
  file: MessageTransmitter.sol
  line: 3127
  has: _attestation.length == signatureLength * signatureThreshold
  says: the attestation holds exactly signatureThreshold signatures
  for:
  - evidence-1
  - what
- id: ecdsa
  source: '0x0a992d191deec32afe36203ad87d7d289a738f81'
  file: MessageTransmitter.sol
  line: 3171
  has: return (ECDSA.recover(_digest, _signature));
  says: each signature is recovered with ECDSA
  for:
  - action
  - evidence-3
  - justification
  - what
- id: enabled-check
  source: '0x0a992d191deec32afe36203ad87d7d289a738f81'
  file: MessageTransmitter.sol
  line: 3153
  has: isEnabledAttester(_recoveredAttester),
  says: each recovered signer must be an enabled attester; there is no other way for a signer to approve
  for:
  - evidence-1
  - justification
  - what
- id: handle
  source: '0x0a992d191deec32afe36203ad87d7d289a738f81'
  file: MessageTransmitter.sol
  line: 3444
  has: .handleReceiveMessage(_sourceDomain, _sender, _messageBody),
  says: the message body is passed to the recipient named in the message
  for:
  - evidence-1
  - what
- id: threshold
  call: '0x0a992d191deec32afe36203ad87d7d289a738f81'
  fn: signatureThreshold()(uint256)
  is: 2
  says: two signatures are required
  for:
  - evidence-1
  - justification
  - what
- id: n-attesters
  call: '0x0a992d191deec32afe36203ad87d7d289a738f81'
  fn: getNumEnabledAttesters()(uint256)
  is: 2
  says: two attesters are enabled
  for:
  - what
- id: att0
  call: '0x0a992d191deec32afe36203ad87d7d289a738f81'
  fn: getEnabledAttester(uint256)(address)
  is: '0xb0ea8e1be37f346c7ea7ec708834d0db18a17361'
  says: first enabled attester
  args:
  - '0'
  for:
  - notes
- id: att1
  call: '0x0a992d191deec32afe36203ad87d7d289a738f81'
  fn: getEnabledAttester(uint256)(address)
  is: '0xe2fefe09e74b921cbbff229e7cd40009231501ca'
  says: second enabled attester
  args:
  - '1'
  for:
  - notes
- id: att0-code
  code: '0xb0ea8e1be37f346c7ea7ec708834d0db18a17361'
  is: empty
  says: the first attester is a plain key with no code
  for:
  - notes
- id: att1-code
  code: '0xe2fefe09e74b921cbbff229e7cd40009231501ca'
  is: empty
  says: the second attester is a plain key with no code
  for:
  - notes
- id: paused
  call: '0x0a992d191deec32afe36203ad87d7d289a738f81'
  fn: paused()(bool)
  is: false
  says: the transmitter is not paused
  for:
  - evidence-1
  - what
- id: real-tx
  tx: '0x86ed47801efd5c84225cfffd894d0288c98a818ffdf650586a59e8186142a655'
  to: '0x0a992d191deec32afe36203ad87d7d289a738f81'
  ok: true
  says: a real receiveMessage succeeded at this address, so attester signatures are public on-chain
  for:
  - what
- id: tm-transmitter
  call: '0xbd3fa81b58ba92a82136038b25adec7066af3155'
  fn: localMessageTransmitter()(address)
  is: '0x0a992d191deec32afe36203ad87d7d289a738f81'
  says: V1 TokenMessenger takes messages from this transmitter
  for:
  - evidence-2
  - what
- id: tm-minter
  call: '0xbd3fa81b58ba92a82136038b25adec7066af3155'
  fn: localMinter()(address)
  is: '0xc4922d64a24675e16e1586e3e3aa56c06fabe907'
  says: V1 TokenMessenger mints through this TokenMinter
  for:
  - evidence-2
  - what
- id: tm-only
  source: '0xbd3fa81b58ba92a82136038b25adec7066af3155'
  file: TokenMessenger.sol
  line: 2851
  has: onlyLocalMessageTransmitter
  says: handleReceiveMessage accepts calls from the local transmitter
  for:
  - evidence-2
  - what
- id: tm-recipient
  source: '0xbd3fa81b58ba92a82136038b25adec7066af3155'
  file: TokenMessenger.sol
  line: 2872
  has: Message.bytes32ToAddress(_mintRecipient)
  says: the mint recipient is read from the message body
  for:
  - what
- id: tm-mint
  source: '0xbd3fa81b58ba92a82136038b25adec7066af3155'
  file: TokenMessenger.sol
  line: 3065
  has: address _mintToken = _minter.mint(
  says: the TokenMessenger mints the message's amount through its minter
  for:
  - evidence-2
  - justification
  - what
- id: is-minter
  call: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  fn: isMinter(address)(bool)
  is: true
  says: USDC lists the V1 TokenMinter as a minter
  args:
  - '0xc4922d64a24675e16e1586e3e3aa56c06fabe907'
  for:
  - evidence-2
  - what
- id: allowance
  call: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  fn: minterAllowance(address)(uint256)
  is: 74020643604788
  says: the V1 TokenMinter may still mint 74,020,643.60 USDC
  args:
  - '0xc4922d64a24675e16e1586e3e3aa56c06fabe907'
  for:
  - evidence-2
  - what
- id: minter-paused
  call: '0xc4922d64a24675e16e1586e3e3aa56c06fabe907'
  fn: paused()(bool)
  is: false
  says: the TokenMinter is not paused
  for:
  - what
- id: no-proxy
  storage: '0x0a992d191deec32afe36203ad87d7d289a738f81'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: 0
  says: the EIP-1967 implementation slot is empty
  for:
  - evidence-3
  - justification
  - upgradeable
- id: no-upgrade
  selector: '0x0a992d191deec32afe36203ad87d7d289a738f81'
  fn: upgradeTo(address)
  absent: true
  says: the code has no upgradeTo
  for:
  - evidence-3
  - justification
  - upgradeable
- id: no-upgrade2
  selector: '0x0a992d191deec32afe36203ad87d7d289a738f81'
  fn: upgradeToAndCall(address,bytes)
  absent: true
  says: the code has no upgradeToAndCall
  for:
  - evidence-3
  - justification
  - upgradeable
- id: enable
  source: '0x0a992d191deec32afe36203ad87d7d289a738f81'
  file: MessageTransmitter.sol
  line: 2986
  has: function enableAttester(address newAttester) public onlyAttesterManager
  says: the attester manager adds attesters, which are still checked with ECDSA
  for:
  - action
  - evidence-3
  - justification
  - upgradeable
- id: disable
  source: '0x0a992d191deec32afe36203ad87d7d289a738f81'
  file: MessageTransmitter.sol
  line: 3033
  has: function disableAttester(address attester) external onlyAttesterManager
  says: the attester manager removes attesters
  for:
  - evidence-3
- id: att-manager
  call: '0x0a992d191deec32afe36203ad87d7d289a738f81'
  fn: attesterManager()(address)
  is: '0x358a85e032aa9507a1303683b2b6a1d1cac3c252'
  says: the attester manager
  for:
  - notes
- id: pause
  source: '0x0a992d191deec32afe36203ad87d7d289a738f81'
  file: MessageTransmitter.sol
  line: 1642
  has: function pause() external onlyPauser
  says: the pauser can pause the transmitter
  for:
  - action
- id: pause-set
  source: '0x0a992d191deec32afe36203ad87d7d289a738f81'
  file: MessageTransmitter.sol
  line: 1643
  has: paused = true;
  says: pause() sets the flag that receiveMessage checks
  for:
  - action
- id: pauser
  call: '0x0a992d191deec32afe36203ad87d7d289a738f81'
  fn: pauser()(address)
  is: '0xc809b0216b149cc301cb203edd84fcdb8f15c4ed'
  says: the pauser
  for:
  - action
- id: pauser-nonce
  nonce: '0xc809b0216b149cc301cb203edd84fcdb8f15c4ed'
  min: 1
  says: the pauser has sent a transaction (a live key)
  for:
  - action
- id: circle
  source: '0x0a992d191deec32afe36203ad87d7d289a738f81'
  file: MessageTransmitter.sol
  line: 2
  has: Copyright (c) 2022, Circle Internet Financial Limited.
  says: the verified source is Circle's
  for:
  - notes
- id: replay-code
  replay: '0xf2741634f8e009fbfe70009857e74a74b73a63f9ca04e4a707939ce8f8343dd1'
  run: eip8151_signer_code
  ok: false
  says: a real receiveMessage reverts when an attester's account has real code
  for:
  - notes
- id: replay-deleg
  replay: '0xf2741634f8e009fbfe70009857e74a74b73a63f9ca04e4a707939ce8f8343dd1'
  run: eip8151_signer_delegated
  ok: true
  says: it still passes when the attester has an EIP-7702 delegation
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
  who: Review09 (finding review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews:
- who: r-0a992d19, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: 'agree: (not blocking) The card never says whose money is at stake: holds $0, and the reader must infer
    that a forged mint dilutes USDC (issuer and holders). A ''value.whose'' or a word in What happens would close
    that.; (not blocking) evidence-3 ''can only swap one ECDSA key for another'' omits that the attester manager
    can also change the threshold; still true that it cannot change the scheme.; (not blocking) Activity shows ''not
    established'' though the author''s own real-tx check and the study''s window (6,'
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Kev''s first-study finding, MEDIUM (PQ-5): CCTP V1''s MessageTransmitter mints USDC on two ECDSA
    attester signatures (both key-held accounts), to any address the message names, up to USDC''s 74.0M minter allowance;
    the transmitter cannot be upgraded, so only pausing or swapping one ECDSA key for another is possible, not a
    post-quantum scheme. Two refuters agree; their non-blocking notes (whose money, the settable threshold) do not
    change a sentence. Claude read the sheet.'
related: []
---

## What happens

Circle's CCTP V1 transmitter accepts a cross-chain message when its two enabled attesters sign it with ECDSA, then passes it on. Whoever recovers both keys can forge a burn message, and the TokenMessenger mints USDC to any address, up to the 74.0 million its minter may still mint.

## Evidence

- [receiveMessage](https://etherscan.io/address/0x0a992d191deec32afe36203ad87d7d289a738f81#code) needs two ECDSA signatures from enabled attesters, then calls the recipient named in the message; it is not paused.
- The [TokenMessenger](https://etherscan.io/address/0xbd3fa81b58ba92a82136038b25adec7066af3155#code) takes messages from this transmitter and mints through a TokenMinter that USDC lets mint 74.0 million more.
- The [transmitter](https://etherscan.io/address/0x0a992d191deec32afe36203ad87d7d289a738f81#code) has no proxy slot and no upgrade function; its attester manager can only swap one ECDSA key for another.

## Reviewer notes

### Mechanism

receiveMessage (MessageTransmitter.sol l.3399-3455, whenNotPaused) calls _verifyAttestationSignatures (l.3122-3160): the attestation must be signatureThreshold x 65 bytes (l.3127); each signature is recovered with ECDSA.recover (l.3171, ecrecover at l.2880), must be in increasing address order and an enabled attester (l.3153). There is no ERC-1271 or code branch. It then checks domain, caller, version and nonce, and calls handleReceiveMessage on the message's recipient (l.3444). At block 26,438,999 the threshold is 2 with two enabled attesters, both EOAs without code. V1 TokenMessenger 0xbd3fa81b names this transmitter (localMessageTransmitter); its handleReceiveMessage (onlyLocalMessageTransmitter, onlyRemoteTokenMessenger on the signed sender) mints the message's amount to its mintRecipient through TokenMinter 0xc4922d64 (l.2844-2877, 3057-3073), which USDC lists as a minter with 74,020,643.60 USDC allowance left. A CRQC holder recovers both attesters' keys from signatures in public receiveMessage calldata and forges a burn message. The transmitter has no proxy slot or upgrade function; the attester manager (enableAttester/disableAttester/setSignatureThreshold) can only change which ECDSA keys count. The pauser (EOA, nonce 1) can pause receiveMessage.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an unused implementation: real receiveMessage transactions go to this address (tx 0x86ed4780...), and it is not paused.
- Ruled out: an ERC-1271 path for attesters with code: _verifyAttestationSignatures has none (l.3122-3160); the replay of tx 0xf2741634... reverts when an attester has real code and passes with an EIP-7702 delegation.
- Ruled out: value held here: the transmitter holds about $0; the money at stake is the V1 TokenMinter's remaining USDC allowance (74.0M, down from 105.4M in the old card), stated in What happens, not as value.
- Ruled out: a fix by replacing attesters: enableAttester and disableAttester only change which ECDSA keys count.
- Ruled out: MEDIUM, not LOW: no setting keeps V1 working post-quantum; pausing it or removing its mint power retires V1, so users must move to another deployment.
- Ruled out: a separate issue for the main reviewer: replay tx 0xd4f4c8b1b1b8697b96de27e5bd1373c2490c45e016f102d07e8e1e4f5a09649d (root selector 0x1e976500, block 26,395,877, kind tight) reverts under EIP-8151 alone (164,133 gas today, 161,110 when it reverts); not cited here; it looks like a sender gas-limit failure and belongs to the contract that transaction calls.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
