---
id: messagetransmitterv2-81d40f21-attester-keys
format: 2
title: A quantum attacker who forges two attester keys can mint USDC
status: confirmed
severity: MEDIUM
justification: Two forged attester keys mint USDC to anyone; fixable, but only by a code upgrade from Circle's proxy
  admin.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x81d40f21f12a8f0e3252bccb954d722d4c464b64'
  name: MessageTransmitterV2
  project: circle
  code: verified
  code_url: https://etherscan.io/address/0xa30c41865729c248067704d4db9f38385cbe1186#code
  proxy_of: '0xa30c41865729c248067704d4db9f38385cbe1186'
  copies: 1
  upgradeable: 'yes'
  admin: '0xb7569e9eb64eaed5c4166e510b4f6ff54ef42258'
value:
  usd: 11
  basis: held
activity: {}
impact: funds-loss
action: Upgrade the transmitter to check attestations with post-quantum signatures; swapping attesters only installs
  new ECDSA keys.
evidence_level: source
checks:
- id: loop
  source: '0xa30c41865729c248067704d4db9f38385cbe1186'
  file: src/roles/Attestable.sol
  lines:
  - 242
  - 262
  has: 'address _recoveredAttester = _recoverAttesterSignature( _digest, _signature ); // Signatures must be in
    increasing order of address, and may not duplicate signatures from same address require( _recoveredAttester
    > _latestAttesterAddress, "Invalid signature order or dupe" ); require( isEnabledAttester(_recoveredAttester),
    "Invalid signature: not attester" );'
  says: each signature of the attestation is recovered and must be a distinct enabled attester, signatureThreshold
    times
  for:
  - action
  - evidence-1
  - evidence-3
  - justification
  - what
- id: recover
  source: '0xa30c41865729c248067704d4db9f38385cbe1186'
  file: src/roles/Attestable.sol
  lines:
  - 271
  - 276
  has: return (ECDSA.recover(_digest, _signature));
  says: the recovery is ECDSA
  for:
  - action
  - evidence-1
  - what
- id: verify-call
  source: '0xa30c41865729c248067704d4db9f38385cbe1186'
  file: src/v2/MessageTransmitterV2.sol
  line: 287
  has: _verifyAttestationSignatures(_message, _attestation);
  says: receiveMessage validates the attestation signatures
  for:
  - evidence-1
  - what
- id: handle
  source: '0xa30c41865729c248067704d4db9f38385cbe1186'
  file: src/v2/MessageTransmitterV2.sol
  lines:
  - 234
  - 243
  has: IMessageHandlerV2(_recipient).handleReceiveFinalizedMessage(
  says: after validation the transmitter calls the message's recipient
  for:
  - evidence-1
  - what
- id: threshold
  call: '0x81d40f21f12a8f0e3252bccb954d722d4c464b64'
  fn: signatureThreshold()(uint256)
  is: 2
  says: two signatures are required
  for:
  - evidence-1
  - evidence-3
  - justification
  - what
- id: nattesters
  call: '0x81d40f21f12a8f0e3252bccb954d722d4c464b64'
  fn: getNumEnabledAttesters()(uint256)
  is: 2
  says: two attesters are enabled
  for:
  - what
- id: mint
  source: '0x555e272506c06e7e559d57418563742afe363ec8'
  file: src/v2/BaseTokenMessenger.sol
  lines:
  - 285
  - 303
  has: _mintToken = _minter.mint( _remoteDomain, _burnToken, _mintRecipient, _amount );
  says: a received burn message mints through the local minter to the message's recipient
  for:
  - evidence-2
  - justification
  - what
- id: localminter
  call: '0x28b5a0e9c621a5badaa536219b3a228c8168cf5d'
  fn: localMinter()(address)
  is: '0xfd78ee919681417d192449715b2594ab58f5d002'
  says: TokenMessengerV2's minter
  for:
  - evidence-2
  - what
- id: localtoken
  call: '0xfd78ee919681417d192449715b2594ab58f5d002'
  fn: getLocalToken(uint32,bytes32)(address)
  args:
  - 3
  - '0x000000000000000000000000af88d065e77c8cc2239327c5edb3a432268e5831'
  is: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  says: a burn of Arbitrum USDC mints mainnet USDC
  for:
  - what
- id: isminter
  call: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  fn: isMinter(address)(bool)
  args:
  - '0xfd78ee919681417d192449715b2594ab58f5d002'
  is: true
  says: the TokenMinterV2 is a USDC minter
  for:
  - evidence-2
  - what
- id: allowance
  call: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  fn: minterAllowance(address)(uint256)
  args:
  - '0xfd78ee919681417d192449715b2594ab58f5d002'
  is: 698690021767466
  says: it can mint 698,690,021.77 USDC
  for:
  - evidence-2
  - what
- id: transmitter
  call: '0x28b5a0e9c621a5badaa536219b3a228c8168cf5d'
  fn: localMessageTransmitter()(address)
  is: '0x81d40f21f12a8f0e3252bccb954d722d4c464b64'
  says: TokenMessengerV2 takes messages from this transmitter
  for:
  - notes
- id: tx
  tx: '0xbe5e2d4415051a614d54cd510c8359cd13e61f0d7f405bb18b156957cd5c4a14'
  to: '0x81d40f21f12a8f0e3252bccb954d722d4c464b64'
  ok: true
  says: a real receiveMessage to this address succeeded, carrying the attesters' signatures
  for:
  - evidence-3
- id: upgrade
  source: '0x81d40f21f12a8f0e3252bccb954d722d4c464b64'
  file: src/proxy/AdminUpgradableProxy.sol
  lines:
  - 111
  - 113
  has: function upgradeTo(address newImplementation) external virtual ifAdmin { _upgradeTo(newImplementation); }
  says: the proxy admin can replace the code
  for:
  - action
  - justification
- id: admin
  call: '0x81d40f21f12a8f0e3252bccb954d722d4c464b64'
  fn: admin()(address)
  is: '0xb7569e9eb64eaed5c4166e510b4f6ff54ef42258'
  says: the proxy admin
  for:
  - action
  - justification
- id: admin-eoa
  code: '0xb7569e9eb64eaed5c4166e510b4f6ff54ef42258'
  is: empty
  says: the proxy admin is an account without code, presumed live
  for:
  - notes
- id: att0
  code: '0x725b06f73ff761ef5390e39315e2bfbf60d33f96'
  is: empty
  says: attester 0x725b06f7 has no code
  for:
  - notes
- id: att1
  code: '0x52ed4cbff8dce6a19748043f3240ec03c834bcef'
  is: empty
  says: attester 0x52ed4cbf has no code
  for:
  - notes
- id: copyright
  source: '0xa30c41865729c248067704d4db9f38385cbe1186'
  file: src/v2/MessageTransmitterV2.sol
  line: 2
  has: Circle Internet Group
  says: the verified source is Circle's
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
- study: eip-8151-impact
  who: Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not
    reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

Circle's CCTP V2 message transmitter accepts a cross-chain message when its two enabled attesters sign it with ECDSA. A quantum attacker who recovers both keys can forge a burn message, and the token messenger then mints USDC to any recipient, up to its minter's allowance of 698.7M USDC.

## Evidence

- [The transmitter](https://etherscan.io/address/0xa30c41865729c248067704d4db9f38385cbe1186#code) recovers each signature with ECDSA, requires two, and calls the recipient once they pass.
- [The token messenger](https://etherscan.io/address/0x555e272506c06e7e559d57418563742afe363ec8#code) mints through a USDC minter allowed 698,690,021 USDC.
- [A real message](https://etherscan.io/tx/0xbe5e2d4415051a614d54cd510c8359cd13e61f0d7f405bb18b156957cd5c4a14) was accepted with both attesters' signatures, so their public keys are on-chain.

## Reviewer notes

### Mechanism

receiveMessage (MessageTransmitterV2.sol l.206-258) -> _validateReceivedMessage -> _verifyAttestationSignatures (l.287; Attestable.sol l.227-263): the attestation must be signatureThreshold (2) x 65-byte signatures; each is ECDSA.recover'd (l.271-276, OZ ECDSA l.67 ecrecover), in increasing order, each an enabled attester. Then the message's recipient gets handleReceiveFinalizedMessage/Unfinalized. TokenMessengerV2 (proxy 0x28b5a0e9, impl 0x555e2725) checks the caller is its localMessageTransmitter (this proxy) and the sender is a registered remote TokenMessenger (a field inside the forged message), then _mintAndWithdraw -> TokenMinterV2 0xfd78ee91 .mint; getLocalToken(3, Arbitrum USDC) = mainnet USDC, and the minter's USDC minterAllowance is 698,690,021.77 USDC. Attesters 0x725b06f7 and 0x52ed4cbf are EOAs (no code, nonce 0) whose signatures sit in every receiveMessage calldata. attesterManager 0xc16b03f8 can enable/disable attesters and set the threshold, but every attester is still a 65-byte ECDSA key: only an upgrade (proxy admin 0xb7569e9e, EOA, upgradeTo l.111) changes the scheme. A pauser (0x38304826) can pause receiveMessage (whenNotPaused) as a stop-gap; it is not a fix.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: unused implementation: this is the proxy in use; the window shows 77,156 recoveries and a real receiveMessage to this address succeeded; initializedVersion() = 1.
- Ruled out: key-state: both enabled attesters are EOAs with no code; signatureThreshold() = 2 and getNumEnabledAttesters() = 2; not paused.
- Ruled out: an alternative signature path (ERC-1271 or other): _verifyAttestationSignatures (Attestable.sol l.227-263) has none; receiveMessage is the only receive path.
- Ruled out: setter as fix: enableAttester/disableAttester/setSignatureThreshold only rotate ECDSA keys; the proxy admin is an EOA with no code, presumed live (nonce 0).
- Ruled out: value: the address itself holds $11 of USDC; the old card's 860.8M figure (block 26,431,457) is now 698,690,021.77 USDC of minter allowance at block 26,438,999, stated in What happens and not as held value.
- Ruled out: V1 transmitter 0x0a992d19 from the old card is a separate address and not covered here.
- Ruled out: EIP-8151 replays in the dossier (0xfa70febd 'many', 0xa4a5b4de 'tight') fail under the change alone; that is a possible separate sender-gas-limits finding for the reviewer to link, not part of this quantum-exposure card.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
