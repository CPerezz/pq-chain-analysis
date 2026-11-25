---
id: dvn-589dedbd-ecdsa-signer-quorum
format: 2
title: Cross-chain verifier trusts ECDSA signer keys a quantum computer could forge
status: confirmed
severity: MEDIUM
justification: Two forged keys let it confirm fake messages; its code cannot change, so apps must move to a new
  verifier.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x589dedbd617e0cbcb916a9223f4d1300c294236b'
  name: DVN
  label: 'LayerZero : DVN'
  code: verified
  code_url: https://etherscan.io/address/0x589dedbd617e0cbcb916a9223f4d1300c294236b#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 371506
impact: funds-loss
action: Deploy a verifier that checks post-quantum signatures and ask the apps that require this one to switch to
  it.
evidence_level: source
checks:
- id: ecdsa
  source: '0x589dedbd617e0cbcb916a9223f4d1300c294236b'
  file: contracts/uln/dvn/MultiSig.sol
  line: 91
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: each signature is recovered with ECDSA
  for:
  - action
  - evidence-1
  - justification
  - what
- id: committee
  source: '0x589dedbd617e0cbcb916a9223f4d1300c294236b'
  file: contracts/uln/dvn/MultiSig.sol
  line: 95
  has: if (!signers[currentSigner]) return (false, Errors.SignerNotInCommittee);
  says: a recovered address must be in the stored signer list
  for:
  - evidence-1
  - justification
  - what
- id: count
  source: '0x589dedbd617e0cbcb916a9223f4d1300c294236b'
  file: contracts/uln/dvn/MultiSig.sol
  line: 82
  has: if (_signatures.length != uint256(quorum) * 65) {
  says: exactly a quorum of 65-byte ECDSA signatures is taken
  for:
  - evidence-1
  - what
- id: quorum
  call: '0x589dedbd617e0cbcb916a9223f4d1300c294236b'
  fn: quorum()(uint64)
  is: 2
  says: two signatures are needed
  for:
  - evidence-1
  - what
- id: size
  call: '0x589dedbd617e0cbcb916a9223f4d1300c294236b'
  fn: signerSize()(uint64)
  is: 3
  says: the signer list has three addresses
  for:
  - what
- id: signer-a
  call: '0x589dedbd617e0cbcb916a9223f4d1300c294236b'
  fn: signers(address)(bool)
  args:
  - '0x03429038953855beec609022284894049746c164'
  is: true
  says: 0x0342...c164 is a current signer
  for:
  - evidence-3
- id: signer-b
  call: '0x589dedbd617e0cbcb916a9223f4d1300c294236b'
  fn: signers(address)(bool)
  args:
  - '0x238fc6e3ffa0615925c96b23633f446881978ab5'
  is: true
  says: 0x238f...8ab5 is a current signer
  for:
  - evidence-3
- id: exec-gate
  source: '0x589dedbd617e0cbcb916a9223f4d1300c294236b'
  file: contracts/uln/dvn/DVN.sol
  line: 171
  has: function execute(ExecuteParam[] calldata _params) external onlyRole(ADMIN_ROLE) {
  says: execute needs the admin role
  for:
  - what
- id: exec-sig
  source: '0x589dedbd617e0cbcb916a9223f4d1300c294236b'
  file: contracts/uln/dvn/DVN.sol
  line: 188
  has: (bool sigsValid, ) = verifySignatures(hash, param.signatures);
  says: each instruction must carry valid quorum signatures
  for:
  - what
- id: exec-call
  source: '0x589dedbd617e0cbcb916a9223f4d1300c294236b'
  file: contracts/uln/dvn/DVN.sol
  line: 205
  has: (bool success, bytes memory rtnData) = param.target.call(param.callData);
  says: a signed instruction calls any target with any data
  for:
  - what
- id: qca-open
  source: '0x589dedbd617e0cbcb916a9223f4d1300c294236b'
  file: contracts/uln/dvn/DVN.sol
  line: 132
  has: function quorumChangeAdmin(ExecuteParam calldata _param) external {
  says: quorumChangeAdmin has no role check
  for:
  - evidence-2
  - justification
  - what
- id: qca-grant
  source: '0x589dedbd617e0cbcb916a9223f4d1300c294236b'
  file: contracts/uln/dvn/DVN.sol
  lines:
  - 145
  - 154
  has: _grantRole(ADMIN_ROLE, abi.decode(_param.callData, (address)));
  says: after the quorum signatures pass, it grants the admin role to the address in the signed data
  for:
  - evidence-2
  - justification
  - what
- id: setsigner
  source: '0x589dedbd617e0cbcb916a9223f4d1300c294236b'
  file: contracts/uln/dvn/DVN.sol
  line: 99
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: the signer list changes only by the contract calling itself, through execute with quorum signatures
  for:
  - action
  - justification
- id: onlyself
  source: '0x589dedbd617e0cbcb916a9223f4d1300c294236b'
  file: contracts/uln/dvn/DVN.sol
  lines:
  - 86
  - 88
  has: if (address(this) != msg.sender) {
  says: onlySelf admits only the contract itself as caller
  for:
  - action
- id: no-upgrade
  selector: '0x589dedbd617e0cbcb916a9223f4d1300c294236b'
  fn: upgradeTo(address)
  absent: true
  says: the code has no upgradeTo
  for:
  - justification
- id: no-upgrade-call
  selector: '0x589dedbd617e0cbcb916a9223f4d1300c294236b'
  fn: upgradeToAndCall(address,bytes)
  absent: true
  says: the code has no upgradeToAndCall
  for:
  - justification
- id: uln-verify-open
  source: '0xc02ab410f0734efa3f14628780e6e695156024c2'
  file: ReceiveUln302.sol
  line: 64
  has: function verify(bytes calldata _packetHeader, bytes32 _payloadHash, uint64 _confirmations) external {
  says: the receive library's verify takes any packet from any caller
  for:
  - what
- id: uln-verify
  source: '0xc02ab410f0734efa3f14628780e6e695156024c2'
  file: ReceiveUlnBase.sol
  line: 44
  has: hashLookup[keccak256(_packetHeader)][_payloadHash][msg.sender] = Verification(true, _confirmations);
  says: the caller (this DVN) is recorded as having confirmed the packet
  for:
  - what
- id: uln-commit
  source: '0xc02ab410f0734efa3f14628780e6e695156024c2'
  file: ReceiveUlnBase.sol
  line: 60
  has: if (!_checkVerifiable(_config, _headerHash, _payloadHash)) {
  says: a message is committed only when the receiver's config is satisfied
  for:
  - what
- id: uln-all
  source: '0xc02ab410f0734efa3f14628780e6e695156024c2'
  file: ReceiveUlnBase.sol
  line: 98
  has: if (!_verified(_config.requiredDVNs[i], _headerHash, _payloadHash, _config.confirmations)) {
  says: every required DVN must have confirmed
  for:
  - what
- id: default-setter
  source: '0xc02ab410f0734efa3f14628780e6e695156024c2'
  file: UlnBase.sol
  line: 55
  has: function setDefaultUlnConfigs(SetDefaultUlnConfigParam[] calldata _params) external onlyOwner {
  says: the library's owner sets the default DVN list
  for:
  - action
  - justification
- id: uln-owner
  call: '0xc02ab410f0734efa3f14628780e6e695156024c2'
  fn: owner()(address)
  is: '0xbe010a7e3686fdf65e93344ab664d065a0b02478'
  says: the receive library's owner
  for:
  - action
- id: default-config-30110
  call: '0xc02ab410f0734efa3f14628780e6e695156024c2'
  fn: getUlnConfig(address,uint32)((uint64,uint8,uint8,uint8,address[],address[]))
  args:
  - '0x0000000000000000000000000000000000000000'
  - 30110
  is:
  - 20
  - 4
  - 0
  - 0
  - - '0x380275805876ff19055ea900cdb2b46a94ecf20d'
    - '0x589dedbd617e0cbcb916a9223f4d1300c294236b'
    - '0xa4fe5a5b9a846458a70cd0748228aed3bf65c2cd'
    - '0xa59ba433ac34d2927232918ef5b2eaafcf130ba5'
  - []
  says: the default config requires this DVN and three others
  for:
  - action
- id: pool-src
  source: '0xc026395860db2d07ee33e05fe50ed7bd583189c7'
  file: src/usdc/StargatePoolUSDC.sol
  line: 11
  has: contract StargatePoolUSDC is StargatePool {
  says: the app is Stargate's USDC pool
  for:
  - what
- id: pool-token
  call: '0xc026395860db2d07ee33e05fe50ed7bd583189c7'
  fn: token()(address)
  is: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  says: the pool's token
  for:
  - what
- id: usdc-sym
  call: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  fn: symbol()(string)
  is: USDC
  says: the token is USDC
  for:
  - what
- id: usdc-dec
  call: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  fn: decimals()(uint8)
  is: 6
  says: USDC has 6 decimals
  for:
  - what
- id: pool-usdc
  call: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  fn: balanceOf(address)(uint256)
  args:
  - '0xc026395860db2d07ee33e05fe50ed7bd583189c7'
  is: 43253516334383
  says: the pool holds 43,253,516 USDC
  for:
  - what
- id: sigtx
  tx: '0xd05da00b16281d24d2fb5342d4870a91706ae1c7e1c0a407e137e58f5276497a'
  to: '0x589dedbd617e0cbcb916a9223f4d1300c294236b'
  ok: true
  says: a successful execute call to this DVN, whose calldata carries the signers' signatures
  for:
  - evidence-3
  - what
- id: sighash
  call: '0x589dedbd617e0cbcb916a9223f4d1300c294236b'
  fn: hashCallData(uint32,address,bytes,uint256)(bytes32)
  args:
  - 101
  - '0xc02ab410f0734efa3f14628780e6e695156024c2'
  - '0x0223536e00000000000000000000000000000000000000000000000000000000000000608eefb37e6db375833ab5c183857ad4e4a3ed1607ea8b10db16a0b81938dbf967000000000000000000000000000000000000000000000000000000000000000f00000000000000000000000000000000000000000000000000000000000000510100000000000009860000759600000000000000000000000070f2eadf1ca1969ff42b0c78e9da519e8937cbaf0000759500000000000000000000000070f2eadf1ca1969ff42b0c78e9da519e8937cbaf000000000000000000000000000000'
  - 1793847590
  is: '0x9ab7d684c602b734d5d1fa9a3c0d655f6d52ed39eb9b5c09fe1e9a8112ae5cab'
  says: the instruction in that transaction, a verify call to the receive library, hashes to this value
  for:
  - evidence-3
  - what
- id: sigvalid
  call: '0x589dedbd617e0cbcb916a9223f4d1300c294236b'
  fn: verifySignatures(bytes32,bytes)(bool,uint8)
  args:
  - '0x9ab7d684c602b734d5d1fa9a3c0d655f6d52ed39eb9b5c09fe1e9a8112ae5cab'
  - '0xfbcfc102ee2f852764996a7e6cf3b61f6762919a3232db7f03a14351bc63e903102ce7e16795ce8a6072e6a515127a1fdbd934de5eb707684111164d5f02e6b41b83982897584ded1f92a5bd777d588a1af8b84a5a7ef29ad5dacb5fba2a7f029721ec98524f91587e07478bc6fe66e6762a6fc335b4e2e374a37dab55153fd0c51c'
  is:
  - true
  - 0
  says: the two signatures posted in that transaction pass for the current signer list
  for:
  - evidence-3
  - what
- id: pool-only-tm-bus
  source: '0xc026395860db2d07ee33e05fe50ed7bd583189c7'
  file: src/StargateBase.sol
  line: 327
  has: onlyCaller(tokenMessaging)
  says: receiveTokenBus pays out only when TokenMessaging calls
  for:
  - what
- id: pool-only-tm-taxi
  source: '0xc026395860db2d07ee33e05fe50ed7bd583189c7'
  file: src/StargateBase.sol
  line: 350
  has: onlyCaller(tokenMessaging)
  says: receiveTokenTaxi pays out only when TokenMessaging calls
  for:
  - what
- id: pool-tm
  call: '0xc026395860db2d07ee33e05fe50ed7bd583189c7'
  fn: getAddressConfig()((address,address,address,address,address,address))
  is:
  - '0x52b35406cb2fb5e0038edecfc129a152a1f74087'
  - '0xe37f7c80ced04c4f243c0fd04a5510d663cb88b5'
  - '0x1041d127b2d4bc700f0f563883bc689502606918'
  - '0x6d6620efa72948c5f68a3c8646d58c00d3f4a980'
  - '0x9b4d17b45d60b8173a5904b85a7baaec291e9173'
  - '0x0000000000000000000000000000000000000000'
  says: the pool's tokenMessaging is 0x6d6620ef...
  for:
  - what
- id: tm-asset
  call: '0x6d6620efa72948c5f68a3c8646d58c00d3f4a980'
  fn: assetIds(address)(uint16)
  args:
  - '0xc026395860db2d07ee33e05fe50ed7bd583189c7'
  is: 1
  says: TokenMessaging serves the USDC pool as asset 1
  for:
  - what
- id: tm-lib-30110
  call: '0x1a44076050125825900e736c501f859c50fe728c'
  fn: getReceiveLibrary(address,uint32)(address,bool)
  args:
  - '0x6d6620efa72948c5f68a3c8646d58c00d3f4a980'
  - 30110
  is:
  - '0xc02ab410f0734efa3f14628780e6e695156024c2'
  - false
  says: TokenMessaging receives through ReceiveUln302, set explicitly
  for:
  - what
- id: tm-config-30110
  call: '0xc02ab410f0734efa3f14628780e6e695156024c2'
  fn: getUlnConfig(address,uint32)((uint64,uint8,uint8,uint8,address[],address[]))
  args:
  - '0x6d6620efa72948c5f68a3c8646d58c00d3f4a980'
  - 30110
  is:
  - 20
  - 3
  - 0
  - 0
  - - '0x589dedbd617e0cbcb916a9223f4d1300c294236b'
    - '0xa4fe5a5b9a846458a70cd0748228aed3bf65c2cd'
    - '0xa59ba433ac34d2927232918ef5b2eaafcf130ba5'
  - []
  says: TokenMessaging requires this DVN and two others on eid 30110
  for:
  - what
- id: tm-config-30184
  call: '0xc02ab410f0734efa3f14628780e6e695156024c2'
  fn: getUlnConfig(address,uint32)((uint64,uint8,uint8,uint8,address[],address[]))
  args:
  - '0x6d6620efa72948c5f68a3c8646d58c00d3f4a980'
  - 30184
  is:
  - 10
  - 3
  - 0
  - 0
  - - '0x589dedbd617e0cbcb916a9223f4d1300c294236b'
    - '0xa4fe5a5b9a846458a70cd0748228aed3bf65c2cd'
    - '0xa59ba433ac34d2927232918ef5b2eaafcf130ba5'
  - []
  says: the same three on eid 30184
  for:
  - what
- id: tm-config-30102
  call: '0xc02ab410f0734efa3f14628780e6e695156024c2'
  fn: getUlnConfig(address,uint32)((uint64,uint8,uint8,uint8,address[],address[]))
  args:
  - '0x6d6620efa72948c5f68a3c8646d58c00d3f4a980'
  - 30102
  is:
  - 20
  - 3
  - 0
  - 0
  - - '0x589dedbd617e0cbcb916a9223f4d1300c294236b'
    - '0xa4fe5a5b9a846458a70cd0748228aed3bf65c2cd'
    - '0xa59ba433ac34d2927232918ef5b2eaafcf130ba5'
  - []
  says: the same three on eid 30102
  for:
  - what
- id: tm-custom-30110
  call: '0xc02ab410f0734efa3f14628780e6e695156024c2'
  fn: getAppUlnConfig(address,uint32)((uint64,uint8,uint8,uint8,address[],address[]))
  args:
  - '0x6d6620efa72948c5f68a3c8646d58c00d3f4a980'
  - 30110
  is:
  - 0
  - 3
  - 255
  - 0
  - - '0x589dedbd617e0cbcb916a9223f4d1300c294236b'
    - '0xa4fe5a5b9a846458a70cd0748228aed3bf65c2cd'
    - '0xa59ba433ac34d2927232918ef5b2eaafcf130ba5'
  - []
  says: the three-DVN list is Stargate's own setting, not the default
  for:
  - action
  - justification
  - what
- id: tm-owner
  call: '0x6d6620efa72948c5f68a3c8646d58c00d3f4a980'
  fn: owner()(address)
  is: '0xbe634b030feaab661300667eaf82510a3a025413'
  says: TokenMessaging's owner
  for:
  - action
- id: tm-delegate
  call: '0x1a44076050125825900e736c501f859c50fe728c'
  fn: delegates(address)(address)
  args:
  - '0x6d6620efa72948c5f68a3c8646d58c00d3f4a980'
  is: '0xbe634b030feaab661300667eaf82510a3a025413'
  says: the same address is TokenMessaging's endpoint delegate, who sets its config
  for:
  - action
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: review (Review04)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews:
- who: r-589dedbd, the row's refuter
  date: 2026-11-22
  by: ai-assisted
  verdict: refuted
  note: 'disagree: what-3: the USDC pool pays out only when Stargate''s TokenMessaging 0x6d6620ef... calls it, and
    that contract requires this DVN plus two others (0xa4fe5a5b..., 0xa59ba433...), not three; the four-DVN list
    is LayerZero''s default, read for the pool''s address, which gets no messages. Should say: ''needs it and two
    other verifiers''.; action/justification checks: pool-config-30110 and default-config-30110 do not govern the
    pool; back them with TokenMessaging''s config (getAppUlnConfig shows Stargate''s o (the card was edited after
    this answer)'
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: A LayerZero verifier (DVN) that confirms cross-chain messages on 2 of its 3 signers'' ECDSA signatures;
    quorumChangeAdmin grants the admin role on those signatures alone; the code cannot change and setSigner only
    installs another ECDSA-checked address. MEDIUM, PQ-5: two forged signer keys make it confirm any message, and
    apps must move to a new verifier. Author A-589dedbd. Refuter R-589dedbd disagreed on two points, both right,
    and the reader corrected the card with the refuter''s checks: (1) Stargate''s USDC pool (43.25M USDC) pays out
    only through TokenMessaging 0x6d6620ef, whose own config requires this verifier and two others, not three; the
    four-verifier list was LayerZero''s default read at the pool''s address, which receives no messages; (2) the
    action and the justification now cite TokenMessaging''s config and its owner, who sets it. Not claimed: whether
    any app relies on this verifier alone (needs logs).'
related: []
---

## What happens

This verifier confirms cross-chain messages when 2 of its 3 signers sign with ECDSA. Two signer keys derived from their public signatures by a quantum computer would make it confirm any message. Stargate's USDC pool, holding 43.25M USDC, needs it and two other verifiers.

## Evidence

- [verifySignatures](https://etherscan.io/address/0x589dedbd617e0cbcb916a9223f4d1300c294236b#code) recovers each signature of the quorum with ECDSA and checks it against the signer list.
- `quorumChangeAdmin` in the [verified source](https://etherscan.io/address/0x589dedbd617e0cbcb916a9223f4d1300c294236b#code) grants admin rights on signer signatures alone.
- The current signers' signatures are public, as in [this transaction](https://etherscan.io/tx/0xd05da00b16281d24d2fb5342d4870a91706ae1c7e1c0a407e137e58f5276497a) that confirmed a message.

## Reviewer notes

### Mechanism

execute (DVN.sol 171-215, ADMIN_ROLE only) hashes each instruction (vid, target, expiration, callData) and calls verifySignatures (MultiSig.sol 81-99): exactly quorum x 65 bytes, each slice recovered with ECDSA.tryRecover over the eth-signed hash, signers ascending, each in the signers mapping. It then calls target with callData, in practice ReceiveUln302.verify, which records this DVN as having verified the packet (ReceiveUlnBase.sol 44). commitVerification requires every required DVN of the receiver's config before passing the payload hash to the endpoint (ReceiveUlnBase.sol 59-61, 90-120). quorumChangeAdmin (DVN.sol 132-155) is open to any caller and grants ADMIN_ROLE to the address in callData on quorum signatures alone. setSigner/setQuorum are onlySelf, reached only via execute with quorum signatures. No upgrade path. At the block: quorum 2, signerSize 3; 0x0342...c164 and 0x238f...8ab5 are signers with empty code. The default ULN config and the Stargate USDC pool's config for eids 30110, 30184, 30102 require four DVNs: 0x3802...f20d, this one, 0xa4fe...c2cd, 0xa59b...0ba5. ReceiveUln302's owner 0xbe01...2478 sets the defaults (UlnBase.sol 55). The USDC pool pays out only when Stargate's TokenMessaging (0x6d6620ef...) calls it; that contract's config, set by its owner 0xbe634b03..., requires this DVN and two others.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: ERC-1271 or another scheme for signers: verifySignatures (MultiSig.sol 81-99) only recovers with ECDSA; a signer with code never counts.
- Ruled out: unused address: not a proxy; 27,889 trace-window transactions recovered the two current signers; tx 0xd05da00b... to this address succeeded.
- Ruled out: pause: paused() is false at the block; execute and quorumChangeAdmin carry no whenNotPaused.
- Ruled out: a path that confirms without signatures: the other admin-only functions cannot make this DVN call verify; only execute, gated by quorum signatures, makes arbitrary calls.
- Ruled out: rotation as a fix: setSigner installs another ECDSA-checked address. The signers recovered up to March 2026 are no longer signers at the block, so the set was rotated once; the third current signer is unknown without logs.
- Ruled out: forging this DVN alone: TokenMessaging's config also requires two other DVNs (ReceiveUlnBase.sol 96-106); whether any app needs only this one needs logs and is not claimed.
- Ruled out: value: the DVN holds nothing; the old cross-pool escrow figure is not carried over; only the USDC pool's own balance is read.
- Ruled out: EIP-8151 itself: both current signers are empty-code accounts and the recovery forwards all gas; a rotate-before-migrating notice for the signers is a separate root issue, not filed here.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
