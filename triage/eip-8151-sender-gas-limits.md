---
id: eip-8151-sender-gas-limits
title: "Transactions sent with too little gas for EIP-8151's price fail on activation day"
status: candidate
severity: LOW
patterns: [PQ-18]
contracts:
- address: "0x2ceb3e994a516c6ba8658211bc94d4c280486cb7"
  project: unidentified-83723113
  name: "GnosisSafeL2 (study family 922d8150), 1 of 8,589 addresses running it"
  upgradeable: "yes"
- address: "0xf4ac5a5dc1543086347d28e757091ebd1b848cca"
  project: unidentified-d7df5bf3
  name: "SafeL2 (study family 9a69c84f), 1 of 39,586 addresses running it"
  upgradeable: "yes"
- address: "0xd19d8ee0a736bf643f53e3dc5489ac94e947a482"
  project: unidentified-0ec16ef9
  name: "NXV (study family e41c77f8), 1 of 80 addresses running it"
  upgradeable: "yes"
- address: "0xb60fa2ad48959c016fb7545d045aeb60086aca2a"
  project: unidentified-3baf6263
  name: "MultiSign (study family 7d5e2ccb), 1 of 34 addresses running it"
  upgradeable: "no"
- address: "0xc2a26188e4d7521960c2ddd31947afa9b2fdd8ac"
  project: unidentified-3baf6263
  name: "unverified code (study family af3852b1), 1 of 5 addresses running it"
  upgradeable: "no"
- address: "0x5427fefa711eff984124bfbb1ab6fbf5e3da1820"
  project: unidentified-1b9dfc56
  name: "Bridge (study family f3969f72), 1 of 5 addresses running it"
  upgradeable: "no"
- address: "0x563eda2afb088b36a1b3735126c409372a6ef46c"
  project: unidentified-ddd85fb0
  name: "Identity (study family c8c4077d), 1 of 3,069 addresses running it"
  upgradeable: "no"
- address: "0x5978c6153a06b141cd0935569f600a83eb44aeaa"
  project: unidentified-96996f23
  name: "unverified code (study family 6022f261)"
  upgradeable: "no"
  value_usd: 737885
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x313416870a4da6f12505a550b67bb73c8e21d5d3"
  project: unidentified-bdc3ab91
  name: "Bridge (study family e3292b2f)"
  upgradeable: "no"
  value_usd: 611565
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x448a9c8a25dc1ec8af43c351bdd0919acbc5be7e"
  project: unidentified-a9e0be08
  name: "Uni (study family d927799d), 1 of 7 addresses running it"
  upgradeable: "yes"
- address: "0x00f2b67b5a5ec2ff88b2be7d5a8d1a39d5929237"
  project: unidentified-23e8bbee
  name: "unverified code (study family d17fa1b5), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x02479bfc7dce53a02e26fe7baea45a0852cb0909"
  project: unidentified-04509d93
  name: "GnosisSafe (study family f15632f5), 1 of 749 addresses running it"
  upgradeable: "yes"
- address: "0xb8563f7bee7fbf68f8b09c97ee4a13dc6c6943ee"
  project: unidentified-d22ad90c
  name: "SettlementSale (study family 8a325b36), 1 of 15 addresses running it"
  upgradeable: "no"
- address: "0x45804880de22913dafe09f4980848ece6ecbaf78"
  project: unidentified-4b39f384
  name: "PAXG (study family 9c1bb3ea), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x6c70c6a2b6b2b0d40e826bfde89fe2e081ca408b"
  project: unidentified-dc9dc0c0
  name: "BridgeVault (study family 5ac31e72)"
  upgradeable: "no"
  value_usd: 103762
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xe80f92077131b9890599e418ae323de71ce1c35a"
  project: unidentified-b669ce71
  name: "SrcBridge (study family 2664bab4), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x468ac716493c51184162681130035b61baff040b"
  project: unidentified-46f064fc
  name: "SmartWalletUpgradeableV2 (study family b57e4077), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x94c9d55f064980ed1faf0abb42f3548700619039"
  project: unidentified-fd3718e7
  name: "Bridge (study family 6fb6da97), 1 of 6 addresses running it"
  upgradeable: "yes"
- address: "0xcb99c58fe81ae6b2cb4835e46f7b703745879042"
  project: unidentified-ceae64c7
  name: "OxidePortal (study family 30acf8f4), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x4080eba7392e3a1824b5a4eba09d7307a5c51b2d"
  project: unidentified-88f2d303
  name: "unverified code (study family 2425f847)"
  upgradeable: "no"
  value_usd: 48362
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x965983977c29158ec53a296a6f47be145ddecc36"
  project: unidentified-15b53fda
  name: "TruthBridge (study family 043cea7a), 1 of 4 addresses running it"
  upgradeable: "yes"
- address: "0xe3f5cf1313dfe3c2827604a187677c34c7ed9aa1"
  project: unidentified-2ccf820f
  name: "unverified code (study family 6b72c066)"
  upgradeable: "no"
  value_usd: 44031
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x3d64bd587300af85ae54007d350bfd293dc24581"
  project: unidentified-494f5d0e
  name: "unverified code (study family c43de8b9), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x24b22b031ae1b5a6b09f9a0fd33613a40e0d70e6"
  project: unidentified-4baaf565
  name: "unverified code (study family fcac02a7), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x28e8882c7e23bc5e3b94c64df34b6e45738a14b9"
  project: unidentified-6deb265a
  name: "unverified code (study family 15c107bb)"
  upgradeable: "no"
  value_usd: 34106
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x49a102a0c04723739f601c158b5d13920ab59d4d"
  project: unidentified-831cfd6b
  name: "PocketDragonsCollection (study family 9e18e28f)"
  upgradeable: "no"
  value_usd: 31038
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xbd0a894e8f8919be0b9eb0f034d1db4e1ac415cf"
  project: unidentified-6b116178
  name: "unverified code (study family f2d6dbad), 1 of 4 addresses running it"
  upgradeable: "yes"
- address: "0x5217493257fcbf209580342e6929e20d2ac914f1"
  project: unidentified-9c7a11df
  name: "Invoice (study family d217865e)"
  upgradeable: "no"
  value_usd: 27249
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x959e33b167e66b09cb524e610e7ef7fb0e4e2d81"
  project: unidentified-24029a57
  name: "RewardClaimer (study family 0901b485)"
  upgradeable: "no"
  value_usd: 24001
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xa32d571fa4dc0011539a0c2fbc8fdfba1dd9a76f"
  project: unidentified-3904f3da
  name: "unverified code (study family 23ec0c1b)"
  upgradeable: "no"
  value_usd: 24001
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x35ac13efaab970f32269b61e4704f4377ce7a0ad"
  project: unidentified-65d22286
  name: "unverified code (study family a26ec3fd), 1 of 4 addresses running it"
  upgradeable: "yes"
- address: "0xbffd79740f9dbb1db94f53bc4c7f8e6ae67b2678"
  project: unidentified-e833af91
  name: "unverified code (study family cdd0f5c7)"
  upgradeable: "no"
  value_usd: 19309
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xc22c479a54925608cc8cd60fbf69510df31aef26"
  project: unidentified-1d75e498
  name: "unverified code (study family bc362389), 1 of 4 addresses running it"
  upgradeable: "yes"
- address: "0xcff5d60bdcb541b31f416ef9779048b0653d04ef"
  project: unidentified-0bdbb412
  name: "unverified code (study family fffa0357), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xd20c024560cca40288c05bab650ac087ae9b0f6e"
  project: unidentified-874c244c
  name: "BatchTrade (study family 0eb672e9)"
  upgradeable: "no"
  value_usd: 11730
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xa4108aa1ec4967f8b52220a4f7e94a8201f2d906"
  project: unidentified-9cafd25b
  name: "Gravity (study family 6727a783)"
  upgradeable: "no"
  value_usd: 10827
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x9b5d9e2c2e1e96986603be922bc44304d6aca898"
  project: unidentified-72c92cab
  name: "Wallet (study family 413f5025)"
  upgradeable: "no"
  value_usd: 10106
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134"
  project: unidentified-7a0d94f5
  name: "AllowanceModule (study family 7c7cca90)"
  upgradeable: "no"
  value_usd: 9925
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xc4a386a0fc1910d60a5283001b6c94efc20e229c"
  project: unidentified-d520b102
  name: "Vault (study family d6883c1d), 1 of 4 addresses running it"
  upgradeable: "no"
- address: "0x24e830d3205e08bc124d8de8a3cfea28cab8a313"
  project: unidentified-c3f45a98
  name: "unverified code (study family 899b80f1)"
  upgradeable: "no"
  value_usd: 7038
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x9ef297c039103301c6c2ee8a1fc7742cae5557ee"
  project: unidentified-01c61177
  name: "LAD (study family e20aa9b6)"
  upgradeable: "no"
  value_usd: 6136
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xfb2dc580eed955b528407b4d36ffafe3da685401"
  project: unidentified-5777aa6f
  name: "Umbra (study family e51f9702)"
  upgradeable: "no"
  value_usd: 5594
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x62728e6ca081b8a253f792980736608e13d45d79"
  project: unidentified-31d97c2f
  name: "Plums (study family ee4900bc), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x97dc5ea031f0424e3a8994a66316c736bb99d8f7"
  project: unidentified-cde1efd7
  name: "ReferralRewardClaim (study family a70965af)"
  upgradeable: "no"
  value_usd: 3068
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xaa0878e38caeafc390876479f5a14c4705c7a54a"
  project: unidentified-5f95d415
  name: "ZebecCard (study family dd7a01fd), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x712868e72caa0c37596113c999fb4d83bcb6fec2"
  project: unidentified-ce1bafe8
  name: "unverified code (study family 207f2b49)"
  upgradeable: "no"
  value_usd: 2165
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xc38eb82ae302b5b3ef4f3cb66a4155d1947090b1"
  project: unidentified-32cad849
  name: "unverified code (study family 737d0a35), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xaec7e8c221c3fd24e75c996e32289235fd899ebf"
  project: unidentified-4c5d24a7
  name: "TeikhosBounty (study family 8186a92d), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x3249dfc80841c136ce5dc9c1b0d511f628b72b27"
  project: unidentified-6b77f6d5
  name: "ERC1155Normal (study family d89bbb67), 1 of 34 addresses running it"
  upgradeable: "yes"
- address: "0x6fb5a99485621b695d5e895838ff882f41743a9a"
  project: unidentified-9c6ecffe
  name: "unverified code (study family a11993ab)"
  upgradeable: "no"
  value_usd: 1083
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xa6f6e791c0152fb983162a216bfa9229e30896c6"
  project: unidentified-690f4e2f
  name: "unverified code (study family 15cf800e)"
  upgradeable: "no"
  value_usd: 902
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x74149f6d0dbdbe356fd8035a83dbc0ab7c4c1a8e"
  project: unidentified-3f0447a6
  name: "unverified code (study family 532c3675), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x22e95073d7a924660bb7222be327c9a6737dc68f"
  project: unidentified-8778c33f
  name: "Distributor (study family 13744d79), 1 of 4 addresses running it"
  upgradeable: "no"
- address: "0x2d26d31052c7d4696b6522a5f680b2c3dfc7bd61"
  project: unidentified-ce7bd51f
  name: "Bridge (study family 7d5f7af8), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x60f80121c31a0d46b5279700f9df786054aa5ee5"
  project: unidentified-3482549f
  name: "MintableToken (study family b44fa70d)"
  upgradeable: "no"
  value_usd: 722
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x93d070772066c977d605d69b602d316adafc25e3"
  project: unidentified-341a38b6
  name: "TetherToken (study family 57df7c13), 1 of 4 addresses running it"
  upgradeable: "yes"
- address: "0xc18360217d8f7ab5e7c516566761ea12ce7f9d72"
  project: unidentified-0904dac3
  name: "ENSToken (study family 132e6235)"
  upgradeable: "no"
  value_usd: 541
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x00000404734b3926572a2f004680a4e496e7da09"
  project: unidentified-140e07ae
  name: "unverified code (study family a7594b2b), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x91077b23df5edd82868b08b3c959e884370b4553"
  project: unidentified-295e0fc7
  name: "VaultAdapter (study family 8b130cfa), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x464f9caf42f5ab295c46f74bf6666b7381c8a60b"
  project: unidentified-72452734
  name: "unverified code (study family 244b0644)"
  upgradeable: "no"
  value_usd: 361
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x3310ad0117333f3b9d25857949df5a2e0856de3b"
  project: unidentified-df1792f7
  name: "SANDUIT (study family 9101ee9b), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xcd04419220bef347b409055ac4e9ad50ee1ad6d6"
  project: unidentified-c358522c
  name: "BuenoMembership (study family ddad8e1c)"
  upgradeable: "no"
  value_usd: 361
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xe02367242b348caca4bf39fd1249b212a88adcec"
  project: unidentified-335944b3
  name: "BFHPrimeV1 (study family d1002346)"
  upgradeable: "no"
  value_usd: 361
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x1bb668d33d367702adbe81346d57d5e5083fa346"
  project: unidentified-147b33c5
  name: "Ibc (study family 1745c7c0), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xca79896bcec80aa7628d67c6fac85bdf6ae63b1c"
  project: unidentified-9bd3befc
  name: "GatewayOfframpRegistryV7 (study family c80e9002), 1 of 4 addresses running it"
  upgradeable: "no"
- address: "0xa2ca14c7d625895e6939961b87ce378836ca840f"
  project: unidentified-cafe2ef5
  name: "HumanIDPayments (study family 61016422)"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xa4704944a59eab8a25ee539a9a6c42ff2527b265"
  project: unidentified-72452734
  name: "unverified code (study family dc2aee69), 1 of 141 addresses running it"
  upgradeable: "no"
- address: "0xda864364f7d1ebcc7c89e9610ebdef45ddf5f81b"
  project: unidentified-920212a0
  name: "unverified code (study family 5ed13761), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xc6a043a97986eabc761db0616513546043ee489a"
  project: unidentified-2907d55a
  name: "DigiGhostsSummoned (study family 39ea14ba)"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x0068c20b863745219b6f9542e86b1263029a1c2f"
  project: unidentified-00000000
  name: "Multisig (study family b3cc36f4), 1 of 15 addresses running it, 1 by 7702 delegation"
  upgradeable: "no"
- address: "0x287d38ca1d89cd3c435a8279ac9a3528ddeb9131"
  project: unidentified-2ae4874b
  name: "unverified code (study family a7051d16), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x3aeca27812d55af8c787a4277438ea01b39a73c4"
  project: unidentified-9fb8a85c
  name: "Escrow (study family ce9296d1), 1 of 7 addresses running it"
  upgradeable: "yes"
- address: "0x26a61de7e9c23ae1e93f291712e0d41c5dc2ad01"
  project: unidentified-4f125e83
  name: "NWOStatePayout (study family be182719)"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xfbfff08fe4169853f7b1b5ac67ec10dc8806801d"
  project: unidentified-d02ade5d
  name: "Verifier (study family 8979ad2d)"
  upgradeable: "no"
- address: "0x8f10b468b06c6fd214b65f87778827f7d113f996"
  project: unidentified-2e01c1cd
  name: "unverified code (study family 32377d14), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x428d1067b33b2bca826cf66344dbecbd5aa6506e"
  project: unidentified-7e063b84
  name: "StakeManager (study family 17997608)"
  upgradeable: "no"
- address: "0xbcbebc20a0fdf9efd53b5852a71869b0cf25283f"
  project: unidentified-4b8a782d
  name: "BeefyClient (study family a587bf57)"
  upgradeable: "no"
- address: "0x8e33f930051c1a6aca3f0c52adccffa530d0785e"
  project: unidentified-9a8f92a8
  name: "OffchainAuctionPlanner (study family f8af2828)"
  upgradeable: "no"
- address: "0x709944a48caf83535e43471680fda4905fb3920a"
  project: unidentified-07b589f0
  name: "Api3ServerV1 (study family 0fcfb15c), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x7cfc5c8b341991993080af67d940b6ad19a010e1"
  project: unidentified-4b8a782d
  name: "BeefyClient (study family 2f07aaa2)"
  upgradeable: "no"
- address: "0xdad58dfa5c1a7a34419afdbe1f0d610efeea95e4"
  project: unidentified-3f6bf1c3
  name: "Consortium (study family 72ce8e73), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x000000000013fdb5234e4e3162a810f54d9f7e98"
  project: unidentified-61e8ac0a
  name: "OwnableValidator (study family 2a9c05d7)"
  upgradeable: "no"
- address: "0x39cf5f1177c37649dca2e26165a06ad9d725d222"
  project: unidentified-9a8f92a8
  name: "unverified code (study family 5461a364), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x0b00004ccc39408fa289e9f6853bfe4eac3e52c8"
  project: unidentified-1f39f9a6
  name: "AkkaRouter (study family 74560b4c)"
  upgradeable: "no"
- address: "0x269c0ebb7a39995db531ccd61d015e431530b87a"
  project: unidentified-91b0d9b9
  name: "StakeManager (study family 3e4b72a4)"
  upgradeable: "no"
- address: "0xd42284814389978dc43c53f8807e8bc0ac6bd5fe"
  project: unidentified-a48581b2
  name: "ManagedValidator (study family b18535c7), 1 of 4 addresses running it"
  upgradeable: "no"
- address: "0x7c91b9d7a20135c597d2c394c9aaf7667f39272e"
  project: unidentified-9a8f92a8
  name: "CounterfactualDepositVanillaCCTP (study family fca96a0c)"
  upgradeable: "no"
- address: "0x7f1d0b26ed27c64a458b7ef3aaa46c81caa62cc6"
  project: unidentified-ee552967
  name: "EscrowFactoryV7 (study family ef6437f0)"
  upgradeable: "no"
- address: "0xdca7ef03e98e0dc2b855be647c39abe984fcf21b"
  project: unidentified-4580b7d2
  name: "EthereumDIDRegistry (study family 554bb9ff)"
  upgradeable: "no"
- address: "0x214c19fbcdfb683f2c726b4bbaf24ab483bfadf3"
  project: unidentified-9a8f92a8
  name: "SponsoredCCTPDstPeriphery (study family fa0a1744)"
  upgradeable: "no"
- address: "0xb96025987c0c10c751517fd2ccf5767245b027bc"
  project: unidentified-1cfd6a81
  name: "OffchainQuotedLinearFee (study family c94bac45), 1 of 130 addresses running it"
  upgradeable: "no"
- address: "0x447654338fba13ce25988cc576b2903ac7cdcec3"
  project: unidentified-7ba5d8c9
  name: "unverified code (study family 0b29091f), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x550cfe1292d0d9c0d28f232b3f42edb4439b1d09"
  project: unidentified-58dc7bf9
  name: "SignedExclusiveSwap (study family f7175e07)"
  upgradeable: "no"
- address: "0x5d38589e9574df1abe4b85cab7a870c285cd23c3"
  project: unidentified-0a088f1d
  name: "unverified code (study family 69fc694f)"
  upgradeable: "no"
- address: "0x2f2370bc4e33c4cd8f21ece6327b58365f9b843e"
  project: unidentified-2ecd442b
  name: "unverified code (study family ce7d0dd1)"
  upgradeable: "no"
- address: "0xd50678f2763db502e9481f39315702aa7900198f"
  project: unidentified-31db6654
  name: "OndoAttestationOracle (study family 88651170), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xdb28719f7f938507dbfe4f0eae55668903d34a15"
  project: unidentified-d6d24c5c
  name: "StakeManager (study family 6e3dc67e)"
  upgradeable: "yes"
- address: "0x1fba0c57b07af804a9717e51dec9cc27fbc12228"
  project: unidentified-7ad8e6b7
  name: "TEEVerifier (study family 75fff02a)"
  upgradeable: "no"
- address: "0x202bdae6ea5cb576c916cf2d2a83d5a21ea2624d"
  project: unidentified-17603ddb
  name: "unverified code (study family 524da18b), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xbace265d7b07e8bba150b689501cd1143d7d8549"
  project: unidentified-a76a037a
  name: "MsControl (study family 11e80640), 1 of 5 addresses running it"
  upgradeable: "no"
- address: "0xec6f74e15777047d2a66d2cc0e775a2db6455c60"
  project: unidentified-08abf5f6
  name: "BRLAV1_1 (study family 296eeebb), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xba0de1085f6ecbc037b6b5d24ab76d2cff9d0a24"
  project: unidentified-658f7fdd
  name: "voxelXMiner (study family d8e0ddf3), 1 of 12 addresses running it"
  upgradeable: "no"
- address: "0xbcba1f21ca212f63f71536128d9e574dc3ae28d9"
  project: unidentified-80957d62
  name: "ValidatorsRegistry (study family 11454bb5), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x93eaca7be5ead8f319fcd9f31cfeee8bcc6ce487"
  project: unidentified-fac91734
  name: "PrelaunchDistribution (study family 706844b2)"
  upgradeable: "no"
- address: "0xc6b080ded03c3382476a76345e79f82bd480977b"
  project: unidentified-ec4529d8
  name: "LaunchFactory (study family 03757069)"
  upgradeable: "no"
- address: "0x3105eb89980a6f6b48904e8c80f24aaf4818d726"
  project: unidentified-a301086b
  name: "BeefyClient (study family 2a6c5ff7), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x1644d2477f809cc2c71bccfd6dc9497e3f83210d"
  project: unidentified-39a695e9
  name: "TychoRouterV3 (study family 122737fd)"
  upgradeable: "no"
- address: "0xd00e17bfdc40d4bc9e54befd6f646c3e66a50100"
  project: unidentified-174ff657
  name: "unverified code (study family 7b68e604)"
  upgradeable: "no"
- address: "0xf57760c0f36cd701d46baea3c4319a69a7c16df7"
  project: unidentified-72452734
  name: "unverified code (study family d3f7b119)"
  upgradeable: "no"
- address: "0xcae31f0f582e27226b15853f9f3b99f6925e0aac"
  project: unidentified-323ea17b
  name: "unverified code (study family 2f674166), 1 of 5 addresses running it"
  upgradeable: "no"
- address: "0xa9d38ccaadefeac4cea38d00c411254cdda59386"
  project: unidentified-3d5c1d3e
  name: "EnergyBridge (study family 007cb5b6), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xd6969df7e382a258ee2932fa1711af520057cc88"
  project: unidentified-798728d5
  name: "EthereumControllerToken (study family 567bf407), 1 of 3 addresses running it"
  upgradeable: "yes"
- address: "0x17501063de376195de2505ef561d9d44c26b4a58"
  project: unidentified-20702cef
  name: "GigaLegendNFT (study family bfc6fecb)"
  upgradeable: "no"
- address: "0x7bdd0ce75eefead46328e260abd41c68098bf791"
  project: unidentified-b228bcc5
  name: "MemeCardMinterV7 (study family d61a38b0), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x9ab772204a845ae7192fc433b87055dc158a985e"
  project: unidentified-2900cb55
  name: "unverified code (study family 937d339e)"
  upgradeable: "no"
- address: "0x196c463b51d9b02c5aadaedb1cca4be850ebb27d"
  project: unidentified-0e7e9988
  name: "TollanUniverseItems (study family a20bac9e), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x3efbd12c6be0f0603f144b86097922230af89157"
  project: unidentified-cedb987e
  name: "FeeManager (study family 89d5db66), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x9f342d7ee2e55e27250208ac97349d4d25761e8a"
  project: unidentified-f514ad1d
  name: "unverified code (study family 269480c8), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xc3ecfe771564e3f28cfb7a9b203f4d10279338ed"
  project: unidentified-3f6bf1c3
  name: "unverified code (study family 9e00b76e)"
  upgradeable: "no"
- address: "0x8a4b4c2acadeaa7206df96f00052e41d74a015ce"
  project: unidentified-1b9dfc56
  name: "Staking (study family 37608c47)"
  upgradeable: "no"
- address: "0x888887e2d0e716ba1ecf857fe0f2a49125655288"
  project: unidentified-0c09eea3
  name: "TeleportToken (study family 6312e472), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x424a31a57f7c63918ecaa2fac38016a8af5a6ec2"
  project: unidentified-0b11e4a5
  name: "CctpClaimExecutor (study family 46b9bf64)"
  upgradeable: "no"
- address: "0x2b216bff2d2be0a542af34314161a815a807be49"
  project: unidentified-d53394ef
  name: "Withdraw (study family 6ffe3cc5), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x6efa927316f924347222d283cf2254ed5eeb63ed"
  project: unidentified-ecea9ab8
  name: "unverified code (study family 0b5d3781), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x2889bcd2e5d6141f98106dffa8a66ab21b5c84d6"
  project: unidentified-c6f4f6e3
  name: "PortfolioTokenManager (study family 2d26bc34), 1 of 4 addresses running it"
  upgradeable: "no"
- address: "0x0000000031ef4155c978d48a8a7d4edba03b04fe"
  project: unidentified-a63dea08
  name: "unverified code (study family 249ca13b), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xb747c1486d8aca1d13018b574701f325f497d198"
  project: unidentified-1d653a91
  name: "ManyChainMultiSig (study family 3d9e34b4), 1 of 78 addresses running it"
  upgradeable: "no"
- address: "0x76fe371cce9da65818f17131a1cffbc52652994c"
  project: unidentified-62ca17e4
  name: "unverified code (study family b23b26db), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x114ae097205df40dc883508fcda9a4d8e185fc68"
  project: unidentified-72452734
  name: "unverified code (study family 81ef8da0), 1 of 103 addresses running it"
  upgradeable: "no"
- address: "0xc2aebd1a60ae8e27115b380fb6ed17a7fa924c4c"
  project: unidentified-1e9c1467
  name: "unverified code (study family 0fc27fd0), 1 of 17 addresses running it"
  upgradeable: "no"
- address: "0x01e82b67367de9f805e55de730d5007a752912a8"
  project: unidentified-7e69b06f
  name: "unverified code (study family 1b36dfa3), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x395c2eaa45865870d735074093720819359b6d0a"
  project: unidentified-cced97e9
  name: "unverified code (study family 41756753), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x255443d8cfe2c3f77832b71099155cec35b80386"
  project: unidentified-ebaaa759
  name: "unverified code (study family 7b975350), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xb53977a70d755a56d3ce26926acb4c33f7861c61"
  project: unidentified-89575b4f
  name: "AttestationOracle (study family 12682743), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x25d0d42aa7125a2daba83721db7684d09b3b327d"
  project: unidentified-26d8c229
  name: "ClaimToken (study family 8506b0c3)"
  upgradeable: "no"
- address: "0x30adfaef118acaa415d73a20d55dc7a8cd3381b4"
  project: unidentified-4cf8e4d3
  name: "RobinhoodSequencerReporterL1 (study family 3fc16f26)"
  upgradeable: "no"
- address: "0x4b12a72af6b5dcfe5f20976ba764ce2a4b7c6ade"
  project: unidentified-84a39aca
  name: "OndoVault (study family c6010fd9), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xbbb1e655f7d21f9261dcd7e5175a6c3f54463c98"
  project: unidentified-b0fe751b
  name: "Settlement (study family 75c19c4d), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x0d006d9e862b362180eb602e5973fd1fdb6f78dd"
  project: unidentified-c9f2d9ad
  name: "MintController (study family e7790a6e)"
  upgradeable: "no"
- address: "0x245578a375b1eac852538ed289a709098354bd18"
  project: unidentified-9c6ecffe
  name: "unverified code (study family bdaf5f27)"
  upgradeable: "no"
- address: "0xb6522e94f18f53806ac5feac97584181521639d3"
  project: unidentified-2004554c
  name: "MYRT (study family ea33be5a), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x1c211646cb99d1557f93f06ce56c302b9493c02d"
  project: unidentified-94d3caa1
  name: "REPERC1155Upgradeable (study family 0ddff458), 1 of 4 addresses running it"
  upgradeable: "yes"
- address: "0xa009a9fdc0ef474e7a3938a89f80329139291568"
  project: unidentified-14398a33
  name: "Vault (study family 0f93914f), 1 of 4 addresses running it"
  upgradeable: "yes"
- address: "0x7591c9855cbd54fea59252f8ba6cdfde06afab36"
  project: unidentified-0a0a2b62
  name: "QRCs (study family eb5c95dd), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x26cc007e3d658719f8a44b6109ce6341eb0010cd"
  project: unidentified-9a8f92a8
  name: "CounterfactualDepositCCTP (study family 0892b9dc), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x78c10059037e245425fa28cf101cdb8c45cca76c"
  project: unidentified-9a8f92a8
  name: "SponsoredCCTPSrcPeriphery (study family 4574817e)"
  upgradeable: "no"
- address: "0x49aaa987b1a7e9e4ae091dcd8332c39f322d7d28"
  project: unidentified-171254cd
  name: "TransitStation (study family 9dfa848d)"
  upgradeable: "no"
- address: "0x57b11c2ced3c974aa5b4669644c4b4cde3326605"
  project: unidentified-86bf8b32
  name: "unverified code (study family 046c9091)"
  upgradeable: "no"
- address: "0x31a53ce49c99b0c05085dd76d17669871dacd6c0"
  project: unidentified-4e1712b4
  name: "unverified code (study family 06d39183), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x62074e272aeff86303062ba3a7a97e51a947972e"
  project: unidentified-31d97c2f
  name: "WolfGameBridge (study family 607110ff), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x37a436253454c718d33d271bd829d15d7d372300"
  project: unidentified-d24be156
  name: "unverified code (study family 6af391e4), 1 of 3 addresses running it"
  upgradeable: "yes"
- address: "0x6470998fc57f74682ebde0739119608c37a6cdc0"
  project: unidentified-cb380c9f
  name: "KSBridgeRouter (study family ff6ffc74), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x7bc8c3364e33c1af927dc51c23c16dbc376c409d"
  project: unidentified-0e7e9988
  name: "TollanUniverseGenesisAvatars (study family 530b9787)"
  upgradeable: "no"
- address: "0x8bc3249fec4f61440af91ea2f3506f156039297c"
  project: unidentified-428f188b
  name: "GRVTBridgeProxy (study family 4c8cdaec), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x5adabde1b6aedf8f768f782fff1b1cc396416f00"
  project: unidentified-9a8f92a8
  name: "AdminWithdrawManager (study family 3c296e91), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xc4d2cc4363a8a8a72c5fe35f53a56b095a29c7b0"
  project: unidentified-25ded7f2
  name: "BMASAchievements (study family f3eb26f7)"
  upgradeable: "no"
- address: "0x2b3c1760a126275002cf7ea003fa4d513cc89f0d"
  project: unidentified-e682dcfb
  name: "TheMineBoxV2 (study family 0ccf723b), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x42a479f4973c173ef640e729453c630c6388949b"
  project: unidentified-81e4dacb
  name: "unverified code (study family 3d2d9657), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0xcd73a05979a1ff8ca444558bda60e54161117ee2"
  project: unidentified-9a8f92a8
  name: "CounterfactualDepositSpokePool (study family be6475cd)"
  upgradeable: "no"
- address: "0x1b01666a3a026df6168fa7a1dd13a80238cf862c"
  project: unidentified-cf67352b
  name: "Verifier (study family 8a5d7d92), 1 of 3 addresses running it"
  upgradeable: "yes"
- address: "0xa3a3e8304c88b017153ba5dfccdaccb7116a185f"
  project: unidentified-dc3988ce
  name: "Bridge (study family 012c8e40)"
  upgradeable: "no"
- address: "0xb5fd9fffddd02de0f570d63759367ed830e22134"
  project: unidentified-9ade9286
  name: "ArchetypeLogicErc721a (study family 52e16320), 1 of 11 addresses running it"
  upgradeable: "no"
- address: "0x503ea999fb0ab4dcbbe3a7c9aaaf1cccc7e54ec7"
  project: unidentified-6fb6303b
  name: "TokenConversionManagerV3 (study family b2d26d87), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x30ddef8cedee40df8cab52813fc929da2bcc070c"
  project: unidentified-9d7eb653
  name: "Rewards (study family 7a460506), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x3ffd8b918917727c6f226f4eb88e33e452802294"
  project: unidentified-9ba15e76
  name: "ExecutorV3 (study family b1d8568d), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x5dcb5f7becaa169377bf08e8a95c8b57d2c47b49"
  project: unidentified-c4bdc428
  name: "unverified code (study family e8b3dec0), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xc581a68b95fb298f04f02b865d28769a4ef1716a"
  project: unidentified-21ebc2f2
  name: "Collateral (study family 46fc541a), 1 of 7 addresses running it"
  upgradeable: "no"
- address: "0x2b05c841811bcd8204ea44da33649bf79c4fd163"
  project: unidentified-1d653a91
  name: "WorkflowRegistry (study family ebc88f77), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0xe1e8f7c0f15e8d5f9f09023695368981b27d7357"
  project: unidentified-a5387b6c
  name: "SpacePort (study family 1b4dd5e3), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x2d346f2cea44097602a5168cf11b0aab93cdbd5b"
  project: unidentified-cc0ce0f2
  name: "KnightToken (study family 3acb046a), 1 of 4 addresses running it"
  upgradeable: "no"
- address: "0x9eefc0099206ae8d82098fcfda41bbb214e8e6ab"
  project: unidentified-187f1205
  name: "ScatterBidRouter (study family bed7dfe8)"
  upgradeable: "no"
- address: "0xf787128e3eb8161174944117b9fe1204a22097fb"
  project: unidentified-a0036dbc
  name: "Validator (study family eac3b5fa)"
  upgradeable: "no"
- address: "0x09beeedf51aa45718f46837c94712d89b157a9d3"
  project: unidentified-d40d9e8e
  name: "unverified code (study family 63a90714)"
  upgradeable: "no"
- address: "0xb94d2df40fef84e20213c7908c7111f92dc28a83"
  project: unidentified-16a9097e
  name: "unverified code (study family 45e0d70d), 1 of 12 addresses running it"
  upgradeable: "no"
- address: "0xfb6626917a2ea7cc68ee6ed567cb5232ecb71a78"
  project: unidentified-d5289ede
  name: "MigrationIntake (study family 0d89aca0)"
  upgradeable: "no"
- address: "0xdbb5cf12408a3ac17d668037ce289f9ea75439d7"
  project: unidentified-f4e55757
  name: "WorldMobileToken (study family fe78caa0)"
  upgradeable: "no"
- address: "0x19d4ad650e8b8d03d3a3565b2eb27229eb6e8ddb"
  project: unidentified-31d97c2f
  name: "ResourceBridge (study family 90a34723), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xc0ca685456363ed2d7521dfc47e0be165a99eb44"
  project: unidentified-762fcf49
  name: "Coordinator (study family f9e9ca27), 1 of 16 addresses running it"
  upgradeable: "no"
- address: "0xb9de5840469185bc07c217077685fa1eec7b362f"
  project: unidentified-4b39f384
  name: "CrossChainBridgeMessenger (study family f6374baf), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xcff469e561d9dce5b1185cd2ac1fa961f8fbde61"
  project: unidentified-5780b22c
  name: "unverified code (study family cd0bb186)"
  upgradeable: "no"
- address: "0x6c38bf44a327bf36bfbefcedc514c0fb3fec6748"
  project: unidentified-64ed2619
  name: "HTLCErc20 (study family 5c7d88a9)"
  upgradeable: "no"
- address: "0xc2d54e4d795469f8616612cc343af078a892f36f"
  project: unidentified-ec3aac81
  name: "unverified code (study family 88ff4b9d)"
  upgradeable: "yes"
- address: "0xe41c726421007e133a59365432fe886a73b45126"
  project: unidentified-58dc7bf9
  name: "unverified code (study family 50661da8)"
  upgradeable: "no"
- address: "0x4206931337dc273a630d328da6441786bfad668f"
  project: unidentified-37130520
  name: "Dogecoin (study family 1c6a7735)"
  upgradeable: "no"
- address: "0x035b5438444f26e6aab81e91d475b7b1ac4fb22b"
  project: unidentified-be595dad
  name: "UpgradeableStork (study family 725edad2), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xfe9f7f7b916085f8221190201246b6a0bb2b80c3"
  project: unidentified-79ff6f02
  name: "MultiSigCold (study family 83c5abf1), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x49b5a631f54927c0007232844f06fe18cbf69786"
  project: unidentified-704deb16
  name: "HypersnapBridge (study family 5fe4b0da), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x4c0b10d3bf4282609f36ae5620491f240d1af898"
  project: unidentified-06c5c9d0
  name: "DuckWarrantRedeemer (study family 372f45c6)"
  upgradeable: "no"
- address: "0x4744feb48a74cd8c3e7f6ba9ba97cd377416ba78"
  project: unidentified-323211cd
  name: "SynthwaveClaim (study family 59358dfb)"
  upgradeable: "no"
- address: "0x1f9a27fc9ea14b4430750e3b718b92752573929a"
  project: unidentified-fe93d561
  name: "unverified code (study family 4aab626c), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xfbd0caabcfbcf1cd4e1c6c4bee710bb7ff8da2f6"
  project: unidentified-c307c7d8
  name: "PremuVault (study family 05222cbc)"
  upgradeable: "no"
- address: "0xb6401e9e43f4fcab6a0ca7412cfe9de8d07e2e3d"
  project: unidentified-a7eccdb9
  name: "OffchainQuotedLinearFee (study family f788eae4), 1 of 183 addresses running it"
  upgradeable: "no"
- address: "0xced337556854775812bea8d88e776643c87f8554"
  project: unidentified-12ee2de7
  name: "unverified code (study family 783d654d), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x0b35d20c9b45f1312f408768bee75150b2b8a80e"
  project: unidentified-ef166182
  name: "PaymentGateway (study family 936caf73)"
  upgradeable: "no"
- address: "0x6769155b16f25d317819efef011e0a50a48e83c5"
  project: unidentified-9a8f92a8
  name: "SponsoredCCTPSrcPeriphery (study family dcbcbb98)"
  upgradeable: "no"
- address: "0x1cdae7dcc3f32551865efe3d77ac2b88ee2905b4"
  project: unidentified-a63dea08
  name: "K1MeeValidator (study family 43656520)"
  upgradeable: "no"
- address: "0xa626ae844aaf91e9b299fa55270d1dceb82b9300"
  project: unidentified-39b84492
  name: "BridgeVault (study family 9b9d1c1e), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x290ae0178314705d95e504ea94ce052fb550b613"
  project: unidentified-ccef2622
  name: "PaniniBlockchain (study family c7d9b8e8), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x0675509169e25134248563c675c15b62618cc479"
  project: unidentified-fe0de137
  name: "FastPayDisburser (study family ada5010c)"
  upgradeable: "no"
- address: "0xc01ca57dc7f7c4b6f1b6b87b85d79e5ddf0df55d"
  project: unidentified-33f61fd7
  name: "OctraLightClient (study family 4444045f)"
  upgradeable: "no"
- address: "0x2fe17fa30a933693b3ae13d82d00ef18299c6435"
  project: unidentified-244a3952
  name: "unverified code (study family 4680ab41)"
  upgradeable: "no"
- address: "0x47e69cbd049c4aa1bbeb74123737b91de95b238b"
  project: unidentified-4540fd07
  name: "ProofOfXP (study family c4e4fd05)"
  upgradeable: "no"
- address: "0x000000000d60704384100a29efb6c9cf8cd72820"
  project: unidentified-d70a2e6e
  name: "SubAPIMultiSig (study family dbf25309), 1 of 4 addresses running it"
  upgradeable: "no"
- address: "0x6b456a9bdc0f6849c0e54306acc56b67a2957a56"
  project: unidentified-7b0c15f3
  name: "unverified code (study family 0a922f8c), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x2d5e0cd9bfea95e89cef80fb39c050991ac19eaf"
  project: unidentified-9c557378
  name: "unverified code (study family 38c4c1e3), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x36c54110936d18ecb11ddd1aaad73e1488888800"
  project: unidentified-bb946534
  name: "Vault_12366 (study family 2cfd3f5c), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xd4505645b724754f5170a2027804a4265e860d44"
  project: unidentified-eba7bfae
  name: "OperationAuthorizationRegistry (study family 5ed0d7fc), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xa5788882538dd3b086f4f97b8695f16a676ae114"
  project: unidentified-9badd034
  name: "RewardVault (study family 29151445)"
  upgradeable: "no"
- address: "0x1ac2fafa1076c3353789a48148cbffdf1155eb03"
  project: unidentified-29f1472e
  name: "unverified code (study family 994bebfa)"
  upgradeable: "no"
- address: "0x323a76393544d5ecca80cd6ef2a560c6a395b7e3"
  project: unidentified-0904dac3
  name: "ENSGovernor (study family 8b887dc7)"
  upgradeable: "no"
- address: "0x1a9a4d919943340b7e855e310489e16155f4ed29"
  project: unidentified-e8bc44ae
  name: "Claimer (study family d14bb73d)"
  upgradeable: "no"
- address: "0x38872faddaf13876bfc60152d69f15f2bab85f36"
  project: unidentified-b71ddba1
  name: "AVNBridge (study family 273aa029), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x9718a210dd1fc4dfa6d756e55ea89617da5efe77"
  project: unidentified-ea94e11f
  name: "unverified code (study family e529f189), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x1612c1db1e373019b35748e3e57bddef8a8c8fde"
  project: unidentified-6b116178
  name: "SignerRegistry (study family 195f2a99), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xb79aae35b00f2250ae7112075a5aa4d616cee34d"
  project: unidentified-b15ad052
  name: "unverified code (study family c1962724), 1 of 59 addresses running it"
  upgradeable: "no"
- address: "0x3aa07cd56d3e46c7b8613681dc2734cf17f267d0"
  project: unidentified-3f0447a6
  name: "unverified code (study family f36dcc40), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xae9f4c581551177f4eec76c32a72aaa991e570c8"
  project: unidentified-9170f726
  name: "FanbaseTransaction (study family 707a5a40)"
  upgradeable: "no"
- address: "0xcd4c7e2e8d2a15192be238bba43181d9cdf87e7b"
  project: unidentified-a3d54fe2
  name: "unverified code (study family b3cde3c1), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xa3d7aa85ac01a085d6838845abefc64f28636b4a"
  project: unidentified-8a332ae2
  name: "BlockBeastsGame (study family e9bf02f8)"
  upgradeable: "no"
- address: "0xbed7d999f1d71ac70c263f64c7c7e009d691be2e"
  project: unidentified-dae98b8f
  name: "MYRC (study family 8f76d504)"
  upgradeable: "no"
- address: "0xfc3c7f624123ed6950a7037f7cc625f9dd5c62a4"
  project: unidentified-d6f0d5c3
  name: "unverified code (study family 1b6e5cec)"
  upgradeable: "no"
- address: "0xed3309a515ca607c4687f096d6e60e639e03d793"
  project: unidentified-7ba97591
  name: "VerifiableBacktestOracleV2 (study family f2cd9fad)"
  upgradeable: "no"
- address: "0xb587566b6c52f3eac667cfbad92b3f637fe3b083"
  project: unidentified-0282e624
  name: "unverified code (study family b9dfa607), 1 of 482 addresses running it"
  upgradeable: "no"
- address: "0xbd00db15ec30d4caa7ef36f38cff6407009ec80d"
  project: unidentified-79ff6f02
  name: "MultiSigHot (study family 5e45baa2), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x9e5c10bc7c9d0005bf956adf93b92c5b1305b021"
  project: unidentified-19c9d02d
  name: "unverified code (study family ad339a53), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x00d7a47798e8ff169104b748131703b78f23390c"
  project: unidentified-eba7bfae
  name: "unverified code (study family 27d5062e), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x3fcd87948cbf46605d6ded0ed56d3daccd9daf9e"
  project: unidentified-abff377a
  name: "RequestWhitelist (study family 71e2b399), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x852ab534c93bb308553bc5e960ea8916a89a9955"
  project: unidentified-932bdf92
  name: "unverified code (study family 32612628)"
  upgradeable: "no"
- address: "0xb5fd5c5f303204ec8735ebbf7c3bd825df7fbfaa"
  project: unidentified-b4eb0eaf
  name: "SmartWallet (study family 84cf1177)"
  upgradeable: "no"
- address: "0xd1432dd5ec5dba6861bd4c6a56212f54abcbc0b9"
  project: unidentified-d58d143c
  name: "Pre111K (study family 46447aba)"
  upgradeable: "no"
- address: "0x0f11d0d1671519683bd48abf3dbe779e300941cd"
  project: unidentified-bcac4daf
  name: "DecentralandMarketplaceEthereum (study family e91d3a4e)"
  upgradeable: "no"
- address: "0xbd82771e11bde162a302068d0e76394f0ea0bdda"
  project: unidentified-8c056041
  name: "unverified code (study family 05478c08), 1 of 5 addresses running it"
  upgradeable: "no"
- address: "0x32955b1023b45cea1ea7eae895df53dd78c25f35"
  project: unidentified-0a0a2b62
  name: "QuestSeason2ImplementationV2 (study family 3e78cda2), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xe570e438c1278a15305de03f67e095facbf35a86"
  project: unidentified-66a0b1ce
  name: "WeightedStakingPool (study family 00644b5c)"
  upgradeable: "no"
- address: "0xa4d8e7a72743b27ceeeb014de5fc8607ab76a162"
  project: unidentified-be58dd48
  name: "unverified code (study family f299b00e)"
  upgradeable: "no"
- address: "0xac5544de9a295ca40bbad818f25db2c3c152022b"
  project: unidentified-a9a9b1c4
  name: "GaslessUSDCDepositRelay (study family 50ce0ed7)"
  upgradeable: "no"
- address: "0x3af06b2801c7a23978c5e0da1df83c8050fd6ab7"
  project: unidentified-9a8f92a8
  name: "unverified code (study family 3455381a)"
  upgradeable: "no"
- address: "0x15cf6e7fdd7da40d4fda6435358f7493a740f51e"
  project: unidentified-8426cc3b
  name: "UtilitiesInteractions (study family 7b786ad8)"
  upgradeable: "no"
- address: "0xb158dfc961a4caff5fcece489ea4c21bfd26a61e"
  project: unidentified-c1c51f90
  name: "SpaceCatsMinting (study family 483c017d)"
  upgradeable: "no"
- address: "0xbe097e6e6db8dbac460cb8c89bad0af28296d0b3"
  project: unidentified-a67dd62e
  name: "unverified code (study family bde672ef), 1 of 4 addresses running it"
  upgradeable: "yes"
- address: "0xbc287b4843aa5f0985aa4694a3eda39ff0c59d0a"
  project: unidentified-dead4b04
  name: "unverified code (study family c14841c2), 1 of 10 addresses running it"
  upgradeable: "yes"
- address: "0x15c1edbf6e6161d50d58682df7587f0d61db5c38"
  project: unidentified-52864fcb
  name: "Home (study family f997427d), 1 of 5 addresses running it"
  upgradeable: "no"
- address: "0xb924d6bc8cb01b8c86bd5f8d8eb8dcf96de93aba"
  project: unidentified-aaaf5d51
  name: "RealeRouter (study family b4c99d23), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x71c1020abf460342a3d5b6a96c719b95d1dfee40"
  project: unidentified-5cc95f47
  name: "QubitsBridge (study family 1048521d)"
  upgradeable: "no"
- address: "0x2991f64bb44bfee20e54d764f8c9ef0fa57b1613"
  project: unidentified-077e709f
  name: "OddSerum (study family 16943d66)"
  upgradeable: "no"
- address: "0x20e2288d9ce9f6356f45e0f950fa782a12dd1d03"
  project: unidentified-67540f00
  name: "unverified code (study family daeb4d73)"
  upgradeable: "no"
- address: "0x3d30aab957c3df1bfc25a5377b4ad7fc939cacb6"
  project: unidentified-6d7c52c9
  name: "unverified code (study family c24a57db), 1 of 4 addresses running it"
  upgradeable: "no"
- address: "0x31d4753dec2a62d2c18ff4ae1d20ad039e3fc4c0"
  project: unidentified-c25464ce
  name: "OLinxMessageVerifier (study family 890610ee), 1 of 5 addresses running it"
  upgradeable: "no"
- address: "0x020e78ba017931480ada4480b231f80675544a89"
  project: unidentified-b4eb0eaf
  name: "SmartWallet (study family 188f672f), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x369f19ba423493f0457431d39417e6f6e0c875ff"
  project: unidentified-fdc1af95
  name: "CompressedOracleV1 (study family d0e339c9), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x5ef397e52fac25aa92ae436ff002f83c043c1620"
  project: unidentified-a03c9213
  name: "MultiPool (study family a46dddc5), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x92008b210e3d5e03370e5d372843a6439196d37f"
  project: unidentified-da9b6480
  name: "StratoNativeRepresentationBridge (study family 74856335), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xd8696e9add7cc886d85cd9934f435c1febfa10af"
  project: unidentified-a3d0da5a
  name: "unverified code (study family ae1d96ce), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x262073f0f5d14863edc257aa527561301ad5a36d"
  project: unidentified-408444aa
  name: "SubscriptionPayments (study family 7ce2a7a3)"
  upgradeable: "no"
- address: "0x3f5c77bb36a16118ccc9ca83ddee8a01b6c01811"
  project: unidentified-07b589f0
  name: "Api3MarketV2 (study family 09130546)"
  upgradeable: "no"
- address: "0xcafea2c575550512582090aa06d0a069e7236b9e"
  project: unidentified-fac70116
  name: "Registry (study family 0972218b), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xb0517f1fd9e439d5119e0fae1053c8b882ec36bf"
  project: unidentified-cba8baea
  name: "PRDCTRBridge (study family 27db3add), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x18e869b7911653fe5519b14c1d3d0b5916e6ee2f"
  project: unidentified-5ae10f6c
  name: "AllForeverWrapper (study family ef324c2c)"
  upgradeable: "no"
- address: "0xc2ae5507720cac7c5e82349e93379768cb19545b"
  project: unidentified-162c7edd
  name: "UXAirdropV2 (study family 38fbb070)"
  upgradeable: "no"
- address: "0x9003b460c25b26c6b54cec0cc741c2a6a206e98a"
  project: unidentified-ee552967
  name: "EscrowFactoryV7 (study family cae6d3ab)"
  upgradeable: "no"
- address: "0x431d5dff03120afa4bdf332c61a6e1766ef37bdb"
  project: unidentified-1ebe8c10
  name: "FiatTokenV1 (study family cbd31b67), 1 of 6 addresses running it"
  upgradeable: "yes"
- address: "0xba9bc3e7a9bdab2bf52e152779e5186d8ed8416a"
  project: unidentified-aa033f19
  name: "unverified code (study family 3fbc7d14), 1 of 4 addresses running it"
  upgradeable: "yes"
- address: "0x2f75ba58ab7ac6e627cbe1cfbb14a1ababc59116"
  project: unidentified-4675fc3d
  name: "AuthRegistry (study family 700737b5), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x1b30a3b5744e733d8d2f19f0812e3f79152a8777"
  project: unidentified-495e889d
  name: "unverified code (study family 93e920e8), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x3f51cbfa16d605a271d06fd8b67a7ab070fd8dd8"
  project: unidentified-3c5a4304
  name: "unverified code (study family a4bc488c), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x72cacbcfde2d1e19122f8a36a4d6676cd39d7a5d"
  project: unidentified-0a47cec6
  name: "EnforcedTxGateway (study family 04746f82), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x4ca75992d2750bec270731a72dfdede6b9e71cc7"
  project: unidentified-80d4c766
  name: "GuardV3 (study family f9308cec)"
  upgradeable: "no"
- address: "0xd52c79d897a24c275729112c3c5ea813b5703f88"
  project: unidentified-d584fe73
  name: "NightmareImpDoor (study family b76ae5ea)"
  upgradeable: "no"
- address: "0x494fda42a2dcc3005886a6f59f144bb000fc584b"
  project: unidentified-8426cc3b
  name: "TraitsConstructorV2 (study family fa3fe4b9)"
  upgradeable: "no"
- address: "0x6f27b4c3307b79c6fc91349db8ae55ef87cac885"
  project: unidentified-48ca14e7
  name: "Swap (study family 1a322bd2)"
  upgradeable: "no"
- address: "0x30c0e6a4b247e706d3a75b6e88bb0645c3b39757"
  project: unidentified-a2aa04da
  name: "unverified code (study family 069da9e4)"
  upgradeable: "no"
- address: "0x81964aca18bc56a4494a9203fb8eed9fa44d9330"
  project: unidentified-f8b53875
  name: "MintlayerBridgeV2 (study family 454bf1c4)"
  upgradeable: "no"
- address: "0x10eab8ab3df628edb6bf3b3b0fff4b3e17e2cdf6"
  project: unidentified-021868f2
  name: "unverified code (study family cf3feec4), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xf2e6e9e5b35a951b003bb560e66377e685a4718c"
  project: unidentified-cba20d16
  name: "VOWBridge (study family bd404d7a), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xcf403d7117cf9544a40d04b27cb0200706fef690"
  project: unidentified-84ba8f08
  name: "BridgeAssist (study family 42b36081), 1 of 16 addresses running it"
  upgradeable: "no"
- address: "0x1b99964e61ae48fe6a386ba8e20d9565ab445530"
  project: unidentified-d70994e8
  name: "unverified code (study family a42002d3), 1 of 7 addresses running it"
  upgradeable: "no"
- address: "0xb9313ff552b942ec3d8a996af7c522c95c7cbc9f"
  project: unidentified-fcf2db11
  name: "unverified code (study family 67a2d77b), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xdbb9711eef41f47d247b273d18961eaa8cd7919d"
  project: unidentified-8c1587ad
  name: "BuddyRewardVault (study family 101b2367), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x2540411f7146d7d887946e45a0541b4b45a6807d"
  project: unidentified-3b66d144
  name: "NEBASaleV3 (study family 3bced071), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x1e6a90d2ef5fdbb1678149736fa37a3d5d5bac49"
  project: unidentified-c32dd5da
  name: "unverified code (study family 159e1508)"
  upgradeable: "no"
- address: "0x4d5473fc8cc5b89e1f3c7610ffabd88b40d8ebbe"
  project: unidentified-fcf2db11
  name: "unverified code (study family 987c2720)"
  upgradeable: "no"
- address: "0x4db1da8f683262a7c40f659845dc73c9ea159fdd"
  project: unidentified-2eff464f
  name: "unverified code (study family 438511bd)"
  upgradeable: "no"
- address: "0x9528659d4ff876a16e36c692ed34a71c03a9cc3f"
  project: unidentified-ee820458
  name: "unverified code (study family 91a71fd6)"
  upgradeable: "no"
- address: "0x91b95120d085aa99c05167f3767eb63460c1dcac"
  project: unidentified-7a0d94f5
  name: "unverified code (study family 652094c5)"
  upgradeable: "no"
- address: "0xce7a61d155623f5eb867a322100a5a6e2c917311"
  project: unidentified-fe93d561
  name: "DePunk (study family cdf2aab3), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x7df6189fccb27ac8528f23f4bc36f9f23a705491"
  project: unidentified-45941504
  name: "Hotwallet (study family 7063f56d), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x545a25cbbcb63a5b6b65af7896172629ca763645"
  project: unidentified-17d04113
  name: "KineExchangeTreasury (study family 93698209)"
  upgradeable: "no"
- address: "0x1105b7e247ed171a14385c316b7d855828577883"
  project: unidentified-ce22620b
  name: "unverified code (study family 35dccdfd), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0xd139416cf34f958f600166e52c855f4aeacc5c42"
  project: unidentified-8473a96d
  name: "NGRNDPaymentLedger (study family fc9a689c), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x9dad54257bb4d1acfc6be53787b2fff1f49f8816"
  project: unidentified-915c8d4e
  name: "BECLab (study family c869791b)"
  upgradeable: "no"
- address: "0x87dafd430de367faabb6387a0b8a702076727d30"
  project: unidentified-0a0185f5
  name: "unverified code (study family c93299bb)"
  upgradeable: "no"
- address: "0xf8017ae65f2ce39b07244e54eca9ec640f558c8a"
  project: unidentified-ba776663
  name: "MVOStaking (study family e9bbe075)"
  upgradeable: "no"
- address: "0xf4c4621b88b52f3f5eaa71986a003f0f98a16d7a"
  project: unidentified-94310e76
  name: "unverified code (study family cb782f90)"
  upgradeable: "no"
- address: "0x8f6b6adb49cdca3b9f6947f61a1201242c3d827f"
  project: unidentified-52864fcb
  name: "Replica (study family 0126a4b4)"
  upgradeable: "no"
- address: "0xea73a0c1fab72c3eb29494b0afec1554e8802afe"
  project: unidentified-70feeec9
  name: "DecagonTimelock (study family 8532e3ca)"
  upgradeable: "no"
- address: "0x92dee10093f7be466a0d57a7637faa8364d8b7ca"
  project: unidentified-c8b6df21
  name: "unverified code (study family 343fde67)"
  upgradeable: "no"
- address: "0xae1a3da3891763918a3ff691d25c0120652becc4"
  project: unidentified-31403342
  name: "TKSClaimVault (study family f936d700)"
  upgradeable: "yes"
- address: "0x2422b2e752ecac1ab4b3702e501b0bb8f70e923d"
  project: unidentified-9f844407
  name: "unverified code (study family bd0fbe2d)"
  upgradeable: "no"
- address: "0xcba0847962bca2050733f3c689b75bd297daa9dc"
  project: unidentified-3d03a642
  name: "unverified code (study family a9152f8f)"
  upgradeable: "no"
- address: "0xb833ee3698d104b49f89dfa50fe72915372ccc1d"
  project: unidentified-862edf41
  name: "unverified code (study family f945f56a), 1 of 101 addresses running it"
  upgradeable: "no"
- address: "0xbb0f2fbce414ad21ba177ea8cb3aaf2953b502c7"
  project: unidentified-6f74d207
  name: "RwaSafe (study family 054c4be8), 1 of 47 addresses running it"
  upgradeable: "yes"
- address: "0xbc98b0805501b8f553304c4d88b00ece4b5fa30f"
  project: unidentified-b15ad052
  name: "unverified code (study family 6f18d8f4), 1 of 29 addresses running it"
  upgradeable: "no"
- address: "0x0000b77fb305b97d405dd7a25759d3f4a0b3b3f9"
  project: unidentified-56009e5e
  name: "NewDawnPaymentForwarder (study family e6943006), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x0bf5b1b8b05fbc5ca0e2cc7693a7f003efb49579"
  project: unidentified-00000b76
  name: "unverified code (study family 2b4c997e), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xba7c0fbc8fde123565094252ca7f2990f8c4a54e"
  project: unidentified-123cc4af
  name: "Rewards (study family e68a6a11), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xd1bb6a77bdbc868b4b15f795e9eaa7665e8c6203"
  project: unidentified-a5b66fd2
  name: "MixinSafeGuard (study family e1640a6f), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x55d64bb5360e4da122a06c1dd8758f42d0ca220c"
  project: unidentified-6e078760
  name: "unverified code (study family ac83a6ef)"
  upgradeable: "no"
- address: "0x1589e52f36eaad35c3eded79fca83959bb841f57"
  project: unidentified-e31fd6cd
  name: "AMTManager (study family 3c5a7dfa)"
  upgradeable: "no"
- address: "0xa40829b32748b8d6013e7a1a57e5e0d390407acd"
  project: unidentified-6cc435f6
  name: "Dojo (study family 5b83d6e8)"
  upgradeable: "no"
- address: "0xe5d3d7da4b24bc9d2fda0e206680cd8a00c0febd"
  project: unidentified-9bb51953
  name: "RainCollateralController (study family 676eb3ed)"
  upgradeable: "no"
- address: "0xc4fefd0851a37282a2d430186194939a4e7c2dec"
  project: unidentified-84fe172c
  name: "AegisIncomeRouter (study family d966b121)"
  upgradeable: "no"
- address: "0x8adcfaf1b64cc514524b80565bcc732273ddeafd"
  project: unidentified-a28cb806
  name: "AegisRewards (study family 26e0a288)"
  upgradeable: "no"
- address: "0x9e30ba42487d53c4f835b91e56a48a6d58c814ea"
  project: unidentified-a560cfd7
  name: "AgentRegistry (study family f88a4e39)"
  upgradeable: "no"
- address: "0xb4b19d174b3c17e7f98dc3a8c44175d2c441590f"
  project: unidentified-7e0cdd9d
  name: "unverified code (study family 4ee0b925)"
  upgradeable: "no"
- address: "0xc600cfef0dc2ae41a7f3b67e52cf2578025cf777"
  project: unidentified-31d08a68
  name: "BonkeeNFT (study family db14743f)"
  upgradeable: "no"
- address: "0x887541ff8c2f1908c489a62983157ac22b331a15"
  project: unidentified-df77e38c
  name: "unverified code (study family 71cc2503)"
  upgradeable: "no"
- address: "0xf0c76a1e2e672044bd59b7b521ea6063e733614d"
  project: unidentified-7ee010fd
  name: "AlwaysProofNFT (study family 8993739f)"
  upgradeable: "no"
- address: "0x21273b83b8009165a6c2c58bb493843022d581a2"
  project: unidentified-8a332ae2
  name: "BeastItemDrop (study family a63834ab)"
  upgradeable: "no"
- address: "0x60cc6ab378949475a3bc8fe463682d458c0bfe59"
  project: unidentified-195f8198
  name: "unverified code (study family dc1dad64)"
  upgradeable: "no"
- address: "0x6cd956807d9e4ec85f184f03a136e5f80778871f"
  project: unidentified-ace1737f
  name: "unverified code (study family edf6fbe9)"
  upgradeable: "no"
- address: "0x34507d88d2bb25b58dd5f4e4205c804e8553fb1e"
  project: unidentified-beed5427
  name: "M4SporeHunt (study family 57e4862a)"
  upgradeable: "no"
- address: "0xc6b582fe107f9873894df587b837f7f8b4a93f84"
  project: unidentified-d5c45473
  name: "unverified code (study family 0b3c6244)"
  upgradeable: "no"
- address: "0x7553a5ced41c29fa4833ebe65ec9da6e2a9efdf0"
  project: unidentified-bb9ddeb1
  name: "CryptoartNFT (study family 065db750), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xf115c1b6122d6014f4ce4275301af1584bbec49d"
  project: unidentified-9e891406
  name: "SolisEscrow (study family 327d3072)"
  upgradeable: "no"
- address: "0x1f415d1426724507a722aa5d66409d23c4de6425"
  project: unidentified-b5dbc342
  name: "unverified code (study family 8060ee4a)"
  upgradeable: "no"
- address: "0xc4df68e592245ca5202fe8b7c438d2b799820fc2"
  project: unidentified-84fe172c
  name: "AegisMinting (study family 64a75ea6), 1 of 7 addresses running it"
  upgradeable: "no"
- address: "0x18aaa7115705e8be94bffebde57af9bfc265b998"
  project: unidentified-a359b85a
  name: "AudiusToken (study family 5ad72ab6), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xb59f87ddf026a78e728fb25df84207e25258d097"
  project: unidentified-b17a226b
  name: "unverified code (study family 3c06c705), 1 of 5,596 addresses running it"
  upgradeable: "no"
- address: "0xbbae9cc87ae22e88b657dce2fc526885c1807599"
  project: unidentified-0ffecac9
  name: "RewardVault (study family 9bb4f2a1), 1 of 4 addresses running it"
  upgradeable: "yes"
- address: "0xbc62eadcb2ca74519c50f092edcb694a904f3db6"
  project: unidentified-e05af54c
  name: "unverified code (study family 26b25552), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0xc1cdefc8833ab00cc73821a7e36fe2f3923e16c8"
  project: unidentified-ec3016a2
  name: "unverified code (study family acb7896b), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0xbc7d9220b8769e66d5e58b194ac94491ec79a075"
  project: unidentified-da77f8fa
  name: "MoontokAdsPayment (study family 43f51294), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x919e864815daefbd33df8d77063d37d0b2058ae4"
  project: unidentified-3eea50ba
  name: "DirectStaking (study family eff6cfee), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x1c73a1be11848658a82bb01455c091471c879d57"
  project: unidentified-12472871
  name: "PharosCollector (study family f95d3793), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x0568d0a74145fd557b3541897bc6878f5c6e9c8c"
  project: unidentified-f2f1acbe
  name: "PYUSDX (study family 742cdc78), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x4010cd0ddb5ed24bf26bdcfc14bc12b2edebdded"
  project: unidentified-96af4cf2
  name: "DistributeFacet (study family fcc6e506), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x29922d3ccb86516f6c24f89f1eb3068655ca7fa0"
  project: unidentified-eba7bfae
  name: "PKPValidation (study family 5f41cb3e), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x6e7a1f7339bbb62b23d44797b63e4258d283e095"
  project: unidentified-80ab6288
  name: "WormholeClient (study family a64f430d), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x14d772d12c2973ed00449099afca82843f6a2613"
  project: unidentified-08e54cd3
  name: "unverified code (study family a712a027), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x5da38614c318b9e24a16e7284932574bdd621ac9"
  project: unidentified-c4e246da
  name: "ICO2 (study family 35ae1dea)"
  upgradeable: "no"
- address: "0x4ed88b09eb02504cd5df19c6786a7d5c6535d0d6"
  project: unidentified-8426cc3b
  name: "GodMinting (study family 8825ec6c)"
  upgradeable: "no"
- address: "0xc1062617d10ae99e09d941b60746182a87eab38f"
  project: unidentified-27e80db1
  name: "RocketSignerRegistry (study family 9baca8e7)"
  upgradeable: "no"
- address: "0xce3ab27f003fda9aa4187288549e8978cd33b6b5"
  project: unidentified-18d7ae12
  name: "TroverseGalaxyBucksManager (study family f28e5512)"
  upgradeable: "no"
- address: "0x2e1081ffb8e4e1467cc4d89e39d19c5044685d5b"
  project: unidentified-e53b6f29
  name: "BLAQPayV1 (study family e8c0715c)"
  upgradeable: "no"
- address: "0x78608813de5852bbec6a07116026b369ebe18c47"
  project: unidentified-bd924545
  name: "BridgeHead (study family 0d79e6ff)"
  upgradeable: "no"
- address: "0xf32cbb9dd78fb1a1025ad79304238c2e31f2b57e"
  project: unidentified-9821f6f7
  name: "Depositer (study family ac93c3db)"
  upgradeable: "no"
- address: "0xe1cefd316b6a297f15324427ab647bb309c25767"
  project: unidentified-9011eb57
  name: "MutationController (study family cbf42d03)"
  upgradeable: "no"
- address: "0xf7e4ab8815accb837e9f52dbede0e9106832ab8c"
  project: unidentified-384f9b9f
  name: "unverified code (study family b74a5b21)"
  upgradeable: "no"
- address: "0x4524011801bb496deaaf675eed123ed2ba5945d8"
  project: unidentified-43975fe7
  name: "unverified code (study family 75dab74a)"
  upgradeable: "no"
- address: "0xea57493a08100a749dc97bb49aedf01265a02e14"
  project: unidentified-2bde30a8
  name: "unverified code (study family 198d71c4)"
  upgradeable: "no"
families:
- code: "0x2ceb3e994a516c6ba8658211bc94d4c280486cb7"
  name: "GnosisSafeL2 (study family 922d8150)"
  instances: 8589
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 226208453
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xf4ac5a5dc1543086347d28e757091ebd1b848cca"
  name: "SafeL2 (study family 9a69c84f)"
  instances: 39586
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 88489848
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xd19d8ee0a736bf643f53e3dc5489ac94e947a482"
  name: "NXV (study family e41c77f8)"
  instances: 80
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 12187637
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb60fa2ad48959c016fb7545d045aeb60086aca2a"
  name: "MultiSign (study family 7d5e2ccb)"
  instances: 34
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 8104279
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xc2a26188e4d7521960c2ddd31947afa9b2fdd8ac"
  name: "unverified code (study family af3852b1)"
  instances: 5
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 4999714
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x5427fefa711eff984124bfbb1ab6fbf5e3da1820"
  name: "Bridge (study family f3969f72)"
  instances: 5
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 1488582
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x563eda2afb088b36a1b3735126c409372a6ef46c"
  name: "Identity (study family c8c4077d)"
  instances: 3069
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 994854
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x448a9c8a25dc1ec8af43c351bdd0919acbc5be7e"
  name: "Uni (study family d927799d)"
  instances: 7
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 448975
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x00f2b67b5a5ec2ff88b2be7d5a8d1a39d5929237"
  name: "unverified code (study family d17fa1b5)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 431470
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x02479bfc7dce53a02e26fe7baea45a0852cb0909"
  name: "GnosisSafe (study family f15632f5)"
  instances: 749
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 377694
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb8563f7bee7fbf68f8b09c97ee4a13dc6c6943ee"
  name: "SettlementSale (study family 8a325b36)"
  instances: 15
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 286384
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x45804880de22913dafe09f4980848ece6ecbaf78"
  name: "PAXG (study family 9c1bb3ea)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 115492
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xe80f92077131b9890599e418ae323de71ce1c35a"
  name: "SrcBridge (study family 2664bab4)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 92754
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x468ac716493c51184162681130035b61baff040b"
  name: "SmartWalletUpgradeableV2 (study family b57e4077)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 92033
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x94c9d55f064980ed1faf0abb42f3548700619039"
  name: "Bridge (study family 6fb6da97)"
  instances: 6
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 70017
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xcb99c58fe81ae6b2cb4835e46f7b703745879042"
  name: "OxidePortal (study family 30acf8f4)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 61535
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x965983977c29158ec53a296a6f47be145ddecc36"
  name: "TruthBridge (study family 043cea7a)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 44934
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x3d64bd587300af85ae54007d350bfd293dc24581"
  name: "unverified code (study family c43de8b9)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 42588
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x24b22b031ae1b5a6b09f9a0fd33613a40e0d70e6"
  name: "unverified code (study family fcac02a7)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 38798
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xbd0a894e8f8919be0b9eb0f034d1db4e1ac415cf"
  name: "unverified code (study family f2d6dbad)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 30497
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x35ac13efaab970f32269b61e4704f4377ce7a0ad"
  name: "unverified code (study family a26ec3fd)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 20211
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xc22c479a54925608cc8cd60fbf69510df31aef26"
  name: "unverified code (study family bc362389)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 15158
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xcff5d60bdcb541b31f416ef9779048b0653d04ef"
  name: "unverified code (study family fffa0357)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 14436
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xc4a386a0fc1910d60a5283001b6c94efc20e229c"
  name: "Vault (study family d6883c1d)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 8662
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x62728e6ca081b8a253f792980736608e13d45d79"
  name: "Plums (study family ee4900bc)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 3790
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xaa0878e38caeafc390876479f5a14c4705c7a54a"
  name: "ZebecCard (study family dd7a01fd)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 2346
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xc38eb82ae302b5b3ef4f3cb66a4155d1947090b1"
  name: "unverified code (study family 737d0a35)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 1805
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xaec7e8c221c3fd24e75c996e32289235fd899ebf"
  name: "TeikhosBounty (study family 8186a92d)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 1805
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x3249dfc80841c136ce5dc9c1b0d511f628b72b27"
  name: "ERC1155Normal (study family d89bbb67)"
  instances: 34
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 1263
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x74149f6d0dbdbe356fd8035a83dbc0ab7c4c1a8e"
  name: "unverified code (study family 532c3675)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 902
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x22e95073d7a924660bb7222be327c9a6737dc68f"
  name: "Distributor (study family 13744d79)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 722
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x2d26d31052c7d4696b6522a5f680b2c3dfc7bd61"
  name: "Bridge (study family 7d5f7af8)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 722
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x93d070772066c977d605d69b602d316adafc25e3"
  name: "TetherToken (study family 57df7c13)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 541
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x00000404734b3926572a2f004680a4e496e7da09"
  name: "unverified code (study family a7594b2b)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 541
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x91077b23df5edd82868b08b3c959e884370b4553"
  name: "VaultAdapter (study family 8b130cfa)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 541
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x3310ad0117333f3b9d25857949df5a2e0856de3b"
  name: "SANDUIT (study family 9101ee9b)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 361
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x1bb668d33d367702adbe81346d57d5e5083fa346"
  name: "Ibc (study family 1745c7c0)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xca79896bcec80aa7628d67c6fac85bdf6ae63b1c"
  name: "GatewayOfframpRegistryV7 (study family c80e9002)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xa4704944a59eab8a25ee539a9a6c42ff2527b265"
  name: "unverified code (study family dc2aee69)"
  instances: 141
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xda864364f7d1ebcc7c89e9610ebdef45ddf5f81b"
  name: "unverified code (study family 5ed13761)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x0068c20b863745219b6f9542e86b1263029a1c2f"
  name: "Multisig (study family b3cc36f4)"
  instances: 15
  list: "every address running this code at block 26,438,999 (1 by 7702 delegation)"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x287d38ca1d89cd3c435a8279ac9a3528ddeb9131"
  name: "unverified code (study family a7051d16)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x3aeca27812d55af8c787a4277438ea01b39a73c4"
  name: "Escrow (study family ce9296d1)"
  instances: 7
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x8f10b468b06c6fd214b65f87778827f7d113f996"
  name: "unverified code (study family 32377d14)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x709944a48caf83535e43471680fda4905fb3920a"
  name: "Api3ServerV1 (study family 0fcfb15c)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xdad58dfa5c1a7a34419afdbe1f0d610efeea95e4"
  name: "Consortium (study family 72ce8e73)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x39cf5f1177c37649dca2e26165a06ad9d725d222"
  name: "unverified code (study family 5461a364)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xd42284814389978dc43c53f8807e8bc0ac6bd5fe"
  name: "ManagedValidator (study family b18535c7)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb96025987c0c10c751517fd2ccf5767245b027bc"
  name: "OffchainQuotedLinearFee (study family c94bac45)"
  instances: 130
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x447654338fba13ce25988cc576b2903ac7cdcec3"
  name: "unverified code (study family 0b29091f)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xd50678f2763db502e9481f39315702aa7900198f"
  name: "OndoAttestationOracle (study family 88651170)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x202bdae6ea5cb576c916cf2d2a83d5a21ea2624d"
  name: "unverified code (study family 524da18b)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xbace265d7b07e8bba150b689501cd1143d7d8549"
  name: "MsControl (study family 11e80640)"
  instances: 5
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xec6f74e15777047d2a66d2cc0e775a2db6455c60"
  name: "BRLAV1_1 (study family 296eeebb)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xba0de1085f6ecbc037b6b5d24ab76d2cff9d0a24"
  name: "voxelXMiner (study family d8e0ddf3)"
  instances: 12
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xbcba1f21ca212f63f71536128d9e574dc3ae28d9"
  name: "ValidatorsRegistry (study family 11454bb5)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x3105eb89980a6f6b48904e8c80f24aaf4818d726"
  name: "BeefyClient (study family 2a6c5ff7)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xcae31f0f582e27226b15853f9f3b99f6925e0aac"
  name: "unverified code (study family 2f674166)"
  instances: 5
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xa9d38ccaadefeac4cea38d00c411254cdda59386"
  name: "EnergyBridge (study family 007cb5b6)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xd6969df7e382a258ee2932fa1711af520057cc88"
  name: "EthereumControllerToken (study family 567bf407)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x7bdd0ce75eefead46328e260abd41c68098bf791"
  name: "MemeCardMinterV7 (study family d61a38b0)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x196c463b51d9b02c5aadaedb1cca4be850ebb27d"
  name: "TollanUniverseItems (study family a20bac9e)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x3efbd12c6be0f0603f144b86097922230af89157"
  name: "FeeManager (study family 89d5db66)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x9f342d7ee2e55e27250208ac97349d4d25761e8a"
  name: "unverified code (study family 269480c8)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x888887e2d0e716ba1ecf857fe0f2a49125655288"
  name: "TeleportToken (study family 6312e472)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x2b216bff2d2be0a542af34314161a815a807be49"
  name: "Withdraw (study family 6ffe3cc5)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x6efa927316f924347222d283cf2254ed5eeb63ed"
  name: "unverified code (study family 0b5d3781)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x2889bcd2e5d6141f98106dffa8a66ab21b5c84d6"
  name: "PortfolioTokenManager (study family 2d26bc34)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x0000000031ef4155c978d48a8a7d4edba03b04fe"
  name: "unverified code (study family 249ca13b)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb747c1486d8aca1d13018b574701f325f497d198"
  name: "ManyChainMultiSig (study family 3d9e34b4)"
  instances: 78
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x76fe371cce9da65818f17131a1cffbc52652994c"
  name: "unverified code (study family b23b26db)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x114ae097205df40dc883508fcda9a4d8e185fc68"
  name: "unverified code (study family 81ef8da0)"
  instances: 103
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xc2aebd1a60ae8e27115b380fb6ed17a7fa924c4c"
  name: "unverified code (study family 0fc27fd0)"
  instances: 17
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x01e82b67367de9f805e55de730d5007a752912a8"
  name: "unverified code (study family 1b36dfa3)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x395c2eaa45865870d735074093720819359b6d0a"
  name: "unverified code (study family 41756753)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x255443d8cfe2c3f77832b71099155cec35b80386"
  name: "unverified code (study family 7b975350)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb53977a70d755a56d3ce26926acb4c33f7861c61"
  name: "AttestationOracle (study family 12682743)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x4b12a72af6b5dcfe5f20976ba764ce2a4b7c6ade"
  name: "OndoVault (study family c6010fd9)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xbbb1e655f7d21f9261dcd7e5175a6c3f54463c98"
  name: "Settlement (study family 75c19c4d)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb6522e94f18f53806ac5feac97584181521639d3"
  name: "MYRT (study family ea33be5a)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x1c211646cb99d1557f93f06ce56c302b9493c02d"
  name: "REPERC1155Upgradeable (study family 0ddff458)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xa009a9fdc0ef474e7a3938a89f80329139291568"
  name: "Vault (study family 0f93914f)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x7591c9855cbd54fea59252f8ba6cdfde06afab36"
  name: "QRCs (study family eb5c95dd)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x26cc007e3d658719f8a44b6109ce6341eb0010cd"
  name: "CounterfactualDepositCCTP (study family 0892b9dc)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x31a53ce49c99b0c05085dd76d17669871dacd6c0"
  name: "unverified code (study family 06d39183)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x62074e272aeff86303062ba3a7a97e51a947972e"
  name: "WolfGameBridge (study family 607110ff)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x37a436253454c718d33d271bd829d15d7d372300"
  name: "unverified code (study family 6af391e4)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x6470998fc57f74682ebde0739119608c37a6cdc0"
  name: "KSBridgeRouter (study family ff6ffc74)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x8bc3249fec4f61440af91ea2f3506f156039297c"
  name: "GRVTBridgeProxy (study family 4c8cdaec)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x5adabde1b6aedf8f768f782fff1b1cc396416f00"
  name: "AdminWithdrawManager (study family 3c296e91)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x2b3c1760a126275002cf7ea003fa4d513cc89f0d"
  name: "TheMineBoxV2 (study family 0ccf723b)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x42a479f4973c173ef640e729453c630c6388949b"
  name: "unverified code (study family 3d2d9657)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x1b01666a3a026df6168fa7a1dd13a80238cf862c"
  name: "Verifier (study family 8a5d7d92)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xb5fd9fffddd02de0f570d63759367ed830e22134"
  name: "ArchetypeLogicErc721a (study family 52e16320)"
  instances: 11
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x503ea999fb0ab4dcbbe3a7c9aaaf1cccc7e54ec7"
  name: "TokenConversionManagerV3 (study family b2d26d87)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x30ddef8cedee40df8cab52813fc929da2bcc070c"
  name: "Rewards (study family 7a460506)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x3ffd8b918917727c6f226f4eb88e33e452802294"
  name: "ExecutorV3 (study family b1d8568d)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x5dcb5f7becaa169377bf08e8a95c8b57d2c47b49"
  name: "unverified code (study family e8b3dec0)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xc581a68b95fb298f04f02b865d28769a4ef1716a"
  name: "Collateral (study family 46fc541a)"
  instances: 7
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x2b05c841811bcd8204ea44da33649bf79c4fd163"
  name: "WorkflowRegistry (study family ebc88f77)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xe1e8f7c0f15e8d5f9f09023695368981b27d7357"
  name: "SpacePort (study family 1b4dd5e3)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x2d346f2cea44097602a5168cf11b0aab93cdbd5b"
  name: "KnightToken (study family 3acb046a)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb94d2df40fef84e20213c7908c7111f92dc28a83"
  name: "unverified code (study family 45e0d70d)"
  instances: 12
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x19d4ad650e8b8d03d3a3565b2eb27229eb6e8ddb"
  name: "ResourceBridge (study family 90a34723)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xc0ca685456363ed2d7521dfc47e0be165a99eb44"
  name: "Coordinator (study family f9e9ca27)"
  instances: 16
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb9de5840469185bc07c217077685fa1eec7b362f"
  name: "CrossChainBridgeMessenger (study family f6374baf)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x035b5438444f26e6aab81e91d475b7b1ac4fb22b"
  name: "UpgradeableStork (study family 725edad2)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xfe9f7f7b916085f8221190201246b6a0bb2b80c3"
  name: "MultiSigCold (study family 83c5abf1)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x49b5a631f54927c0007232844f06fe18cbf69786"
  name: "HypersnapBridge (study family 5fe4b0da)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x1f9a27fc9ea14b4430750e3b718b92752573929a"
  name: "unverified code (study family 4aab626c)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xb6401e9e43f4fcab6a0ca7412cfe9de8d07e2e3d"
  name: "OffchainQuotedLinearFee (study family f788eae4)"
  instances: 183
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xced337556854775812bea8d88e776643c87f8554"
  name: "unverified code (study family 783d654d)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xa626ae844aaf91e9b299fa55270d1dceb82b9300"
  name: "BridgeVault (study family 9b9d1c1e)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x290ae0178314705d95e504ea94ce052fb550b613"
  name: "PaniniBlockchain (study family c7d9b8e8)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x000000000d60704384100a29efb6c9cf8cd72820"
  name: "SubAPIMultiSig (study family dbf25309)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x6b456a9bdc0f6849c0e54306acc56b67a2957a56"
  name: "unverified code (study family 0a922f8c)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x2d5e0cd9bfea95e89cef80fb39c050991ac19eaf"
  name: "unverified code (study family 38c4c1e3)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x36c54110936d18ecb11ddd1aaad73e1488888800"
  name: "Vault_12366 (study family 2cfd3f5c)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xd4505645b724754f5170a2027804a4265e860d44"
  name: "OperationAuthorizationRegistry (study family 5ed0d7fc)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x38872faddaf13876bfc60152d69f15f2bab85f36"
  name: "AVNBridge (study family 273aa029)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x9718a210dd1fc4dfa6d756e55ea89617da5efe77"
  name: "unverified code (study family e529f189)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x1612c1db1e373019b35748e3e57bddef8a8c8fde"
  name: "SignerRegistry (study family 195f2a99)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb79aae35b00f2250ae7112075a5aa4d616cee34d"
  name: "unverified code (study family c1962724)"
  instances: 59
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x3aa07cd56d3e46c7b8613681dc2734cf17f267d0"
  name: "unverified code (study family f36dcc40)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xcd4c7e2e8d2a15192be238bba43181d9cdf87e7b"
  name: "unverified code (study family b3cde3c1)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xb587566b6c52f3eac667cfbad92b3f637fe3b083"
  name: "unverified code (study family b9dfa607)"
  instances: 482
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xbd00db15ec30d4caa7ef36f38cff6407009ec80d"
  name: "MultiSigHot (study family 5e45baa2)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x9e5c10bc7c9d0005bf956adf93b92c5b1305b021"
  name: "unverified code (study family ad339a53)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x00d7a47798e8ff169104b748131703b78f23390c"
  name: "unverified code (study family 27d5062e)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x3fcd87948cbf46605d6ded0ed56d3daccd9daf9e"
  name: "RequestWhitelist (study family 71e2b399)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xbd82771e11bde162a302068d0e76394f0ea0bdda"
  name: "unverified code (study family 05478c08)"
  instances: 5
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x32955b1023b45cea1ea7eae895df53dd78c25f35"
  name: "QuestSeason2ImplementationV2 (study family 3e78cda2)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xbe097e6e6db8dbac460cb8c89bad0af28296d0b3"
  name: "unverified code (study family bde672ef)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xbc287b4843aa5f0985aa4694a3eda39ff0c59d0a"
  name: "unverified code (study family c14841c2)"
  instances: 10
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x15c1edbf6e6161d50d58682df7587f0d61db5c38"
  name: "Home (study family f997427d)"
  instances: 5
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb924d6bc8cb01b8c86bd5f8d8eb8dcf96de93aba"
  name: "RealeRouter (study family b4c99d23)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x3d30aab957c3df1bfc25a5377b4ad7fc939cacb6"
  name: "unverified code (study family c24a57db)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x31d4753dec2a62d2c18ff4ae1d20ad039e3fc4c0"
  name: "OLinxMessageVerifier (study family 890610ee)"
  instances: 5
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x020e78ba017931480ada4480b231f80675544a89"
  name: "SmartWallet (study family 188f672f)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x369f19ba423493f0457431d39417e6f6e0c875ff"
  name: "CompressedOracleV1 (study family d0e339c9)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x5ef397e52fac25aa92ae436ff002f83c043c1620"
  name: "MultiPool (study family a46dddc5)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x92008b210e3d5e03370e5d372843a6439196d37f"
  name: "StratoNativeRepresentationBridge (study family 74856335)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xd8696e9add7cc886d85cd9934f435c1febfa10af"
  name: "unverified code (study family ae1d96ce)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xcafea2c575550512582090aa06d0a069e7236b9e"
  name: "Registry (study family 0972218b)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xb0517f1fd9e439d5119e0fae1053c8b882ec36bf"
  name: "PRDCTRBridge (study family 27db3add)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x431d5dff03120afa4bdf332c61a6e1766ef37bdb"
  name: "FiatTokenV1 (study family cbd31b67)"
  instances: 6
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xba9bc3e7a9bdab2bf52e152779e5186d8ed8416a"
  name: "unverified code (study family 3fbc7d14)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x2f75ba58ab7ac6e627cbe1cfbb14a1ababc59116"
  name: "AuthRegistry (study family 700737b5)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x1b30a3b5744e733d8d2f19f0812e3f79152a8777"
  name: "unverified code (study family 93e920e8)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x3f51cbfa16d605a271d06fd8b67a7ab070fd8dd8"
  name: "unverified code (study family a4bc488c)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x72cacbcfde2d1e19122f8a36a4d6676cd39d7a5d"
  name: "EnforcedTxGateway (study family 04746f82)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x10eab8ab3df628edb6bf3b3b0fff4b3e17e2cdf6"
  name: "unverified code (study family cf3feec4)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xf2e6e9e5b35a951b003bb560e66377e685a4718c"
  name: "VOWBridge (study family bd404d7a)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xcf403d7117cf9544a40d04b27cb0200706fef690"
  name: "BridgeAssist (study family 42b36081)"
  instances: 16
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x1b99964e61ae48fe6a386ba8e20d9565ab445530"
  name: "unverified code (study family a42002d3)"
  instances: 7
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb9313ff552b942ec3d8a996af7c522c95c7cbc9f"
  name: "unverified code (study family 67a2d77b)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xdbb9711eef41f47d247b273d18961eaa8cd7919d"
  name: "BuddyRewardVault (study family 101b2367)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x2540411f7146d7d887946e45a0541b4b45a6807d"
  name: "NEBASaleV3 (study family 3bced071)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xce7a61d155623f5eb867a322100a5a6e2c917311"
  name: "DePunk (study family cdf2aab3)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x7df6189fccb27ac8528f23f4bc36f9f23a705491"
  name: "Hotwallet (study family 7063f56d)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x1105b7e247ed171a14385c316b7d855828577883"
  name: "unverified code (study family 35dccdfd)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xd139416cf34f958f600166e52c855f4aeacc5c42"
  name: "NGRNDPaymentLedger (study family fc9a689c)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb833ee3698d104b49f89dfa50fe72915372ccc1d"
  name: "unverified code (study family f945f56a)"
  instances: 101
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xbb0f2fbce414ad21ba177ea8cb3aaf2953b502c7"
  name: "RwaSafe (study family 054c4be8)"
  instances: 47
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xbc98b0805501b8f553304c4d88b00ece4b5fa30f"
  name: "unverified code (study family 6f18d8f4)"
  instances: 29
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x0000b77fb305b97d405dd7a25759d3f4a0b3b3f9"
  name: "NewDawnPaymentForwarder (study family e6943006)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x0bf5b1b8b05fbc5ca0e2cc7693a7f003efb49579"
  name: "unverified code (study family 2b4c997e)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xba7c0fbc8fde123565094252ca7f2990f8c4a54e"
  name: "Rewards (study family e68a6a11)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xd1bb6a77bdbc868b4b15f795e9eaa7665e8c6203"
  name: "MixinSafeGuard (study family e1640a6f)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x7553a5ced41c29fa4833ebe65ec9da6e2a9efdf0"
  name: "CryptoartNFT (study family 065db750)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xc4df68e592245ca5202fe8b7c438d2b799820fc2"
  name: "AegisMinting (study family 64a75ea6)"
  instances: 7
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x18aaa7115705e8be94bffebde57af9bfc265b998"
  name: "AudiusToken (study family 5ad72ab6)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xb59f87ddf026a78e728fb25df84207e25258d097"
  name: "unverified code (study family 3c06c705)"
  instances: 5596
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xbbae9cc87ae22e88b657dce2fc526885c1807599"
  name: "RewardVault (study family 9bb4f2a1)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xbc62eadcb2ca74519c50f092edcb694a904f3db6"
  name: "unverified code (study family 26b25552)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xc1cdefc8833ab00cc73821a7e36fe2f3923e16c8"
  name: "unverified code (study family acb7896b)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xbc7d9220b8769e66d5e58b194ac94491ec79a075"
  name: "MoontokAdsPayment (study family 43f51294)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x919e864815daefbd33df8d77063d37d0b2058ae4"
  name: "DirectStaking (study family eff6cfee)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x1c73a1be11848658a82bb01455c091471c879d57"
  name: "PharosCollector (study family f95d3793)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x0568d0a74145fd557b3541897bc6878f5c6e9c8c"
  name: "PYUSDX (study family 742cdc78)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x4010cd0ddb5ed24bf26bdcfc14bc12b2edebdded"
  name: "DistributeFacet (study family fcc6e506)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x29922d3ccb86516f6c24f89f1eb3068655ca7fa0"
  name: "PKPValidation (study family 5f41cb3e)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x6e7a1f7339bbb62b23d44797b63e4258d283e095"
  name: "WormholeClient (study family a64f430d)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x14d772d12c2973ed00449099afca82843f6a2613"
  name: "unverified code (study family a712a027)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, 350 families of the reading list"
  date: 2026-11-19
  verdict: reported
  rating: LOW
related: []
reviews: []
---

## Summary

A real transaction of each family below fails under EIP-8151 as sent and succeeds with more gas. The contracts are unchanged; whoever sets the gas limit (sender, relayer, keeper) must add up to 3,100 gas per recovery. 350 families, 59,800 addresses, $346.5M held.

## Evidence

Each family's recovery sites were read, judged from bytecode or placed by a measured rule; 103 families were also replayed on real transactions.
