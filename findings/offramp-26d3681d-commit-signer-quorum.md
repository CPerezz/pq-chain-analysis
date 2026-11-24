---
id: offramp-26d3681d-commit-signer-quorum
format: 2
title: Forged commit signer keys let a quantum attacker release CCIP bridge tokens
status: candidate
severity: MEDIUM
justification: Forged keys release pooled tokens; the fix is new verification code that Chainlink must deploy.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x26d3681dfc9e4c8c79cfbf461adec8a21d5d73c5'
  name: OffRamp
  project: chainlink
  code: verified
  code_url: https://etherscan.io/address/0x26d3681dfc9e4c8c79cfbf461adec8a21d5d73c5#code
  copies: 1
  upgradeable: 'no'
  admin: '0x44835bbba9d40deda9b64858095ecfb2693c9449'
value:
  usd: 0
  basis: held
activity: {}
impact: funds-loss
action: Deploy an off-ramp with post-quantum commit signatures, add it to the Router and remove this one; rotating
  signers keeps ECDSA.
evidence_level: source
checks:
- id: recover
  source: '0x26d3681dfc9e4c8c79cfbf461adec8a21d5d73c5'
  file: src/v0.8/ccip/ocr/MultiOCR3Base.sol
  line: 318
  has: address signer = ecrecover(hashedReport, uint8(rawVs[i]) + 27, rs[i], ss[i]);
  says: each commit signature is recovered with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: role
  source: '0x26d3681dfc9e4c8c79cfbf461adec8a21d5d73c5'
  file: src/v0.8/ccip/ocr/MultiOCR3Base.sol
  lines:
  - 320
  - 323
  has: if (oracle.role != Role.Signer) revert UnauthorizedSigner(); if (signed & (0x1 << oracle.index) != 0) revert
    NonUniqueSignatures();
  says: each recovered address must hold the stored Signer role, and signers must be distinct
  for:
  - evidence-1
  - what
- id: count
  source: '0x26d3681dfc9e4c8c79cfbf461adec8a21d5d73c5'
  file: src/v0.8/ccip/ocr/MultiOCR3Base.sol
  line: 288
  has: if (rs.length != configInfo.F + 1) revert WrongNumberOfSignatures();
  says: a report carries exactly F+1 signatures
  for:
  - evidence-1
  - what
- id: transmitter
  source: '0x26d3681dfc9e4c8c79cfbf461adec8a21d5d73c5'
  file: src/v0.8/ccip/ocr/MultiOCR3Base.sol
  lines:
  - 272
  - 277
  has: transmitter.role == Role.Transmitter
  says: the report must be sent by a configured transmitter
  for:
  - what
- id: config
  call: '0x26d3681dfc9e4c8c79cfbf461adec8a21d5d73c5'
  fn: latestConfigDetails(uint8)(((bytes32,uint8,uint8,bool),address[],address[]))
  args:
  - 0
  is:
  - - '0x000a4629e22851b5fc99f512c204ca08926586e4596b20309d2044cc6caab70b'
    - 5
    - 16
    - true
  - - '0x8c8167acfa0dc624e88054f5f4f92853ff0300cb'
    - '0xd33e2ea7f20e734617db6261105fb392dfe5e3ef'
    - '0x8c027d245d800f9887adb0a0bf23fb0816fc3d83'
    - '0x376038c76d067eae5cefa1042dd7fd382f9ebc61'
    - '0xd7956c40e387ea45a0b28df568353436e869b4a7'
    - '0xc3cfa4ff2a4b4fe39cf7ffdcdd44584ce57d244b'
    - '0x0fab8d0907d1349bb9e21af4c42bdfb52ca03ce0'
    - '0x2d2251fac6871df405450337e327683822bafc52'
    - '0x21e0fd5bc82a8760abfb9faa3ceedc5e7a77b6bf'
    - '0x7502128af7a58e9906696ea6b60434f75d0026e0'
    - '0x0de127a00242d8b7b477df58656ffbb127835468'
    - '0x64ef6a50875b1d9824e8e51ec1cad93c559e8e26'
    - '0x1e78d24845a94dd27cc2c746fc920a3958eca29f'
    - '0x6ec3b0c8604043f78f8fc425a5ca47fcf4b3404d'
    - '0xa761c71063cbdd6bce3d83b6da19bbac10aa23f7'
    - '0xc4940a913488e924820a66dabcd0cf33830b8c1d'
  - - '0xccad6836e9e3c05f737573c4a4ca8b311a684df2'
    - '0xbe004180112433deb2f9ccb3ed17920bd13ca2ba'
    - '0x802d353c5d8b1865f73f6669e48e7c4b752853eb'
    - '0xceeb4c3b08a10b4ee3dbb83996c14454d425e37f'
    - '0x19d5d543878ce0163874faf3b5a8f8aa12bea03e'
    - '0x69a0720c66a1f9c8893b9982ba1578ddf6137546'
    - '0x564a5b77edc6e66b32f108b9b8df63a4e6b7ab44'
    - '0x6b0f53dadc2ce610b963788f8014ffed1b818fb4'
    - '0x796dbe6593e339d76ad5d59ad584595156071849'
    - '0x6d955d32713abaa10c34f27d9f5608bb73711984'
    - '0x0ee05ab47c2d68dbc821d205d876955b2289d9fb'
    - '0x7ca4321170ede03dacf21cd2d57945226c93839a'
    - '0x2ed0c5eedc30985feecbaa446fbc80e34742d217'
    - '0xb0a0a0d9f00813c5e1ccd5f677263c0bc156093f'
    - '0x66ed924143d3a20382cd70bf73813070fffe7d8c'
    - '0x1374fe931e49b15e397a15244eb2d3dc86219bd1'
  says: 'commit plugin: F = 5, 16 signers, signature checks on, 16 transmitters'
  for:
  - evidence-1
  - what
- id: txkey
  nonce: '0xccad6836e9e3c05f737573c4a4ca8b311a684df2'
  min: 1
  says: a commit transmitter has sent transactions, so its public key is on chain
  for:
  - what
- id: committx
  tx: '0xb59ce20f1260ed25306df863983c696956fa5651321cadba786f335c240ef47d'
  to: '0x26d3681dfc9e4c8c79cfbf461adec8a21d5d73c5'
  ok: true
  says: a real commit carrying signer signatures, public in its calldata
  for:
  - what
- id: commitsel
  selector: '0x26d3681dfc9e4c8c79cfbf461adec8a21d5d73c5'
  fn: commit(bytes32[2],bytes,bytes32[],bytes32[],bytes32)
  says: commit (0xde5e0b9a) is in the runtime code
  for:
  - notes
- id: commit
  source: '0x26d3681dfc9e4c8c79cfbf461adec8a21d5d73c5'
  file: src/v0.8/ccip/offRamp/OffRamp.sol
  line: 854
  has: _transmit(uint8(Internal.OCRPluginType.Commit), reportContext, report, rs, ss, rawVs);
  says: commit checks the signatures through _transmit
  for:
  - notes
- id: rmnonly
  source: '0x26d3681dfc9e4c8c79cfbf461adec8a21d5d73c5'
  file: src/v0.8/ccip/offRamp/OffRamp.sol
  lines:
  - 817
  - 820
  has: if (commitReport.blessedMerkleRoots.length > 0) { i_rmnRemote.verify(address(this), commitReport.blessedMerkleRoots,
    commitReport.rmnSignatures);
  says: the risk network is asked only for blessed roots
  for:
  - evidence-1
  - what
- id: blessmatch
  source: '0x26d3681dfc9e4c8c79cfbf461adec8a21d5d73c5'
  file: src/v0.8/ccip/offRamp/OffRamp.sol
  line: 873
  has: if (isBlessed == sourceChainConfig.isRMNVerificationDisabled) {
  says: a lane with RMN verification disabled takes unblessed roots
  for:
  - what
- id: lanes
  call: '0x26d3681dfc9e4c8c79cfbf461adec8a21d5d73c5'
  fn: getAllSourceChainConfigs()(uint64[],(address,bool,uint64,bool,bytes)[])
  is:
  - - 11344663589394136015
    - 15971525489660198786
    - 4949039107694359620
    - 124615329519749607
    - 13624601974233774587
    - 18164309074156128038
    - 4741433654826277614
    - 17673274061779414707
    - 5936861837188149645
    - 6473245816409426016
    - 9335212494177455608
    - 4426351306075016396
    - 2135107236357186872
    - 3016212468291539606
    - 9723842205701363942
    - 4829375610284793157
    - 8481857512324358265
    - 12657445206920369324
    - 1523760397290643893
    - 16978377838628290997
    - 6093540873831549674
    - 17529533435026248318
    - 1556008542357238666
    - 7801139999541420232
    - 6325494908023253251
    - 4059281736450291836
    - 17912061998839310979
    - 2442541497099098535
    - 16448340667252469081
    - 7281642695469137430
    - 18240105181246962294
    - 3461204551265785888
    - 6180753054346818345
    - 3229138320728879060
    - 6370580034781731079
    - 4215185756725900654
    - 2988178761202034333
  - - - '0x3237c0d7b58bec8dc17f00103b784bd6678f789e'
      - true
      - 9
      - true
      - '0x000000000000000000000000f09afe78d3c7d359b334d7cb88995751f7ec5e13'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 4908
      - true
      - '0x000000000000000000000000ee85aefb15b9489563a6a29891ebe0750aa1a7ae'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 2597
      - true
      - '0x00000000000000000000000076a443768a5e3b8d1aed0105fc250877841deb40'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 9056
      - true
      - '0xac972977e1bab5fff6c686291f994ff52f34abed1bc7df88f76f43f926592c8f'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 356
      - true
      - '0x000000000000000000000000d4d2841ac332075833ae86eb49ce7af9f353cd21'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 161
      - true
      - '0x000000000000000000000000318ec96df83accc18b5ead5d23e0f022f7eb5503'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 508
      - true
      - '0x20f808de3375db34d17cc946ec6b43fc26962f6afa125182dc903359756caf6b'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 14
      - true
      - '0x00000000000000000000000040530f5305d6fd6912925c5ec2c36453b85d8f5f'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 142
      - true
      - '0x00000000000000000000000051e2a24742db77604b881d6781ee16b5b8fcbe29'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 145
      - true
      - '0x000000000000000000000000913814782144864e523c3fdb78e3ca25d2c2aeca'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 2993
      - true
      - '0x0000000000000000000000008fe3b17e6b0863aeea3d38df063aea39d4ab1602'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 2538
      - true
      - '0x000000000000000000000000a132f089492cce5f1d79483a9e4552f37266ed01'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 149
      - true
      - '0x000000000000000000000000345cc465bcb9a902b420320b8793c9a5d6064404'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 25
      - true
      - '0x000000000000000000000000530ae314ec3fa038bd9a215095e37295ec76162a'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 144
      - true
      - '0x000000000000000000000000dd8af6046349edfd40123e0b616286cec08010ed'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 194
      - true
      - '0x0000000000000000000000009b04018b5285ff16f3967af108bdc72423d547cc'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 3123
      - true
      - '0x000000000000000000000000cdca5d374e46a6dddab50bd2d9acb8c796ec35c3'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 155
      - true
      - '0x0000000000000000000000009b04018b5285ff16f3967af108bdc72423d547cc'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 91
      - true
      - '0x0000000000000000000000009b04018b5285ff16f3967af108bdc72423d547cc'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 88
      - true
      - '0x000000000000000000000000d21d5a4e3fa0ebacc3dabb5258d9c1f4d24dc894'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 226
      - true
      - '0x00000000000000000000000059d32e5fa8eed1fd1510f7e583a2b6e6142dd49f'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 10
      - true
      - '0x03e843cbba25c863bae63783fe99213c5269916ed4a8bba32489094baa580fbf'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 460
      - true
      - '0x0000000000000000000000004e2c866885b65f67e7a2b8382ecf0164bb19aa00'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 274
      - true
      - '0x000000000000000000000000193beb1e11731b8b740b9fbbb62655553c3b4a25'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 28
      - true
      - '0x000000000000000000000000a132f089492cce5f1d79483a9e4552f37266ed01'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 27011
      - true
      - '0x000000000000000000000000abd3f7722c178e42db20065f063b1e758b19fdb6'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 228
      - true
      - '0x000000000000000000000000c23071a8ae83671f37bda1dadbc745a9780f632a'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 69
      - true
      - '0x00000000000000000000000072f6000d70b291c67bed898214156d01383274b1'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 35
      - true
      - '0x00000000ec893bc42d1abdf46f4b9d0712e17d826b8b6a40df15009dc541697866ade47a'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 65
      - true
      - '0x00000000000000000000000021d66d23fe27bb4175c866d4d3ee9bc12c4824e3'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 61
      - true
      - '0x000000000000000000000000770318d51052871def5eb5c452f4fd28b7960c4e'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 55
      - true
      - '0x000000000000000000000000530ae314ec3fa038bd9a215095e37295ec76162a'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 278
      - true
      - '0x000000000000000000000000e72d25add538e8ef9cef85622ea8912a6cb98be6'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 7
      - true
      - '0x000000000000000000000000ee85aefb15b9489563a6a29891ebe0750aa1a7ae'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 167
      - true
      - '0x000000000000000000000000051665f2455116e929b9972c36d23070f5054ce0'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 155
      - true
      - '0x0000000000000000000000009b04018b5285ff16f3967af108bdc72423d547cc'
    - - '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
      - true
      - 166
      - true
      - '0x0000000000000000000000009b04018b5285ff16f3967af108bdc72423d547cc'
  says: 37 source lanes, all enabled, all with RMN verification disabled
  for:
  - what
- id: manual
  source: '0x26d3681dfc9e4c8c79cfbf461adec8a21d5d73c5'
  file: src/v0.8/ccip/offRamp/OffRamp.sol
  lines:
  - 277
  - 280
  has: function manuallyExecute( Internal.ExecutionReport[] memory reports, GasLimitOverride[][] memory gasLimitOverrides
    ) external {
  says: manuallyExecute has no caller check
  for:
  - what
- id: threshold
  source: '0x26d3681dfc9e4c8c79cfbf461adec8a21d5d73c5'
  file: src/v0.8/ccip/offRamp/OffRamp.sol
  lines:
  - 456
  - 461
  has: (block.timestamp - timestampCommitted) > s_dynamicConfig.permissionLessExecutionThresholdSeconds;
  says: manual execution opens once the committed root is older than the threshold
  for:
  - what
- id: dyn
  call: '0x26d3681dfc9e4c8c79cfbf461adec8a21d5d73c5'
  fn: getDynamicConfig()((address,uint32,address))
  is:
  - '0x93669cf8eabe869687544de34b453063fb23bb69'
  - 3600
  - '0x0000000000000000000000000000000000000000'
  says: the threshold is 3,600 seconds, one hour
  for:
  - what
- id: release
  source: '0x26d3681dfc9e4c8c79cfbf461adec8a21d5d73c5'
  file: src/v0.8/ccip/offRamp/OffRamp.sol
  lines:
  - 688
  - 691
  has: IPoolV1.releaseOrMint,
  says: executing a message calls the token pool's releaseOrMint
  for:
  - justification
  - what
- id: router
  call: '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
  fn: isOffRamp(uint64,address)(bool)
  args:
  - 15971525489660198786
  - '0x26d3681dfc9e4c8c79cfbf461adec8a21d5d73c5'
  is: true
  says: the CCIP Router accepts this address as an off-ramp on that lane
  for:
  - action
  - evidence-3
  - what
- id: pool
  call: '0xb22764f98dd05c789929716d677382df22c05cb6'
  fn: getPool(address)(address)
  args:
  - '0x514910771af9ca656af840dff83e8264ecf986ca'
  is: '0x1b7492c3bd23a4adb448710e4275ff14a5288932'
  says: the token admin registry this off-ramp uses names the LINK pool
  for:
  - evidence-3
  - what
- id: pooltype
  call: '0x1b7492c3bd23a4adb448710e4275ff14a5288932'
  fn: typeAndVersion()(string)
  is: LockReleaseTokenPool 1.5.1
  says: the LINK pool locks and releases bridged LINK
  for:
  - evidence-3
- id: linkbal
  call: '0x514910771af9ca656af840dff83e8264ecf986ca'
  fn: balanceOf(address)(uint256)
  args:
  - '0x1b7492c3bd23a4adb448710e4275ff14a5288932'
  is: 315416438807547151649769
  says: the LINK pool holds 315,416 LINK
  for:
  - evidence-3
- id: poollane
  call: '0x1b7492c3bd23a4adb448710e4275ff14a5288932'
  fn: isSupportedChain(uint64)(bool)
  args:
  - 15971525489660198786
  is: true
  says: the LINK pool serves that lane
  for:
  - evidence-3
  - what
- id: rate
  call: '0x1b7492c3bd23a4adb448710e4275ff14a5288932'
  fn: getCurrentInboundRateLimiterState(uint64)((uint128,uint32,bool,uint128,uint128))
  args:
  - 15971525489660198786
  is:
  - 50000000000000000000000
  - 1794969479
  - true
  - 50000000000000000000000
  - 13880000000000000000
  says: 'inbound limit on that lane: 50,000 LINK capacity, refilling 13.88 LINK a second'
  for:
  - evidence-3
- id: setter
  source: '0x26d3681dfc9e4c8c79cfbf461adec8a21d5d73c5'
  file: src/v0.8/ccip/ocr/MultiOCR3Base.sol
  lines:
  - 131
  - 133
  has: function setOCR3Configs( OCRConfigArgs[] memory ocrConfigArgs ) external onlyOwner {
  says: only the owner replaces signers and transmitters
  for:
  - evidence-2
- id: static
  source: '0x26d3681dfc9e4c8c79cfbf461adec8a21d5d73c5'
  file: src/v0.8/ccip/ocr/MultiOCR3Base.sol
  lines:
  - 154
  - 156
  has: revert StaticConfigCannotBeChanged(ocrPluginType);
  says: signature checking cannot be switched once set
  for:
  - action
  - evidence-2
  - justification
- id: mustsign
  source: '0x26d3681dfc9e4c8c79cfbf461adec8a21d5d73c5'
  file: src/v0.8/ccip/offRamp/OffRamp.sol
  lines:
  - 933
  - 937
  has: revert SignatureVerificationRequiredInCommitPlugin();
  says: the commit plugin must always check signatures
  for:
  - action
  - evidence-2
  - justification
- id: owner
  call: '0x26d3681dfc9e4c8c79cfbf461adec8a21d5d73c5'
  fn: owner()(address)
  is: '0x44835bbba9d40deda9b64858095ecfb2693c9449'
  says: the owner is the RBACTimelock
  for:
  - action
  - evidence-2
- id: delay
  call: '0x44835bbba9d40deda9b64858095ecfb2693c9449'
  fn: getMinDelay()(uint256)
  is: 10800
  says: the timelock's minimum delay is 3 hours
  for:
  - evidence-2
- id: tlcode
  code: '0x44835bbba9d40deda9b64858095ecfb2693c9449'
  is: contract
  says: the owner is a contract
  for:
  - evidence-2
- id: curse
  call: '0x411de17f12d1a34ecc7f45f49844626267c75e81'
  fn: isCursed()(bool)
  is: false
  says: the risk network has no global curse in force
  for:
  - notes
- id: bypasser
  call: '0x44835bbba9d40deda9b64858095ecfb2693c9449'
  fn: getRoleMemberCount(bytes32)(uint256)
  args:
  - '0xa1b2b8005de234c4b8ce8cd0be058239056e0d54f6097825b5117101469d5a8d'
  is: 1
  says: the timelock has one BYPASSER_ROLE member, which can execute without the 3-hour delay
  for:
  - evidence-2
- id: r-rampupdates
  selector: '0x80226fc0ee2b096224eeac085bb9a8cba1146f7d'
  fn: applyRampUpdates((uint64,address)[],(uint64,address)[],(uint64,address)[])
  says: the Router can add and remove off-ramps
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
  who: Review11 (Claude), finding review
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
reviews:
- who: r-26d3681d, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Kev''s first-study finding, MEDIUM candidate (PQ-5): CCIP OffRamp 1.6.0 accepts a commit report on
    6 of 16 ECDSA signers with the risk network''s blessing off on all 37 lanes; forged commits execute after an
    hour and release pool tokens (the LINK pool: 315,416 LINK, 50,000 per lane at once). Fix is new verification
    code: deploy a post-quantum off-ramp, add it to the Router and remove this one (the Router lists several off-ramps
    per lane: second refuter''s point, made by Claude). Claude also left whose open (the pool''s rebalancer Safe
    may hold part of the LINK; question kept) and named the timelock''s bypasser. Refuters agree on the final card;
    Claude read the sheet.'
related: []
---

## What happens

This CCIP off-ramp accepts a commit report once 6 of its 16 signers sign it with ECDSA; risk-network blessing is off on all 37 lanes. With those keys and a transmitter's, a quantum attacker commits invented messages that anyone can execute an hour later, releasing tokens from pools such as LINK's.

## Evidence

- The [verified source](https://etherscan.io/address/0x26d3681dfc9e4c8c79cfbf461adec8a21d5d73c5#code) recovers each commit signature with ECDSA, needs 6 distinct signers, and asks the risk network only for blessed roots.
- The [owner](https://etherscan.io/address/0x44835bbba9d40deda9b64858095ecfb2693c9449), a timelock with a 3-hour minimum delay and one bypasser who need not wait, can replace signers, but commit reports always need ECDSA signatures.
- The Router accepts this off-ramp; the [LINK pool](https://etherscan.io/address/0x1b7492c3bd23a4adb448710e4275ff14a5288932) holds 315,416 LINK and lets up to 50,000 out at once on one of its lanes.

## Reviewer notes

### Mechanism

commit (OffRamp.sol 807-855) decodes the report, asks RMNRemote.verify only for blessedMerkleRoots (818-820), commits unblessed roots for lanes whose isRMNVerificationDisabled is true (873), then calls MultiOCR3Base._transmit (854). _transmit requires a configured transmitter (272-283) and exactly F+1 signatures (288); _verifySignatures recovers each with ecrecover (318) and requires a distinct Signer role (320-323). At the block F = 5 and 16 signers, and all 37 lanes have RMN verification disabled. A committed root lets manuallyExecute (277, no caller check) run its messages once older than permissionLessExecutionThresholdSeconds = 3,600 (456-461); executeSingleMessage calls the pool's releaseOrMint (688-691) for the token the TokenAdminRegistry names. setOCR3Configs (onlyOwner, 131-133) replaces signers but the commit plugin must keep signature checks (154-156; OffRamp 933-937), so the scheme stays ECDSA. Owner: RBACTimelock 0x4483, min delay 10,800 s. Signer keys never send transactions (nonce 0) but their public keys follow from the signatures in every commit; transmitter keys sign transactions.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or second verification path for signers: _verifySignatures has none (MultiOCR3Base 305-325).
- Ruled out: unused address: the Router accepts it as off-ramp (36 lanes in getOffRamps at the block) and the study window shows 87,414 recoveries up to block 26,438,996.
- Ruled out: risk-network blessing as a second committee: disabled on all 37 lanes at the block; the risk network can still curse a lane (isCursed checked in _commitRoot and execution), and no global curse is in force.
- Ruled out: fixed gas: ecrecover is the Solidity builtin with all gas forwarded; the scan found no gas constant. Under EIP-8151 a signer that moves to real code stops counting until the owner rotates it; that migration notice is a separate issue, not this card.
- Ruled out: the old escrow figure (all CCIP pools, about $1.19B) is not carried over: it was an upper bound across pools and lanes that no check here re-reads; the card cites one pool with its rate limit.
- Ruled out: pool rate limits bound how fast a forged message drains a pool; they slow the loss, they do not stop it.

### Questions

- Whose is the LINK pool's 315,416 LINK: bridged users' tokens, the 2-of-6 rebalancer Safe's own liquidity, or both? Only the pool's liquidity events can show it.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
