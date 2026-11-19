---
id: eip-8151-rotate-signer-before-migrating
title: "Signer keys that must be rotated before their account takes code under EIP-8151"
status: candidate
severity: LOW
patterns: [PQ-17]
contracts:
- address: "0xce43851485f437005ef3c1821e250c4d3c53b946"
  project: unidentified-f6102306
  name: "SingleOwnerMSCA (study family ee56db4b), 1 of 7,712 addresses running it"
  upgradeable: "yes"
- address: "0x9512a1ff49fcceaa464ae44226a004ba19122518"
  project: unidentified-a233b124
  name: "SingleOwnerMSCA (study family d37ca877), 1 of 40 addresses running it"
  upgradeable: "yes"
- address: "0x642c9b393c3754d3618b88e16d6c96c13a467627"
  project: unidentified-18c37f7e
  name: "WalletCore (study family fd63c340), 1 of 106,596 addresses running it, 106,594 by 7702 delegation"
  upgradeable: "no"
- address: "0x1a446a47aed68ef4f9b1536c5f8f27f9dc03f508"
  project: unidentified-fe942bd8
  name: "unverified code (study family 2babc14b), 1 of 3,696 addresses running it"
  upgradeable: "yes"
- address: "0x0cfabe8a8a5cd4ceee2baaa850cfb92f7391f47e"
  project: unidentified-ddf32240
  name: "SemiModularAccount7702 (study family dda3e769), 1 of 98,841 addresses running it, 98,840 by 7702 delegation"
  upgradeable: "yes"
- address: "0x0a4fd9ebe5d8ebf63b1ab77a3296e2d79884b48e"
  project: unidentified-b1430c8d
  name: "GnosisSafe (study family 132235e3), 1 of 965 addresses running it"
  upgradeable: "yes"
- address: "0xea6294f6d4b231141f04562887a0d06f8df3bd49"
  project: unidentified-555367f9
  name: "CaliburEntry (study family 6d5daa99), 1 of 47,265 addresses running it, 47,263 by 7702 delegation"
  upgradeable: "no"
- address: "0x22becbd1958d25536b7a08bbc12e6048df4ab9a3"
  project: unidentified-9567c40d
  name: "ZtakingPool (study family ad8cefc3), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0xce890746664e17a3220e1f64d1b7f86c1e4be4b2"
  project: unidentified-e49acc3b
  name: "CaliburEntry (study family 545783d9), 1 of 159,930 addresses running it, 159,927 by 7702 delegation"
  upgradeable: "no"
- address: "0x7da82c7ab4771ff031b66538d2fb9b0b047f6cf9"
  project: unidentified-e012d7ed
  name: "MultiSigWallet (study family 077a160a), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0xf36a146160ec69820542f3c4dec5c72b37403967"
  project: unidentified-d0b124f8
  name: "WalletCore (study family 1cab59ca), 1 of 24,451 addresses running it, 24,448 by 7702 delegation"
  upgradeable: "no"
- address: "0xe87531e34e042262c03bcbbefcb36ccc45bfe34f"
  project: unidentified-ecf083ed
  name: "AvocadoMultisig (study families 99e85c8b, 65a5926d), 1 of 519 addresses running it"
  upgradeable: "yes"
- address: "0xb6c2f7f91b099b0c42ff6a1e2d91ed7998781fff"
  project: unidentified-ecf083ed
  name: "AvocadoMultisig (study family d3212a1c), 1 of 109 addresses running it"
  upgradeable: "yes"
- address: "0xa0e054fe86c7810592c2d3091acac6a7da02c599"
  project: unidentified-12369488
  name: "MezoBridge (study family 741a551b), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x139cfd93dbaf2682b2ceae7aef2465470cfb9ee3"
  project: unidentified-c708ef37
  name: "MultiSigWalletImplementation (study family ac6dda8c), 1 of 32 addresses running it"
  upgradeable: "yes"
- address: "0x405c6f5acd29dc6b72f3cce8e4f6a76fa3d53c7a"
  project: unidentified-59134277
  name: "SmartWalletEntry (study family 099a9a9f), 1 of 9,172 addresses running it, 9,170 by 7702 delegation"
  upgradeable: "yes"
- address: "0x816f722424b49cf1275cc86da9840fbd5a6167e9"
  project: unidentified-362b41d5
  name: "unverified code (study family de3f7a67), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xf3caf8dfa2c017961b8dcfd1c20cac5ebc091d2d"
  project: unidentified-0e4e6318
  name: "unverified code (study family 63bc6d87), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x61a7ebc69a34e72005a195b42b5d5577c20032ad"
  project: unidentified-cf21fc62
  name: "unverified code (study family 83cce250), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xa79692b65bad10d7d2fe9de309a646fbe311d6a2"
  project: unidentified-ddf32240
  name: "SemiModularAccount7702 (study family 8554540d), 1 of 30,422 addresses running it, 30,421 by 7702 delegation"
  upgradeable: "yes"
- address: "0x013d0dc75808d097b00a1ce8dc6d464fb7c7746e"
  project: unidentified-4cc434ab
  name: "unverified code (study family aac67042), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xd7974ab51ea966aee19fb8b6ebab8c22074e16c0"
  project: ambire
  name: "AmbireAccount7702 (study family a8dadc5a), 1 of 282 addresses running it, 279 by 7702 delegation"
  upgradeable: "no"
- address: "0xaa7427d8f17d87a28f5e1ba3adbb270badbe1011"
  project: unidentified-e1f3c653
  name: "WrapperLockEth (study family a6020f29), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x814b55996914911b2bb57a2069c918ae159d02f4"
  project: unidentified-09d8d9e6
  name: "USDmMinting (study family 7b0f60f1), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x836e1a843e6240211cf1a7b75511dd44543aff7f"
  project: unidentified-ddf32240
  name: "SemiModularAccountBytecode (study family e51591bf), 1 of 3,924 addresses running it"
  upgradeable: "yes"
- address: "0xcf5839f8309f6315749c084d5c5eb8e35aca2439"
  project: unidentified-fdbb79a5
  name: "MintedTokenCappedCrowdsale (study family ca3f26dd), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x3f98beb42c618d31c4f60008de15401bdc84f83f"
  project: unidentified-72d8a690
  name: "unverified code (study family 68d7cf2d), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x64192819ac13ef72bf6b5ae239ac672b43a9af08"
  project: unidentified-ec42db8a
  name: "MainchainGatewayV3 (study family 2660d36c), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x0f8dd218ee17eee03d254805f84c7ba613e45e62"
  project: unidentified-2de1dcb8
  name: "unverified code (study family 10059bd1), 1 of 216 addresses running it"
  upgradeable: "yes"
- address: "0xce0e4d548735137d3b3afcbaaf47800b88eb0b6a"
  project: unidentified-edd03127
  name: "unverified code (study family 1bbffa52), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x2452b803e81d7eee43b283d234a875528d2c5a50"
  project: unidentified-8e6af8ed
  name: "SmartVault (study family 22475f91), 1 of 748 addresses running it"
  upgradeable: "yes"
- address: "0x1a2a1c938ce3ec39b6d47113c7955baa9dd454f2"
  project: unidentified-aa1d3423
  name: "MainchainGatewayManager (study family bdf14344), 1 of 4 addresses running it"
  upgradeable: "yes"
- address: "0xd62595c3c23b690baee0935e107a209cb1dbd37b"
  project: unidentified-1c8236b4
  name: "SynthetixDepositContract (study family 86cb27da), 1 of 5 addresses running it"
  upgradeable: "yes"
- address: "0xec0377a6bc71c4a28288a5cfd307b80c53a7e1e1"
  project: unidentified-1bb00168
  name: "DEXVaultV1 (study family 06599eb9), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xc249c0fc4f7283d4a58c57d8fb0cf5f126ae4ead"
  project: unidentified-2f5dc246
  name: "unverified code (study family e96b6fef), 1 of 9,347 addresses running it"
  upgradeable: "no"
- address: "0xb323692b6d4db96af1f52e4499a2bd0ded9af3c5"
  project: unidentified-9cc99311
  name: "Bridge (study family 8c9ffb6a)"
  upgradeable: "no"
  value_usd: 574572
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x125ab2ca5071b60433d90bce2dfc8e1e83adad2b"
  project: unidentified-d4272634
  name: "ForeignBridgeErcToErc (study family 51937336), 1 of 4 addresses running it"
  upgradeable: "no"
- address: "0x717d0bf97ce58e14945f5e0320ee98381aeaddaf"
  project: unidentified-5acaf86d
  name: "CampaignRewardDistribution (study family 6c04e807), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x3cda13cdab0c80339980721822689d998eca761a"
  project: unidentified-89c4e46e
  name: "unverified code (study family 9693f5f5), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x79383f1ab202c0f7ad755e298c4ab544296c9fdf"
  project: unidentified-508bcdf9
  name: "Account (study family 49a157ce), 1 of 15,444 addresses running it"
  upgradeable: "no"
- address: "0xf28f22868b5d7199772034f224d1fa6f8bafac83"
  project: unidentified-f078305e
  name: "CloneableWallet (study family 8a26da14), 1 of 34,447 addresses running it"
  upgradeable: "no"
- address: "0xc8518d5de0451c67a20da2b1dc54d68569018ca3"
  project: unidentified-ab65a42f
  name: "USDxMarket (study family cfadd732), 1 of 10 addresses running it"
  upgradeable: "no"
- address: "0x5dc76fd132354be5567ad617fd1fe8fb79421d82"
  project: unidentified-566cb8ec
  name: "WrapMultisig (study family 092b8ed6)"
  upgradeable: "no"
  value_usd: 423169
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xf92cd566ea4864356c5491c177a430c222d7e678"
  project: unidentified-7d97676c
  name: "Wormhole (study family 26e6e027)"
  upgradeable: "no"
  value_usd: 415771
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xa2f5bf5eb1b8894a514162ca7abe5f095a5371b1"
  project: unidentified-5913711b
  name: "unverified code (study family b4da8554), 1 of 5,761 addresses running it"
  upgradeable: "no"
- address: "0x460e0cd087033a73e1bc5c071711f1f27884968a"
  project: unidentified-df576863
  name: "CyanVaultV2 (study family dc622884), 1 of 10 addresses running it"
  upgradeable: "yes"
- address: "0x075af08596c26a81384e1f06757f96c96bb1e896"
  project: unidentified-ecba1d33
  name: "unverified code (study family d1083aa3), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x77ba78c10efb5100ce93e611f01e272f1b9ced84"
  project: unidentified-a78bbf97
  name: "CloneableWallet (study family 93fafd58), 1 of 10,278 addresses running it"
  upgradeable: "no"
- address: "0x8bb510a3860e0ad2a0f2794a90cbf14b1b85a2f0"
  project: unidentified-595caa1c
  name: "unverified code (study family 5a054238), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xab41cfa52dab44ccb3c12e208816fe24a0d39a32"
  project: unidentified-5dfba379
  name: "ShrincsWallet (study family b5e7b5d9), 1 of 6,282 addresses running it"
  upgradeable: "yes"
- address: "0xcfc1bc6013ed89d484c626dd9ee5eb7bc1a1d9da"
  project: unidentified-06fb521c
  name: "LiquidityPool (study family adb08b46), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x4c2bddd6d3bc89940e0f7a4bd3d43825d03a3ce0"
  project: unidentified-174ff657
  name: "unverified code (study family b4aa3552), 1 of 272 addresses running it, 271 by 7702 delegation"
  upgradeable: "no"
- address: "0x1ecdb32e59e948c010a189a0798c674a2d0c6603"
  project: unidentified-914b776b
  name: "unverified code (study family 4af46768), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x6cb5fe1d0b5adf12362b0fbb203b0a7898c7ec69"
  project: unidentified-165c27b6
  name: "RelayContract (study family fe57b600), 1 of 5,074 addresses running it"
  upgradeable: "no"
- address: "0x7c9735521ad7d81f57bc56bc85b5bc885d4748ae"
  project: unidentified-d0b86b35
  name: "Safe (study family f108e396), 1 of 126 addresses running it"
  upgradeable: "yes"
- address: "0xc2f44bc508b6b50047a2f3afb1984ed105070be1"
  project: unidentified-dc43b25f
  name: "Presale (study family aefef5b5)"
  upgradeable: "no"
  value_usd: 260759
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xbeef02961503351625926ea9a11ae13b29f5c555"
  project: unidentified-6b83e72a
  name: "unverified code (study family dad22242), 1 of 2 addresses running it, 1 by 7702 delegation"
  upgradeable: "no"
- address: "0x4bacc118f9cee2f6e9b52aab317f8b5aaf2503f5"
  project: unidentified-ebc09c7e
  name: "unverified code (study family 51f03785)"
  upgradeable: "no"
  value_usd: 236758
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x979594ce68c551f98e72a43adfb4b419b6fdd5d3"
  project: unidentified-33c41081
  name: "unverified code (study family 122cbca8), 1 of 14 addresses running it"
  upgradeable: "no"
- address: "0xf2e6ed63bb255e51b64337c67fb4898aa979da6b"
  project: unidentified-0cdae5da
  name: "unverified code (study family b67e3771), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x6c5e91e9b4d1799ea48a4de216184bff7ef32676"
  project: unidentified-98371038
  name: "Wallet (study family 19940b45), 1 of 17,229 addresses running it"
  upgradeable: "yes"
- address: "0x9ac0c8bade28dfe1f44ae4fd75465e3cce6f0152"
  project: unidentified-bf231557
  name: "SunperpVault (study family 99bea6bb), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x38741a69785e84399fcf7c5ad61d572f7ecb1dab"
  project: unidentified-4002ed1a
  name: "EverPay (study family 244e6e23), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x9d7adfce2a7f17500d83510421a0de79906526b6"
  project: unidentified-404614bd
  name: "unverified code (study family 71c8ae99)"
  upgradeable: "no"
  value_usd: 186772
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xbba3c74a006f199193645e35a936b75b605cb2bc"
  project: unidentified-7808501d
  name: "unverified code (study family d81eb18d), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x937478e73bf6547843af57564d7265306af024aa"
  project: unidentified-28c20927
  name: "unverified code (study family b26359b4), 1 of 404 addresses running it"
  upgradeable: "no"
- address: "0xb5d425d678b10949dd0f7bb0dd0427c47451d57e"
  project: unidentified-9506ea24
  name: "BitSafeEvmAssetBridge (study family 3a8dddb4), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xe87753eb91d6a61ea342bb9044a97764366cc7b2"
  project: unidentified-aadd0fda
  name: "TinfunReserve (study family 4cb50580), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xaf895c514d2448150b67f3c0b828250bd947ce7e"
  project: unidentified-abff377a
  name: "Facility (study family af9cc07b), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x3a9624f9bb2dc43e90c0699ddc4a9b6bec147cde"
  project: unidentified-d29995d8
  name: "ThresholdCustody (study family 75ed4c5c), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x453095fc585c5fda2756ed16990463038a6d8a17"
  project: unidentified-ecba1d33
  name: "unverified code (study family 643a74e6), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x4fd9dba1d53b7e6cc933a2fdd12b1c012a0654f6"
  project: unidentified-39e5351e
  name: "MultiSigWalletV2 (study family c69b7f5d), 1 of 41 addresses running it"
  upgradeable: "no"
- address: "0x149e280cc6597a461eab7db69c66a5c09a04caa5"
  project: unidentified-a7522b8c
  name: "unverified code (study family fb29630b)"
  upgradeable: "no"
  value_usd: 138951
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xb5a650a68f8328090135ea96b4a1455debf72b0e"
  project: unidentified-3e990e78
  name: "Account (study family 076aeff3), 1 of 4,360 addresses running it"
  upgradeable: "yes"
- address: "0x50cb61afa3f023d17276dcfb35abf85c710d1cff"
  project: unidentified-14d06788
  name: "WrapperLockEth (study family dadd69ce)"
  upgradeable: "no"
  value_usd: 129748
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xd91e14b8124bcb8986d35048b41ebb7172d4f4fe"
  project: unidentified-13b9c9cb
  name: "GnosisSafe (study family 59287f67), 1 of 512 addresses running it"
  upgradeable: "yes"
- address: "0x775db93999c339e04276040069e2a08aaf3c13d4"
  project: unidentified-ed565474
  name: "HomeBridgeNativeToErc (study family 9c8a31f6), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xf3347c1feca81e9e42c263458ec8d6fea3662ea2"
  project: unidentified-aa0afc85
  name: "unverified code (study family 783e1802), 1 of 281 addresses running it"
  upgradeable: "no"
- address: "0xd1d45a99e04cd3e50c1bbfd8f98e4a6ba3602121"
  project: unidentified-d7df465c
  name: "unverified code (study family 1a0be12c), 1 of 9,736 addresses running it"
  upgradeable: "yes"
- address: "0xc578cbaf5a411dfa9f0d227f97dadaa4074ad062"
  project: unidentified-1b9dfc56
  name: "Bridge (study family 17b7191d), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x260924d36380cadf882d1a1514fba2eae26bbb91"
  project: unidentified-00306cef
  name: "TokenDistributor (study family ef167be5), 1 of 12 addresses running it"
  upgradeable: "no"
- address: "0x215e278c44787dffd33b58311a0e9bb0657c1d8d"
  project: unidentified-ee7b429e
  name: "unverified code (study family 804b95e3), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xfd84612b395da9459ef47f9f4598a0be6d9f3e29"
  project: unidentified-cdea2d9b
  name: "unverified code (study family 008d5e1f), 1 of 28 addresses running it"
  upgradeable: "no"
- address: "0xc6b9743624faa056edb7c57b35f2937155c0e425"
  project: unidentified-4cfce55f
  name: "unverified code (study family 02bda5d1), 1 of 8 addresses running it"
  upgradeable: "yes"
- address: "0xf4c27b8b002389864ac214cb13bfeef4cc5c4e8d"
  project: unidentified-8a1ff1f8
  name: "Ethen (study family 778c4d91)"
  upgradeable: "no"
  value_usd: 78318
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xf95f0359704a66db38d159e5a99721f069f30d9c"
  project: unidentified-03581aeb
  name: "unverified code (study family c7647798)"
  upgradeable: "no"
  value_usd: 77957
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x5b3f0568b4499646d6992aa600ae0e8b86b4dbe9"
  project: unidentified-ec60bb16
  name: "BonusDistributor (study family bbd9d1dd), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x73aceb5025f173aeb7feb7e6d8a3a6090c59b268"
  project: unidentified-6b911807
  name: "PullSplit (study family 82bca671), 1 of 7,276 addresses running it"
  upgradeable: "no"
- address: "0xb59ffa679380b65bc2c1fdf690db7aa214c884bf"
  project: unidentified-165c27b6
  name: "unverified code (study family cb2d7456), 1 of 2,345 addresses running it"
  upgradeable: "no"
- address: "0x07964f135f276412b3182a3b2407b8dd45000000"
  project: unidentified-7f21c9e7
  name: "TransitSwapRouterV5 (study family 3d3d2bfa)"
  upgradeable: "no"
  value_usd: 71100
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xcad5a42d74f66d96650fdf1a1b1d738dedb7d876"
  project: unidentified-86601ae7
  name: "SeeleBridge (study family 37488515), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x10735575e14fc4ed86d68fea5bcbdc2455c7154a"
  project: unidentified-447e2eeb
  name: "unverified code (study family e9da47a7)"
  upgradeable: "no"
  value_usd: 68754
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xb5db375799e35dab6780d41b7abe9ff997839700"
  project: unidentified-752dfb1c
  name: "PrimeRewardPool (study family 2c5c2ab3), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xb6260b8b0bcdcbb7a57f86b074a7e03a095106f0"
  project: unidentified-e8bc44ae
  name: "unverified code (study family 25d8a07a), 1 of 6 addresses running it"
  upgradeable: "no"
- address: "0xa7ad82f4d1209ea99858d3ebbd1f8127ad675242"
  project: unidentified-92e5a4b2
  name: "AuthereumAccount (study family edf9adda), 1 of 3,853 addresses running it"
  upgradeable: "yes"
- address: "0xb0813fadbb418503fe6b23f410cf27572e74948b"
  project: unidentified-3a950de8
  name: "unverified code (study family fd568f63), 1 of 152 addresses running it"
  upgradeable: "no"
- address: "0x067a989e2156ae3cd6e4d0242a6f7026bd6c758e"
  project: unidentified-e77f2c7d
  name: "LightAccount (study family 15f7750b), 1 of 1,574 addresses running it"
  upgradeable: "yes"
- address: "0x7ed67981362846fe5c49f90c2f8c54ab1147a41d"
  project: unidentified-e848e0cb
  name: "unverified code (study family c82892c2)"
  upgradeable: "no"
  value_usd: 53235
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x8768551d4dfc099577c6871e424b0d771c7b2328"
  project: unidentified-3a950de8
  name: "unverified code (study family 769a51e1), 1 of 63 addresses running it"
  upgradeable: "no"
- address: "0xe255fd35cec33a10e46c807423ea318c072de5d2"
  project: unidentified-6e1c6a3f
  name: "VisualMassageModule (study family 6a628899)"
  upgradeable: "no"
  value_usd: 49625
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xad2406ae4eadca4176c8d72a5bc6c70351b741a2"
  project: unidentified-28c20927
  name: "unverified code (study family ca4939cf), 1 of 123 addresses running it"
  upgradeable: "no"
- address: "0x8b2833425d751c1fbfb5c6d43d209ff9b366439e"
  project: unidentified-57db889b
  name: "unverified code (study family e40e4882)"
  upgradeable: "no"
  value_usd: 47640
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x11ac75b61c0974f71a6e171e1e36714c4f105e35"
  project: unidentified-4b339694
  name: "unverified code (study family d7fbee65), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xc736a9e9c71cbe6b7eb7404131a6a98394795ca6"
  project: unidentified-beed4a41
  name: "Distributor (study family 5d883d1a), 1 of 47 addresses running it"
  upgradeable: "yes"
- address: "0xb5dfdfb2a1c97b329361d261239c51e5f88d035d"
  project: unidentified-e1f3c653
  name: "WrapperLock (study family d9029440), 1 of 46 addresses running it"
  upgradeable: "no"
- address: "0xa00db4042b9537b8958289c7c68c5c74e341f766"
  project: unidentified-d1eaefbe
  name: "MyERC20Token (study family d8dfdd1b)"
  upgradeable: "no"
  value_usd: 45836
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x00f9dc19fae6c913cd60e215acaf39853d2dfb61"
  project: unidentified-ec1bd3a6
  name: "GlideDeposit (study family feca8a6c), 1 of 51,541 addresses running it"
  upgradeable: "no"
- address: "0xd923af5d509042a3b24b711caaba8c408d4d4c23"
  project: unidentified-759c5f29
  name: "KubzAuction (study family aa68edc9), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x086b9734d33783bbe4fbc8249df4c686aae27054"
  project: unidentified-9e0bce7e
  name: "Rewards (study family deae0666)"
  upgradeable: "no"
  value_usd: 43851
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x1c03d454272382aaff97b46fe0f6cd66a65857c1"
  project: unidentified-70ad4814
  name: "Hub2Eth (study family dc0e4063), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x223ca78df868367d214b444d561b9123c018963a"
  project: unidentified-620118ad
  name: "unverified code (study family cbdf5650)"
  upgradeable: "no"
  value_usd: 43129
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x69592e6f9d21989a043646fe8225da2600e5a0f7"
  project: unidentified-c6f89c23
  name: "Gravity (study family 65514035)"
  upgradeable: "no"
  value_usd: 42588
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x1ce865c81e76aafd2003e69acd2d196d19aac144"
  project: unidentified-86f24f0f
  name: "BiddableEscrow (study family 8f0881d3)"
  upgradeable: "no"
  value_usd: 41866
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x6453f5cc7d1b03f416a35eea212344d955d87008"
  project: unidentified-a2d5608d
  name: "SaleV2 (study family e5622a48)"
  upgradeable: "no"
  value_usd: 41685
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x49811020c8f25de1d8d03ef2c9cdbe5be8fb07a1"
  project: unidentified-e8c1b979
  name: "TeaVaultV2 (study family 34f84caf), 1 of 17 addresses running it"
  upgradeable: "no"
- address: "0x19c10fff96b80208f454034c046ccc4445cd20ba"
  project: unidentified-830d497f
  name: "AuctionMinter (study family 7ff17a19)"
  upgradeable: "no"
  value_usd: 40422
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xa8372d6ff00d48a25baa1af16d6a86c936708f4e"
  project: unidentified-d2b61b1e
  name: "L1ERC20Predicate (study family 0e843f24), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x37304b0ab297f13f5520c523102797121182fb5b"
  project: unidentified-83c74830
  name: "SportCrypt (study family bca8e068)"
  upgradeable: "no"
  value_usd: 38978
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xce701340261a3dc3541c5f8a6d2be689381c8fcc"
  project: unidentified-74258a92
  name: "Chronicle_SKY_USD_1 (study family a721f47a), 1 of 46 addresses running it"
  upgradeable: "no"
- address: "0xeebe6f7fd87ed28748f5e4d3e339ba0f28e90782"
  project: unidentified-72cc6e4d
  name: "Dao (study family 6fff5ce6), 1 of 712 addresses running it"
  upgradeable: "no"
- address: "0x10e55548db8cdd32ad9a90c14271a88cd0b52e96"
  project: unidentified-a0c8961e
  name: "AuthereumAccount (study family e7f0144c), 1 of 912 addresses running it"
  upgradeable: "yes"
- address: "0xbc27b882b65e40205efcb9373b11b06caa7c0f81"
  project: unidentified-00153c25
  name: "unverified code (study family b8d051b3)"
  upgradeable: "no"
  value_usd: 35911
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x5c29376a264e9244b50076650cea0cf30172c466"
  project: unidentified-725299a9
  name: "Crate (study family b9c62f69)"
  upgradeable: "no"
  value_usd: 35008
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x69bcb93d13d1063335269e8602b009485abd3e87"
  project: unidentified-26ba5ae3
  name: "NFTEntry (study family 396acdfa), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x02b758ce469af940c57a42ad1de5d404122bc283"
  project: unidentified-03e73eca
  name: "GenericBridge (study family 62404c98), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xfdeaf7d9ab542c6ad617666015e512fa1633b8a0"
  project: unidentified-6f27d2f9
  name: "unverified code (study family 98135b0c), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x82b9011fff28f04028bc66f44f981fe1dfab3cb1"
  project: unidentified-88f2d303
  name: "unverified code (study family 815a8c16)"
  upgradeable: "no"
  value_usd: 32843
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xa80fb695d273eda9766342f5805c97e027ca8901"
  project: unidentified-15d81f46
  name: "Resolver (study family cfa9347d), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x0d8f1817c644101a915852841a3b5933b0b8dcc7"
  project: unidentified-cc6eaa08
  name: "Azaraks (study family bd5dfcd3)"
  upgradeable: "no"
  value_usd: 31399
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x0b57c3d5a7a93c3e9652459aff3c7fef792a7c2c"
  project: unidentified-ecf083ed
  name: "AvocadoMultisig (study family 9591f7a6), 1 of 131 addresses running it"
  upgradeable: "yes"
- address: "0x855e15cff2a98c3d051f88858e791a4929c17145"
  project: unidentified-c1acf4a7
  name: "unverified code (study family df4cdaa9)"
  upgradeable: "no"
  value_usd: 30497
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x136d841d4bece3fc0e4debb94356d8b6b4b93209"
  project: unidentified-345c9ae6
  name: "StakersPoolV2 (study family c9d97a3c), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x0e9d8e14293dd069690c1addbf51b61b4dca2f96"
  project: unidentified-b75a08e8
  name: "AmmoVault (study family f29fbdcd), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x9d4bcc065788787515f9baac673bf44cfb9d389c"
  project: unidentified-1304f1b9
  name: "Identity (study family 7afdaae8), 1 of 2,065 addresses running it"
  upgradeable: "no"
- address: "0x147aa9ada01b70c4c8c8b89b06afe767908aced7"
  project: unidentified-a58a1bb2
  name: "PharaGoddess (study family d1d8280d), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x74699d5fb553afed0360a6a266981dcd98d9dfa4"
  project: unidentified-759c5f29
  name: "Waitlist (study family 11591c5e), 1 of 7 addresses running it"
  upgradeable: "yes"
- address: "0x05cefcb9471605380c1750874ec652e3f0609856"
  project: unidentified-a0c8961e
  name: "AuthereumAccount (study family 5cd5f31e), 1 of 243 addresses running it"
  upgradeable: "yes"
- address: "0x15c5f0f18feb8a9f5808ccd2fc4ac279d9d89bb8"
  project: unidentified-99e12094
  name: "WStock3 (study family 58f0e620)"
  upgradeable: "no"
  value_usd: 26888
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x5de9f32b2665bb2cdc23bfb51b03e2a2985ecc87"
  project: unidentified-34858c5a
  name: "KYCCrowdsale (study family bb977a33), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xccb57afedecc8d975ca4ae06f850a175142499de"
  project: unidentified-1c0aa8cc
  name: "Keep (study family d7ed1420), 1 of 21 addresses running it"
  upgradeable: "no"
- address: "0x0af7f2162b4714c99f49b8c4fb4f3cece026b432"
  project: unidentified-4585b198
  name: "CloneableWallet (study family ca85fe9a), 1 of 7,202 addresses running it"
  upgradeable: "no"
- address: "0xc5a6349aedf573ee01c7bdf3d713496b5a45d056"
  project: unidentified-eadb1013
  name: "UpstreamCollectiveToken (study family fa2a7e01), 1 of 11 addresses running it"
  upgradeable: "yes"
- address: "0xde5d4949f445650325c7c8739610c3a979c7a6db"
  project: unidentified-223fd02f
  name: "RaffleAuctionMinter (study family a14ad682)"
  upgradeable: "no"
  value_usd: 24903
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x03cc979c46b030c4abd7d4063cd075cb38cd0919"
  project: unidentified-5baa3920
  name: "Exchange (study family 80f3c228)"
  upgradeable: "no"
  value_usd: 24362
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x72ca32879941a51b089f6ace3dd8f13dd8bf6c14"
  project: unidentified-e55b85bc
  name: "WhopPaymentGateway (study family 2d0a18e0)"
  upgradeable: "no"
  value_usd: 22557
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x2cbe14b7f60fbe6a323cba7db56f2d916c137f3c"
  project: unidentified-eccd4292
  name: "SealedArtMarket (study family 4b5a2c8e), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xcebfc5dfbd5ce21694fe2acefa63ad6f828831d2"
  project: unidentified-974c4612
  name: "unverified code (study family c41a1cf3), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0xe080079ac12521d57573f39543e1725ea3e16dcc"
  project: unidentified-620118ad
  name: "unverified code (study family 8543ea65)"
  upgradeable: "no"
  value_usd: 21835
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x65011d7322dd36dd3c2c38fccaf7503406a740ba"
  project: unidentified-b36b80bf
  name: "RewardNew (study family 9396b71f), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xeba462aa6b835ef0f4a85f9b0a2beb3b1ce6bfe7"
  project: unidentified-79572522
  name: "BlindAuction (study family a5b088a1), 1 of 3 addresses running it"
  upgradeable: "yes"
- address: "0xaa4737ba58625f442d0ca6018ea04e3830537984"
  project: unidentified-b2dea0e2
  name: "MinimalAccount (study family dd54c4b3), 1 of 2,473 addresses running it, 2,472 by 7702 delegation"
  upgradeable: "no"
- address: "0x0701202173ebf83eff0f735115497b5baa2afb8f"
  project: unidentified-5e51b67b
  name: "unverified code (study family d9e443dd), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x2ce8e90200c02ee7f82f99708dc0dfee9c292bd7"
  project: unidentified-8b1de587
  name: "BvbBox (study family d67919a4)"
  upgradeable: "no"
  value_usd: 21113
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xd22fff18b5e25ef1f07f8e194b89966652d44f5b"
  project: unidentified-c260bb2b
  name: "BTCDMinting (study family ec85fa63), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xba90158ab116ed37ab0c32128b2809d9b6388013"
  project: unidentified-4d12056d
  name: "RechargeContract (study family 2a030947), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x76644c879d0b61ea8fbbf306879eb60a292ab45f"
  project: unidentified-c7575549
  name: "Space (study family 4795b93f), 1 of 29 addresses running it"
  upgradeable: "yes"
- address: "0xa5646ba7f8fa7339f3de65d08d9667451abcb024"
  project: unidentified-b2307204
  name: "unverified code (study family 84c7bf48), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xba834c583231e79ea08aeb5e577317b105b10603"
  project: unidentified-a71d501c
  name: "DepositVault (study family 913f23ef), 1 of 4 addresses running it"
  upgradeable: "yes"
- address: "0x5afe266ab4e43c32bad5459fe8df116dd5541222"
  project: unidentified-e8bc44ae
  name: "unverified code (study family 5c55c4d1), 1 of 6 addresses running it"
  upgradeable: "no"
- address: "0x5bd25d2f4f26bc82a34de016d34612a28a0cd492"
  project: unidentified-111ae6fe
  name: "unverified code (study family 86e24537)"
  upgradeable: "no"
  value_usd: 19489
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xd746f3601ea520baf3498d61e1b7d976dbb33310"
  project: unidentified-8fa51007
  name: "KeeperRegistry2_0 (study family ce352daf)"
  upgradeable: "no"
  value_usd: 18407
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xa74c0b5adea01df5a43a6c6b5e012dc8ed5d2687"
  project: unidentified-5640cccf
  name: "RaremintsERC721 (study family 1ebc9ede), 1 of 143 addresses running it"
  upgradeable: "yes"
- address: "0x794e28e72ae90cfc90e2e4ac231ce17eae1d3a1e"
  project: unidentified-fc8bb77f
  name: "VTScan (study family 01dce662), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xf061a9001fa4957e7e0bc6143b332fd76759a471"
  project: unidentified-6f9aec78
  name: "JurasickPets (study family 841a453d)"
  upgradeable: "no"
  value_usd: 17685
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xd4001a2bee20bcad4775d47499a3fc3516e93a08"
  project: unidentified-3a950de8
  name: "unverified code (study family b97a8708), 1 of 87 addresses running it"
  upgradeable: "no"
- address: "0xdac2977f505d38f4457a0bdbc965e6c4a6f7fa9b"
  project: unidentified-4e494629
  name: "Kernel (study family f22d6bf5), 1 of 1,907 addresses running it"
  upgradeable: "yes"
- address: "0x7bb0949ce7d3dee05b08ce182ee69c134b904433"
  project: unidentified-882f7d71
  name: "HangOutETHFlatland (study family 5f11075b), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x4a7c43add8aecb827e2d3b0a89d5cd2d7b28539c"
  project: unidentified-7136930c
  name: "unverified code (study family eacbd19c), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x0afa5cd68d624aca5f8e588ea6295d89c2d14c14"
  project: unidentified-71a15ac1
  name: "LendingPool (study family f8a41c68), 1 of 130 addresses running it"
  upgradeable: "no"
- address: "0x26bbea7803dcac346d5f5f135b57cf2c752a02be"
  project: unidentified-a8863bf1
  name: "ERC1155LazyPayableClaim (study family f8e75c27)"
  upgradeable: "no"
  value_usd: 15519
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x01e0237fddb7e169dcc34c724d4ef09cd7c2eff8"
  project: unidentified-8a6a17f1
  name: "CloneableWallet (study family 74ac18ce), 1 of 1,371 addresses running it"
  upgradeable: "no"
- address: "0xda7fb91545545d044a9fd118f85a4f10a8d4c6b5"
  project: unidentified-105e8dd6
  name: "CaptainzReserve (study family 18a9cecd), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xd5e22e225f58c85be0cfbac718f0b04be887f995"
  project: unidentified-2362a7e9
  name: "unverified code (study family 605c3260)"
  upgradeable: "no"
  value_usd: 15339
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x12617f31a29dccff3790e4767239a7b00928d43b"
  project: unidentified-914b776b
  name: "unverified code (study family e195b6e9), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x3788657e6ab0efc4be4b824c84377396e5896821"
  project: unidentified-759c5f29
  name: "YgpzReserve (study family d9e74837), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xe794ffecc16a8e5f5c7d7818322ba7fe41a63f72"
  project: unidentified-e8bc44ae
  name: "unverified code (study family 3a1ff297), 1 of 10 addresses running it"
  upgradeable: "no"
- address: "0x86734d2fc365231b8502254e08ae635ae949da0a"
  project: unidentified-ca6930d3
  name: "unverified code (study family 84990218)"
  upgradeable: "no"
  value_usd: 14978
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x374368fbc18a0dd3c8044bcbe9cc76f718e56da8"
  project: unidentified-a39989ca
  name: "TunnelContract (study family 360854de), 1 of 9 addresses running it"
  upgradeable: "yes"
- address: "0xaea5fa28cf2b56dea9d1dea2ac8e76e799143a28"
  project: unidentified-05aec747
  name: "unverified code (study family 0d407e20)"
  upgradeable: "no"
  value_usd: 14617
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x1f2788f8fdf2ba0014cfd49264846a6a1e8b5888"
  project: unidentified-82b83206
  name: "unverified code (study family f6f0bf23)"
  upgradeable: "no"
  value_usd: 14436
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x7eeeadafb417d9627c49dbe91a4e0e48f167a536"
  project: unidentified-759c5f29
  name: "KubzWaitlist (study family 497cdea3), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xd7ae00b91ba0b8e0240b22cd75fe447d177c260f"
  project: unidentified-a3533fd3
  name: "OxidePortal (study family 72ed6916), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x51382330280f5198ff415d54646cbea59593973c"
  project: unidentified-c7b1b80a
  name: "DCN (study family d1c51316), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x49f743c2d3ba45fadf2768ba30844d0ecd548bc6"
  project: unidentified-0df49ec6
  name: "SPLSPLGatewayV3 (study family 2abb0772), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x1a6a47f4080eaa48ee66aaa8893c3ae9edd0553d"
  project: unidentified-f16e1061
  name: "unverified code (study family 8f2684d9)"
  upgradeable: "no"
  value_usd: 13715
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x4f011b623eda3b7ad64c0ee506812dc1b98e1a33"
  project: unidentified-759c5f29
  name: "BlindAuction (study family 2af85c62), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x9480e0e7e2bb6c4daef1e3d7b8a2f8cbed8dbc46"
  project: unidentified-80f1b766
  name: "PullSplit (study family b270d664), 1 of 269 addresses running it"
  upgradeable: "no"
- address: "0xc1251023f4a5863503d68e0dbdf9c65ff1cbf05c"
  project: unidentified-c0a7e0b3
  name: "LiquidityHolder (study family a4475c13)"
  upgradeable: "no"
  value_usd: 13354
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xbdcb49e941615668dad186d8a95043d666fd08a5"
  project: unidentified-c8baef7f
  name: "unverified code (study family c0815231), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x813892bc85940aa8d4ff2817650d58557df8774d"
  project: unidentified-10a5e9c5
  name: "unverified code (study family 55c90e07), 1 of 59 addresses running it"
  upgradeable: "no"
- address: "0xb735cc58d71deac4cfc46de68d3b04988f7d7b2d"
  project: unidentified-4cadde3d
  name: "AccessControlledOffchainAggregator (study family 6b45b05e), 1 of 280 addresses running it"
  upgradeable: "no"
- address: "0xd5d2b9e9bcd172d5fc8521afd2c98dd239f5b607"
  project: unidentified-ff04598c
  name: "OffchainAggTCD (study family 3412ae42)"
  upgradeable: "no"
  value_usd: 12993
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xf0c9651fcb5ec9ff8eb405ba50a1c5840c9f917d"
  project: unidentified-91295b3a
  name: "unverified code (study family 6df27152), 1 of 81 addresses running it"
  upgradeable: "no"
- address: "0x4837f64cd9201abf0f7625fd7126249cab8bd556"
  project: unidentified-b1620466
  name: "unverified code (study family 43041f31)"
  upgradeable: "no"
  value_usd: 12632
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x237c23d2a1c6320d6010338a48db3fcc29f64eed"
  project: unidentified-d52e7e6c
  name: "mfatches (study family 258c2315)"
  upgradeable: "no"
  value_usd: 12451
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x8a80d5ae71b0f498c4688651f1405047f03f46f2"
  project: unidentified-06693936
  name: "PersonalCornerSale (study family d8334a0d), 1 of 5 addresses running it"
  upgradeable: "no"
- address: "0xb6728bff344e2109dbb3a0c153cad65ec4bdb736"
  project: unidentified-e734f67a
  name: "BadgeMinterV2 (study family fec5b277), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xcbd5eb27176db6b261196ed3431a612e0b5a82f6"
  project: unidentified-c28e1cdf
  name: "NestShareOFT (study family 563a3bfc), 1 of 25 addresses running it"
  upgradeable: "no"
- address: "0x38d8b04ab6b9392c8e14f4745eb25dc3f4a49bb0"
  project: unidentified-3817fdef
  name: "LuckyFish (study family f6ad9770)"
  upgradeable: "no"
  value_usd: 11549
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xba0152f01f33946742d1bb0b14015d8d8944c6ec"
  project: unidentified-0e1d77e0
  name: "Nettensor (study family 2ff8c4d5), 1 of 15 addresses running it"
  upgradeable: "no"
- address: "0xcfeb40116dbe6464d357d6a1808ff5ddde0f87dd"
  project: unidentified-b2125e9b
  name: "StakePool (study family f60b5890)"
  upgradeable: "no"
  value_usd: 11369
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xfaefea4f45c8a7af8c8c591ae6b69a19946d0b08"
  project: unidentified-cbc2c69f
  name: "unverified code (study family 82ce892c)"
  upgradeable: "no"
  value_usd: 11188
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xd38554b676f8c03dd8a1d3bab3f1eab448e5f3d3"
  project: unidentified-e5293f28
  name: "DraculaKEY (study family 3f8f13ab)"
  upgradeable: "no"
  value_usd: 11008
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xab5ff3bc7343cca575ae0e94b79377182364458d"
  project: unidentified-b3dff85e
  name: "GeniusVault (study family ce0561ac), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x2cedd98d4ec9bc9cd51fc9ea9091da5664518dd2"
  project: unidentified-b45a8389
  name: "AltMint (study family fab8c226), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x110fd9a44a056cb418d07f7d9957d0303f0020e4"
  project: unidentified-0e17c1a7
  name: "Bridge (study family 5919cd32)"
  upgradeable: "no"
  value_usd: 10827
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x99120d128a5f7cb81c318a24fa1f60f66d9777d7"
  project: unidentified-13226628
  name: "PPADealers (study family d2b00a01)"
  upgradeable: "no"
  value_usd: 10647
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x7548fcd0191a3372c00943e2f8ba21a3218ddeb5"
  project: unidentified-7b99bed4
  name: "KyoDepository (study family a68dc36e)"
  upgradeable: "no"
  value_usd: 10466
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xd7bec4d6bf6fc371eb51611a50540f0b59b5f896"
  project: unidentified-e7af1137
  name: "MCHDailyActionV4 (study family 7edbc0d0)"
  upgradeable: "no"
  value_usd: 10466
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x2b0e3fd77e061769904b71dce0ee336bf3eb1543"
  project: unidentified-588ede44
  name: "OracleFeeDistributor (study family b6d60def), 1 of 377 addresses running it"
  upgradeable: "no"
- address: "0xce0d7faf97604dcdb5b775b57198c0719c119f71"
  project: unidentified-14d06788
  name: "WrapperLock (study family 87aa1458), 1 of 24 addresses running it"
  upgradeable: "no"
- address: "0x79fc41a5a0fe5ab087425ec0c5961cff6ce71a29"
  project: unidentified-b0c71e33
  name: "unverified code (study family 06ebf83b)"
  upgradeable: "no"
  value_usd: 10106
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x20278fb9de54d037391b26532f3227fe224ab595"
  project: unidentified-c1149cda
  name: "PrivateVault (study family 61d5cfca), 1 of 245 addresses running it"
  upgradeable: "no"
- address: "0x388f478199f45a67db6765ffcbe07f0197623678"
  project: unidentified-9ce83b55
  name: "XenoMining (study family f84243d8), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x0ac7b11449e3ffc2137dccb8371ebcee275e3aaf"
  project: unidentified-3e92892c
  name: "unverified code (study family 09a76b0a), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x7fda203f6f77545548e984133be62693bcd61497"
  project: unidentified-e9af0428
  name: "LevelStakingPool (study family 7353bc70)"
  upgradeable: "no"
  value_usd: 9564
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x1e4cc5f267853aa2e2142ea7f0532a776117cfff"
  project: unidentified-b369e3f9
  name: "MarsMaiers (study family d6480790)"
  upgradeable: "no"
  value_usd: 9384
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xcfd3e772338ee65193e74eb0e70ecb228afb5df7"
  project: unidentified-238033db
  name: "MarketplaceV2 (study family 2327f2f0), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xb9c317cae7dd05ecb0c0925020e529934c96f84d"
  project: unidentified-859a15b7
  name: "AccountableAsyncRedeemVault (study family dd38ba2a), 1 of 27 addresses running it"
  upgradeable: "no"
- address: "0x8608a089a9ec9a5483faa12a56e987901aad27ce"
  project: unidentified-ee8ae1f1
  name: "MevWalletV1 (study family 4e559de5), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xc6e82d96d2b0204e6467b67752817939ec6162e9"
  project: unidentified-cdcc880f
  name: "TrufNetworkBridge (study family 810f9edc), 1 of 4 addresses running it"
  upgradeable: "yes"
- address: "0x9f8d9bac13751bf6121e829eb5a70e44a025d64c"
  project: unidentified-e2856478
  name: "AutoMinterERC721 (study family 6922ce76), 1 of 267 addresses running it"
  upgradeable: "no"
- address: "0x58497fbd4423b8621aadd5fde04444d8d21d14f2"
  project: unidentified-9cc46816
  name: "unverified code (study family 927b5281), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x65f2e558ce981a15541571be8188524ad75cad8a"
  project: unidentified-4cca9b32
  name: "FiveKMSneaker (study family 2f781b74)"
  upgradeable: "no"
  value_usd: 8301
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x97caca78ac2a94c67643d07843f85afaa44a3ea5"
  project: unidentified-ac9cf3e9
  name: "RFQVaultExecutor (study family 1bd672d4)"
  upgradeable: "no"
  value_usd: 8121
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x5d4d384e239afaf120d18a115acc902f7a44d2f9"
  project: unidentified-a8000022
  name: "AuthereumAccount (study family 18ca6e97), 1 of 50 addresses running it"
  upgradeable: "yes"
- address: "0x2f2f36a88dd5ff8d53ba2505b2dbc0c153d910ab"
  project: unidentified-fcb10d67
  name: "unverified code (study family 7514861f)"
  upgradeable: "no"
  value_usd: 7760
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x883e3c18d43c8414cc22e49512b9785fb571f0c4"
  project: unidentified-02f7c077
  name: "unverified code (study family a903d634)"
  upgradeable: "no"
  value_usd: 7760
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x2d5a000e4c2fb1843ffab1fe94767d0fb45f179d"
  project: unidentified-6528e587
  name: "Claims (study family 6fcf1fe3), 1 of 11 addresses running it"
  upgradeable: "no"
- address: "0x8b6a843ef95bc85049df091cf4bf84acdef34cf3"
  project: unidentified-e1432944
  name: "Nobodies (study family a9c63f24)"
  upgradeable: "no"
  value_usd: 7579
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xc00c733702248aebdb357340dddda5c47500a35a"
  project: unidentified-e2856478
  name: "AutoMinterERC20 (study family c5251f39), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xe501afedfef8715471d8b4b4ebc3fd89034e5578"
  project: unidentified-e233ec68
  name: "Evinco (study family 930356fe)"
  upgradeable: "no"
  value_usd: 7579
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xced332d82394fc79eca4da5d128e01799a7aa351"
  project: unidentified-169fccbb
  name: "unverified code (study family 4873fc66), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x9eafad32e91f59cfe3e764254e3ed163a98ab55b"
  project: unidentified-105e8dd6
  name: "BootyClaim (study family ac165e57), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x36d758c58bedf3f819bd102be4361e4fd0a33268"
  project: unidentified-01bf1d7c
  name: "unverified code (study family 0aed7ffc), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0xa5c603e1c27a96171487aea0649b01c56248d2e8"
  project: unidentified-46cf7ddb
  name: "MultiSigWallet (study family 216e3db7), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x00000000046534fc66d46673efd54583bf8f38cd"
  project: unidentified-45aa9ff8
  name: "O2Settler (study family 4f56d5f1), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x1ce81a8b3b321ebc6782edd99c5b0ac6a2f4adb1"
  project: unidentified-9d65638a
  name: "TradingVaultImplementation (study family ce8a294c), 1 of 45 addresses running it"
  upgradeable: "no"
- address: "0x8e44663eee4bfbd9e46580d37973da90171cebcf"
  project: unidentified-aa0c2647
  name: "AuthereumAccount (study family ee0b34e1), 1 of 35 addresses running it"
  upgradeable: "yes"
- address: "0x7fc4012bf86d8aaef4951bb7b486ea02c08c419f"
  project: unidentified-a0fa7077
  name: "AngryContract (study family d34490eb)"
  upgradeable: "no"
  value_usd: 7038
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x2a14b47e551288f3f5e35842970cc2bc78ceb47d"
  project: unidentified-3da6066f
  name: "EthErc20Vault (study family b3deddbc), 1 of 18 addresses running it"
  upgradeable: "yes"
- address: "0xbae1924736d8bab471e0e46960c55a092698d5f0"
  project: unidentified-415ba130
  name: "TokenGatedAccount (study family c5a2bd8e), 1 of 188 addresses running it"
  upgradeable: "no"
- address: "0xd20969460645add745f3f490d0f7aee1be60b741"
  project: unidentified-fbc626c7
  name: "THREEFACE (study family 2d5e7c3c)"
  upgradeable: "no"
  value_usd: 6857
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x33009fc337c2d5c10c41b983e3965860fc8d1201"
  project: unidentified-2c5641c0
  name: "unverified code (study family 1c4b1c3a), 1 of 103 addresses running it"
  upgradeable: "no"
- address: "0xb35c53c860f646231594a73946ecfd7907759009"
  project: unidentified-be9ad354
  name: "LinkdropMastercopy (study family e0dffb2c), 1 of 138 addresses running it"
  upgradeable: "no"
- address: "0x1fa912cfdc9ad3773550aeaa72727c66a60e01b6"
  project: unidentified-0f4ba5c2
  name: "Metacity (study family ff1b2a77)"
  upgradeable: "no"
  value_usd: 6677
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x00000000007767d79f9f4aa1ff0d71b8e2e4a231"
  project: unidentified-3ab105f0
  name: "Yolo (study family ec4a2374)"
  upgradeable: "no"
  value_usd: 6677
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xdb0f8cc11d9641fbbf37ec1c216cef543810537a"
  project: unidentified-b822cc6d
  name: "unverified code (study family 25134a84), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x70f2202d85a4f0cad36e978976f84e982920a624"
  project: unidentified-3a35ddbb
  name: "DKGResultVerification (study family c50bddbe), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xd665a161c687bb0818f53a0815e5b8b038d983d4"
  project: unidentified-f41a93c6
  name: "OMNINFTLogic (study family 58d38680), 1 of 10 addresses running it"
  upgradeable: "yes"
- address: "0x7fc9c19ced994a8ef28df46be4c95772de5eeefd"
  project: unidentified-69f74d7d
  name: "unverified code (study family a00c7986), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x01a5ad4b57c404dbed28c15bc248a8f020640c22"
  project: unidentified-f1ab5957
  name: "GabbyMasterpiece (study family f0f58083)"
  upgradeable: "no"
  value_usd: 6496
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x6ad85107af103150d3df2b3d8f7c9662d89eacc8"
  project: unidentified-1a3d5fb6
  name: "ERC721Minter (study family b407c4d4)"
  upgradeable: "no"
  value_usd: 6496
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xdfde2e8e3e48114ec492b397905fd2b1f014c936"
  project: unidentified-7820c32b
  name: "unverified code (study family bf1faaaa), 1 of 157 addresses running it"
  upgradeable: "no"
- address: "0xd54ac8ce537d1a0e1a406f60704b61b65e3c1afc"
  project: unidentified-8d283d41
  name: "unverified code (study family f48c03ef), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x66b5eb7152861168d7176b5235ee41c9c9aa4a05"
  project: unidentified-00e94075
  name: "LilBOB (study family c3f325cc)"
  upgradeable: "no"
  value_usd: 6316
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x2339439b4113e85e3ad263c186d33435a7ea40e8"
  project: unidentified-28d14b02
  name: "Inferno (study family aef2fac4)"
  upgradeable: "no"
  value_usd: 6316
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xfa9869982542fb20bad929789b252b7b06eee10e"
  project: unidentified-b183c86c
  name: "unverified code (study family 5b68e9c2)"
  upgradeable: "no"
  value_usd: 6136
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x17330b12d286e2b48d71bf84cab4469cf970920a"
  project: unidentified-11a545dc
  name: "unverified code (study family 04be25f8), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x582908d8edbaf3d1632d31aa5596e30b26482fce"
  project: unidentified-9bcd3305
  name: "ParlayCoreSimple (study family 7e038716)"
  upgradeable: "no"
  value_usd: 6136
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x053513b3c1482da58725924ab168b6358dda66fc"
  project: unidentified-90588b57
  name: "unverified code (study family 4e6eab5e), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x0732156088264b59ee9287851c4457326127ec3e"
  project: unidentified-2e3889f0
  name: "Shizuka (study family f0098390)"
  upgradeable: "no"
  value_usd: 6136
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x85cef9f957c644e91c081eef2e5da318458778b1"
  project: unidentified-abdfc957
  name: "StarterKit (study family 4af685a8)"
  upgradeable: "no"
  value_usd: 5955
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x15818fce7757fd827f3a1be6b68ca66d5d116302"
  project: unidentified-a7b6bef8
  name: "CyberVault (study family f4c3d903), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x1a66f065303299d78693f122c800ab3debe9c966"
  project: unidentified-7023a321
  name: "Underwriting (study family 22549f03)"
  upgradeable: "no"
  value_usd: 5955
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x88ce0200850eb5579aeaaa64df3d7805c901bbb3"
  project: unidentified-7e6ce0b7
  name: "unverified code (study family d3811243), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x0107fa0cbcf04c87184f5f3076000e5e4d1d7693"
  project: unidentified-c447116c
  name: "Vincents (study family 71ac4fa5)"
  upgradeable: "no"
  value_usd: 5955
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x790586f98b1e9d06a4a869621cc21d201078956c"
  project: unidentified-8dbfabfe
  name: "WediditJoeContract (study family 123be7c1)"
  upgradeable: "no"
  value_usd: 5775
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xa7d854eaf481846f7da8cc863a46ac1f67b548d8"
  project: unidentified-5b67a1c7
  name: "unverified code (study family de060e73)"
  upgradeable: "no"
  value_usd: 5775
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x3d36c43d96a0eb4e217423fcd9d66d9fe9d1e349"
  project: unidentified-185e6bd1
  name: "unverified code (study family 89c24223)"
  upgradeable: "no"
  value_usd: 5775
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x8094816e435b8ca77f2dfe240820c6c6ac784900"
  project: unidentified-6f48603d
  name: "unverified code (study family 78a87bfd), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xc5124014d21e06208f2dcfac619d8a49484f1033"
  project: unidentified-1d4a8fea
  name: "BloctoAccountCloneableWallet (study family 3737a622), 1 of 963 addresses running it"
  upgradeable: "yes"
- address: "0xe4f9943910710ea06b674630eaa3eb57ff4f80f7"
  project: unidentified-f3f78a32
  name: "unverified code (study family 42689004)"
  upgradeable: "no"
  value_usd: 5594
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x0e8d0720716a7e43508c22cdd48642cd7882b387"
  project: unidentified-1a7bc54e
  name: "unverified code (study family 1573fe2d)"
  upgradeable: "no"
  value_usd: 5594
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xc5204200faabbbbfec38260df8465510a08c607f"
  project: unidentified-d6178af6
  name: "PJF (study family 06585e55)"
  upgradeable: "no"
  value_usd: 5594
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xb395c7f6e936e3d6ae96ab31e3f69ad37328ceb3"
  project: unidentified-cf2d5f81
  name: "wQUIL (study family de764465), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x4391187cbcab7be1db403fcc71a2fc1be673863e"
  project: unidentified-b15bb946
  name: "BettingV2 (study family fb666473), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xd3d9ddd0cf0a5f0bfb8f7fceae075df687eaebab"
  project: unidentified-9d49cdcf
  name: "Remilia (study family 4b419c62)"
  upgradeable: "no"
  value_usd: 5414
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x725b3c9afdc19f055a3a3a4c1204856b94e3f0ea"
  project: unidentified-0c0465cf
  name: "BullionFxPeriphery (study family 6d376de5)"
  upgradeable: "no"
  value_usd: 5414
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x1c4a02fec7bc0c17cbc4084b362b192e12171196"
  project: unidentified-cf280b9a
  name: "unverified code (study family f90e718b), 1 of 7 addresses running it"
  upgradeable: "yes"
- address: "0x97ae6e03d8518660b8f9a433c9cb21f3fa255d1c"
  project: unidentified-33338b2c
  name: "IERCSwapV1 (study family bfbcdeb8)"
  upgradeable: "no"
  value_usd: 5233
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x1bc6388782796b54462ca27bbdb3ea335c0a746c"
  project: unidentified-759c5f29
  name: "ApeEscape (study family 3486d4b5), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x496a2d17a89cbc4248e9b52c8003a50c648fbca0"
  project: unidentified-df92e031
  name: "PeopleInThePlaceTheyLove (study family 769c238a)"
  upgradeable: "no"
  value_usd: 5053
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x73f7e6ae9eee36c77995250c6a573c07774fa10d"
  project: unidentified-5843c3df
  name: "FundPool (study family f52096bc)"
  upgradeable: "no"
  value_usd: 5053
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xb645cffd9bfb93c2c181d5be0d6a8c1d81c2aef3"
  project: unidentified-0e7de56c
  name: "FixedPrice (study family a52640f2)"
  upgradeable: "no"
  value_usd: 5053
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x2d035fc2d2147748edd3b3059e99bd0fbad929cb"
  project: unidentified-02f7c077
  name: "unverified code (study family b350786c), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x95d978884a13c666708835105a9cbb9b6afd2436"
  project: unidentified-e1253d01
  name: "PoolContract (study family 73d6cf3f)"
  upgradeable: "no"
  value_usd: 5053
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x4457ccc55820cadcd552694df26f41848f79e4b3"
  project: unidentified-4d6bb0b9
  name: "unverified code (study family a6ef9a3f), 1 of 4 addresses running it"
  upgradeable: "yes"
- address: "0xfb2fd515e35752abd79a0121a9c95e0868a80bb6"
  project: unidentified-055565df
  name: "unverified code (study family ce624aee)"
  upgradeable: "no"
  value_usd: 4872
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x24ec1018e03c432f5a2ba02fcc617404df16394f"
  project: unidentified-50306be5
  name: "PerpXVault (study family 1ee3c593)"
  upgradeable: "no"
  value_usd: 4872
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x4d87bc56090ab96923a8a940fa5703a5811a1ba1"
  project: unidentified-2c5641c0
  name: "LinkdropMastercopy (study family cf9048e8), 1 of 195 addresses running it"
  upgradeable: "no"
- address: "0xdaabb76d7d5f88f8734828d5cbbdd0bf5f522ca8"
  project: unidentified-2e1be603
  name: "QUOKKA_KIDS_STOREFRONT (study family 4df2e861)"
  upgradeable: "no"
  value_usd: 4872
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x1629da0810eb1ff313090e051f9a47e768353e51"
  project: unidentified-60a59d70
  name: "Archetype (study family b289ddf5), 1 of 37 addresses running it"
  upgradeable: "no"
- address: "0xbab27afe3f6be3f39d70739eb846d53d7ffd0d11"
  project: unidentified-4c49093c
  name: "unverified code (study family 00e6ca7c), 1 of 19 addresses running it"
  upgradeable: "no"
- address: "0xfdbbac8ea37efbab5e776e74e01a47a57d2d2ed3"
  project: unidentified-8b50c76e
  name: "unverified code (study family 09b82a53), 1 of 12 addresses running it"
  upgradeable: "no"
- address: "0x86e263cadd1cace347a752fe84c065823bca66a1"
  project: unidentified-6a07feef
  name: "DutchAuction (study family 605e2b78)"
  upgradeable: "no"
  value_usd: 4692
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xa7e55efa7177699544a11adc6c51b846c3bdc48f"
  project: ownbit
  name: "OwnbitMultiSigImplementation (study family a4064f89), 1 of 9 addresses running it"
  upgradeable: "no"
- address: "0x2f925542d1689258be55f87e17fcd8b7480d76f0"
  project: unidentified-e743089d
  name: "BonusDistributor (study family 8a47d6e2), 1 of 4 addresses running it"
  upgradeable: "no"
- address: "0xd5c93db749eb5e3e8c1e9311219985a54a0170b4"
  project: unidentified-6372b136
  name: "unverified code (study family 64ecd791), 1 of 10 addresses running it"
  upgradeable: "yes"
- address: "0x892a6f9df0147e5f079b0993f486f9aca3c87881"
  project: unidentified-481fe690
  name: "XFUND (study family af4bb89f)"
  upgradeable: "no"
  value_usd: 4511
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xa102b15710d0dd04ff269a8e13706f0a7ce573fa"
  project: unidentified-68e9aef5
  name: "PulseSmartWallet (study family 5b696ec2), 1 of 332 addresses running it"
  upgradeable: "yes"
- address: "0xb7da7b8ffca7ca4bff6b68024d4ba50ef337d049"
  project: unidentified-099cc0f5
  name: "EnhancedVault (study family c6d8ed33), 1 of 3 addresses running it"
  upgradeable: "yes"
- address: "0x82bfb461f3a718060e17af228541b54a18011f98"
  project: unidentified-73a37b3e
  name: "Router (study family 7d7b8ec6), 1 of 31 addresses running it"
  upgradeable: "no"
- address: "0x51e6775b7be2ea1d20ca02cfeeb04453366e72c8"
  project: unidentified-aec6233a
  name: "unverified code (study family 8014aea3), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x258399d5f1f80773a8c2f671653fcd00750229f7"
  project: unidentified-ad23a77d
  name: "unverified code (study family ac10cdc1)"
  upgradeable: "no"
  value_usd: 4331
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xa9d3173fa17d14fc147c993667a97c6889f5d486"
  project: unidentified-218f850e
  name: "unverified code (study family 7dd16091)"
  upgradeable: "no"
  value_usd: 4331
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xff2618931df61f0cc22b3decc5bb0e4bd444ee17"
  project: unidentified-8a0d67a3
  name: "unverified code (study family 047762b3), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x2d37eb7a02474e7d2cc1d5da7507e6e39d4479a4"
  project: unidentified-8b5f94a2
  name: "unverified code (study family 2fc6ae9f)"
  upgradeable: "no"
  value_usd: 4331
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x95fabdd34adac5070607e732a42888cb51666583"
  project: unidentified-f1ae63c3
  name: "Node (study family b4f0d62f)"
  upgradeable: "no"
  value_usd: 4331
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x6fc5bc7b2e82a7ab8687ab1217b621f718676ce2"
  project: unidentified-33338b2c
  name: "IERCSwapV1 (study family 5cefca7d)"
  upgradeable: "no"
  value_usd: 4331
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x23aa05a271debffaa3d75739af5581f744b326e4"
  project: unidentified-a8863bf1
  name: "ERC721LazyPayableClaim (study family 1af97a7a)"
  upgradeable: "no"
  value_usd: 4150
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x25563dfc1aa8310d1321b0d9d405e632ea9cb824"
  project: unidentified-207fec9b
  name: "unverified code (study family ac030ec6), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x273567205659bc007124e228ed8505aa025bac00"
  project: unidentified-04f87645
  name: "FckDice (study family 8d9bded7), 1 of 12 addresses running it"
  upgradeable: "no"
- address: "0x86853545c99ac7491d1088c84740f284108c00dd"
  project: unidentified-a9ada0d1
  name: "unverified code (study family ea611cf6)"
  upgradeable: "no"
  value_usd: 4150
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x578c55fa6890b30ef74ccd3af52f455bbcca4d3e"
  project: unidentified-8b5f94a2
  name: "TransferSwapper (study family b6a425ab)"
  upgradeable: "no"
  value_usd: 3970
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x9b58c0b0c2c9403e03a65bf7b7a2cb71b7b25ce0"
  project: unidentified-734a3067
  name: "unverified code (study family e664b203), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x7339453b0c6947f33f95278a2589dab317612254"
  project: unidentified-40c26c6c
  name: "unverified code (study family 56979671)"
  upgradeable: "no"
  value_usd: 3970
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x0b20d5d59e14c71a948d55439019a2aaf74fa7b4"
  project: unidentified-8fa9aa69
  name: "FeeBoxETH (study family 768d868c), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x42ecf9bde9078d659663da66b97c4823f762005e"
  project: unidentified-6c74fda1
  name: "Native20 (study family 7fd26ba3), 1 of 5 addresses running it"
  upgradeable: "yes"
- address: "0x7c6c6b92364501827179164b5bee67082cc66721"
  project: unidentified-be9ad354
  name: "LinkdropMastercopy (study family f35b8199), 1 of 69 addresses running it"
  upgradeable: "no"
- address: "0x2222222216460df561c56bb450bd7847baa1f7b5"
  project: unidentified-b908c25d
  name: "unverified code (study family 1bc0bf03)"
  upgradeable: "no"
  value_usd: 3790
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x12e6da438d7d73464151b954c2f92a0b8666d8e6"
  project: unidentified-c4cc35f9
  name: "unverified code (study family 4aebdb59)"
  upgradeable: "no"
  value_usd: 3790
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x9042314460be7690db3ad9c7c6f7d189d907a7c5"
  project: unidentified-4c2ecafc
  name: "FutureIcons (study family e12338c6), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xf61cbe88a2ce59f816f1577903230239efdb274d"
  project: unidentified-c7c84d88
  name: "unverified code (study family 0576ebc3), 1 of 62 addresses running it"
  upgradeable: "no"
- address: "0x462b572089d3176c1b916aabe24bc23de459f5e1"
  project: unidentified-1b99e3b8
  name: "WittyPixelsTokenVault (study family be2d4251), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xf38d6bf300d52ba7880b43cddb3f94ee3c6c4ea6"
  project: unidentified-1b9bb765
  name: "PixelGlyphs (study family 684afb75)"
  upgradeable: "no"
  value_usd: 3609
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x0da0ea640fb7338e55bb3ed37f913e99bd0e9845"
  project: unidentified-07711fdd
  name: "unverified code (study family 5d8e621b)"
  upgradeable: "no"
  value_usd: 3609
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xb3bf6eb65f0fbfe4c75665db5b60d0e1b81957f6"
  project: unidentified-0000001b
  name: "MultisigWallet (study family 68b0530d), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x41f8d14c9475444f30a80431c68cf24dc9a8369a"
  project: unidentified-447e2eeb
  name: "unverified code (study family 2afd6bd6)"
  upgradeable: "no"
  value_usd: 3609
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x6eb0e558140025cb740f99979613a0876685f0be"
  project: unidentified-d4be0897
  name: "BlockChainCasino (study family b504ab88), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xa288b938fe6d6bc70adb5c545a99985993e398f5"
  project: unidentified-218f850e
  name: "unverified code (study family 9ab2da91), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x941131e857a6100a37298c2c571c7f4c823caded"
  project: unidentified-3688d570
  name: "unverified code (study family 7c54a2b2), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x2ad3b1c08a30af13be89c63dc28de4e6cf076c2f"
  project: unidentified-c99e4b18
  name: "TeaVaultV2 (study family c31faf26), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x68fae3f4a152fbe8ce625918f5d41a20ea5b3cf3"
  project: unidentified-0ef15ad4
  name: "unverified code (study family 253ab8f1)"
  upgradeable: "no"
  value_usd: 3429
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xc3f78f50222b3cab2ed2f73d07ed28131d1ebaa3"
  project: unidentified-030839c3
  name: "GenAI (study family 649be8bb)"
  upgradeable: "no"
  value_usd: 3429
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x804298f4b87b011330fb853254ebe0cb84c77a63"
  project: unidentified-eadb1013
  name: "unverified code (study family 795fa4a4), 1 of 7 addresses running it"
  upgradeable: "yes"
- address: "0x2364134ef692d0c4a1ce809915f8f3c9be708d62"
  project: unidentified-3a950de8
  name: "unverified code (study family b83a5ae9), 1 of 18 addresses running it"
  upgradeable: "no"
- address: "0x146f2ac6ffc0c953073598fb5d6fbe0976421d8e"
  project: unidentified-31c00012
  name: "NNSRegistrarController (study family 3b0e2137), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xe282de82d08e6b002127e203681d16222069a9f0"
  project: unidentified-30a05a2f
  name: "C86Cybank (study family 11477fff)"
  upgradeable: "no"
  value_usd: 3429
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x7fe2d15b82a54eef3c0a5167b7579cd972ba420b"
  project: unidentified-a86afa6b
  name: "Breeder (study family ffcbbf2a)"
  upgradeable: "no"
  value_usd: 3429
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xf0b9e57528c1ebc2e104c7eb877a2af0fae7ae61"
  project: unidentified-711a8720
  name: "unverified code (study family c7875b74), 1 of 265 addresses running it"
  upgradeable: "no"
- address: "0x6b839666485b03964e68e4d21b9f359f301f0551"
  project: unidentified-999657a4
  name: "Account (study family 8196b9d2), 1 of 385 addresses running it"
  upgradeable: "yes"
- address: "0x4d38ac8f0db33904ab04d97296ec4c549998b880"
  project: unidentified-07711fdd
  name: "unverified code (study family e3e09280)"
  upgradeable: "no"
  value_usd: 3429
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x9ec6232742b6068ce733645af16ba277fa412b0a"
  project: unidentified-11a5b37a
  name: "ParallelID (study family 19f51c6b), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x27f06f6886b3adf40514ccd05cbaf745bb6e1eda"
  project: unidentified-588ede44
  name: "DeoracleizedFeeDistributor (study family d8f737e4), 1 of 1,866 addresses running it"
  upgradeable: "no"
- address: "0x6596e330566ad25284684ae6e2d6006f215fd315"
  project: unidentified-434121f6
  name: "unverified code (study family aede8b55)"
  upgradeable: "no"
  value_usd: 3248
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xb668bdbb7dc16417aeaf93f8c7dbe1062a1ab58c"
  project: unidentified-7add5e53
  name: "XPSRDeposit (study family f92fc384)"
  upgradeable: "no"
  value_usd: 3248
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x665d8597340f61816ed727ea3e0d7368468fe70b"
  project: unidentified-250d4ce9
  name: "DoomskullDungeon (study family b4a7a6d6)"
  upgradeable: "no"
  value_usd: 3248
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xca44819097bc0d4d385e83e9e0708d92a979b6e6"
  project: unidentified-476b535c
  name: "FairXYZDeployer (study family af121be1), 1 of 841 addresses running it"
  upgradeable: "no"
- address: "0x389dcc122a2304a95ef929e71b7ef2504c6cc3ac"
  project: unidentified-e6509a75
  name: "PortalPass (study family a2e45755)"
  upgradeable: "no"
  value_usd: 3248
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xde371dad8d8fe3799b8dc60560341614228c5aaf"
  project: unidentified-5a83cac3
  name: "BaseFixedPriceAuctionERC1155 (study family 0d88869d)"
  upgradeable: "no"
  value_usd: 3248
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x15af685f93202ccd1e380a6e0b79563a3827726f"
  project: unidentified-bef40dcb
  name: "unverified code (study family 8c4810c0), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0xc5f167436534886ad3d16b37df907598ad93c62a"
  project: unidentified-cf1a7be1
  name: "Editions (study family 2fce9298)"
  upgradeable: "no"
  value_usd: 3248
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x9bd0474cc4f118efe56f9f781aa8f0f03d4e7a9c"
  project: unidentified-cb1d410a
  name: "unverified code (study family 949b4867), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xb611401574061947abac7d2406711f115be22a6e"
  project: unidentified-d436f206
  name: "AccessControlledOCR2Aggregator (study family 094a5af9), 1 of 382 addresses running it, 1 by 7702 delegation"
  upgradeable: "no"
- address: "0xb74172d5ab803799449df4d0ddd9eb15c7a12a03"
  project: unidentified-ee7b429e
  name: "unverified code (study family 17fcf13f), 1 of 4 addresses running it"
  upgradeable: "yes"
- address: "0xd21d15751ca9df6813ac5fb1ff366f05a28fda27"
  project: unidentified-06be18a8
  name: "unverified code (study family 21e8f447), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xd4517dbeef443cf3d1d760abdd4268f12940c6f8"
  project: unidentified-9d0e0117
  name: "TokenRewardV2 (study family 51b86c99), 1 of 3 addresses running it"
  upgradeable: "yes"
- address: "0x75e404231433c0993125c8cfae78e3a9f016b44f"
  project: unidentified-7ae7e674
  name: "IDreamer (study family 57a70788)"
  upgradeable: "no"
  value_usd: 3068
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x03fba07b98ce91ab9d8ee3c70817ab340b12b20c"
  project: unidentified-9723a2d2
  name: "BlockchainAssetManager (study family db20ec2d)"
  upgradeable: "no"
  value_usd: 3068
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x784e6df1490ee2b49a293405e443e2f72279cb25"
  project: unidentified-01bf1d7c
  name: "unverified code (study family a4a9dc41), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x603b6e737278eaa71a3a1630174f2452841a1c5c"
  project: unidentified-31781b4e
  name: "unverified code (study family b7bf95e0), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x15e343d8cebb2d9b17feb7271bb26e127aa2e537"
  project: unidentified-4bed4d66
  name: "unverified code (study family c3f671ed)"
  upgradeable: "no"
  value_usd: 2887
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x5b28c6856d61ca91cdbaed52eab7dc8135287818"
  project: unidentified-149c9e60
  name: "RBCLand (study family 86ef1d82)"
  upgradeable: "no"
  value_usd: 2887
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x602e476c70feef069f5ba1c1b1138d13f6f60ee8"
  project: unidentified-be9ad354
  name: "LinkdropMastercopy (study family e5711031), 1 of 30 addresses running it"
  upgradeable: "no"
- address: "0x747e550a7b848ace786c3cfe754aa78febc8a022"
  project: unidentified-2483dee0
  name: "DODO (study family a1a65706)"
  upgradeable: "no"
  value_usd: 2887
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x63253e3352c0cae9f6ee64e61ed461ae23f9c8b6"
  project: unidentified-f5d7940e
  name: "Attestations (study family 399c108c), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x999999c60566e0a78df17f71886333e1dace0bae"
  project: unidentified-b9fcfa55
  name: "FckDice (study family 38d39b88)"
  upgradeable: "no"
  value_usd: 2887
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xec4549cadce5da21df6e6422d448034b5233bfbc"
  project: unidentified-172b750a
  name: "unverified code (study family 0f21c318), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x80a84a3508aa58521344311c428d88e6d0baabef"
  project: unidentified-5d021314
  name: "ULANDHeroesDapp (study family d335ceb1)"
  upgradeable: "no"
  value_usd: 2887
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xd01c92937400dd1ece24992b1dc44aeaa47ae72a"
  project: unidentified-4add46c2
  name: "AuctionityDepositEth (study family 740479c6)"
  upgradeable: "no"
  value_usd: 2887
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xcb57d171682817ad3c2dcab473770ac43725f65f"
  project: unidentified-d408edf3
  name: "unverified code (study family c24dc003), 1 of 17 addresses running it"
  upgradeable: "no"
- address: "0xf78da89c1fd7785742e2ea9a4495527db7b99d5b"
  project: unidentified-28da9df2
  name: "unverified code (study family 95c83c80)"
  upgradeable: "no"
  value_usd: 2887
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xbfebc5ecac789643a61fadf15048a37dc9612dcf"
  project: unidentified-7946669e
  name: "unverified code (study family 54b7a1c2), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xd83e611af1bb562db4702fcca44f34a859950514"
  project: unidentified-5dff6344
  name: "unverified code (study family 037da16f), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x31f8179866f10b87f08a956c14c5a377c83efb1a"
  project: unidentified-eadb1013
  name: "UpstreamCollectiveToken (study family 524c172f), 1 of 27 addresses running it"
  upgradeable: "yes"
- address: "0xc801502c574eec48b11b3ec93fdf73752d7f63cb"
  project: unidentified-113d7257
  name: "Sale (study family 67c29699)"
  upgradeable: "no"
  value_usd: 2707
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x6628ca85d822fb41ac745cb86bccb5dcbd90be05"
  project: unidentified-d3c54f83
  name: "unverified code (study family 84eb89c6), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x1b6bf7ab4163f9a7c1d4ecb36299525048083b5e"
  project: unidentified-ae75b29a
  name: "Batcher (study family 97d45a23)"
  upgradeable: "no"
  value_usd: 2707
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xd58e8c1c83d598ad76b5f0e26b4a25cdb885d190"
  project: unidentified-e427040f
  name: "UnderlyingOFTAdapter (study family e8f04f06), 1 of 3 addresses running it"
  upgradeable: "yes"
- address: "0x74e9fee3fcb56bccac22e726cce7a78ca90185e1"
  project: unidentified-d2dbbe69
  name: "Rizo (study family 65607c85)"
  upgradeable: "no"
  value_usd: 2707
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xfd0d28539aed12477dcba1575eb40fca53969440"
  project: unidentified-7023a321
  name: "Treasury (study family 2c4af58a)"
  upgradeable: "no"
  value_usd: 2707
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xa7952effcc5d8b1732dae495d6652a575a2ea2fe"
  project: unidentified-94194476
  name: "TGLPlatformV1 (study family 6f342059)"
  upgradeable: "no"
  value_usd: 2707
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x1c67d8f07d7ef2d637e61ed3fbc3fa9aaf7a6267"
  project: unidentified-60a59d70
  name: "Archetype (study family f6f2e13c), 1 of 8 addresses running it"
  upgradeable: "no"
- address: "0x752aeb29026a9f3bd7fbfe6dc7ed5ab35e405a6c"
  project: unidentified-058272e9
  name: "NodeSetOperatorRewardDistributor (study family 4c2dc2bb), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x34699696d60259bd5278518d043328be3c6179e6"
  project: unidentified-7345e803
  name: "unverified code (study family a6348d82), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x6bface5ec1dd1ba63d04d4ffefe12e72839659dc"
  project: unidentified-15762b20
  name: "unverified code (study family 0586a373), 1 of 8 addresses running it"
  upgradeable: "no"
- address: "0x22a97bd8e8bb284433d867b04fcb2369f35aa6d3"
  project: unidentified-523151a0
  name: "MultiSigPoolV2 (study family 61fa3fee)"
  upgradeable: "no"
  value_usd: 2526
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x25a023e0076a8d7da3d098722ddd69da66401c16"
  project: unidentified-ebf4909c
  name: "ERC721SignatureExtension (study family 83e3fca1)"
  upgradeable: "no"
  value_usd: 2526
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x9f91b5aa41b9fbdae6877593910586484d291f05"
  project: unidentified-c683c905
  name: "FairHouse (study family 92b33472)"
  upgradeable: "no"
  value_usd: 2526
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x1c80a8bb40d80679bb3615ad20215eec5a5e8ded"
  project: unidentified-eadb1013
  name: "UpstreamCollectiveToken (study family 14206458), 1 of 57 addresses running it"
  upgradeable: "yes"
- address: "0x2db959050b1c2859746b95af5a1f4a0cab809a37"
  project: unidentified-b1ff36e2
  name: "PhotochromicCore (study family 365e4627)"
  upgradeable: "no"
  value_usd: 2526
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xf67bfdd598978d747ce6698540e65bc895da22d3"
  project: unidentified-7ad2cb81
  name: "MasterchefMasatoshiJuniorX (study family d59472cb), 1 of 31 addresses running it"
  upgradeable: "no"
- address: "0x7156fbe1671abd7713d622eb17424481d39bc6ea"
  project: unidentified-7704847d
  name: "unverified code (study family 9c6c1163)"
  upgradeable: "no"
  value_usd: 2526
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x2d208703e30873c59a2ba905414b256b6bd2d1c2"
  project: unidentified-b4eaa204
  name: "GodsOfEgypt (study family f3a58d93)"
  upgradeable: "no"
  value_usd: 2526
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x80105a874f82c09e1959db6d6cf919ac9e6ba1e5"
  project: unidentified-6f08a927
  name: "CA22Characters (study family 707ffc4b)"
  upgradeable: "no"
  value_usd: 2526
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xb8180bed5a2980f31a65ef4ce2ead0025fef0a03"
  project: unidentified-90902053
  name: "NFT (study family 0438c9a5)"
  upgradeable: "no"
  value_usd: 2526
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xaa1b7ed99b4dc3a6bbf03654d85af89cfcaa49ed"
  project: unidentified-799a2973
  name: "AutoMinterERC721 (study family 0bd5ca2b), 1 of 107 addresses running it"
  upgradeable: "no"
- address: "0x4333ab5682cd4589330bd9cfcedd5e054a0e9d8d"
  project: unidentified-b1362de0
  name: "unverified code (study family 4d1dc785), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xbbf4fb0565d7b9ad58819c9f83785785c71f00c3"
  project: unidentified-5738bfc4
  name: "unverified code (study family 60b54f97)"
  upgradeable: "no"
  value_usd: 2346
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x6c152a7fcfe50f499be3977358fac9d6d8b06451"
  project: unidentified-29e6dbce
  name: "BoxBetRewardsDistribution (study family b51c00fb)"
  upgradeable: "no"
  value_usd: 2346
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xdc879409509995f65342e0046a68b8151b8ffc8e"
  project: unidentified-f67cd363
  name: "AhBoysvsAhGirls (study family f94f29bf)"
  upgradeable: "no"
  value_usd: 2346
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x97405af0b849b5ef2d04f464b53480037b214eae"
  project: unidentified-f276bf68
  name: "unverified code (study family b49b28c5), 1 of 6 addresses running it"
  upgradeable: "no"
- address: "0xbdd172e4f5a3728aef683fd62bd3472c60aadbc9"
  project: unidentified-9437c272
  name: "unverified code (study family 3a473b3c)"
  upgradeable: "no"
  value_usd: 2346
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xd7ec987886c7fb192f8223a1f55925bb93682556"
  project: unidentified-00eb6d65
  name: "unverified code (study family 36695b8b)"
  upgradeable: "no"
  value_usd: 2346
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xb8b1bc880cb6b2ab75418225f4fa4edc749f49ea"
  project: unidentified-caef1298
  name: "GreyMarket (study family c1e47e40), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xaefcf0171403deb760a2c3a2326cb492094dc4fc"
  project: unidentified-761f0f28
  name: "unverified code (study family a7bc2fd2), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x1b5668ca8edfc8af5dcb9de014b4b08ed5d0615f"
  project: unidentified-000039dd
  name: "AtomicLockContract (study family 92213bc2), 1 of 3 addresses running it"
  upgradeable: "yes"
- address: "0x52de8d3febd3a06d3c627f59d56e6892b80dcf12"
  project: unidentified-6e80c53f
  name: "Invoice (study family 0c5b3822)"
  upgradeable: "no"
  value_usd: 2346
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x3d8fbffada66edb970266086ba40493e6fce98ff"
  project: unidentified-8b902efd
  name: "TokenPresale (study family 4599512e)"
  upgradeable: "no"
  value_usd: 2346
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x4ceb65c4f5b70d2afef97ffdd6c3bc1337f64697"
  project: unidentified-c6a34b2b
  name: "unverified code (study family a2c9e8ee), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xc1c3039eb11fc1558879c5a25d77adc875d9cc98"
  project: unidentified-b2800abf
  name: "unverified code (study family 55f145db)"
  upgradeable: "no"
  value_usd: 2346
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x0583ce2dc21d4d6b7cdcf599ca6cc03043652ef3"
  project: unidentified-0b18c06d
  name: "AvantGarde (study family 2ddb4956)"
  upgradeable: "no"
  value_usd: 2165
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x4776defcf622c60c6419cccc9ee9e9042fadf3f7"
  project: unidentified-5b6b5a95
  name: "Coinage (study family 460797bc)"
  upgradeable: "no"
  value_usd: 2165
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xa6a7109edd298fdb5606a8244a905fb9daee5bc0"
  project: unidentified-7c29e9c1
  name: "unverified code (study family 29e3101a)"
  upgradeable: "no"
  value_usd: 2165
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x35c562e8b6b53fe6b89343b894bf49a39c70ecb6"
  project: unidentified-846721b6
  name: "unverified code (study family 61484e3d)"
  upgradeable: "no"
  value_usd: 2165
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x39fbd1140cd1fc298f00c3ea64b3591de94c67e7"
  project: unidentified-bbbce6a0
  name: "BitEyeExchange (study family 5baafa54), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0xa2bf58cbaeffc76f8433b7b8492010ac8a51ef80"
  project: unidentified-0014eb4a
  name: "unverified code (study family 76555dff), 1 of 4 addresses running it"
  upgradeable: "yes"
- address: "0x9439f13a120bfe1420e010b4d946d6d0dc834846"
  project: unidentified-5b47acb2
  name: "Wallet (study family 50f33a31), 1 of 273 addresses running it"
  upgradeable: "no"
- address: "0xb8cb3a53dbe2147f8d2be89af6932757163d0726"
  project: unidentified-6372b136
  name: "unverified code (study family 1eadfd72), 1 of 8 addresses running it"
  upgradeable: "yes"
- address: "0x24218f732d5df76f9354269cb648e211907dea64"
  project: unidentified-60a59d70
  name: "Archetype (study family 70b391fd), 1 of 6 addresses running it"
  upgradeable: "no"
- address: "0xccb4c4b522b74d719b0dda075fe24a90bb9f6805"
  project: unidentified-3bbbf01e
  name: "unverified code (study family 51704981)"
  upgradeable: "no"
  value_usd: 2165
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x277c5dd6e4aab3e0bd812eb2052c4c2e63918e65"
  project: unidentified-7055a6fc
  name: "RACINGSHOE5 (study family a3dfe881)"
  upgradeable: "no"
  value_usd: 2165
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xc5d9a2f5ca7fd61f45d1fb57202cbc1d308babd0"
  project: unidentified-ed708ea8
  name: "DataVault (study family 608b10af)"
  upgradeable: "no"
  value_usd: 2165
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x079e4c98902cf68c0cbacaaebcc6f257abf768cd"
  project: unidentified-3bbbf01e
  name: "unverified code (study family dfbbe08f)"
  upgradeable: "no"
  value_usd: 2165
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x1c02b59c6500169275e1ebcfef47f944a2c53ae6"
  project: unidentified-6303b25f
  name: "Airdrop (study family 1c39cac2)"
  upgradeable: "no"
  value_usd: 2165
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x701e55ccf6ba23706cdff5db26e30c72f5d59eff"
  project: unidentified-3dfb4aea
  name: "AlicenetMultiSigWallet (study family 96b42e2b), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0xb5ae82b7677875875c5e526fb6bb2cfb325d9230"
  project: unidentified-536ee634
  name: "AccessControlledOffchainAggregator (study family 7e64ca1f), 1 of 609 addresses running it"
  upgradeable: "no"
- address: "0x4bf15d56d6c9834ed06636ceda6a08f8fc68476b"
  project: unidentified-a8997d7a
  name: "IndexTownTrade (study family 940bdc37)"
  upgradeable: "no"
  value_usd: 1985
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x333c9f5e2590dcdfcdfedf2e41023d7effaf44e8"
  project: unidentified-e9da5e99
  name: "unverified code (study family 4b06462e), 1 of 5 addresses running it"
  upgradeable: "no"
- address: "0xf06c0f48632dfb86921c140fc532da1ed3989e89"
  project: unidentified-997d256d
  name: "unverified code (study family 4b69c618), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xa2e91499388f1accc943e0cfbffe83f26046e16f"
  project: unidentified-35adde4a
  name: "GeneralInstantPayment (study family 1261a3e4)"
  upgradeable: "no"
  value_usd: 1985
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x2dc8e886762ee490ec01269e48bf29075f59c0d4"
  project: unidentified-fbb3a847
  name: "EthBet (study family 6262e0ce)"
  upgradeable: "no"
  value_usd: 1985
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x38b9996376cffec77362fccb1cd15ba43c210db8"
  project: unidentified-76c54c77
  name: "unverified code (study family 5f9152d1)"
  upgradeable: "no"
  value_usd: 1985
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x9fb2fd4bce3061b826bf1a0b53b737c6f3e0e586"
  project: unidentified-14d06788
  name: "WrapperLockEth (study family 028987d6)"
  upgradeable: "no"
  value_usd: 1985
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x4d3737a674d22e06c80ded656efd3130d879ac59"
  project: unidentified-90588b57
  name: "unverified code (study family 909bc3bc)"
  upgradeable: "yes"
  value_usd: 1985
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xb9879cd06c904c2fdbc75d03534929b5e842f3a0"
  project: unidentified-52465c99
  name: "MemecoinFiresaleV1 (study family 9570ae10), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x0922c267ff86ff17d8b20d2c4be9950e01a08d81"
  project: unidentified-b67b1f3d
  name: "unverified code (study family 7cb18973), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x4945c0c2322ccb064cb0a054729490db3de55089"
  project: unidentified-7379f91c
  name: "unverified code (study family 6df6834d)"
  upgradeable: "no"
  value_usd: 1985
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xdd29979189e6f1211ed0eba4040671272239ea86"
  project: unidentified-fb014860
  name: "WithdrawMEV (study family ef6792e4)"
  upgradeable: "no"
  value_usd: 1985
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x2abf5eeeebd3d0a19c7acefdd2ef6be00ae6c427"
  project: unidentified-a0e8e9ca
  name: "unverified code (study family df19842d)"
  upgradeable: "no"
  value_usd: 1985
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x34bb281cfa125446310b2e4aef2b0de625b2c105"
  project: unidentified-f31bcd58
  name: "unverified code (study family 4394bd0f)"
  upgradeable: "no"
  value_usd: 1985
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xf802f5ef19a0033c297a26649f2eb54e416a989c"
  project: unidentified-4a4c7c55
  name: "unverified code (study family 58f9f6c4)"
  upgradeable: "no"
  value_usd: 1985
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xb184b9414e7d7c436b7097ed2c774bb56fae392f"
  project: unidentified-e789d673
  name: "SODA (study family 8cd99141)"
  upgradeable: "no"
  value_usd: 1985
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xaf0a510c2cd86863ff176ef7d284680ed9be12bb"
  project: unidentified-eef3559d
  name: "WackyWizards (study family 8d19ba41)"
  upgradeable: "no"
  value_usd: 1985
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xa274e2b88cb288bb6fab47729a5c13021e0dfe09"
  project: unidentified-ec3f9eee
  name: "Minter (study family 9775bd87), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xd1ceeeefa68a6af0a5f6046132d986066c7f9426"
  project: unidentified-9607e783
  name: "Dice2Win (study family 221e626a)"
  upgradeable: "no"
  value_usd: 1985
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x3b8f6d6970a24a58b52374c539297ae02a3c4ae4"
  project: unidentified-3291b1ae
  name: "Rabbit (study family 66ff2885), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x895e34343e2cdaa58bd393ec416b446ba4781c1c"
  project: unidentified-54130995
  name: "MintverseWord (study family 04a34539)"
  upgradeable: "no"
  value_usd: 1985
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x54d75052225f16765cd9baaac24f5ca616852046"
  project: unidentified-5cba88d5
  name: "PullSplit (study family a378d6fe), 1 of 218 addresses running it"
  upgradeable: "no"
- address: "0x08669c836f41aead03e3ef81a59f3b8e72ec417a"
  project: unidentified-b846254d
  name: "Chronicle_LIDO_LST_2DAYS_1 (study family 63b9cd88)"
  upgradeable: "no"
  value_usd: 1805
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x36d28b5c6af2ef894b5612c0563f39a3d9289c43"
  project: unidentified-f6a7d8cd
  name: "unverified code (study family 29fe6f01), 1 of 107 addresses running it"
  upgradeable: "yes"
- address: "0xa8dd406bfb9cfc759eced17a9887f09addf913ca"
  project: unidentified-701fc21a
  name: "ScrollerAccount (study family 8a92c93a), 1 of 8,268 addresses running it"
  upgradeable: "no"
- address: "0x6b32f28e2e51335b5df4cddbc996a902a504ae4e"
  project: unidentified-9abbeee9
  name: "unverified code (study family 30d74f05)"
  upgradeable: "no"
  value_usd: 1805
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x770023d55d09a9c110694827f1a6b32d5c2b373e"
  project: unidentified-ef4b994f
  name: "RepoDriver (study family 25758761), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x9e2c12d9240bf267fbebd510d47ac3abd4d9d9ee"
  project: unidentified-c6a34b2b
  name: "unverified code (study family 6a6626ea), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xcaed49b77ad08345fba620a10ca4e4915a9c6f56"
  project: unidentified-73022f15
  name: "unverified code (study family 9a77591e), 1 of 11 addresses running it"
  upgradeable: "no"
- address: "0xc3f546ea8a2cbe7b8754505c95c05f81fcdf2c34"
  project: unidentified-3ee896ec
  name: "CryptantCrabPrimordialMinter (study family 44b02ce2), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x41340a82e1ad69248cb1e51e88a1597e5f837dc4"
  project: unidentified-8d10ddca
  name: "unverified code (study family 180011a8)"
  upgradeable: "no"
  value_usd: 1805
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x7f6f3012373b4fc7c33812402a880407eeac317c"
  project: unidentified-05959ad1
  name: "LuckVegas (study family a0ab4c69), 1 of 11 addresses running it"
  upgradeable: "no"
- address: "0xbce0c70a10d374f0fcda6d37274915f6a8134286"
  project: unidentified-ee019bee
  name: "MintManager (study family 40efce4e)"
  upgradeable: "no"
  value_usd: 1805
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x023cb563593da062848dd3460c0b72203d3e24a5"
  project: unidentified-3816a52e
  name: "ClaimManager (study family b76323f6)"
  upgradeable: "no"
  value_usd: 1805
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x1d27654f4fd673021ef78b686baf80fa7753b0b8"
  project: unidentified-ca64548b
  name: "unverified code (study family 9aa45da2)"
  upgradeable: "no"
  value_usd: 1805
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x3f15d92b2caaaacd865249ed0ff7aa413063ca41"
  project: unidentified-91582cb9
  name: "unverified code (study family 83f56cf2), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xb7d3f81e857692d13e9d63b232a90f4a1793189e"
  project: unidentified-1304f1b9
  name: "Identity (study family 69199e45), 1 of 127 addresses running it"
  upgradeable: "no"
- address: "0x128f4fbde99e0628d822f5082c164c82d9516171"
  project: unidentified-8f352299
  name: "unverified code (study family 51d86b48), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xb1f3a7b816b0681188f54dfa400991b93adf00ed"
  project: unidentified-3cb68a67
  name: "OkuRouter (study family 43086e4d)"
  upgradeable: "no"
  value_usd: 1624
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x808730240f0c7f650ad0fd33cd355ef422df59ce"
  project: unidentified-e2856478
  name: "AutoMinterERC721A (study family 84893169), 1 of 124 addresses running it"
  upgradeable: "no"
- address: "0xbc9fa7391d67fdae5b4b1ed4866c465d12e4127e"
  project: unidentified-f13c450e
  name: "ERC20Vault (study family 37bd711e), 1 of 110 addresses running it"
  upgradeable: "no"
- address: "0x3583f79886aa6fcbd5d2575b3d27311399d447a6"
  project: unidentified-26c95f67
  name: "PushOracleReceiverV2 (study family 2e761ac4), 1 of 14 addresses running it"
  upgradeable: "no"
- address: "0x75eee167d2e5cc675f5b07f95d6a93e7088d6c34"
  project: unidentified-9797674d
  name: "unverified code (study family dda0783b)"
  upgradeable: "no"
  value_usd: 1444
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x450e4e9a267bd941689470a88586bcc81531505b"
  project: unidentified-1457ea13
  name: "SmartFlipToolsPayments (study family a5a6f1b9)"
  upgradeable: "no"
  value_usd: 1444
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x74312363e45dcaba76c59ec49a7aa8a65a67eed3"
  project: unidentified-dc43b25f
  name: "X2Y2_r1 (study family 0181b019), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x5c24d7b4adfa7c6638307ce29bb5790338b9594e"
  project: unidentified-b3c12c95
  name: "CloneableWallet (study family f0b83a6d), 1 of 179 addresses running it"
  upgradeable: "no"
- address: "0x348119a721bf36efd7e2f7886ed3ada120490abe"
  project: unidentified-e2856478
  name: "AutoMinterERC721 (study family 17d3e9ea), 1 of 481 addresses running it"
  upgradeable: "no"
- address: "0xb616cb62c7fdc02d7742a5ba58cd4f9603b8a611"
  project: unidentified-259f872a
  name: "unverified code (study family 5184c14b), 1 of 326 addresses running it"
  upgradeable: "no"
- address: "0x7a956fd329d0c616f2d1dde98bb35694f397df46"
  project: unidentified-f6e22abb
  name: "unverified code (study family 96366355)"
  upgradeable: "no"
  value_usd: 1083
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xfe531ad1b3f4a2fb971eebec315e9da3512485b1"
  project: unidentified-b1d76e79
  name: "unverified code (study family ce93d414)"
  upgradeable: "no"
  value_usd: 1083
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xb6e5f83b3d53d2c1e98d1e9d077def565e9347df"
  project: unidentified-22aa91ce
  name: "CFHelpersVaultTemplatev1 (study family 43f84b41), 1 of 91 addresses running it"
  upgradeable: "no"
- address: "0x2aae699ed04bbbd068f67a5b3c813ebb35f2c9e8"
  project: unidentified-35765f86
  name: "GnosisSafeWithoutProxy (study family 6eb7b21b), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x03acb6b0de1aba3306eb3a5bab0715d6707a774b"
  project: unidentified-274d52fb
  name: "GreyMarket (study family 920e1686)"
  upgradeable: "no"
  value_usd: 1083
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x7f15d6124be1d67584f9f1c306d6aaf0c04a7556"
  project: unidentified-96b795b1
  name: "WrapperLock (study family 197fffef)"
  upgradeable: "no"
  value_usd: 1083
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xa811b6d840f3eed85a2e8b36e4738114bccd5e67"
  project: unidentified-259f872a
  name: "unverified code (study family f90c050c), 1 of 3,864 addresses running it"
  upgradeable: "no"
- address: "0xdf75f7562aa976f96c76bec3942426a247df53d0"
  project: unidentified-8096a343
  name: "UxuySmartLogic (study family 66614fc2), 1 of 624 addresses running it"
  upgradeable: "yes"
- address: "0x5bd129a87533f2902fbd4e68576aa844626b7f59"
  project: unidentified-00000000
  name: "LightAccount (study family 03bf1fb0), 1 of 5,603 addresses running it"
  upgradeable: "yes"
- address: "0x64c3edf7730b55bd55f9181b2f0bc5bf52f23faa"
  project: unidentified-b0403b32
  name: "HybridDeleGator (study family 9a2ecd67), 1 of 123 addresses running it"
  upgradeable: "yes"
- address: "0x6d77496b7c143d183157e8b979e47a0a0180e86b"
  project: unidentified-32f4b63a
  name: "MaskhumanV2 (study family d9019d16)"
  upgradeable: "no"
  value_usd: 902
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xd2489fd449af786ce6a8c5f52042ef239fac8009"
  project: unidentified-7ef1615f
  name: "SinsNode (study family 0290c86f)"
  upgradeable: "no"
  value_usd: 902
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x920bf81087c296d57b4f7f5fcfd96ca71582f066"
  project: unidentified-00d80759
  name: "companyWallet (study family 08e10c23), 1 of 4 addresses running it"
  upgradeable: "yes"
- address: "0x7f44698c7d94ea548f830f156dc71069cc36bc38"
  project: unidentified-36274414
  name: "Sedition (study family 0d335599), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x75c671a40307826749b840269d085578ff756414"
  project: unidentified-43fd37b3
  name: "GnosisSafeL2 (study family 0775fe28), 1 of 651 addresses running it"
  upgradeable: "yes"
- address: "0xc7c216d955ead4214866179f20b32d9f7a588525"
  project: unidentified-ff61f755
  name: "unverified code (study family 1fd4b291), 1 of 22 addresses running it"
  upgradeable: "no"
- address: "0xbe634b030feaab661300667eaf82510a3a025413"
  project: unidentified-39f86ece
  name: "OneSig (study family 3b53e508), 1 of 23 addresses running it"
  upgradeable: "no"
- address: "0x896cb15542a50e084cb01138211daa110b1fe8f2"
  project: unidentified-46bd6f80
  name: "unverified code (study family 28693709), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x2593c582b7a24d94ba0056b493fd4048bd99fc3f"
  project: unidentified-7cbb62ea
  name: "Portal (study family 2d092e82), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xb677d6cd6186c98a80f117c5c8ede0994d945d67"
  project: unidentified-b3805fb4
  name: "TokenERC20 (study family d15b20cd), 1 of 1,110 addresses running it"
  upgradeable: "no"
- address: "0x415f5cbc212070719f607d18b620a6f7415dff74"
  project: unidentified-869bdbb2
  name: "FishProxy (study family f35a72f7), 1 of 531 addresses running it"
  upgradeable: "no"
- address: "0x45d4ad700e1c1e961e55b4b5363c3c571435bc7d"
  project: unidentified-07d3bda4
  name: "AyniStaking (study family 0d2e482a), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xb94eb74361285c281fe84a18fd1d1c9f287c6e37"
  project: unidentified-14eb5516
  name: "RemoteEVMBridge (study family 40fccdcf), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x26206bfdee32128739f08aa12f57505a3a4ccaaf"
  project: unidentified-4cb8a913
  name: "MultiBridge (study family 99787abb), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x3d651d1aea4aeff06de41436b2ea03daf2d457a6"
  project: unidentified-6f378c17
  name: "HNTRMembership (study family a71d8701)"
  upgradeable: "no"
  value_usd: 541
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x25ef4d7f1d2706808d67a7ecf577062b055afd4e"
  project: unidentified-ed919818
  name: "GalleryTwentySeven (study family 0be44ec8)"
  upgradeable: "no"
  value_usd: 541
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xb78509ea22143e0753054478d67e2d765903da82"
  project: unidentified-cb895965
  name: "unverified code (study family e01ef43f), 1 of 188 addresses running it"
  upgradeable: "no"
- address: "0x3384abd4c63810188e07524d86ff15fcef99010d"
  project: unidentified-f25c4207
  name: "BloctoAccountCloneableWallet (study family 03a06f8e), 1 of 219 addresses running it"
  upgradeable: "yes"
- address: "0x1671556e9e1d563d3a2795a31923de12e33b2274"
  project: unidentified-43c12d4e
  name: "unverified code (study family 8d7f2089), 1 of 1,300 addresses running it"
  upgradeable: "no"
- address: "0xfe4a23bbe27be16955f4d8599c73bac88ef647d1"
  project: unidentified-81ee2b6b
  name: "DirectAnyLauncher (study family 95d7ec16)"
  upgradeable: "no"
  value_usd: 361
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xb5bf8df8c116f35a02c7f348fc25c75abd2ace8b"
  project: unidentified-a12db9f8
  name: "MintableOwnableToken (study family 2527beca), 1 of 1,979 addresses running it"
  upgradeable: "no"
- address: "0xbce70f484b4312a14c71d8285a50260aeac4bb7c"
  project: unidentified-ee4a068d
  name: "unverified code (study family 0e9fa910), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xee43082f843abbe99117588c5b2924c0a1af3a82"
  project: unidentified-953615dd
  name: "TokenRedeemer (study family 4c626a29)"
  upgradeable: "no"
  value_usd: 361
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xc420f778d85cab30eedd314af965dd68541e275b"
  project: unidentified-7172ec3d
  name: "ChainFundedPool (study family 6b86a9fd), 1 of 5 addresses running it"
  upgradeable: "yes"
- address: "0x91ac260980952332226c7eba90a7945f7b3570be"
  project: unidentified-dc0e057b
  name: "ManagedAccount (study family d4855157), 1 of 504 addresses running it"
  upgradeable: "no"
- address: "0x20f6ee51340adeed01a59b0e65cb3703f3dc860c"
  project: unidentified-9f2efccb
  name: "DexAggregator (study family bb70c1b7)"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x8b1f6cb5d062aa2ce8d581942bbb960420d875ba"
  project: unidentified-e07e8567
  name: "CandidePaymaster07 (study family 348afe82)"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xac12a5324cd7514b72cb10b95b3877bd570a75c0"
  project: unidentified-8c9328a6
  name: "unverified code (study family a223192a), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x5299eacba73379598e0fea93046d00c711461403"
  project: unidentified-fed0095d
  name: "unverified code (study family 20d6a666)"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x0e49f213201cce625295f8b04c02aed6b0138b7a"
  project: unidentified-250d3e00
  name: "unverified code (study family c1609274), 1 of 3 addresses running it"
  upgradeable: "yes"
- address: "0x6e369754595662379611e0dfb405950e33756e2a"
  project: unidentified-58dc7bf9
  name: "unverified code (study family 7c496870)"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x38caf0349864babad8cc8a672418b9b15806b6d9"
  project: unidentified-4be0ddfe
  name: "unverified code (study family ae23ffa6), 1 of 134 addresses running it"
  upgradeable: "no"
- address: "0xdf97e5f22f7f1f457bc08600ea365b65b6b39bdb"
  project: unidentified-c4e5bb48
  name: "unverified code (study family 903c0ac4), 1 of 6 addresses running it"
  upgradeable: "no"
- address: "0xcf70e67a2c160f87d46792a868945bf2c0123ddf"
  project: unidentified-a0581576
  name: "unverified code (study family 8c8161f5), 1 of 16 addresses running it"
  upgradeable: "no"
- address: "0xc91807c59b354437eae0de32f153c06665cd2270"
  project: unidentified-00004e2c
  name: "DepositWithdrawVault (study family 302b95f0)"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x477a911f76c44a5d3e5e692c59945263f61426c4"
  project: unidentified-1df665c9
  name: "TokenPortal (study family f9d07893), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xf3dd84c3b47c16d2258e9fec6296885974f1a448"
  project: unidentified-bfebdc2d
  name: "TapBridge (study family a012abc0)"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xa53bbf092ab7ea0a6ffb8aa5a9f59c9396b0455c"
  project: unidentified-b25fe9d3
  name: "unverified code (study family c25e286c), 1 of 42 addresses running it"
  upgradeable: "yes"
- address: "0x8ecb522a1d48676a1f0080b9e575660f5e7657ec"
  project: unidentified-5c0644ea
  name: "unverified code (study family 371cc97b), 1 of 35 addresses running it"
  upgradeable: "no"
- address: "0x9cc1aa0adb9809d37eecf28a1668324bed761c12"
  project: unidentified-fb62f7af
  name: "unverified code (study family 0b3dd834)"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x3c037014486aaa5d509c5171d413c8b3022f1072"
  project: unidentified-e7d134c2
  name: "CloversController (study family 6abab024)"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xb04ded6cd23934f78cb8dedd948a533d0531d66a"
  project: unidentified-e4bc3d25
  name: "Exchange (study family d8f1012f)"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x22c6b2e3084ccbf980b472a18aa892c200b63dbc"
  project: unidentified-7499aa42
  name: "AyniNFTClaim (study family 047168cb), 1 of 3 addresses running it"
  upgradeable: "yes"
- address: "0x25cd94a4ac4211f8b91298f5a066d70d27f5c1ef"
  project: unidentified-85f36452
  name: "FastPay (study family b7ca2977), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xad21686d1820db593aa1ac6c15f5a336e8e4b961"
  project: unidentified-b744f96b
  name: "USDCEscrow (study family e0801786)"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x44480f176110ee31b0837856fba41ce3a04d6f9e"
  project: unidentified-1e9e1815
  name: "unverified code (study family 2cc64692), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xc4f4bb4cd9c2098dd1eb11e0055fd0e212c967fc"
  project: unidentified-7213d217
  name: "unverified code (study family aa3d98eb), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xccb1138d047627552dd9f6c91b1218c10c933907"
  project: unidentified-d5a70ff9
  name: "unverified code (study family 11a35382), 1 of 4 addresses running it"
  upgradeable: "no"
- address: "0xeef8101bc63cdacd1a3e6ad8f333f7eda87d532b"
  project: unidentified-1bf41851
  name: "CnpEvolution (study family 6d26238f)"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xaca282fbda8eabdcc156d6dbb6e63937823fc212"
  project: unidentified-8d5d41ae
  name: "Referral (study family c68796d5)"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x899b09fa62ba30e334adbf4a7d57b9dcfcd32617"
  project: unidentified-3e365fe4
  name: "unverified code (study family 8222b273), 1 of 7 addresses running it"
  upgradeable: "no"
- address: "0x6bc9b0b0eb4490e0e1c3aa7b6bbf5aaf7303453c"
  project: unidentified-11157988
  name: "unverified code (study family 305bb568), 1 of 4 addresses running it"
  upgradeable: "yes"
- address: "0xa19f4c1d4cae249b4a6cd903ad8584736bbfd733"
  project: unidentified-ae2c4511
  name: "unverified code (study family 66a9129c)"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xdd4013a64ca6b99cf4c976f76d85c1946134496e"
  project: unidentified-a8863bf1
  name: "PhysicalClaim (study family 1da95492)"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x20ea3be58cfe5c687a4bfd1ede068d8c456517af"
  project: unidentified-0bdbb2a7
  name: "unverified code (study family 1df8bf4f), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xb50ecdd02a79be4b8f8d1f1c0377d6c91f08862b"
  project: unidentified-236aa31d
  name: "WalletGardenNFT (study family b6a311a0), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x1779b8777b7c411428ccdfadc1ceae18f3ab4187"
  project: unidentified-e49acc3b
  name: "unverified code (study family 711f854e), 1 of 124 addresses running it, 121 by 7702 delegation"
  upgradeable: "no"
- address: "0x40056d114c87689e1724d8d19f3c75e2fff0e6ce"
  project: unidentified-fc4039b8
  name: "unverified code (study family b41f3aa0), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xd62c71447bb5a0fda331a76e12456562842a329e"
  project: unidentified-7da00f9b
  name: "AccountV3Upgradable (study family 7e80ede1), 1 of 13,269 addresses running it"
  upgradeable: "yes"
- address: "0xf8ab2dbe6c43bf1a856471182290f91d621ba76d"
  project: unidentified-b2dea0e2
  name: "UniversalBridgeV1 (study family 65ae3625), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xb58b14bdefaf3cea66407e9ed15bb74c60aebefb"
  project: unidentified-69dcd681
  name: "RaribleUserToken (study family 793b4fe6), 1 of 2,803 addresses running it"
  upgradeable: "no"
- address: "0xb82a0803df982412daee9d82826395e3f0bed1a2"
  project: unidentified-8183f851
  name: "AccessControlledOffchainAggregator (study family d46e2adf), 1 of 193 addresses running it"
  upgradeable: "no"
- address: "0x9a1cb9ee1abcd70a761724192b6b32c251f2f3aa"
  project: unidentified-92cef6f8
  name: "unverified code (study family 142b21d4), 1 of 3,737 addresses running it"
  upgradeable: "yes"
- address: "0x696ada227454bd0bf38e8605ab7bacc02a293605"
  project: unidentified-291034d4
  name: "unverified code (study family ec3ce6ee)"
  upgradeable: "no"
- address: "0xd7a5c6b52756e795f680b0f7e0c2f21281dde6ef"
  project: unidentified-b0d22387
  name: "unverified code (study family f68aaf20)"
  upgradeable: "no"
- address: "0xb88349328bcb41219b15e7d56c9d64692c8356af"
  project: unidentified-b5d4cc7f
  name: "DualAggregator (study family 7b414d74), 1 of 46 addresses running it"
  upgradeable: "no"
- address: "0x7bce1a3297604cafa601f05799b6ed98e8c01b7f"
  project: unidentified-062f05cd
  name: "CommitteeVerifier (study family 1e15fd25)"
  upgradeable: "no"
- address: "0xa4f070629058767c0d5d70465082ec1b7d9ca5a4"
  project: unidentified-ddf32240
  name: "VerifyingPaymaster (study family 1ec730b0), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x4777a6b3a9a889abfd4c7666bdd2a7ab633293be"
  project: unidentified-00004e2c
  name: "unverified code (study family 73fa29c3)"
  upgradeable: "no"
- address: "0xef435b99c2108d0309211d0cc05b70d202c0b5df"
  project: unidentified-00004e2c
  name: "unverified code (study family 998eed11)"
  upgradeable: "no"
- address: "0xda7afeed021eafc1c1af9c362de477dad0396b81"
  project: unidentified-81d58d3c
  name: "PrioUpdateRegistry (study family 78db403a)"
  upgradeable: "no"
- address: "0x183e9b247521fe2149516c98ce2dd0e2367bb6fa"
  project: unidentified-690f4e2f
  name: "UTBFeeManager (study family a905692e), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xc1f46adf341145369eee9fbe0d84fa1cb0c24706"
  project: unidentified-4253578c
  name: "NumeraiStaking (study family c04de267), 1 of 6 addresses running it"
  upgradeable: "yes"
- address: "0x7f432c32231d1fbb397528431d6714acb4754795"
  project: unidentified-4f0cf2a1
  name: "unverified code (study family 1bf370eb), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xa818428ed2f3f949bdc71b8a15bdd7b5d27ce938"
  project: unidentified-85a73f63
  name: "HCAOwnerAndSessionValidator (study family cb5932cd)"
  upgradeable: "no"
- address: "0xb259d0267cdf1852714f6a3037551fd577170cf0"
  project: unidentified-0ef551ea
  name: "FullSignedUW (study family d2877a99)"
  upgradeable: "no"
- address: "0xcce758d01775d6c9fc822a4e33b70f019dbdc963"
  project: unidentified-7c533deb
  name: "unverified code (study family 777461c4), 1 of 5 addresses running it"
  upgradeable: "no"
- address: "0x00000072f286204bb934ed49d8969e86f7dec7b1"
  project: unidentified-635eeedc
  name: "unverified code (study family 8dfa88b7)"
  upgradeable: "no"
- address: "0x17fdafb44736e7a88348fc560d8b738da73d8f68"
  project: unidentified-97f7d409
  name: "unverified code (study family 2703a38d)"
  upgradeable: "no"
- address: "0x2bd45d293f1e3b790f2923fb36782170b559d84c"
  project: unidentified-4f0cf2a1
  name: "unverified code (study family 694a1849), 1 of 3 addresses running it"
  upgradeable: "yes"
- address: "0x26f77c6455518caf29a5414004c5a2ef441228b1"
  project: unidentified-2315baef
  name: "SponsorPaymaster (study family 299f7893), 1 of 4 addresses running it"
  upgradeable: "yes"
- address: "0xd9ab5096a832b9ce79914329daee236f8eea0390"
  project: unidentified-6ed6d3fa
  name: "ECDSAValidator (study family af33ec96), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0xb0999914b3de1be58ef2416af09bd2e7f8aad03c"
  project: unidentified-3f9f2bea
  name: "unverified code (study family 2f07018c), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x7a776fe72e75fece6ecab154e823b30f28653caa"
  project: unidentified-4f0cf2a1
  name: "VerifyingPaymaster (study family 2e49e392)"
  upgradeable: "yes"
- address: "0xd1e6aae6c1d4c050c0763591150c5a90295c2fbe"
  project: unidentified-9678dd58
  name: "ValueETHUSD (study family 12bb3918), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x7123c40f7ac521a30c45f5c5401cd819e2aee79b"
  project: unidentified-02321d71
  name: "SwapSettlementModule (study family 5c238124)"
  upgradeable: "no"
- address: "0x4789dc31aa8d22298275292f95b57dd8526c7955"
  project: unidentified-fa2aba6e
  name: "RiskRateOracle (study family 3d372378), 1 of 5 addresses running it"
  upgradeable: "no"
- address: "0xb717f3b4c4d3aa40da1ee9c92f3d5e291bfd8d05"
  project: unidentified-7e99c772
  name: "SponsorPaymaster (study family cd78360b), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x1644a664b8d97957da6a8284d626c9aab93cb486"
  project: unidentified-576f0a8a
  name: "unverified code (study family 7b468ad5), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xb8e21d2ad752c7fd562b95f84d61a377d7b1411a"
  project: unidentified-588598e7
  name: "ValueWBTCUSD (study family 7f5c8077), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x75ec277bf8d9a70ef6097d575d5aafd9a1cbc4ec"
  project: unidentified-ee552967
  name: "EscrowFactoryV7 (study family 4c9d3344)"
  upgradeable: "no"
- address: "0x578f916aaa85a52b846a0cd3b84387be3a98d829"
  project: unidentified-1fccc097
  name: "PendlePTLooper (study family ffb57bdb), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x9a1d0059f5534e7a6c6c4dae390ebd3a731bd7dc"
  project: unidentified-67985b1f
  name: "ModuleTrades (study family 6da31684), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xec2c96e75b09e29b66bf2ee5c37fa749ef9aa7c7"
  project: unidentified-256b7064
  name: "ECDSAExecutor (study family 3f3f348c)"
  upgradeable: "no"
- address: "0xd37a60e8c36e802d2e1a6321832ee85556beeb76"
  project: unidentified-5c19826e
  name: "CommitStore (study family 4a59acac), 1 of 13 addresses running it"
  upgradeable: "no"
- address: "0x7a37037c085584ee7dad50cd6a4ade1181c65b3b"
  project: unidentified-cd98a330
  name: "unverified code (study family 0a213e84), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xa6571b73489d4ebfa269a107208665df7c80aef5"
  project: unidentified-4c34c668
  name: "BridgeController (study family 87ffbc11), 1 of 3 addresses running it"
  upgradeable: "yes"
- address: "0x677ef7152a6c620d37fbf57d4882ec2bc53e2ccd"
  project: unidentified-9ec3f0d7
  name: "NitroVerifier (study family 3efe18a9), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x6a6f069e2a08c2468e7724ab3250cdbfba14d4ff"
  project: unidentified-6892bef4
  name: "ECDSASigner (study family c26ace57)"
  upgradeable: "no"
- address: "0x00000000000099de0bf6fa90deb851e2a2df7d83"
  project: unidentified-ddf32240
  name: "SingleSignerValidationModule (study family 1bdef898)"
  upgradeable: "no"
- address: "0x366d88f03b8ef34eb49f32a927ff6e1609f694f2"
  project: unidentified-6e3dadca
  name: "ECDSAPPSOracle (study family d482402e), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xed89244160cfe273800b58b1b534031699dfeeee"
  project: unidentified-20e9695f
  name: "WeightedECDSAValidator (study family cb2cbf36)"
  upgradeable: "no"
- address: "0x000000000004598d17aad017bf0734a364c5588b"
  project: unidentified-61e8ac0a
  name: "unverified code (study family 084bc264), 1 of 4 addresses running it"
  upgradeable: "yes"
- address: "0x1b41ffaca6450020e0e6c757db91fcbef327dce1"
  project: unidentified-5854e29a
  name: "BronPaymaster (study family b2279754), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x7529abff0f8665a4e7fcd532d0f528090435d10e"
  project: unidentified-0ef551ea
  name: "UnifiedForwarderAccount (study family aa9b73be)"
  upgradeable: "no"
- address: "0xdd233d8721f92c80fc29fe683dbd9e326207a6bf"
  project: unidentified-ffeaea32
  name: "unverified code (study family 8791bc2c), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xc69f43741d379ce93bdaac9b5135ea3e697df1f8"
  project: unidentified-f5c4c75b
  name: "BlobstreamO (study family db7d5d36), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x9835a4e15fd34f8d3217beffaa011fab9b8bea0b"
  project: unidentified-1fccc097
  name: "PendlePTLooper (study family 15182103), 1 of 4 addresses running it"
  upgradeable: "no"
- address: "0x36a8e347006e151f4a0e9559fea239439611777a"
  project: unidentified-e7b84d88
  name: "RemoteDomainDepositor (study family f68e5698), 1 of 6 addresses running it"
  upgradeable: "yes"
- address: "0xc04d73ee602179bc426791babe058aea406da3cf"
  project: unidentified-aa5293b0
  name: "unverified code (study family 5924eda1), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x5fa03555f186e53a644405817e1beac894bd6562"
  project: unidentified-7794de82
  name: "PangeaDVN (study family 4182627a)"
  upgradeable: "no"
- address: "0x5d0ae8cbad6a88eda0fbe5e916992f9aed417bbb"
  project: unidentified-4cb3fd42
  name: "unverified code (study family 4c7e2b30)"
  upgradeable: "no"
- address: "0x1ad8acbdb3670c72645b54a7df55dcf70bce057a"
  project: unidentified-0a09517f
  name: "unverified code (study family 4d0fff06)"
  upgradeable: "no"
- address: "0x9a1d00899099d06fe50fb31f03db5345c45abb36"
  project: unidentified-67985b1f
  name: "ModuleTradesAdvanced (study family d4da0da5), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xb62061b8c48afc6c978579eb4f466987123e3621"
  project: unidentified-f4a522f1
  name: "unverified code (study family bd6c999d), 1 of 49 addresses running it"
  upgradeable: "no"
- address: "0x4443e09a19c5fda8d09f797821b322358e5bcf90"
  project: unidentified-cdb6d29a
  name: "NotusPaymaster (study family dd38d053), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xb9635eaa3c29c4678c5bd80d0b93e2a09432291f"
  project: unidentified-01667877
  name: "RampImplementation (study family 8ef474dd), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xc47e67676551bb74cabe6f1925172a8035955b82"
  project: unidentified-32106420
  name: "EcdsaOwnershipRegistryModule (study family 2635f88c), 1 of 5 addresses running it"
  upgradeable: "no"
- address: "0xb59e7df2b636a66bff03ca554407b920bb150109"
  project: unidentified-61e8ac0a
  name: "unverified code (study family 8af55ca1), 1 of 4 addresses running it"
  upgradeable: "no"
- address: "0x2c1543b147626f887faea0b6514593e22521d7ee"
  project: unidentified-6298551d
  name: "TransferModule (study family b0278dd4), 1 of 6 addresses running it"
  upgradeable: "no"
- address: "0xb7b84725790b8a179bb310aa51548ed2e6872af7"
  project: unidentified-00000000
  name: "LightAccount (study family e6aa3f41), 1 of 4 addresses running it"
  upgradeable: "yes"
- address: "0xbc81091a00e98a7fcb969102d921e85bfb4bfcbd"
  project: unidentified-2999ed8c
  name: "ChronicleVAO_Galaxy_CLO_Consumer_1 (study family 9aea754c), 1 of 28 addresses running it"
  upgradeable: "no"
- address: "0x2d001ccffda16e6f1b59f94dfa1788e6ee8d8e7e"
  project: unidentified-00ada725
  name: "MultisigCommitter (study family 77dfae21), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x5a2eb0cdb4aa8253924a488a77edfd24bb64407f"
  project: unidentified-e5df05a8
  name: "Relay (study family 9711cae7), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x0b57b7333c43fe900d17a81bddc67c88c825afd6"
  project: unidentified-d04aa8cb
  name: "TokenContract (study family e3ba62c4), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x4555ac13d7338d9e671584c1d118c06b2a3c88ed"
  project: unidentified-6be3a4af
  name: "unverified code (study family 10bf4481), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xf7f9638cb444d65e5a40bf5ff98ebe4ff319f04e"
  project: unidentified-f2f1acbe
  name: "MinterGateway (study family 1a178b24)"
  upgradeable: "no"
- address: "0x183e3171eef801ce2a29fd48b3b21188f241875d"
  project: unidentified-6e3dadca
  name: "SuperVaultExecutor (study family 244c0ef7), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xca944fb73fa5191969014ded9bb075381d59c7de"
  project: unidentified-e07e8567
  name: "CandidePaymaster09V4 (study family 736919c6)"
  upgradeable: "no"
- address: "0x9d58779365b067d5d3fcc6e92d237acd06f1e6a1"
  project: unidentified-46cf7ddb
  name: "ArgentModule (study family 47e24077), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xa57016b153287da52b869f2a64dd73e7b97af6c6"
  project: unidentified-13461862
  name: "PriceFeedOracle (study family ef35b1fc), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x6a9f3126c0ea3eeb9cbe53205175c9673da6565f"
  project: unidentified-7794de82
  name: "PangeaDVNV3 (study family 50900e48)"
  upgradeable: "no"
- address: "0x251e4b432d5c69d8f4d3d31aae4ae4f3c4816fc7"
  project: unidentified-f3d63166
  name: "RelayGatewayDepository (study family 57b6d95a), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0xbbfa3b50b6b0fc26d5af0abcf5afb830fe897288"
  project: unidentified-9627dd57
  name: "StaticMessageIdMultisigIsm (study family f69c873c), 1 of 28 addresses running it"
  upgradeable: "no"
- address: "0xa7c14010afa616fa23a2bb0a94d76dd57dde644d"
  project: unidentified-16447da0
  name: "DBridge (study family 9e7d4318)"
  upgradeable: "no"
- address: "0x9d89e5b4ec94640eac8c00c84b545983479a63be"
  project: unidentified-fa2aba6e
  name: "unverified code (study family 3bb13d48)"
  upgradeable: "no"
- address: "0x0000000002d3cc5642a748b6783f32c032616e03"
  project: unidentified-a63dea08
  name: "unverified code (study family 87be266f)"
  upgradeable: "no"
- address: "0x27d7b391e493bcc7fd81d317b0ac2e013f0b1ad6"
  project: unidentified-d8e68084
  name: "MultiSigGenVerifier (study family d2f0a7be), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x1ac760d5c985c635c18a3e5d9c5685f1ef2a721e"
  project: unidentified-ceaf908c
  name: "ECDSAProofSystem (study family f8e7017d), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x3954a5bf350cb660a681152d7a30eb2124041f99"
  project: unidentified-960f1e31
  name: "unverified code (study family f0fe62ff), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x6b5815467da09daa7dc83db21c9239d98bb487b5"
  project: unidentified-229f53ef
  name: "Keeper (study family 194db6ac)"
  upgradeable: "no"
- address: "0xc10f8792926dc85feded347c245d41be7818cdf0"
  project: unidentified-60745fca
  name: "unverified code (study family baac5e89), 1 of 3 addresses running it"
  upgradeable: "yes"
- address: "0xb7baaef3e72736d1fef03eea8ec3224c649e1d1b"
  project: unidentified-b138018e
  name: "GnosisSafe (study family c09ca34d), 1 of 73 addresses running it"
  upgradeable: "no"
- address: "0xb3619b30910df374965a6169082d2597a1cf15dc"
  project: unidentified-5897f415
  name: "SwapExecutor (study family 63bab776)"
  upgradeable: "no"
- address: "0x3bdb857afe9b51d8916d80240d2ade40d4d3f2f9"
  project: unidentified-f938994b
  name: "FluidkeyEarnModule (study family 871a1f6d), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x2e787629c3b7545271240a87197108823ce8303b"
  project: unidentified-07b589f0
  name: "Api3ServerV1OevExtension (study family 8b15f0af)"
  upgradeable: "no"
- address: "0x47f00fd16ccfdcec08617373f524a5e68ac8a29a"
  project: unidentified-72d8a690
  name: "unverified code (study family b5fb6a6d), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x07696dcab55e62cfef953666b29fe1970518cb00"
  project: unidentified-4c34c668
  name: "WPearl (study family 7652d82c), 1 of 3 addresses running it"
  upgradeable: "yes"
- address: "0x4f8916cc1d9307364f0343e0a1e9c658b79daa46"
  project: unidentified-abc50aee
  name: "unverified code (study family c82dcacd), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xbf3e143e5076963a6dac3a522e5093ad88fbeae7"
  project: unidentified-3e365fe4
  name: "unverified code (study family aad2124d), 1 of 10 addresses running it"
  upgradeable: "no"
- address: "0xa8151918eac3818deb713d3dbbb7930329fe86ed"
  project: unidentified-ff745652
  name: "unverified code (study family cee24e73)"
  upgradeable: "no"
- address: "0x81e5a46e60d5bc92b2f98f13a31793a51cdc56c3"
  project: unidentified-0d508862
  name: "unverified code (study family 9d9cc3c7), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x54a6543e748221aac10b43a5eb2964ad018ccc23"
  project: unidentified-0568f611
  name: "unverified code (study family 8eb5ea64)"
  upgradeable: "no"
- address: "0x9d8888ba6c653f315606bfb494eb679fd02000cb"
  project: unidentified-72452734
  name: "unverified code (study family 59850547), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xb5fceefbb04ca0cdef87038be5a91f296229b54a"
  project: unidentified-187d19ec
  name: "OxideAccount (study family a6101ad8), 1 of 948 addresses running it"
  upgradeable: "no"
- address: "0x4773878c6cb3a1318a8c8d97edab3cc38320e9ce"
  project: unidentified-1905ff9f
  name: "unverified code (study family f0c8961c), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xdd17d9216bd1683c8076b13b045bd1331aadccd7"
  project: unidentified-7b99bed4
  name: "unverified code (study family f187596f)"
  upgradeable: "no"
- address: "0x0bdde46b81c093b02a35591ade8d277cc68b6d69"
  project: unidentified-bfc73017
  name: "AccessControlledOffchainAggregator (study family 6e45cb03), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x6338afee3ff32599bff2ce3d8b7604bd6d6a41a7"
  project: unidentified-595caa1c
  name: "unverified code (study family 79ad262f)"
  upgradeable: "no"
- address: "0x2483da3a338895199e5e538530213157e931bf06"
  project: unidentified-00000000
  name: "OwnableValidator (study family 642f8215)"
  upgradeable: "no"
- address: "0x26fdb12dfc046c116a5077fdaa3fd6c9e9ded091"
  project: unidentified-f378708b
  name: "MultisigCommitter (study family 1eb7dd57), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x7408b27aa182380224563c3ba337cfa35f3231b9"
  project: unidentified-c423173d
  name: "unverified code (study family 84eb3b59), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xdf6e2411c519bfd959472e0b90ab334d742f57af"
  project: unidentified-536e5c49
  name: "CFHelpersUsersv1 (study family 9adb5132)"
  upgradeable: "no"
- address: "0x0e6ff904f764c0b5b84a9c3c1780e08dff84deb9"
  project: unidentified-93620a4a
  name: "PriceAttestorV3 (study family 69098ed0)"
  upgradeable: "no"
- address: "0xc4f2704273598d51a0ec76a31c12553ec8f5a891"
  project: unidentified-d990770e
  name: "DelegationContract (study family 49d1545a), 1 of 19 addresses running it"
  upgradeable: "no"
- address: "0x39bb5d491e98a44d1bfe8047a737a81e296a63e0"
  project: unidentified-70d78ec7
  name: "DepositSecurityModule (study family 692bdfa4)"
  upgradeable: "no"
- address: "0xc52058b11cfc12c16388e88c92c422cbab2f6e64"
  project: unidentified-473b686d
  name: "Aethra (study family aea273e1)"
  upgradeable: "no"
- address: "0x0000000000001f3c39d61698ab21131a12134454"
  project: unidentified-000000cc
  name: "Stage1Module (study family b4730e85)"
  upgradeable: "yes"
- address: "0xaae30a4d51cf44c18f1353acbbb9ae36df8edfcc"
  project: unidentified-a326184c
  name: "unverified code (study family 2bc26042)"
  upgradeable: "no"
- address: "0x5f522c617bbab774027e11d417360b768e06f494"
  project: unidentified-edd03127
  name: "unverified code (study family 7bbb6c79), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xb933a1d21354102d32c32db2c62a62e416512631"
  project: unidentified-dcbb1a5d
  name: "unverified code (study family bbacd88f), 1 of 22 addresses running it"
  upgradeable: "no"
- address: "0xb84b0084895cd1d51152eda88ffc9459fec55a88"
  project: unidentified-b7b9bf98
  name: "unverified code (study family 2306de05), 1 of 40 addresses running it"
  upgradeable: "no"
- address: "0xb5ebdec6da02119dd7beb4782c181261f8bfecc2"
  project: unidentified-224d7291
  name: "Controller (study family 3f066d34), 1 of 9 addresses running it"
  upgradeable: "no"
- address: "0xd0ae8ef93b7da4eabb32ec4d81b7a501dca04d4c"
  project: unidentified-00000000
  name: "Stage2Module (study family d03a8717)"
  upgradeable: "yes"
- address: "0x232628c79982337ad0e576759d218640b382f230"
  project: unidentified-fbc171f3
  name: "unverified code (study family 73455ae2), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x3bdb21ea8793acbf0ce18954865b7572694d037f"
  project: unidentified-2eaecb11
  name: "KSZapRouterV3 (study family 2f9f33a9), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x92728968236cf856503ac4a15c21ebf1d7539fe7"
  project: unidentified-9629e0fc
  name: "unverified code (study family ca78cca5), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xbdd3e80c97d443314bee0af74c903863f7dc319d"
  project: unidentified-d469ca61
  name: "unverified code (study family e4a7dee1), 1 of 22 addresses running it"
  upgradeable: "yes"
- address: "0xbf5ee7c3713850e458a6d4b810dcf45d6080bd7e"
  project: unidentified-abc50aee
  name: "unverified code (study family 8c4245bf), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x1b7f2c3fa0f887212130292dfa0e93a5f44bc0cc"
  project: unidentified-2c55db92
  name: "unverified code (study family 3d1b5fd0)"
  upgradeable: "no"
- address: "0x000ecfa392ecdefee6e2a5c095d39b7a32f1e000"
  project: unidentified-fcd300aa
  name: "Cosigner (study family d9e20be0)"
  upgradeable: "no"
- address: "0x980df04b4e8c40bc728198f998459700d97f083b"
  project: unidentified-8f352299
  name: "unverified code (study family e510516c), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xd99571cc34bfc41bf469a8f346db4d32d7e957e1"
  project: unidentified-8f352299
  name: "unverified code (study family 0f5943ea), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xc3ba43ff0a8e006c2aca1d9fd6443540b51372fa"
  project: unidentified-055a33be
  name: "unverified code (study family 5ef3a079), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0xc93803e782df6b94d757623b3116a969ce5fb936"
  project: unidentified-8b421243
  name: "ScatterAggregatorRouter (study family 359de153), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x536384fcd25b576265b6775f383d5ac408ff9db7"
  project: unidentified-c66efbf0
  name: "WalletFactory (study family 51b88864), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x94182a281bab6f36077c77a9fd8f6fc63bfa0492"
  project: unidentified-42bfd161
  name: "unverified code (study family 188f6ffa), 1 of 27 addresses running it, 21 by 7702 delegation"
  upgradeable: "no"
- address: "0xc6d27843426f31ef378d0c2101384519811933cf"
  project: unidentified-06fb521c
  name: "unverified code (study family 7ef4cef6), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xc4c189fd5792197994c4acd9fad5244b6a16e056"
  project: unidentified-f11f92a8
  name: "unverified code (study family 632c9e7b), 1 of 8 addresses running it"
  upgradeable: "yes"
- address: "0x36f4aa64673568782461bf03c75462f8ef0a1b76"
  project: unidentified-e07e8567
  name: "CandidePaymaster06 (study family 3db3066f)"
  upgradeable: "no"
- address: "0x3f1603602e870bd4c6953333b35ec988eede4f9c"
  project: unidentified-6dc8ba58
  name: "unverified code (study family a74b8130), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x08ac2e0e625f0a2e5dd750325156512c01600457"
  project: unidentified-6dc8ba58
  name: "unverified code (study family f151381a), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xc295c2cf67c2f9811f9815db5cf0f99e0312dcf6"
  project: unidentified-8c5ee3f9
  name: "NameRegistry (study family 301e717e), 1 of 5 addresses running it"
  upgradeable: "no"
- address: "0x4a92a3456818004ab8872b41beabdb6dfe9210c9"
  project: unidentified-78a6c322
  name: "VestingEarndrop (study family 8ac28c94), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x259144fba30da78075d07ecbbc3e36de5c6fd992"
  project: unidentified-1e78a417
  name: "unverified code (study family 7c63fe06), 1 of 5 addresses running it"
  upgradeable: "no"
- address: "0xa3d5699a389c1be44468add10134cb33f726d391"
  project: unidentified-bb64404a
  name: "MultiSignWallet (study family 4b7590f0)"
  upgradeable: "no"
- address: "0x134ccaaa4f1e4552ec8aecb9e4a2360ddcf8df76"
  project: unidentified-9604d542
  name: "SyrupRouter (study family 2f946ab3), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0xd400341aefed0bc75176714cfde82e8bdaa2d3b8"
  project: unidentified-074105fd
  name: "HarvestingEIP1271 (study family c9134c07), 1 of 5 addresses running it"
  upgradeable: "no"
- address: "0xc368f93e2a3b24e4f41e26166613ee530d921b56"
  project: unidentified-34ef1b70
  name: "WithdrawalExecutionPolicy (study family 1fc641d4), 1 of 4 addresses running it"
  upgradeable: "no"
- address: "0x14413419452aaf089762a0c5e95ed2a13bbc488c"
  project: unidentified-ac171e58
  name: "EthCrossChainManager (study family 6d1aa67a), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x544e62df13d6273e64b06ac1afd925c8dcbc6569"
  project: unidentified-bed8c03e
  name: "FeeCollector (study family 2984d07e)"
  upgradeable: "no"
- address: "0xb46b4773c5f53ff941533f5dfeffd0713f5f9f8e"
  project: unidentified-22bc97cf
  name: "SuperValidator (study family 38be5710), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x846d961b1627212e070e0ece95f2251e73b53239"
  project: unidentified-4675fc3d
  name: "EIP712TypedDataSafeModule (study family 7d342935), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x0cb5ceb2dbe1d42ae9791b1cdb4f11fde9e71675"
  project: unidentified-6fa60bd5
  name: "ScatterOfferer (study family d3ab88a8), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x46c2227c1d9fdeb7b3b85b71872c188314f65bdf"
  project: unidentified-f0174e32
  name: "PowerStaker (study family a57bf528), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xa24bd06230f3f54e5bf266ae7a41750ee3b789fa"
  project: unidentified-461c5f59
  name: "RoleBasedECDSAValidator (study family df95fadc)"
  upgradeable: "no"
- address: "0x3d3158ea79a204aadb379f6a77fd3fd8fad5bc03"
  project: unidentified-069ed98e
  name: "unverified code (study family bd076bbd), 1 of 3 addresses running it"
  upgradeable: "yes"
- address: "0xd828370f26b30652a675b23057b50e9701cb07ae"
  project: unidentified-6f8e121d
  name: "ChronicleVAO_Superstate_USTB_Consumer_2 (study family d55ca758), 1 of 7 addresses running it"
  upgradeable: "no"
- address: "0xb75bb4c7aaacfa400758bf024c2ffefe17c9cbe3"
  project: unidentified-b75ce308
  name: "unverified code (study family dda85e24), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0xd9d78c80b70bb432caf6920f8a0575cd7079a396"
  project: unidentified-e45a21b0
  name: "unverified code (study family 975cebe0), 1 of 4 addresses running it"
  upgradeable: "no"
- address: "0x57c758fb1d7da84154aecefa30f328f93fa0ae7c"
  project: unidentified-f38b2019
  name: "unverified code (study family 9599ff7c)"
  upgradeable: "yes"
- address: "0x144f02c15a8cb2e01d35bf2af8e9efd96401e44b"
  project: unidentified-97751373
  name: "WeightedValidator (study family 3bf60790)"
  upgradeable: "no"
- address: "0xc4c70d6f74437d153416f7fb68173e4cd2235e39"
  project: unidentified-112ffdd7
  name: "unverified code (study family 9797f0d5), 1 of 33 addresses running it"
  upgradeable: "no"
- address: "0xbf25d8d83dfc1fdd094c58b177e8d3ff37cb833b"
  project: unidentified-10adc2b3
  name: "unverified code (study family 67db7ba0), 1 of 12 addresses running it"
  upgradeable: "no"
- address: "0xf58cf2421e39a572f821cddf08bdf6dce673dc74"
  project: unidentified-deadfa8b
  name: "unverified code (study family 88d5bb0c), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xfc01b10dba138f791a569108bfe82efb70930e17"
  project: unidentified-f8d37142
  name: "unverified code (study family 6906f881)"
  upgradeable: "no"
- address: "0x2fe3f04b0f2a0d0243b1d770e955c97307c91b0c"
  project: unidentified-88f2d303
  name: "unverified code (study family b99fe828)"
  upgradeable: "no"
- address: "0xb781595ba4dd7ae937a7b7890fae10662be653ee"
  project: unidentified-81cc2586
  name: "ApeBond (study family 62e00230), 1 of 14 addresses running it"
  upgradeable: "no"
- address: "0x940a87f18ceb24e58c447851cbb3a57c6fa8d52c"
  project: unidentified-f79db8d4
  name: "WormholeOracle (study family e8cc81e6)"
  upgradeable: "no"
- address: "0xe146ffb504582f604438d1d6fc48091b5c7767ae"
  project: unidentified-e7e93a96
  name: "unverified code (study family 13e997df)"
  upgradeable: "no"
- address: "0xdf6889b8e4a74c5bdedf7fff0bbd1f4c552e6a10"
  project: unidentified-afd2aaa7
  name: "unverified code (study family c4732d7b)"
  upgradeable: "no"
- address: "0xd579979fe7478f13ee85a792023fe050b2df0140"
  project: unidentified-c9485145
  name: "unverified code (study family 66bc1c85), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xec4ddc3b27fffc9593ee63085cbf05bffab6be37"
  project: unidentified-2a1888d8
  name: "RegistrationController (study family 0bf92a13)"
  upgradeable: "no"
- address: "0x51032c841e823bb487c33c9f1773b18c8d0e5209"
  project: unidentified-b25fe9d3
  name: "OpenfortPaymasterV2 (study family d0897312)"
  upgradeable: "no"
- address: "0x9b10e2b35c094cdc9df89275cb3bbee7744c1ea7"
  project: unidentified-58317a6c
  name: "TriVectorOracle (study family ac11e899)"
  upgradeable: "no"
- address: "0xd3b7a89b4c0ffe71952f6a0ea72551f635b86d5f"
  project: unidentified-ffc69066
  name: "TWAPSettlementModule (study family 3d24a1ab)"
  upgradeable: "no"
- address: "0xa2bd91fb0c8258134706629edf7464c14bab8b66"
  project: unidentified-d8e68084
  name: "unverified code (study family 000ab5ae)"
  upgradeable: "no"
- address: "0xbe9cc5cdbb6ae6a4378e2795099c5e951d3ec5e4"
  project: unidentified-69c2222c
  name: "PendleCrossChainSwapHub (study family 9792d0ac), 1 of 6 addresses running it"
  upgradeable: "no"
- address: "0x33d136c1501709ee020d7a8ca56d44dacb15e227"
  project: unidentified-b7a42ba7
  name: "ForeignAMB (study family f8c3d295), 1 of 13 addresses running it"
  upgradeable: "yes"
- address: "0x3db744585f892dc77750b2f4376b4fc1dd66d510"
  project: unidentified-d0623f1f
  name: "unverified code (study family 6bf5d9e2), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xbfc88418abb3054c16c21ba404387751a114847d"
  project: unidentified-15371272
  name: "BridgeAssist (study family 1783b96d), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x0ea25bf9f313344d422b513e1af679484338518e"
  project: unidentified-09fd4f60
  name: "unverified code (study family 6d5ae85c)"
  upgradeable: "no"
- address: "0x34b30f4d1a4ad909cd58610e5c9a552b5c9b28d3"
  project: unidentified-effa6a23
  name: "unverified code (study family f878b0df)"
  upgradeable: "no"
- address: "0xd66ddc6484f93422016b4c2c33baf711bcfb0ab4"
  project: unidentified-494f5d0e
  name: "unverified code (study family fe5a12cb), 1 of 13 addresses running it"
  upgradeable: "no"
- address: "0x52c1f22b812f4b9a02d9f3b81e8c49bc081e3035"
  project: unidentified-0a5ca576
  name: "ECDSAValidator (study family 371a0e74), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x0000000049c4957e14395934c8952cb00575f9c2"
  project: unidentified-a0cc9b25
  name: "unverified code (study family 286a540f), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x021890b9b6c1e77f5ea7fb8639336ff3a17849dd"
  project: unidentified-ff59d0ed
  name: "unverified code (study family d68ca87a), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xb942ec944a432ef9985cee4abc6996ad151a79e0"
  project: unidentified-7c533deb
  name: "MixinPaymaster (study family 178bb3f8), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0xd275f00ee101d0d498b26e7ff73a66443f898f18"
  project: unidentified-69696977
  name: "unverified code (study family f16ce629), 1 of 4 addresses running it"
  upgradeable: "yes"
- address: "0xd274e8f34e948cd15b212d797f92918ab0b70b65"
  project: unidentified-536e5c49
  name: "CFHelpersPoliciesv1 (study family e667897b)"
  upgradeable: "no"
- address: "0x0bbc02ef7ce79a820b7edda8d5d409ae7615e636"
  project: unidentified-52300928
  name: "Crosschain (study family abfe2067), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x15477048dc9182717a560465ee9547cd11d51c39"
  project: unidentified-53c9970b
  name: "unverified code (study family 79f3f054), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xff9dbc41559ad67c8d885ac22e41b5a528f3962c"
  project: unidentified-0a5ca576
  name: "unverified code (study family b56869f1), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x3ba17675f0d319c89d70722f6eb07790df0b254b"
  project: unidentified-cb8bc192
  name: "unverified code (study family 405f8e89), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x8e07aca75614646c0a05b151e561b424d6b8b104"
  project: unidentified-f38b2019
  name: "unverified code (study family ea0ecd62)"
  upgradeable: "yes"
- address: "0x43dcd6586e6209ee7235a21bdc4aa301e5bc44e8"
  project: unidentified-00043880
  name: "LiquoriceSettlement (study family 879d988d)"
  upgradeable: "no"
- address: "0x31c628a15792331e1ec8ac3bbb5fbb56ad9cca02"
  project: unidentified-557f20ac
  name: "Exchange (study family 6550c9d1), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xbea215446c7c3fa61c682d794f741a6a345312a3"
  project: unidentified-c4108e3d
  name: "BurrHibernationRewards (study family d21c0d59)"
  upgradeable: "no"
- address: "0xb9c6d2fd321a899de14e71ae8abeb0da0fef5f68"
  project: unidentified-f68d7fad
  name: "unverified code (study family 845c32cd), 1 of 23 addresses running it"
  upgradeable: "no"
- address: "0x31d058b5e02c8b01c749e6844d86cdd3f2962cd7"
  project: unidentified-594f7b54
  name: "unverified code (study family c574d71f)"
  upgradeable: "no"
- address: "0xe81421f761e60a75078412957cbebb634cbaf4fe"
  project: unidentified-71901a9a
  name: "unverified code (study family 1927bf93)"
  upgradeable: "no"
- address: "0xab3d96237328385f8988166c6d7788a63f48dda6"
  project: unidentified-8d91b670
  name: "AssetVault (study family 14989406), 1 of 4 addresses running it"
  upgradeable: "yes"
- address: "0x3cd98baef599923813f72169d3b0f24567b13639"
  project: unidentified-2a25bb44
  name: "MultiBridge (study family 2966dcfd), 1 of 3 addresses running it"
  upgradeable: "yes"
- address: "0x61c9ce5b50d66778c9c8f4de41211f7cc1d7e9c3"
  project: unidentified-ee552967
  name: "UniswapEscrowFactoryV4 (study family b303cc5e)"
  upgradeable: "no"
- address: "0x45f626e2a4d63232677c96b163ac46e20514a915"
  project: unidentified-2a1888d8
  name: "RegistrationController (study family becee036)"
  upgradeable: "no"
- address: "0x10980d8f4542ebee4ef972fd909eee3d472294e9"
  project: unidentified-2272ecf4
  name: "VaultHandlerV8Upgradable (study family b8b7116a), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xbd0d691d2784975d7c3cd9f12e37c7b3fb2027c2"
  project: unidentified-b93ee131
  name: "MultichainWalletMaster (study family 77ac903a), 1 of 26 addresses running it"
  upgradeable: "no"
- address: "0x5a2a792ede6eb1f0eccd5f6b7ee5a8aaae64e08c"
  project: unidentified-5755e82d
  name: "HeroesOfValdir (study family c311c642)"
  upgradeable: "no"
- address: "0xaafefb601445063f27cf4cb621201b84d6fdaadd"
  project: unidentified-b22dde7c
  name: "unverified code (study family 64e7994d), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xc8291c0603c8d06ae3c56be036dedc57c3b57169"
  project: unidentified-ded76bed
  name: "unverified code (study family 5988adb8), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xa846d040904ddc177ccba22b8af633175e115944"
  project: unidentified-7434abae
  name: "FillableSwapSettlementModule (study family 1d66f6be)"
  upgradeable: "no"
- address: "0x7aeaea29f54d26ceb4eac4dd498ccf66109b6790"
  project: unidentified-ee552967
  name: "UniswapEscrowFactoryV4 (study family 3407b968)"
  upgradeable: "no"
- address: "0x3a4f41dac6000a59b79669b9356b5eb71bf4cc59"
  project: unidentified-804016c3
  name: "PreCollateralizedMinter (study family 07eb9e5f)"
  upgradeable: "no"
- address: "0xddf2a6644c1750e63eea74619c3b76535cbf5e0c"
  project: unidentified-facc1ca3
  name: "FamilySpace (study family ded38fe6), 1 of 24 addresses running it"
  upgradeable: "no"
- address: "0xf9a3762563e34c77778e834b276ca2854688f9fe"
  project: unidentified-00000055
  name: "LightAccount (study family 17712074), 1 of 20 addresses running it"
  upgradeable: "yes"
- address: "0x51abf9debee58abaa2bd3019a5bdb5610f5fecf8"
  project: unidentified-23d0c169
  name: "BuySettlementModule (study family 154ad0cf)"
  upgradeable: "no"
- address: "0xb9b4690c0b5d93c7256964c8f07a4e5ff7f7ea5c"
  project: unidentified-0a7ada4d
  name: "unverified code (study family 087720fa), 1 of 7 addresses running it"
  upgradeable: "no"
- address: "0xc4d0cf567f699252d4f2ab0aa918332933f21347"
  project: unidentified-e7504d43
  name: "Withdraw (study family 4b665faf), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0xc7a2e29b7ef4543a3e7c50057d83bedfcde2fb0c"
  project: unidentified-39c27a0e
  name: "unverified code (study family 1aea8b1d), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xd730df52f2575da8560d02d84fe39fbf518f5497"
  project: unidentified-7032aa32
  name: "unverified code (study family 5fdbad86), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x24a600b827a41e29be4b332829b5eb47ff282e92"
  project: unidentified-a81705c8
  name: "WadzActionAuthorizer (study family 33c55697), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xbbef2b8f30f72373f41238efba9c245ccae88245"
  project: unidentified-3dfb4aea
  name: "PolygonDataCommittee (study family 75848bf0), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x5e1eb8d4eb8d8389b46afc631e2bebaacf3befd7"
  project: unidentified-276392e2
  name: "EigenYieldsVaultSettlement (study family ec18ed5e)"
  upgradeable: "no"
- address: "0xbabfb4936976573a9494a396ea078e6ecd926574"
  project: unidentified-059de1da
  name: "V3DutchOrderReactor (study family 60cd266c), 1 of 6 addresses running it"
  upgradeable: "no"
- address: "0x09becf6e5e297825d19aa14ed6081a03524532d7"
  project: unidentified-a5ab0683
  name: "AvantMintingV2 (study family 2f1e8d93)"
  upgradeable: "no"
- address: "0xc884a55146d8aac61982bab13bb505dbc7b8d3cc"
  project: unidentified-c4e5bb48
  name: "unverified code (study family 9869e9cf), 1 of 11 addresses running it"
  upgradeable: "no"
- address: "0x7e203c8c568cfbcad41658a51ec07c0af4af5735"
  project: unidentified-e887e007
  name: "AtumModule (study family 802415fa)"
  upgradeable: "no"
- address: "0xc927cd5aa9cbd163603da5030889860c72586669"
  project: unidentified-16061168
  name: "unverified code (study family f4e97349), 1 of 4 addresses running it"
  upgradeable: "yes"
- address: "0xce0000007b008f50d762d155002600004cd6c647"
  project: unidentified-ddf32240
  name: "MultiOwnerPlugin (study family c54eb441)"
  upgradeable: "no"
- address: "0x151c89a5584a91d1b8369596dd4d671e2d53f833"
  project: unidentified-5a95b0c7
  name: "unverified code (study family ca55658f)"
  upgradeable: "no"
- address: "0xadae7b70ede8b76d9fca39c2ca8901d131a07613"
  project: unidentified-7b15eb64
  name: "unverified code (study family 51f8423e)"
  upgradeable: "no"
- address: "0xd219ff97329ee70a2eb5baaef293ccd10a05809a"
  project: unidentified-b8605297
  name: "PolygonDataCommittee (study family 92df77b5), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xc9c3ecf83dc9c863c01ae95073fd958493f04c8f"
  project: unidentified-7f139b3d
  name: "VestaPaymentGateway (study family a764035a)"
  upgradeable: "no"
- address: "0xf7f27c29e60fe6325bef8da7f93250353d2e3294"
  project: unidentified-b42d7bd7
  name: "unverified code (study family 2d0d8462)"
  upgradeable: "no"
- address: "0xbc48fd45aaaf6549293056606397d351a100b222"
  project: unidentified-ba768286
  name: "BOOAEth (study family 7a77508b)"
  upgradeable: "no"
- address: "0xc08233547177a2a5617da4e6e52d99b78b856c63"
  project: unidentified-06831d47
  name: "unverified code (study family 5a40c6c9)"
  upgradeable: "no"
- address: "0x077e2dedb33a40acbffd5a6d29bc88dbe8ca7a86"
  project: unidentified-0c1d2b14
  name: "SingletonPaymasterV8 (study family 4872c60c), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0xd156ffb54871f4562744d6be5d6321b5bffca3b6"
  project: unidentified-3a2de028
  name: "CashmereCCTP (study family b18f08ea)"
  upgradeable: "no"
- address: "0xa43e6f75ee006411f79ac1c84120606c2330de82"
  project: unidentified-047f606f
  name: "Intake (study family a0071b91)"
  upgradeable: "no"
- address: "0xac49c7ee67b6afe5f9693089e4b8f171d0432605"
  project: unidentified-c8923ee8
  name: "HyperlogueCreator (study family e9541423), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x95053e3c177d99bccaa314d668b9b080f4a6de79"
  project: unidentified-ffa6002f
  name: "unverified code (study family 496323aa), 1 of 5 addresses running it"
  upgradeable: "no"
- address: "0xa868b94b286e69c4c21801672e4e19ff3ce95192"
  project: unidentified-978e9247
  name: "unverified code (study family 283463d1), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xd6fceb7328a6b24a2a17d3640d3875df636ffc3d"
  project: unidentified-030bfe50
  name: "PeniwalletStorage (study family 715345c3)"
  upgradeable: "no"
- address: "0xc9c9e9bec3a3064c88c2c01ab859d16d63f99d35"
  project: unidentified-6f373fd4
  name: "unverified code (study family 99ba4233)"
  upgradeable: "no"
- address: "0xff3f6d14df43c112ab98834ee1f82083e07c26bf"
  project: unidentified-ddd85fb0
  name: "QuickAccManager (study family 9f9e4b18)"
  upgradeable: "no"
- address: "0xeadfd738c602f79fb191f4bee297f944979829d4"
  project: unidentified-ee552967
  name: "UniswapV4EscrowFactoryV4 (study family 5e44ca38)"
  upgradeable: "no"
- address: "0xfbaa0e362212e909fe3ff011a7d65077c1971942"
  project: unidentified-539e318a
  name: "FinalBosu (study family 67374e12)"
  upgradeable: "no"
- address: "0xc3a5d5023b9f7b0aebe9dd49b9b4d02c6877061f"
  project: unidentified-f1d47329
  name: "unverified code (study family 49484bc4), 1 of 4 addresses running it"
  upgradeable: "no"
- address: "0x2331495f0212017449029574f02048eb721e3fe1"
  project: unidentified-069994c2
  name: "unverified code (study family 5ea60fae)"
  upgradeable: "no"
- address: "0x8e351774b73248e98adc053bf30a5e7d5c2105c7"
  project: unidentified-647dd07e
  name: "unverified code (study family d3736c65), 1 of 5 addresses running it"
  upgradeable: "no"
- address: "0x9cb9ae7480ee98a41373100d4304194043f02c9d"
  project: unidentified-b2480df5
  name: "unverified code (study family 0ac33ab0), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x56a0743392255227c7bc3e5a7aee874dab3b5f84"
  project: unidentified-37f70cd0
  name: "unverified code (study family 0001ca40)"
  upgradeable: "no"
- address: "0xf09ec70775ca2c99d8f407ffdf331a69b14e96f6"
  project: unidentified-680fc6eb
  name: "GMTokenManager (study family ce342c5a)"
  upgradeable: "no"
- address: "0xce8635e5d0a0d2e9b9b8919d3a5d82ee390cc3d6"
  project: unidentified-5c73da88
  name: "CFHelpersVaultTemplatev1_1 (study family ea6ede94), 1 of 33 addresses running it"
  upgradeable: "no"
- address: "0x46e431c9329604abd68cbc254be4f1afd710dcb9"
  project: unidentified-14703c56
  name: "unverified code (study family d0278be1)"
  upgradeable: "no"
- address: "0xbfb1bd17d068d1d395942392b8c02853c6bafdc8"
  project: unidentified-ad942435
  name: "ThreeFAdapter (study family e251f7ac), 1 of 5 addresses running it"
  upgradeable: "yes"
- address: "0x0e79ebdb832c7ea54a1b65ac5ff2b75d449747ca"
  project: unidentified-ee552967
  name: "UniswapV4EscrowFactoryV4 (study family 3bd9b488)"
  upgradeable: "no"
- address: "0x590fcffc3f53d325f57f74a93f75123c308ffaf1"
  project: unidentified-085b59cc
  name: "HyperlogueCreator (study family 6b87b85d)"
  upgradeable: "yes"
- address: "0xb8e873e23215a672722f397006bd0330718d16da"
  project: unidentified-63ac0dec
  name: "unverified code (study family 551dac2b)"
  upgradeable: "no"
- address: "0x3e70b0695ecd987c7c2a52ca1edc0979355a0d18"
  project: unidentified-b19f00e0
  name: "unverified code (study family 22c5c0f2)"
  upgradeable: "no"
- address: "0xc9dfef6702fcafde7d6aae08967a0848a5248bdb"
  project: unidentified-78df53dc
  name: "unverified code (study family ba6eaa6b), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x29ac686ac80eef807cce19bf1b7bb3b5b1b95b8e"
  project: unidentified-40e2cb0d
  name: "unverified code (study family 3df0c5bd), 1 of 15 addresses running it"
  upgradeable: "no"
- address: "0xbc9ea21892737cee8f25b1531d60354204706e9a"
  project: unidentified-eba68abe
  name: "unverified code (study family 2f03c691), 1 of 8 addresses running it"
  upgradeable: "no"
- address: "0x78024226f0f962a981d914be5b7a093cb064b6e9"
  project: unidentified-6c56f636
  name: "unverified code (study family 7bb7c36b), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x0000b1c0790e5a28293276c320d2b95d651dbad6"
  project: unidentified-a63dea08
  name: "unverified code (study family c4d9507a)"
  upgradeable: "no"
- address: "0x79dd22579112d8a5f7347c5ed7e609e60da713c5"
  project: unidentified-9e0bce7e
  name: "Rewards (study family 21388f4b)"
  upgradeable: "no"
- address: "0xcd462fb01e6b8333f77a19765ede930adf95e3e8"
  project: unidentified-5912d976
  name: "EthXFileInstanceSale (study family abe471de)"
  upgradeable: "no"
- address: "0xbbb1d3428dabb4fe4420187b6ae8dc93f2da2c0c"
  project: unidentified-920694bc
  name: "unverified code (study family 21cf7931)"
  upgradeable: "no"
- address: "0xc3d9617a081b675213665ed8247b99c1c1e64ed5"
  project: unidentified-6c56f636
  name: "unverified code (study family 09cdf436)"
  upgradeable: "no"
- address: "0x75d2be781770befa5e939ddd9df657fd52fe1385"
  project: unidentified-83ac5578
  name: "unverified code (study family 420659cd)"
  upgradeable: "no"
- address: "0xc7b7df036b34fb562e625b00417bdd16155ae186"
  project: unidentified-039a8df2
  name: "unverified code (study family d7038f27)"
  upgradeable: "no"
- address: "0xfc5be8ab7e408b850be734a9a97068b42704b9f1"
  project: unidentified-435e0af2
  name: "unverified code (study family 7efb22c1), 1 of 74 addresses running it, 73 by 7702 delegation"
  upgradeable: "no"
- address: "0xb6c220d5fb70ff88a7490d47bc4c2000f74de78c"
  project: unidentified-cd912afc
  name: "SalesOrderUpgradeable (study family 35a259bf), 1 of 6 addresses running it"
  upgradeable: "yes"
- address: "0xca9bb3fcdfb455962ee284a189cbfc2262970b39"
  project: unidentified-22bc97cf
  name: "SuperDestinationValidator (study family 7818b7e5), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x8490c7b1f0a404d32cda9f9e5665c8bda66d0469"
  project: unidentified-38cead40
  name: "unverified code (study family a43a8ac9), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x818f0804fbb93f4279529fd7474db6d7a65167db"
  project: unidentified-2c06f933
  name: "unverified code (study family 9c7d22d2), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xd7e4b46977bd52e84cabaa3bf0b2846b151a1e58"
  project: unidentified-a036e0f9
  name: "Invest (study family 4925d1f2)"
  upgradeable: "no"
- address: "0x036b00de5a611700acc12f00f1f40000001f0000"
  project: unidentified-8635f269
  name: "GrailsOtcSignedZone (study family 9da7b769)"
  upgradeable: "no"
- address: "0xbd4be1a7e2e262e8aa86a9094c84fb6171f41cfd"
  project: unidentified-d793f919
  name: "unverified code (study family 7acdab52)"
  upgradeable: "no"
- address: "0x300777d580e4c6823e533defdcada788413cfee3"
  project: unidentified-a2b7f2cc
  name: "unverified code (study family f123f01c), 1 of 4 addresses running it"
  upgradeable: "yes"
- address: "0xb5bc367e74815b073582dbd7f264009f9f3dee12"
  project: unidentified-4582ad5e
  name: "unverified code (study family 04f08e7d), 1 of 987 addresses running it"
  upgradeable: "no"
- address: "0x113573c68c0b04b889672f76c9c50cd47fac1a13"
  project: unidentified-6c773cbe
  name: "unverified code (study family 6303564a), 1 of 8 addresses running it"
  upgradeable: "no"
- address: "0xc9a87d3df7e0ba741372558b13fc45770810af39"
  project: unidentified-38cead40
  name: "unverified code (study family 4ccd0c60), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xa6a02d654c9a941eb95e8a925655903ad77bbe6b"
  project: unidentified-0cdae5da
  name: "unverified code (study family 2dae6051), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x14c88431d0f0d487c807c3c2e1c0ad09e8349f6b"
  project: unidentified-408444aa
  name: "SubscriptionPayments (study family d1709b23), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xcf24efe3bad6bae085c7402c29859023c3a7844a"
  project: unidentified-1d3a571f
  name: "InvoiceFactoryEVM (study family 397c9128), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x1e169a45fc37359e7b57d98402b23c10131546e3"
  project: unidentified-9634c2c4
  name: "unverified code (study family 2c23649e), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x7b6801086c33c2b904194f2f11513eef03aabcd7"
  project: unidentified-65aa5c9d
  name: "unverified code (study family 714de433)"
  upgradeable: "no"
- address: "0x093702d70e62bc90075ad363c6979ae2d246080c"
  project: unidentified-2e72e8ad
  name: "VaultLifecycleModule (study family 915d1a5c)"
  upgradeable: "no"
- address: "0xfbf8f1a5e00034762d928f46d438b947f5d4065d"
  project: unidentified-8b55a6f5
  name: "MainModule (study family c14b7e38)"
  upgradeable: "yes"
- address: "0xd5463f233c18ba404a79fe9da202d086b5599fe7"
  project: unidentified-630ff637
  name: "unverified code (study family 14f212be), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x60b4c271eed9f03f2a37796ca97387f87e97ce89"
  project: unidentified-91295b3a
  name: "unverified code (study family ba7aa6a4), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xa62ffeb083b390b9e1ee1e8203f2a00556c48728"
  project: unidentified-a0f4af03
  name: "unverified code (study family 9d1ba6b3)"
  upgradeable: "no"
- address: "0xb967b04c26d83e7f082190c84a789c30aeaf49da"
  project: unidentified-40e2cb0d
  name: "unverified code (study family 334f3bcb), 1 of 48 addresses running it"
  upgradeable: "no"
- address: "0xbaf948657daf4315098644c9b7c880146174ff4e"
  project: unidentified-7cef0380
  name: "ClaimIssuer (study family 31b465e6), 1 of 38 addresses running it"
  upgradeable: "no"
- address: "0xb5896b4673a8755642094aabdc6d07de4e15a187"
  project: unidentified-3be7e2ee
  name: "DepositWallet (study family e1bb42c4), 1 of 33 addresses running it"
  upgradeable: "yes"
- address: "0xbc51cb0b9b21972312450fd1b4c0451735dff0b4"
  project: unidentified-e9772cbb
  name: "unverified code (study family a4be5529), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xc437df90b37c1db6657339e31bfe54627f0e7181"
  project: unidentified-a1e8d001
  name: "CrossChainBridge_R2 (study family b9479c0d), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xc9d591e91869d49dabf0021681e043e9b52f3ac4"
  project: unidentified-ff03410d
  name: "OracleShrine (study family e6d354ae)"
  upgradeable: "no"
- address: "0x169d7775c8ae7994b26ba19600b080221c764104"
  project: unidentified-a005e790
  name: "Paymaster (study family cf708802)"
  upgradeable: "no"
- address: "0x00893a26a3b95920bd6a84130c9d69231f2241ae"
  project: unidentified-39c6f6e1
  name: "Router (study family ed040479)"
  upgradeable: "no"
- address: "0x316dffe3df247ef6a334854d9a92d841a7e329fd"
  project: unidentified-250d3e00
  name: "unverified code (study family f737bf9d), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xce29c86c9e559eaa10fb824a75566445095d417c"
  project: unidentified-00043880
  name: "unverified code (study family 3cb6d0db), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x625d78dbdf9d7cfcc9499bbe847fd29b1a8b7ed5"
  project: unidentified-9bbbbb3c
  name: "unverified code (study family 0d310fa1), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xd901298e6855a909831d76ddfe69f8dcf2bd3828"
  project: unidentified-333a985a
  name: "SignatureRewardDistributor (study family 90e8756f), 1 of 6 addresses running it"
  upgradeable: "yes"
- address: "0x0eeb3852f67e6391454df07c7ebda9b30da444e3"
  project: unidentified-d2d63724
  name: "HelloBridge (study family 1a318bf5), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0xc39e0302eef1cd9ec05fd9eb27188a6eec1d26fd"
  project: unidentified-8fa9aa69
  name: "ERC2612Verifier (study family 11635914), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xb58d4162f9d8312f152aeac17af12b62fd235673"
  project: unidentified-250d3e00
  name: "unverified code (study family e69b8951), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x1eca6b8e7a5da3bb39b89188737f35e4fbfc7b2e"
  project: unidentified-46c416ff
  name: "YugeSale (study family edc84cf4), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x974a1f9fa9c59874ea77221c9e52bb5a5ed03429"
  project: unidentified-a03c9213
  name: "unverified code (study family 34e5e0d9), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x65c37f752d14d58cb3cee9ad1524db2bccc19498"
  project: unidentified-14a770b0
  name: "BSKTUtils (study family e9e526a4), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x26bf6056cba643a1f0c66d9f464e6d23a4d91930"
  project: unidentified-a710cee5
  name: "unverified code (study family 06fc8f0f), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x384e6308d797c02db0db1fb85789e26dc94719cb"
  project: unidentified-2e249a00
  name: "Escrow (study family b67fbc10)"
  upgradeable: "no"
- address: "0x055429e4bf607818d2a61e0dcfac4bbd7e0bfec0"
  project: unidentified-b815db86
  name: "unverified code (study family c00cac63)"
  upgradeable: "no"
- address: "0xe75c693cc30c7d1422679a00bb242d5336431e59"
  project: unidentified-c0b5503c
  name: "unverified code (study family e2e5b092)"
  upgradeable: "no"
- address: "0xb609107eee817501756dd30f61d39d7d4966bce7"
  project: unidentified-73d4c8ef
  name: "PriceVerifier (study family fc734dec)"
  upgradeable: "no"
- address: "0x9aff1446396c7a8a0d3dbff71443c673439572b1"
  project: unidentified-88f2d303
  name: "unverified code (study family c9377078)"
  upgradeable: "no"
- address: "0x0edd02144f8b8a2726555afda445323b11044602"
  project: unidentified-4337004e
  name: "unverified code (study family 3d4c8b21)"
  upgradeable: "no"
- address: "0x6fad52bb2fbdff41755492c64b08317ff53213a2"
  project: unidentified-be493ff2
  name: "SignedNavYieldMinter (study family 65863636)"
  upgradeable: "no"
- address: "0x7687da958f1b8799b8b0df39d2f2d729cf3d85bf"
  project: unidentified-d8e68084
  name: "unverified code (study family 07fd9dc8)"
  upgradeable: "no"
- address: "0x14006b5a8c3a56f676bb87ec7f1b42972042fd87"
  project: unidentified-2d66029e
  name: "unverified code (study family b4e0320f)"
  upgradeable: "no"
- address: "0x604ae9c5eea41a136d8fcfdf038f6440a20a6f4c"
  project: unidentified-be493ff2
  name: "EmUsdSolverRouter (study family fd0206c0)"
  upgradeable: "no"
- address: "0x3d5537092e25ebdac13c5f00a272853c945ac79b"
  project: unidentified-02f086db
  name: "unverified code (study family 96b4826c)"
  upgradeable: "no"
- address: "0xd0f4de81e0b6e9d8018f2b8bf7f05da0edbc963f"
  project: unidentified-68f31dc3
  name: "FundFactory (study family 13e334da)"
  upgradeable: "no"
- address: "0xa4fd0dd242f7e51caee98de78d93d5b717b542e3"
  project: unidentified-a3ac8958
  name: "SingletonPaymasterV7 (study family a6775737), 1 of 10 addresses running it"
  upgradeable: "no"
- address: "0x5d006d947fa48d7324eee1030644209f29e239e4"
  project: unidentified-b1a8814a
  name: "MacininoVault (study family 6582c294)"
  upgradeable: "no"
- address: "0xe052c9cfe22b5974dc821cba907f1daac7979c94"
  project: unidentified-6ae493db
  name: "Sponsored7702 (study family 81d3efe3), 1 of 3 addresses running it, 1 by 7702 delegation"
  upgradeable: "no"
- address: "0x72107883a6df4d59662329e14f2365ba853d82c8"
  project: unidentified-e1fda67d
  name: "unverified code (study family c477c387), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xc51552d3b5766f6117dbf0a38530f3630c92f273"
  project: unidentified-9731bdf1
  name: "NAVOracle (study family fc9cf0ba), 1 of 11 addresses running it"
  upgradeable: "yes"
- address: "0xba53172b83e62c9fc0157ec96223d397776a1a31"
  project: unidentified-d469ca61
  name: "unverified code (study family 935c64b6), 1 of 8 addresses running it"
  upgradeable: "yes"
- address: "0xd743d5b09ecea67880c4bc326a18a874bafe246e"
  project: unidentified-16e47d27
  name: "unverified code (study family f80da18b), 1 of 4 addresses running it"
  upgradeable: "yes"
- address: "0x1c9327f8698860e4b57e1c4ffa43b292bc6a930b"
  project: unidentified-2ffaceef
  name: "AlephVaultSettlement (study family b4328a40), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x10a0847c2d170008ddca7c3a688124f493630032"
  project: unidentified-c66efbf0
  name: "RelayerManager (study family cde46488), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x789d89ebb2a882343044830a9d4d072737ffec92"
  project: unidentified-0c000f9e
  name: "Quote (study family 10b3162e), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xaeefb95c15330aefa29ef71a432e9f9cf9b3bd0c"
  project: unidentified-05950b4e
  name: "unverified code (study family a5bd9ea8), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x626784d4af1e8d37b13b42f5fd2c9959c1711952"
  project: unidentified-ba5b79ed
  name: "unverified code (study family 90ce4a9e), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x3564eb5e11033d43ffff8edb58dd3d23eb932f00"
  project: unidentified-75076617
  name: "unverified code (study family e745191a), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x88e7dc15e79fb8531c7a853843d14c634b6c5bca"
  project: unidentified-f7d3b899
  name: "GMIssuerManager (study family e2314373), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x534b95e0780b434026c8a9bfcefa7a9a4df846cc"
  project: unidentified-e366b0ec
  name: "unverified code (study family bb3a9781), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xef371a11e6adb9dc3d333dafcb1ff5afbcb6cdc8"
  project: unidentified-762ba862
  name: "GarbageFriends (study family 92fa1709)"
  upgradeable: "no"
- address: "0xf303dda9244102c7d2e9e0afb7aab7fc179834a2"
  project: unidentified-5c689e1f
  name: "unverified code (study family b52d7b85)"
  upgradeable: "no"
- address: "0x913e4d699a4b6d90185b3388909a0b46929b6a57"
  project: unidentified-289a9f9e
  name: "ArcsSingletonPaymasterV7 (study family d9793eb9)"
  upgradeable: "no"
- address: "0x61576d9ef23514bfe6f080e22ccfff473cf11a1a"
  project: unidentified-5b5e0d40
  name: "unverified code (study family 8b651373)"
  upgradeable: "no"
- address: "0x40908546de1b322f2eb269e64d2ad325bf3b24e0"
  project: unidentified-6e078760
  name: "unverified code (study family e1c93ac3)"
  upgradeable: "no"
- address: "0x20406d87be3dcbb773cf031d2ab86fd6a9fee7bd"
  project: unidentified-20f6ed3e
  name: "unverified code (study family 713b1814)"
  upgradeable: "no"
- address: "0x200d09abf9041d6476b86f5116090415d9059ebf"
  project: unidentified-610d694c
  name: "unverified code (study family 4fbf7658)"
  upgradeable: "no"
- address: "0x54cf68ab8f68813f2a2df20af72d19c44485a0b2"
  project: unidentified-019cf4ee
  name: "unverified code (study family dd06fc1d)"
  upgradeable: "no"
- address: "0x8872c35c53005f5e9bc6515bfadf8834f81414d3"
  project: unidentified-d0f2390b
  name: "OndoPortfolio (study family 082f05f6)"
  upgradeable: "no"
- address: "0x760728c38a987923bf4942dee33dbeb284b77bd0"
  project: unidentified-d0f2390b
  name: "OndoMarket (study family 062fb1d3)"
  upgradeable: "no"
- address: "0x73731dacb1ee5906aa515512fcda2074d690487a"
  project: unidentified-e7699541
  name: "MagpieStargateBridgeV3 (study family fa0e00bd), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xbbe830d5b5377c1bdedd94e87c0fb1cfd45f7555"
  project: unidentified-d009f57a
  name: "LegionTokenDistributor (study family 90288969), 1 of 74 addresses running it"
  upgradeable: "no"
- address: "0xbaea00c4c9bd79f19d71b6a6461c7086f4b4a363"
  project: unidentified-da210d98
  name: "ForeignAMB (study family cfd35726), 1 of 12 addresses running it"
  upgradeable: "yes"
- address: "0x44aadf7d16c96e34d2ba0b4d15eebd4792107bda"
  project: unidentified-42b9c17d
  name: "PhalaClaimer (study family 30ea409d), 1 of 4 addresses running it"
  upgradeable: "yes"
- address: "0xd43a70d54e907b339bf77a31da25d30af4b4c73c"
  project: unidentified-c0b9ea83
  name: "HypernativeGuard (study family 1f6e24ca), 1 of 4 addresses running it"
  upgradeable: "no"
- address: "0x3b1a5da88b7819f40092ba8707a3cd8b9bc5cb56"
  project: unidentified-0c81357a
  name: "GlobalRegistryService (study family f33edf29), 1 of 4 addresses running it"
  upgradeable: "yes"
- address: "0x2cdb0e0ce0ceee4c788f243698694d241df1655d"
  project: unidentified-23b0caa3
  name: "FacetEthscriptionBridgeV6 (study family 34e2135e), 1 of 3 addresses running it"
  upgradeable: "yes"
- address: "0x2b255f240cca3b8581770c7c22dc1314eb3fd744"
  project: unidentified-b8ea9fba
  name: "FeeManager (study family 185db9f3), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0xd83c448854838d4f50b9df1fa1afafb1f5483fee"
  project: unidentified-27cd2563
  name: "WeightedECDSASigner (study family 831d86dd), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x2238f90f51ab021c06cb28bd98f5f1ce04cbdf5c"
  project: unidentified-b096258f
  name: "unverified code (study family eb1d0729), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x44d016b20a0c8f0a3791b3ea10ff09af0ece1dc2"
  project: unidentified-a0783c56
  name: "unverified code (study family f5654fc2), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x5ed753abc1c08668b5f2e706d69dc5db2799a4a6"
  project: unidentified-98634f1c
  name: "BatchSignedERC721OrdersFeature (study family 313953c0), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xd2a50aba1d93569726739808e9f69985ca222d40"
  project: unidentified-5049d580
  name: "MynaWalletAuthorityManager (study family ec3bab3a), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xbf151b7be7208afb5f13040a2308bb84b55f5044"
  project: unidentified-4cfe37d2
  name: "unverified code (study family 0bd524d1), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x2a64caa7f12101f3410a7ef8dde27c0b4bd4eb35"
  project: unidentified-2d66029e
  name: "unverified code (study family 6dfaf498), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x930333dc07495977b3e075b57ee0cf3effd399dd"
  project: unidentified-762ba862
  name: "TestCans (study family c6281a48), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x671df9ed06982b5c572bed6fa8d11d4fd532ef2f"
  project: unidentified-6e078760
  name: "unverified code (study family 97e81932), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xcfc87f6579bac55cefd180165777abaa1847ffbd"
  project: unidentified-de2ae72a
  name: "unverified code (study family d20e435d), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x0b1866692f2c4770c3fed4376090f4daec90c00e"
  project: unidentified-ca9b5e9f
  name: "unverified code (study family b7dc5f9b), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x4237f965b1646d28303f33925f14d8e84c27b46c"
  project: unidentified-c2fc24a8
  name: "GatewayVerifier (study family b4e8682c), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x4dac8619dfc77361a0752faaba24f5df7a82e8f2"
  project: unidentified-58ac18aa
  name: "unverified code (study family 4bd26e0b), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xd77b76a65a19715bdcb5ee223928af2919836a3e"
  project: unidentified-ca11aad3
  name: "Federation (study family 366cdfb1), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x0cd548b851b330a97694a1f107ba8e1a8291cb61"
  project: unidentified-2f8ecf93
  name: "unverified code (study family cf2982ea), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x1ce2b1be96a082b1b1539f80d5d8f82ec06a0f9a"
  project: unidentified-77777777
  name: "BytecodeRepository (study family ce815443), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xbb0b08a9bf9b31185c5b925b1e32baf2d29e1b69"
  project: unidentified-4413140c
  name: "STOFactoryManagedUpgradeable (study family 44610ee6), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x4e2b7cb19fc9ca6b5e46d016e21fc8bcf6173713"
  project: unidentified-417eec5a
  name: "unverified code (study family 8a3acb72)"
  upgradeable: "no"
- address: "0x3343d696e6a70a0c57b196314a7459ed9ac63ff5"
  project: unidentified-289cdd03
  name: "MtxPrivateSaleV2 (study family 467349a4)"
  upgradeable: "no"
- address: "0x7a2d53c6322201e70841e4d3d55b9412a92d115c"
  project: unidentified-4cb3fd42
  name: "unverified code (study family 383a8b02)"
  upgradeable: "no"
- address: "0x9a6b9f8fe863d7ca1977d934ad93f6c729868582"
  project: unidentified-ca9f2178
  name: "ApproveManager (study family b7068a90)"
  upgradeable: "no"
- address: "0xdfa5fb3727e417015d6fefacee0144c85626c667"
  project: unidentified-6cb43188
  name: "ArcadeScores (study family cea38219)"
  upgradeable: "no"
- address: "0x8b0f19b4cf56cac3552d7df1d95da60660695e78"
  project: unidentified-3c6bac35
  name: "LockerRegistrar (study family 9e8b4940)"
  upgradeable: "no"
- address: "0x93746538d4519c809827205bd1c2c7a0e15bd74b"
  project: unidentified-83f53c07
  name: "unverified code (study family 01ecc28c)"
  upgradeable: "no"
- address: "0xb367b1a74c409fc148fb21753b130b65b794dad3"
  project: unidentified-762ba862
  name: "WalkingCans (study family 046c87af)"
  upgradeable: "no"
- address: "0x346d03bef8de1a2503ae42877514fe8eecb58272"
  project: unidentified-bd4a41ba
  name: "unverified code (study family 8c141bcb)"
  upgradeable: "no"
- address: "0xacce550121e59d04bf3a616c4155f89d2cf7d4c4"
  project: unidentified-658faf56
  name: "SANSWAP (study family 7ca3089b)"
  upgradeable: "no"
- address: "0xde95e3a89637895cb11742734646bd9a109d9f82"
  project: unidentified-6f9fb2ff
  name: "unverified code (study family ebaf5d09)"
  upgradeable: "no"
- address: "0x85fbc426381c95cbbc3909bb9f866b454dd9262f"
  project: unidentified-d0cf64b8
  name: "unverified code (study family 86f8c7fe)"
  upgradeable: "no"
- address: "0x84411c0d48fd64ca43d086679b1f791fc5af3a24"
  project: unidentified-3779fc89
  name: "unverified code (study family b77c5d5e)"
  upgradeable: "no"
- address: "0x0a8cd7a0e3f70baa801acc2d576be05bfd8b4b1e"
  project: unidentified-80b0fa70
  name: "ATSRemotePaymaster (study family baec52c4)"
  upgradeable: "no"
- address: "0x01d96c0e273878ca176ff4699ad92e6f6a41b29d"
  project: unidentified-47f72c84
  name: "unverified code (study family a91e7458)"
  upgradeable: "no"
- address: "0x64fdd96dc513e01327f3f307de9e1fd66df3ed45"
  project: unidentified-4413140c
  name: "P2PHandler (study family eac0d05e)"
  upgradeable: "no"
- address: "0xc384a2647894f487bde2cbc8ca0c0194a89cf1ef"
  project: unidentified-11d76fe8
  name: "unverified code (study family 2a236e8f)"
  upgradeable: "no"
- address: "0xffbdf7bdb928f2960d24df75ad551e6a404292b9"
  project: unidentified-60415e24
  name: "unverified code (study family 612afdcd)"
  upgradeable: "no"
- address: "0x8104e3ad430ea6d354d013a6789fdfc71e671c43"
  project: unidentified-9831d6f5
  name: "ECDSAValidator (study family 114cdc89)"
  upgradeable: "no"
- address: "0x800e38bfd8f00257ab4e54e04747a9ad3032b240"
  project: unidentified-f7553153
  name: "TenbinHub (study family fc6502c0)"
  upgradeable: "no"
- address: "0x542fba1a58da3585014f15946e4221e0a7d3d571"
  project: unidentified-ed0b7f17
  name: "unverified code (study family 623e133e)"
  upgradeable: "no"
- address: "0x9596477b46f6503e4a72822445e402983ba87966"
  project: unidentified-4675fc3d
  name: "EIP712TypedDataSafeModule (study family b6b8bc9d)"
  upgradeable: "no"
- address: "0x6599bba2a055f3c769cba1a2d462a75429bd7bf7"
  project: unidentified-fb10f665
  name: "unverified code (study family e900db81)"
  upgradeable: "no"
- address: "0xff61f7551c8117e623de56cf65f972a61bcd38f6"
  project: unidentified-039a8df2
  name: "unverified code (study family 55d8d200)"
  upgradeable: "no"
- address: "0xfe633a5374f21e1202133d6a0ef569407a9f97db"
  project: unidentified-f0fdd470
  name: "HodlerLabPrizeVault (study family 4d13d1ba)"
  upgradeable: "no"
- address: "0xec5347b886cc19816c175164109b7227bf6630c6"
  project: unidentified-71e3b31d
  name: "StakingRewardsDistributor (study family 0583ee96)"
  upgradeable: "no"
- address: "0xe5bfd61acdf778451d35b8f931309b0a46f6df54"
  project: unidentified-aa00813e
  name: "unverified code (study family b30fd4c4)"
  upgradeable: "no"
- address: "0xbcdccfa13c44c7c31f837cd5957540add2ffd8ee"
  project: unidentified-4b4d6337
  name: "unverified code (study family 86c3174e), 1 of 10 addresses running it"
  upgradeable: "yes"
- address: "0x0dc6614bf66f557f296ec2e7a5f112d009cc8d05"
  project: unidentified-353d5111
  name: "unverified code (study family 16e72759)"
  upgradeable: "no"
- address: "0x3d93a07cda938a22ddc9b5c1fe4ea8fee3121b5f"
  project: unidentified-d0f2390b
  name: "CFG (study family d5d2e8ac), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0xcf7d63a79d64531719c41d9cf3c18146ecdc4938"
  project: unidentified-e7d28157
  name: "HerEra (study family 54e08b83)"
  upgradeable: "no"
- address: "0x29c81fe69afe74d0b6d68090d50d62864c043abc"
  project: unidentified-59ccbc43
  name: "RaycashPaymentEscrow (study family 6815a76a)"
  upgradeable: "no"
- address: "0x38bd4363b7cd4040fac6eea5ef5d38e934aebd65"
  project: unidentified-9b12eaaf
  name: "unverified code (study family 78044b3c), 1 of 4 addresses running it"
  upgradeable: "no"
- address: "0x5e6ce32bb6fa47001cf87f2f9e07d5fd3de57990"
  project: unidentified-09fd4f60
  name: "unverified code (study family d51f9620)"
  upgradeable: "no"
- address: "0x4f624a90ae152e524b12258ce6aa9df6ed70ddfb"
  project: unidentified-7e00d33b
  name: "unverified code (study family aabcde3f), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x7b3d6f627011db3125f33540b9123f91b61935d8"
  project: unidentified-978e9247
  name: "unverified code (study family b7d17799)"
  upgradeable: "no"
- address: "0xa2232202443d852abf3e472877b94c075221faa6"
  project: unidentified-c4e79369
  name: "unverified code (study family c6cd598f), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x368e7478ff8c88c9002c32e1f576fabe2e9ddf7b"
  project: unidentified-0c81357a
  name: "SecuritizeOnRamp (study family 7488210b), 1 of 4 addresses running it"
  upgradeable: "yes"
- address: "0x100567077281235b446c81f0e2bd54c21979610d"
  project: unidentified-8fa9aa69
  name: "StrategyCefi (study family b35719ea), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x05d911538a95d955376b589a666578cb046d3307"
  project: unidentified-e536c4bf
  name: "unverified code (study family c5f22fd1), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xbc6f75192f9d7e85421c28442f963b4e8af298dd"
  project: unidentified-1e4f84ca
  name: "unverified code (study family 9e7f43e4), 1 of 38 addresses running it"
  upgradeable: "yes"
- address: "0xb802b54f8c8a16e68cf136bdd556d949710614e7"
  project: unidentified-d13cd7c1
  name: "MultiSigWalletMaster (study family 144eb546), 1 of 36 addresses running it"
  upgradeable: "no"
- address: "0xc18483bad1918e5579ad9983d80895e691a6cbe5"
  project: unidentified-1350b1e5
  name: "unverified code (study family 2dd212e5), 1 of 8 addresses running it"
  upgradeable: "yes"
- address: "0xb645ba7646a806d3aa0e383aac93d4a333ce92f3"
  project: unidentified-de04a78d
  name: "CHFD_VASP (study family 34b83e73), 1 of 8 addresses running it"
  upgradeable: "yes"
- address: "0x0a32204744b0768290e28ec303a6194a7396c6a1"
  project: unidentified-470850c1
  name: "unverified code (study family 497a812e), 1 of 7 addresses running it"
  upgradeable: "no"
- address: "0xc34e78005ff0b14893d94ca91d6758d15c04f8f7"
  project: unidentified-d4fc49ac
  name: "SingletonPaymasterV7 (study family 00f6d1a2), 1 of 5 addresses running it"
  upgradeable: "no"
- address: "0x06f6512a2f08df9f566b0843ee27326a688883b7"
  project: unidentified-b66054b3
  name: "ForeignBridgeNativeToErc (study family b4151b62), 1 of 4 addresses running it"
  upgradeable: "no"
- address: "0xd585b4ab9d002a9b2e44ef0a40e914fef6c06ca5"
  project: unidentified-408444aa
  name: "SubscriptionPayments (study family 3d3b16b8), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0xb76a65de9cae1df779b9bb3b328e48dc0864c73c"
  project: unidentified-ecc836e4
  name: "PaymentSwapBurner (study family 1a1c9e67), 1 of 3 addresses running it"
  upgradeable: "yes"
- address: "0xb7f9a206ae8eba2d99e9fe4de7205202a3e9d755"
  project: unidentified-7f1cd202
  name: "ClaimIssuer (study family d65034f7), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x103675510a219bd84ce91d1bcb82ca194d665a09"
  project: unidentified-c66efbf0
  name: "TransferManager (study family afb78a1b), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0x17a1905143166f67270e02f390083062e1f6b941"
  project: unidentified-e7504d43
  name: "Withdraw (study family c263401c), 1 of 3 addresses running it"
  upgradeable: "no"
- address: "0xd08e8bb3d754641bbf6dd2e797b1b52703f00486"
  project: unidentified-b0403b32
  name: "unverified code (study family 0c5ef9d5), 1 of 3 addresses running it"
  upgradeable: "yes"
- address: "0x21d956eaecce336b714150b8cc8ce36905306bda"
  project: unidentified-e0df1094
  name: "StakingUpgradableV2 (study family 5d083b74), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x4b89c78aa42822e1bd24865a4fe44a138cac590f"
  project: unidentified-e7504d43
  name: "AyniStaking (study family e095da61), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xb80e0dc1f21670cfcc7c08a4273431f8bd2b4c91"
  project: unidentified-73c73e93
  name: "unverified code (study family bce83885), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0xddc6625feca10438857dd8660c021cd1088806fb"
  project: unidentified-ff76aec6
  name: "unverified code (study family 80caea2b), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x2e311692d5cffc0c72ffc8b31a845707ccc17c0b"
  project: unidentified-6beeb100
  name: "unverified code (study family 70c410fc), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xc3f44f5cbce27e19f02e66d0584b24767bc6c8be"
  project: unidentified-6be3a4af
  name: "RateLimit (study family ccb0ad79), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x3eeaa85daf1433db18b243f10df888128bdde6eb"
  project: unidentified-f1462ede
  name: "unverified code (study family 63ae9ecf), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x0d257995f29c95ce12c697487f5d456e7c0165a5"
  project: unidentified-a8ea6452
  name: "unverified code (study family 69b22718), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x457f785000ca495fae63aab38c9fc4b2965b106a"
  project: unidentified-fa28c7fb
  name: "RestrictedActionsGuard (study family 505f9fd3), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x8b1072d0d8be0f10552429861a9e2400c575699d"
  project: unidentified-0e3bfcc0
  name: "ClaimIssuer (study family 883ba1d7), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x6d84f0831ffaf5ac1d811dc13540881d2862c539"
  project: unidentified-b0caa22f
  name: "unverified code (study family abc45c5a), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x4e50adfc953551286bbd7fee2b2b846d1d227394"
  project: unidentified-d33814c5
  name: "unverified code (study family 3edf4ec9), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0x69fe85d152dde0dc62a1b8c79b358877e8bf1ec5"
  project: unidentified-94e55efa
  name: "CoinFactory (study family 513d4c67)"
  upgradeable: "no"
- address: "0x474b348e3d07022b02f9f9e1feb10c30b27cd355"
  project: unidentified-f9f26967
  name: "unverified code (study family 8c5eae6c)"
  upgradeable: "no"
- address: "0x1899b652313def67a54dc4bbc67252efe55a7fe5"
  project: unidentified-776babc8
  name: "unverified code (study family 32b0dc2f)"
  upgradeable: "no"
- address: "0xb8c327efe5926cbd7b019a34c5db7c3a4bdf5866"
  project: unidentified-6dc9c83e
  name: "unverified code (study family 10a82ae8)"
  upgradeable: "no"
- address: "0xc27f778c107e1c42cd3d0f39575624a12254b22e"
  project: unidentified-a633753a
  name: "unverified code (study family cb9f1451)"
  upgradeable: "no"
- address: "0x0ee53a802f7a0d9c89666fb11aed70db5a2c00e9"
  project: unidentified-3ed995fb
  name: "PreSale (study family 17c236d9)"
  upgradeable: "no"
- address: "0x0c14ba3eb1edd16cd9f4015b461c21fcf264efd8"
  project: unidentified-5723759d
  name: "P2PLendingSecuritizeErc20 (study family 006029b5)"
  upgradeable: "no"
- address: "0x88eb0e6a38a8ea9a291697cf2420efba6ee0ccf9"
  project: unidentified-ff03410d
  name: "AttestationChecker (study family 540a5bc2)"
  upgradeable: "no"
- address: "0x0804c76639a56c10bdaf79c328cf139005352b6e"
  project: unidentified-c9d0fc2d
  name: "unverified code (study family a1850a27)"
  upgradeable: "no"
- address: "0xd1f1da33b2934981ade31f6ad525f0d1646114f5"
  project: unidentified-de03a1af
  name: "unverified code (study family ae56f491)"
  upgradeable: "no"
- address: "0xcc95863c2815f8cd2371494798906de4e18c467b"
  project: unidentified-cf82a516
  name: "unverified code (study family 34cb2d27)"
  upgradeable: "no"
- address: "0xa3267debd7ac8c24fa8ccc89e52c560c8bf674ec"
  project: unidentified-b02ca8f1
  name: "unverified code (study family b26e2bdb)"
  upgradeable: "yes"
- address: "0x59b99d037b56e1f75ba489ff552c3ac7a42219d8"
  project: unidentified-7fd3d70f
  name: "TONPaymaster (study family 4c48d1bc)"
  upgradeable: "no"
- address: "0x0db0dd371646b62c0de87b72101009f50484b9a3"
  project: unidentified-d69fefe5
  name: "SecuritizeOnRamp (study family 8bf1f99b)"
  upgradeable: "yes"
- address: "0x65637ad049554751c030869b2312cac0e9e8a50f"
  project: unidentified-f9f26967
  name: "unverified code (study family fda6bee7)"
  upgradeable: "no"
- address: "0x2aea6165552d06e8eef6fee370726f67bd1a03d4"
  project: unidentified-42949e0e
  name: "unverified code (study family ec9729c2)"
  upgradeable: "no"
- address: "0x1eb1694542237867d3006e8b3a17049d18d936b5"
  project: unidentified-08c33364
  name: "KeeperRole (study family 51a3fa1f)"
  upgradeable: "no"
- address: "0xeb909624bba64e7932cbac2af5482c3d45ad8869"
  project: unidentified-0088cdc6
  name: "unverified code (study family 545b3675)"
  upgradeable: "no"
- address: "0xa0cc9b2573dff01b720a31fd9c4e341cf88ae576"
  project: unidentified-c9ec0848
  name: "PermissionedDeployer (study family 74f8bea4)"
  upgradeable: "no"
- address: "0xce90d38b084aad57bc26c5c66f377d6df7882846"
  project: unidentified-b268f575
  name: "BerezkaWithdraw (study family ba0c8aa0)"
  upgradeable: "no"
- address: "0x74ab15849e3f83102a119d03fee373f47fc56a80"
  project: unidentified-e159a665
  name: "ConfidoIngress (study family 3b63dabd)"
  upgradeable: "no"
- address: "0x355d77a407ab69890a2a76ad018cdd917f1bfb48"
  project: unidentified-b19f00e0
  name: "unverified code (study family 1ae8d025)"
  upgradeable: "yes"
- address: "0xaf5c15e7a76422fb27a32c7cf67a76a118e84b6c"
  project: unidentified-6d92993a
  name: "unverified code (study family ce3ed6c9)"
  upgradeable: "yes"
- address: "0x1a48b8ba4f8efb18b6eebc8b91ee551abe7956f7"
  project: unidentified-cad0c613
  name: "BookkeepaUserIncentive (study family a4af5efa)"
  upgradeable: "no"
- address: "0xda57a13ef4444f8ca32d51ae04b8eaa27664491e"
  project: unidentified-289cdd03
  name: "MtxPrivateSale (study family b1551d1f)"
  upgradeable: "no"
- address: "0x5901b15fcde9b7d46b26bd22c7197a44494a9ced"
  project: unidentified-36d43d24
  name: "ElhexaAchievements (study family e222d4f6)"
  upgradeable: "no"
- address: "0x7915fa1b376de495e0d0b254da11a6cb27cc4b8f"
  project: unidentified-5a1c0c3d
  name: "FlatteningAttestation (study family b50300c7)"
  upgradeable: "no"
- address: "0x946fb276dfd92b50458170473711fd9c8cbf0fb2"
  project: unidentified-02867114
  name: "EspressoTEEVerifier (study family 79ffc2b0)"
  upgradeable: "no"
- address: "0x1e530e5fd5c2419f2059151303cb0bc01841cf9d"
  project: unidentified-3f0447a6
  name: "EarthmetaCrossChainCheckout (study family f0aeea98)"
  upgradeable: "no"
- address: "0x537d75f9f9bfee1f39dcbdf005a20663e892a88e"
  project: unidentified-2e72e8ad
  name: "UFarmVault (study family 9aa07dbd)"
  upgradeable: "no"
- address: "0xf955efad2e2aca7f24b16a2b2baa89b463542b26"
  project: unidentified-c3825c54
  name: "unverified code (study family a7199534)"
  upgradeable: "no"
- address: "0x0f545c6178830e249117b5162120378735fdd635"
  project: unidentified-31ca5c5a
  name: "Gateway (study family c7226cec)"
  upgradeable: "no"
- address: "0x3fed135c3d8ffe36ce0cb835cef57c4566f25852"
  project: unidentified-c8fc994f
  name: "PAHolder (study family 12356661)"
  upgradeable: "no"
- address: "0x473833fbb446cf8efe5f762455f9f17592277e52"
  project: unidentified-65aa2a3c
  name: "Poppets (study family 055a85d8)"
  upgradeable: "no"
- address: "0xd4c3e452a13fe2fd2b1fde65adf17d101eb42d25"
  project: unidentified-00000003
  name: "ZagrosBridgeGateway (study family 69a8fbf8)"
  upgradeable: "no"
- address: "0x0448633eb8b0a42efed924c42069e0dcf08fb552"
  project: unidentified-00043880
  name: "LiquoriceSettlement (study family 7983c08f)"
  upgradeable: "no"
- address: "0xbc283006fb7c9cbbb7f63442ec6937138c82d5a4"
  project: unidentified-e4f09156
  name: "ArtistCollection (study family 320d32da), 1 of 49 addresses running it"
  upgradeable: "no"
- address: "0xba4961de8ba4a3754f3ed3fe8b05903dc794cde3"
  project: unidentified-bc5ee07d
  name: "Tally (study family 24e32d7d), 1 of 6 addresses running it"
  upgradeable: "no"
- address: "0xc927a1e4c431babb798d705988ab036e2bdcf640"
  project: unidentified-c66efbf0
  name: "ApprovedTransfer (study family b1b01ed0), 1 of 4 addresses running it"
  upgradeable: "no"
- address: "0xd1006642fd2e35355e58f5ae077964c5a72b7d00"
  project: unidentified-7f7dded2
  name: "unverified code (study family 3c2944f3), 1 of 2,026 addresses running it, 2,025 by 7702 delegation"
  upgradeable: "no"
- address: "0xb5e937676acdc6fd8585443b1c5b9b6eec6269d4"
  project: unidentified-dd99b75f
  name: "TokenERC20 (study family 196f17ea), 1 of 504 addresses running it"
  upgradeable: "no"
- address: "0xb653797907a17e29c38be0cf09de4f7dcc1bfde9"
  project: unidentified-e0f28d9d
  name: "TokenERC20 (study family dda37296), 1 of 861 addresses running it"
  upgradeable: "no"
- address: "0x10c785db70114d17a3cb694b2bb8170c87684342"
  project: unidentified-969aa1c5
  name: "BloctoAccountCloneableWallet (study family 2de72ace), 1 of 152 addresses running it"
  upgradeable: "yes"
- address: "0xee1270ab435413396a050ee0758907e805eae607"
  project: unidentified-ee8dc70c
  name: "unverified code (study family cd1f0b12), 1 of 779 addresses running it, 778 by 7702 delegation"
  upgradeable: "no"
- address: "0xb645f43266969ff209dd2962fbcb0ad9f54109fe"
  project: unidentified-dd99b75f
  name: "TokenERC20 (study family 98347180), 1 of 450 addresses running it"
  upgradeable: "no"
- address: "0x98a7af3950c2bfaca4af6f18b4b209310c63bf59"
  project: unidentified-d0b25af4
  name: "SlickSwapV1 (study family 1055d696), 1 of 159 addresses running it"
  upgradeable: "yes"
- address: "0x75462291e6fcf7250cd7c6feaea678b59ec7c0fc"
  project: unidentified-770d818d
  name: "unverified code (study family fa597019), 1 of 213 addresses running it"
  upgradeable: "no"
- address: "0xfec266a3b8aed9ebe97400a7e4e3fa907ed4d8b0"
  project: unidentified-ec433d74
  name: "unverified code (study family 6804d878), 1 of 739 addresses running it, 738 by 7702 delegation"
  upgradeable: "no"
- address: "0xb6ab24fd917bfe3b8734cee84abbc0c330295f7e"
  project: unidentified-3ba1f0dd
  name: "unverified code (study family 24c34137), 1 of 211 addresses running it"
  upgradeable: "no"
- address: "0xb57c84aaba0319e5fe481efc9518be541bf8bf29"
  project: unidentified-1ff21eca
  name: "unverified code (study family 0fdf2040), 1 of 545,102 addresses running it"
  upgradeable: "no"
- address: "0xb57ec7f4c3372d590916d71669346a11c1a1d429"
  project: unidentified-1ff21eca
  name: "unverified code (study family b780810f), 1 of 58,303 addresses running it"
  upgradeable: "no"
- address: "0xb57ccbe436722c07c66aefb85c15e438a31ac339"
  project: unidentified-2ef5ecfb
  name: "Roles (study family cde8f1d1), 1 of 9,959 addresses running it"
  upgradeable: "no"
- address: "0xb57ed3b7b7be5a25356639145261530027d9390e"
  project: unidentified-512d346a
  name: "unverified code (study family 887cafb6), 1 of 6,579 addresses running it"
  upgradeable: "no"
- address: "0xb57cde6af4d777f5f111ecd9953f44fe64a3cd7c"
  project: unidentified-41142d38
  name: "NiftyERC721Token (study family be579c17), 1 of 5,098 addresses running it"
  upgradeable: "no"
- address: "0xb580d2eead23edf54facb7dc35d52b9148863f5c"
  project: unidentified-1ff21eca
  name: "unverified code (study family 038a8573), 1 of 3,772 addresses running it"
  upgradeable: "no"
- address: "0xb581558952213203321e76e8af4f692abc08cd1e"
  project: unidentified-3be39430
  name: "unverified code (study family 57a0f1e4), 1 of 2,628 addresses running it"
  upgradeable: "no"
- address: "0xb5c5a64e8c2916cf370465aeaab9ebda99dfdade"
  project: unidentified-b8a01196
  name: "unverified code (study family 78773c32), 1 of 1,534 addresses running it"
  upgradeable: "no"
- address: "0xb5dd936b19dc3b6bbadb11684733daa3a92b0cbb"
  project: unidentified-37beb1c8
  name: "unverified code (study family be630529), 1 of 852 addresses running it, 851 by 7702 delegation"
  upgradeable: "no"
- address: "0xb5bb2cdc78f3fac2f19e84c174b25de8a33d1d63"
  project: unidentified-85058056
  name: "TokenERC721 (study family 3a79904b), 1 of 737 addresses running it"
  upgradeable: "no"
- address: "0xb5c957e73f276f607ead2a746e87e409fa3a4a73"
  project: unidentified-dd99b75f
  name: "TokenERC721 (study family 1d775643), 1 of 617 addresses running it"
  upgradeable: "no"
- address: "0xb5bd6d8e9b92203b94bc5b44189490b92de6793d"
  project: unidentified-7df0808c
  name: "Roles (study family d5275e6a), 1 of 492 addresses running it"
  upgradeable: "no"
- address: "0xb600c54dc2dec8487c70fec6e6db0acfa7f8d590"
  project: unidentified-dd99b75f
  name: "TokenERC20 (study family bde87a66), 1 of 468 addresses running it"
  upgradeable: "no"
- address: "0xb595496501d4e2580325abbfd626761ace7d301d"
  project: unidentified-96bb5557
  name: "FrozenERC1155 (study family efbd2ced), 1 of 392 addresses running it"
  upgradeable: "no"
- address: "0xb639703a86140b30d4a03968b468a12737b9d469"
  project: unidentified-0305cd14
  name: "Airdrop (study family e2ad46c2), 1 of 360 addresses running it"
  upgradeable: "no"
- address: "0xb6b4f1f56361636c76f9701a9bb5b624e26234d8"
  project: unidentified-40e44712
  name: "Roles (study family dd7c4d92), 1 of 357 addresses running it"
  upgradeable: "no"
- address: "0xb5c2a29b87d1844e9dfb69d648f08f14530ffabc"
  project: unidentified-41142d38
  name: "NiftyERC721Token (study family 4c03806f), 1 of 357 addresses running it"
  upgradeable: "no"
- address: "0xb5ccf283ad21b6b996800a458da684fd86403da9"
  project: unidentified-4f59ae1e
  name: "unverified code (study family 38027af9), 1 of 344 addresses running it"
  upgradeable: "yes"
- address: "0xb5b3f50168abe322f7c11f9e79f0a814923ebe55"
  project: unidentified-85058056
  name: "TokenERC1155 (study family bb8f467e), 1 of 289 addresses running it"
  upgradeable: "no"
- address: "0xb5bfdafe519f1a722572b3eefe7db17ee111b555"
  project: unidentified-1d1c9f70
  name: "unverified code (study family 564b47f7), 1 of 273 addresses running it"
  upgradeable: "no"
- address: "0xb633cf4c54833db3574edabbd324e5ba5436acd5"
  project: unidentified-dd99b75f
  name: "SignatureDrop (study family 1afffc27), 1 of 272 addresses running it"
  upgradeable: "no"
- address: "0xb58769c7a306ed4315a3e2a1fc21b79c7ecc812a"
  project: unidentified-b31d16a5
  name: "unverified code (study family 80c2016c), 1 of 272 addresses running it"
  upgradeable: "no"
- address: "0xb622716ed56fb618f8b9c414644255b0de3c8097"
  project: unidentified-67985b1f
  name: "TrustedForwarder (study family c2e6f3b3), 1 of 256 addresses running it"
  upgradeable: "no"
- address: "0xb67e4f72512f5aa96c82ca58e02fbf841e53c2c8"
  project: unidentified-7df0808c
  name: "Delay (study family f0c09306), 1 of 252 addresses running it"
  upgradeable: "no"
- address: "0xb7c13e86abeef9b4a64e5e38ea92e3208b4bd7c7"
  project: unidentified-9165b344
  name: "unverified code (study family 66032ad8), 1 of 250 addresses running it"
  upgradeable: "no"
- address: "0xb9d2d253514d15262330a186108e1ad0f97baf30"
  project: unidentified-dd99b75f
  name: "SignatureDrop (study family cc5402c9), 1 of 243 addresses running it"
  upgradeable: "no"
- address: "0xb81081740ea5dee93595cb77550f745fb28a37db"
  project: unidentified-88eb7f59
  name: "unverified code (study family d045c2d9), 1 of 241 addresses running it"
  upgradeable: "no"
- address: "0xb76035fca16a4c868332860af67b2ef0e9a39226"
  project: unidentified-dd99b75f
  name: "TokenERC20 (study family a066538d), 1 of 235 addresses running it"
  upgradeable: "no"
- address: "0xb604d187735c615fe8c4c1cd8ef62c93b1b415d4"
  project: unidentified-dd99b75f
  name: "TokenERC1155 (study family d33da90d), 1 of 215 addresses running it"
  upgradeable: "no"
- address: "0xb581eea5f6f26bcd9003366df617cf1f3935aab9"
  project: unidentified-dd99b75f
  name: "TokenERC721 (study family c77e2b1d), 1 of 214 addresses running it"
  upgradeable: "no"
- address: "0xb5e656a8330294670a064b1c0745339df9a531d4"
  project: unidentified-f3edac9b
  name: "MintedTokenCappedCrowdsaleExt (study family be4639f0), 1 of 210 addresses running it"
  upgradeable: "no"
- address: "0xb74231fccafc6f1b10a3f36e8c8433909e89dcfd"
  project: unidentified-dd99b75f
  name: "SignatureDrop (study family 50e19225), 1 of 210 addresses running it"
  upgradeable: "no"
- address: "0xb68ccdcd53b639d7e330cb9d0cf281ed220ae05d"
  project: unidentified-5e80919d
  name: "CreatorCollection (study family 7ee1302e), 1 of 209 addresses running it"
  upgradeable: "no"
- address: "0xb6e3dece6f6731d1d8c44daea8ad5903959d7f56"
  project: unidentified-9db00606
  name: "TokenCollection (study family 59d12741), 1 of 194 addresses running it"
  upgradeable: "no"
- address: "0xb961b90c4e1f3717eecc04625efd2136f6c62adf"
  project: unidentified-85058056
  name: "TokenERC20 (study family 2324a018), 1 of 179 addresses running it"
  upgradeable: "no"
- address: "0xb6f60256e54e0be8eb4754b8f4d46c62207445f0"
  project: unidentified-01fa2427
  name: "unverified code (study family 7ddc257e), 1 of 175 addresses running it"
  upgradeable: "yes"
- address: "0xb5a0b4e55877c8fbc5cb9753dc6b8619cb810687"
  project: unidentified-d1b06286
  name: "MintableOwnableToken (study family e5b52728), 1 of 160 addresses running it"
  upgradeable: "no"
- address: "0xb971b07146c8f3bd502763c22b1e35fcc3b82d1a"
  project: unidentified-dc95598e
  name: "GeneralTransferManager (study family baa4d4f3), 1 of 155 addresses running it"
  upgradeable: "no"
- address: "0xb5d2fbdd5800ae26ed0a1dc0979fdea330cdb099"
  project: unidentified-c42dea1d
  name: "SignatureDrop (study family 748fca50), 1 of 152 addresses running it"
  upgradeable: "no"
- address: "0xb8e4a7c80444a484fa3cfaaf3f540c5366834b4a"
  project: unidentified-b653d090
  name: "MintableOwnableToken (study family ca6b41cf), 1 of 145 addresses running it"
  upgradeable: "no"
- address: "0xb607faf1ed5cc566fc1d705497b14dec71fc72cf"
  project: unidentified-0e7de56c
  name: "FxGenArt721 (study family 5b1f0b39), 1 of 141 addresses running it"
  upgradeable: "no"
- address: "0xb59a5c9f708d824fd30dfe2a65c8c2b566d6f6f7"
  project: unidentified-06b2e1a9
  name: "unverified code (study family 7008ed6a), 1 of 137 addresses running it"
  upgradeable: "no"
- address: "0xb67b19d3a5bb819732c1465ae58b6c006ae4c902"
  project: unidentified-49d65472
  name: "unverified code (study family d8cbe550), 1 of 133 addresses running it"
  upgradeable: "no"
- address: "0xba4a459e5d50e030199e4f485ee47ecc5c66d438"
  project: unidentified-e40850f4
  name: "TokenERC721 (study family eb2f1dae), 1 of 133 addresses running it"
  upgradeable: "no"
- address: "0xb979b5eac91bf62da1d1f856f5b16aeb877fb884"
  project: unidentified-ce417118
  name: "AutoMinterERC721 (study family e17cbf5c), 1 of 128 addresses running it"
  upgradeable: "no"
- address: "0xb5a52a52c484c7dca846794b723dad6af6108f08"
  project: unidentified-0f92d394
  name: "unverified code (study family 61ff3c02), 1 of 123 addresses running it"
  upgradeable: "no"
- address: "0xb6704dd58fff8db60619a72d79bf074d59889e6f"
  project: unidentified-9db00606
  name: "TokenCollection (study family 593ad07f), 1 of 119 addresses running it"
  upgradeable: "no"
- address: "0xb75bd8fa48c7c727bfbaef44ccd8a9083801f27a"
  project: unidentified-dd99b75f
  name: "TokenERC721 (study family 0c957675), 1 of 115 addresses running it"
  upgradeable: "no"
- address: "0xb68144374b2153ccc0956ed886be3321e64eb1cf"
  project: unidentified-f4699ae9
  name: "WaymontSafeAdvancedSigner (study family ebbf0691), 1 of 115 addresses running it"
  upgradeable: "no"
- address: "0xb71a312ff8cd4b81b6790cf4b730ab8ee93e2c32"
  project: unidentified-9db00606
  name: "TokenCollection (study family 0efa34b9), 1 of 106 addresses running it"
  upgradeable: "no"
- address: "0xb9f00db866fa934eb1ac3bb97fe0a412c0b63b5e"
  project: unidentified-c7b7df03
  name: "unverified code (study family 580d55bf), 1 of 104 addresses running it"
  upgradeable: "yes"
- address: "0xb66c94c85d97e73c29ec6fbf60ad7c3f7613a5b4"
  project: unidentified-b5ff6c56
  name: "MintedTokenCappedCrowdsaleExt (study family f4a8c24f), 1 of 102 addresses running it"
  upgradeable: "no"
- address: "0xba5784adc72eb02781b57e3360f04cd482e8ac04"
  project: unidentified-ab0d964b
  name: "DepositCollect (study family 35cdcaab), 1 of 101 addresses running it"
  upgradeable: "no"
families:
- code: "0xce43851485f437005ef3c1821e250c4d3c53b946"
  name: "SingleOwnerMSCA (study family ee56db4b)"
  instances: 7712
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 4177821670
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x9512a1ff49fcceaa464ae44226a004ba19122518"
  name: "SingleOwnerMSCA (study family d37ca877)"
  instances: 40
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 1699569797
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x642c9b393c3754d3618b88e16d6c96c13a467627"
  name: "WalletCore (study family fd63c340)"
  instances: 106596
  list: "every address running this code at block 26,438,999 (106,594 by 7702 delegation)"
  upgradeable: "no"
  value_usd: 121201648
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x1a446a47aed68ef4f9b1536c5f8f27f9dc03f508"
  name: "unverified code (study family 2babc14b)"
  instances: 3696
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 117479021
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x0cfabe8a8a5cd4ceee2baaa850cfb92f7391f47e"
  name: "SemiModularAccount7702 (study family dda3e769)"
  instances: 98841
  list: "every address running this code at block 26,438,999 (98,840 by 7702 delegation)"
  upgradeable: "yes"
  value_usd: 88055490
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x0a4fd9ebe5d8ebf63b1ab77a3296e2d79884b48e"
  name: "GnosisSafe (study family 132235e3)"
  instances: 965
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 46831941
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xea6294f6d4b231141f04562887a0d06f8df3bd49"
  name: "CaliburEntry (study family 6d5daa99)"
  instances: 47265
  list: "every address running this code at block 26,438,999 (47,263 by 7702 delegation)"
  upgradeable: "no"
  value_usd: 35728664
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x22becbd1958d25536b7a08bbc12e6048df4ab9a3"
  name: "ZtakingPool (study family ad8cefc3)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 35197943
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xce890746664e17a3220e1f64d1b7f86c1e4be4b2"
  name: "CaliburEntry (study family 545783d9)"
  instances: 159930
  list: "every address running this code at block 26,438,999 (159,927 by 7702 delegation)"
  upgradeable: "no"
  value_usd: 34914988
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x7da82c7ab4771ff031b66538d2fb9b0b047f6cf9"
  name: "MultiSigWallet (study family 077a160a)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 17205216
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xf36a146160ec69820542f3c4dec5c72b37403967"
  name: "WalletCore (study family 1cab59ca)"
  instances: 24451
  list: "every address running this code at block 26,438,999 (24,448 by 7702 delegation)"
  upgradeable: "no"
  value_usd: 15395784
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xe87531e34e042262c03bcbbefcb36ccc45bfe34f"
  name: "AvocadoMultisig (study families 99e85c8b, 65a5926d)"
  instances: 519
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 12895386
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb6c2f7f91b099b0c42ff6a1e2d91ed7998781fff"
  name: "AvocadoMultisig (study family d3212a1c)"
  instances: 109
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 7549016
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xa0e054fe86c7810592c2d3091acac6a7da02c599"
  name: "MezoBridge (study family 741a551b)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 6654856
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x139cfd93dbaf2682b2ceae7aef2465470cfb9ee3"
  name: "MultiSigWalletImplementation (study family ac6dda8c)"
  instances: 32
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 4772520
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x405c6f5acd29dc6b72f3cce8e4f6a76fa3d53c7a"
  name: "SmartWalletEntry (study family 099a9a9f)"
  instances: 9172
  list: "every address running this code at block 26,438,999 (9,170 by 7702 delegation)"
  upgradeable: "yes"
  value_usd: 4722894
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x816f722424b49cf1275cc86da9840fbd5a6167e9"
  name: "unverified code (study family de3f7a67)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 4463760
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xf3caf8dfa2c017961b8dcfd1c20cac5ebc091d2d"
  name: "unverified code (study family 63bc6d87)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 3998905
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x61a7ebc69a34e72005a195b42b5d5577c20032ad"
  name: "unverified code (study family 83cce250)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 3418919
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xa79692b65bad10d7d2fe9de309a646fbe311d6a2"
  name: "SemiModularAccount7702 (study family 8554540d)"
  instances: 30422
  list: "every address running this code at block 26,438,999 (30,421 by 7702 delegation)"
  upgradeable: "yes"
  value_usd: 2794361
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x013d0dc75808d097b00a1ce8dc6d464fb7c7746e"
  name: "unverified code (study family aac67042)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 2142554
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xd7974ab51ea966aee19fb8b6ebab8c22074e16c0"
  name: "AmbireAccount7702 (study family a8dadc5a)"
  instances: 282
  list: "every address running this code at block 26,438,999 (279 by 7702 delegation)"
  upgradeable: "no"
  value_usd: 1683474
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xaa7427d8f17d87a28f5e1ba3adbb270badbe1011"
  name: "WrapperLockEth (study family a6020f29)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 1680587
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x814b55996914911b2bb57a2069c918ae159d02f4"
  name: "USDmMinting (study family 7b0f60f1)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 1594690
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x836e1a843e6240211cf1a7b75511dd44543aff7f"
  name: "SemiModularAccountBytecode (study family e51591bf)"
  instances: 3924
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 1416399
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xcf5839f8309f6315749c084d5c5eb8e35aca2439"
  name: "MintedTokenCappedCrowdsale (study family ca3f26dd)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 1210679
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x3f98beb42c618d31c4f60008de15401bdc84f83f"
  name: "unverified code (study family 68d7cf2d)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 1178017
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x64192819ac13ef72bf6b5ae239ac672b43a9af08"
  name: "MainchainGatewayV3 (study family 2660d36c)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 1125504
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x0f8dd218ee17eee03d254805f84c7ba613e45e62"
  name: "unverified code (study family 10059bd1)"
  instances: 216
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 1104030
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xce0e4d548735137d3b3afcbaaf47800b88eb0b6a"
  name: "unverified code (study family 1bbffa52)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 950281
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x2452b803e81d7eee43b283d234a875528d2c5a50"
  name: "SmartVault (study family 22475f91)"
  instances: 748
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 868715
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x1a2a1c938ce3ec39b6d47113c7955baa9dd454f2"
  name: "MainchainGatewayManager (study family bdf14344)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 861858
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xd62595c3c23b690baee0935e107a209cb1dbd37b"
  name: "SynthetixDepositContract (study family 86cb27da)"
  instances: 5
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 851752
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xec0377a6bc71c4a28288a5cfd307b80c53a7e1e1"
  name: "DEXVaultV1 (study family 06599eb9)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 779931
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xc249c0fc4f7283d4a58c57d8fb0cf5f126ae4ead"
  name: "unverified code (study family e96b6fef)"
  instances: 9347
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 776322
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x125ab2ca5071b60433d90bce2dfc8e1e83adad2b"
  name: "ForeignBridgeErcToErc (study family 51937336)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 573670
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x717d0bf97ce58e14945f5e0320ee98381aeaddaf"
  name: "CampaignRewardDistribution (study family 6c04e807)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 558692
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x3cda13cdab0c80339980721822689d998eca761a"
  name: "unverified code (study family 9693f5f5)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 554000
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x79383f1ab202c0f7ad755e298c4ab544296c9fdf"
  name: "Account (study family 49a157ce)"
  instances: 15444
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 483622
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xf28f22868b5d7199772034f224d1fa6f8bafac83"
  name: "CloneableWallet (study family 8a26da14)"
  instances: 34447
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 477667
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xc8518d5de0451c67a20da2b1dc54d68569018ca3"
  name: "USDxMarket (study family cfadd732)"
  instances: 10
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 424072
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xa2f5bf5eb1b8894a514162ca7abe5f095a5371b1"
  name: "unverified code (study family b4da8554)"
  instances: 5761
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 402056
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x460e0cd087033a73e1bc5c071711f1f27884968a"
  name: "CyanVaultV2 (study family dc622884)"
  instances: 10
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 396642
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x075af08596c26a81384e1f06757f96c96bb1e896"
  name: "unverified code (study family d1083aa3)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 387619
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x77ba78c10efb5100ce93e611f01e272f1b9ced84"
  name: "CloneableWallet (study family 93fafd58)"
  instances: 10278
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 374807
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x8bb510a3860e0ad2a0f2794a90cbf14b1b85a2f0"
  name: "unverified code (study family 5a054238)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 368130
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xab41cfa52dab44ccb3c12e208816fe24a0d39a32"
  name: "ShrincsWallet (study family b5e7b5d9)"
  instances: 6282
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 363438
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xcfc1bc6013ed89d484c626dd9ee5eb7bc1a1d9da"
  name: "LiquidityPool (study family adb08b46)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 318144
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x4c2bddd6d3bc89940e0f7a4bd3d43825d03a3ce0"
  name: "unverified code (study family b4aa3552)"
  instances: 272
  list: "every address running this code at block 26,438,999 (271 by 7702 delegation)"
  upgradeable: "no"
  value_usd: 298835
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x1ecdb32e59e948c010a189a0798c674a2d0c6603"
  name: "unverified code (study family 4af46768)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 291617
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x6cb5fe1d0b5adf12362b0fbb203b0a7898c7ec69"
  name: "RelayContract (study family fe57b600)"
  instances: 5074
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 277000
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x7c9735521ad7d81f57bc56bc85b5bc885d4748ae"
  name: "Safe (study family f108e396)"
  instances: 126
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 273030
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xbeef02961503351625926ea9a11ae13b29f5c555"
  name: "unverified code (study family dad22242)"
  instances: 2
  list: "every address running this code at block 26,438,999 (1 by 7702 delegation)"
  upgradeable: "no"
  value_usd: 244879
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x979594ce68c551f98e72a43adfb4b419b6fdd5d3"
  name: "unverified code (study family 122cbca8)"
  instances: 14
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 234232
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xf2e6ed63bb255e51b64337c67fb4898aa979da6b"
  name: "unverified code (study family b67e3771)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 227735
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x6c5e91e9b4d1799ea48a4de216184bff7ef32676"
  name: "Wallet (study family 19940b45)"
  instances: 17229
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 221420
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x9ac0c8bade28dfe1f44ae4fd75465e3cce6f0152"
  name: "SunperpVault (study family 99bea6bb)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 220698
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x38741a69785e84399fcf7c5ad61d572f7ecb1dab"
  name: "EverPay (study family 244e6e23)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 192547
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xbba3c74a006f199193645e35a936b75b605cb2bc"
  name: "unverified code (study family d81eb18d)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 184967
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x937478e73bf6547843af57564d7265306af024aa"
  name: "unverified code (study family b26359b4)"
  instances: 404
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 181178
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb5d425d678b10949dd0f7bb0dd0427c47451d57e"
  name: "BitSafeEvmAssetBridge (study family 3a8dddb4)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 172335
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xe87753eb91d6a61ea342bb9044a97764366cc7b2"
  name: "TinfunReserve (study family 4cb50580)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 162771
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xaf895c514d2448150b67f3c0b828250bd947ce7e"
  name: "Facility (study family af9cc07b)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 152846
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x3a9624f9bb2dc43e90c0699ddc4a9b6bec147cde"
  name: "ThresholdCustody (study family 75ed4c5c)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 152846
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x453095fc585c5fda2756ed16990463038a6d8a17"
  name: "unverified code (study family 643a74e6)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 150861
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x4fd9dba1d53b7e6cc933a2fdd12b1c012a0654f6"
  name: "MultiSigWalletV2 (study family c69b7f5d)"
  instances: 41
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 140936
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb5a650a68f8328090135ea96b4a1455debf72b0e"
  name: "Account (study family 076aeff3)"
  instances: 4360
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 131733
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xd91e14b8124bcb8986d35048b41ebb7172d4f4fe"
  name: "GnosisSafe (study family 59287f67)"
  instances: 512
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 128665
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x775db93999c339e04276040069e2a08aaf3c13d4"
  name: "HomeBridgeNativeToErc (study family 9c8a31f6)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 124876
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xf3347c1feca81e9e42c263458ec8d6fea3662ea2"
  name: "unverified code (study family 783e1802)"
  instances: 281
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 121266
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xd1d45a99e04cd3e50c1bbfd8f98e4a6ba3602121"
  name: "unverified code (study family 1a0be12c)"
  instances: 9736
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 111341
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xc578cbaf5a411dfa9f0d227f97dadaa4074ad062"
  name: "Bridge (study family 17b7191d)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 110620
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x260924d36380cadf882d1a1514fba2eae26bbb91"
  name: "TokenDistributor (study family ef167be5)"
  instances: 12
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 108815
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x215e278c44787dffd33b58311a0e9bb0657c1d8d"
  name: "unverified code (study family 804b95e3)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 104304
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xfd84612b395da9459ef47f9f4598a0be6d9f3e29"
  name: "unverified code (study family 008d5e1f)"
  instances: 28
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 85897
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xc6b9743624faa056edb7c57b35f2937155c0e425"
  name: "unverified code (study family 02bda5d1)"
  instances: 8
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 79401
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x5b3f0568b4499646d6992aa600ae0e8b86b4dbe9"
  name: "BonusDistributor (study family bbd9d1dd)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 77777
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x73aceb5025f173aeb7feb7e6d8a3a6090c59b268"
  name: "PullSplit (study family 82bca671)"
  instances: 7276
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 76152
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb59ffa679380b65bc2c1fdf690db7aa214c884bf"
  name: "unverified code (study family cb2d7456)"
  instances: 2345
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 73446
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xcad5a42d74f66d96650fdf1a1b1d738dedb7d876"
  name: "SeeleBridge (study family 37488515)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 71100
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb5db375799e35dab6780d41b7abe9ff997839700"
  name: "PrimeRewardPool (study family 2c5c2ab3)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 68212
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb6260b8b0bcdcbb7a57f86b074a7e03a095106f0"
  name: "unverified code (study family 25d8a07a)"
  instances: 6
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 64423
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xa7ad82f4d1209ea99858d3ebbd1f8127ad675242"
  name: "AuthereumAccount (study family edf9adda)"
  instances: 3853
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 60453
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb0813fadbb418503fe6b23f410cf27572e74948b"
  name: "unverified code (study family fd568f63)"
  instances: 152
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 55761
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x067a989e2156ae3cd6e4d0242a6f7026bd6c758e"
  name: "LightAccount (study family 15f7750b)"
  instances: 1574
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 54678
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x8768551d4dfc099577c6871e424b0d771c7b2328"
  name: "unverified code (study family 769a51e1)"
  instances: 63
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 51430
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xad2406ae4eadca4176c8d72a5bc6c70351b741a2"
  name: "unverified code (study family ca4939cf)"
  instances: 123
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 48543
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x11ac75b61c0974f71a6e171e1e36714c4f105e35"
  name: "unverified code (study family d7fbee65)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 47640
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xc736a9e9c71cbe6b7eb7404131a6a98394795ca6"
  name: "Distributor (study family 5d883d1a)"
  instances: 47
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 47460
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb5dfdfb2a1c97b329361d261239c51e5f88d035d"
  name: "WrapperLock (study family d9029440)"
  instances: 46
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 47460
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x00f9dc19fae6c913cd60e215acaf39853d2dfb61"
  name: "GlideDeposit (study family feca8a6c)"
  instances: 51541
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 45475
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xd923af5d509042a3b24b711caaba8c408d4d4c23"
  name: "KubzAuction (study family aa68edc9)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 44573
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x1c03d454272382aaff97b46fe0f6cd66a65857c1"
  name: "Hub2Eth (study family dc0e4063)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 43309
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x49811020c8f25de1d8d03ef2c9cdbe5be8fb07a1"
  name: "TeaVaultV2 (study family 34f84caf)"
  instances: 17
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 40783
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xa8372d6ff00d48a25baa1af16d6a86c936708f4e"
  name: "L1ERC20Predicate (study family 0e843f24)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 39339
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xce701340261a3dc3541c5f8a6d2be689381c8fcc"
  name: "Chronicle_SKY_USD_1 (study family a721f47a)"
  instances: 46
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 37896
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xeebe6f7fd87ed28748f5e4d3e339ba0f28e90782"
  name: "Dao (study family 6fff5ce6)"
  instances: 712
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 37174
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x10e55548db8cdd32ad9a90c14271a88cd0b52e96"
  name: "AuthereumAccount (study family e7f0144c)"
  instances: 912
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 36091
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x69bcb93d13d1063335269e8602b009485abd3e87"
  name: "NFTEntry (study family 396acdfa)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 34648
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x02b758ce469af940c57a42ad1de5d404122bc283"
  name: "GenericBridge (study family 62404c98)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 33926
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xfdeaf7d9ab542c6ad617666015e512fa1633b8a0"
  name: "unverified code (study family 98135b0c)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 33204
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xa80fb695d273eda9766342f5805c97e027ca8901"
  name: "Resolver (study family cfa9347d)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 32663
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x0b57c3d5a7a93c3e9652459aff3c7fef792a7c2c"
  name: "AvocadoMultisig (study family 9591f7a6)"
  instances: 131
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 31219
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x136d841d4bece3fc0e4debb94356d8b6b4b93209"
  name: "StakersPoolV2 (study family c9d97a3c)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 29956
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x0e9d8e14293dd069690c1addbf51b61b4dca2f96"
  name: "AmmoVault (study family f29fbdcd)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 28873
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x9d4bcc065788787515f9baac673bf44cfb9d389c"
  name: "Identity (study family 7afdaae8)"
  instances: 2065
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 27971
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x147aa9ada01b70c4c8c8b89b06afe767908aced7"
  name: "PharaGoddess (study family d1d8280d)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 27249
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x74699d5fb553afed0360a6a266981dcd98d9dfa4"
  name: "Waitlist (study family 11591c5e)"
  instances: 7
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 27068
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x05cefcb9471605380c1750874ec652e3f0609856"
  name: "AuthereumAccount (study family 5cd5f31e)"
  instances: 243
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 27068
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x5de9f32b2665bb2cdc23bfb51b03e2a2985ecc87"
  name: "KYCCrowdsale (study family bb977a33)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 26888
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xccb57afedecc8d975ca4ae06f850a175142499de"
  name: "Keep (study family d7ed1420)"
  instances: 21
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 26527
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x0af7f2162b4714c99f49b8c4fb4f3cece026b432"
  name: "CloneableWallet (study family ca85fe9a)"
  instances: 7202
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 26166
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xc5a6349aedf573ee01c7bdf3d713496b5a45d056"
  name: "UpstreamCollectiveToken (study family fa2a7e01)"
  instances: 11
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 25264
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x2cbe14b7f60fbe6a323cba7db56f2d916c137f3c"
  name: "SealedArtMarket (study family 4b5a2c8e)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 22196
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xcebfc5dfbd5ce21694fe2acefa63ad6f828831d2"
  name: "unverified code (study family c41a1cf3)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 22016
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x65011d7322dd36dd3c2c38fccaf7503406a740ba"
  name: "RewardNew (study family 9396b71f)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 21835
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xeba462aa6b835ef0f4a85f9b0a2beb3b1ce6bfe7"
  name: "BlindAuction (study family a5b088a1)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 21655
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xaa4737ba58625f442d0ca6018ea04e3830537984"
  name: "MinimalAccount (study family dd54c4b3)"
  instances: 2473
  list: "every address running this code at block 26,438,999 (2,472 by 7702 delegation)"
  upgradeable: "no"
  value_usd: 21474
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x0701202173ebf83eff0f735115497b5baa2afb8f"
  name: "unverified code (study family d9e443dd)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 21474
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xd22fff18b5e25ef1f07f8e194b89966652d44f5b"
  name: "BTCDMinting (study family ec85fa63)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 20752
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xba90158ab116ed37ab0c32128b2809d9b6388013"
  name: "RechargeContract (study family 2a030947)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 20752
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x76644c879d0b61ea8fbbf306879eb60a292ab45f"
  name: "Space (study family 4795b93f)"
  instances: 29
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 20752
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xa5646ba7f8fa7339f3de65d08d9667451abcb024"
  name: "unverified code (study family 84c7bf48)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 20392
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xba834c583231e79ea08aeb5e577317b105b10603"
  name: "DepositVault (study family 913f23ef)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 19850
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x5afe266ab4e43c32bad5459fe8df116dd5541222"
  name: "unverified code (study family 5c55c4d1)"
  instances: 6
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 19670
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xa74c0b5adea01df5a43a6c6b5e012dc8ed5d2687"
  name: "RaremintsERC721 (study family 1ebc9ede)"
  instances: 143
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 18407
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x794e28e72ae90cfc90e2e4ac231ce17eae1d3a1e"
  name: "VTScan (study family 01dce662)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 18046
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xd4001a2bee20bcad4775d47499a3fc3516e93a08"
  name: "unverified code (study family b97a8708)"
  instances: 87
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 17504
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xdac2977f505d38f4457a0bdbc965e6c4a6f7fa9b"
  name: "Kernel (study family f22d6bf5)"
  instances: 1907
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 17324
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x7bb0949ce7d3dee05b08ce182ee69c134b904433"
  name: "HangOutETHFlatland (study family 5f11075b)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 16241
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x4a7c43add8aecb827e2d3b0a89d5cd2d7b28539c"
  name: "unverified code (study family eacbd19c)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 16241
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x0afa5cd68d624aca5f8e588ea6295d89c2d14c14"
  name: "LendingPool (study family f8a41c68)"
  instances: 130
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 16061
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x01e0237fddb7e169dcc34c724d4ef09cd7c2eff8"
  name: "CloneableWallet (study family 74ac18ce)"
  instances: 1371
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 15519
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xda7fb91545545d044a9fd118f85a4f10a8d4c6b5"
  name: "CaptainzReserve (study family 18a9cecd)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 15519
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x12617f31a29dccff3790e4767239a7b00928d43b"
  name: "unverified code (study family e195b6e9)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 15339
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x3788657e6ab0efc4be4b824c84377396e5896821"
  name: "YgpzReserve (study family d9e74837)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 15339
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xe794ffecc16a8e5f5c7d7818322ba7fe41a63f72"
  name: "unverified code (study family 3a1ff297)"
  instances: 10
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 14978
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x374368fbc18a0dd3c8044bcbe9cc76f718e56da8"
  name: "TunnelContract (study family 360854de)"
  instances: 9
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 14978
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x7eeeadafb417d9627c49dbe91a4e0e48f167a536"
  name: "KubzWaitlist (study family 497cdea3)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 14436
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xd7ae00b91ba0b8e0240b22cd75fe447d177c260f"
  name: "OxidePortal (study family 72ed6916)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 14076
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x51382330280f5198ff415d54646cbea59593973c"
  name: "DCN (study family d1c51316)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 13895
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x49f743c2d3ba45fadf2768ba30844d0ecd548bc6"
  name: "SPLSPLGatewayV3 (study family 2abb0772)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 13715
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x4f011b623eda3b7ad64c0ee506812dc1b98e1a33"
  name: "BlindAuction (study family 2af85c62)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 13534
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x9480e0e7e2bb6c4daef1e3d7b8a2f8cbed8dbc46"
  name: "PullSplit (study family b270d664)"
  instances: 269
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 13534
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xbdcb49e941615668dad186d8a95043d666fd08a5"
  name: "unverified code (study family c0815231)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 13173
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x813892bc85940aa8d4ff2817650d58557df8774d"
  name: "unverified code (study family 55c90e07)"
  instances: 59
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 13173
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb735cc58d71deac4cfc46de68d3b04988f7d7b2d"
  name: "AccessControlledOffchainAggregator (study family 6b45b05e)"
  instances: 280
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 12993
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xf0c9651fcb5ec9ff8eb405ba50a1c5840c9f917d"
  name: "unverified code (study family 6df27152)"
  instances: 81
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 12812
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x8a80d5ae71b0f498c4688651f1405047f03f46f2"
  name: "PersonalCornerSale (study family d8334a0d)"
  instances: 5
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 11910
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb6728bff344e2109dbb3a0c153cad65ec4bdb736"
  name: "BadgeMinterV2 (study family fec5b277)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 11730
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xcbd5eb27176db6b261196ed3431a612e0b5a82f6"
  name: "NestShareOFT (study family 563a3bfc)"
  instances: 25
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 11549
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xba0152f01f33946742d1bb0b14015d8d8944c6ec"
  name: "Nettensor (study family 2ff8c4d5)"
  instances: 15
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 11369
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xab5ff3bc7343cca575ae0e94b79377182364458d"
  name: "GeniusVault (study family ce0561ac)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 10827
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x2cedd98d4ec9bc9cd51fc9ea9091da5664518dd2"
  name: "AltMint (study family fab8c226)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 10827
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x2b0e3fd77e061769904b71dce0ee336bf3eb1543"
  name: "OracleFeeDistributor (study family b6d60def)"
  instances: 377
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 10466
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xce0d7faf97604dcdb5b775b57198c0719c119f71"
  name: "WrapperLock (study family 87aa1458)"
  instances: 24
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 10106
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x20278fb9de54d037391b26532f3227fe224ab595"
  name: "PrivateVault (study family 61d5cfca)"
  instances: 245
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 9925
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x388f478199f45a67db6765ffcbe07f0197623678"
  name: "XenoMining (study family f84243d8)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 9925
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x0ac7b11449e3ffc2137dccb8371ebcee275e3aaf"
  name: "unverified code (study family 09a76b0a)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 9745
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xcfd3e772338ee65193e74eb0e70ecb228afb5df7"
  name: "MarketplaceV2 (study family 2327f2f0)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 9384
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb9c317cae7dd05ecb0c0925020e529934c96f84d"
  name: "AccountableAsyncRedeemVault (study family dd38ba2a)"
  instances: 27
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 9203
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x8608a089a9ec9a5483faa12a56e987901aad27ce"
  name: "MevWalletV1 (study family 4e559de5)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 9023
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xc6e82d96d2b0204e6467b67752817939ec6162e9"
  name: "TrufNetworkBridge (study family 810f9edc)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 8842
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x9f8d9bac13751bf6121e829eb5a70e44a025d64c"
  name: "AutoMinterERC721 (study family 6922ce76)"
  instances: 267
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 8662
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x58497fbd4423b8621aadd5fde04444d8d21d14f2"
  name: "unverified code (study family 927b5281)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 8662
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x5d4d384e239afaf120d18a115acc902f7a44d2f9"
  name: "AuthereumAccount (study family 18ca6e97)"
  instances: 50
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 8121
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x2d5a000e4c2fb1843ffab1fe94767d0fb45f179d"
  name: "Claims (study family 6fcf1fe3)"
  instances: 11
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 7760
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xc00c733702248aebdb357340dddda5c47500a35a"
  name: "AutoMinterERC20 (study family c5251f39)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 7579
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xced332d82394fc79eca4da5d128e01799a7aa351"
  name: "unverified code (study family 4873fc66)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 7579
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x9eafad32e91f59cfe3e764254e3ed163a98ab55b"
  name: "BootyClaim (study family ac165e57)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 7579
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x36d758c58bedf3f819bd102be4361e4fd0a33268"
  name: "unverified code (study family 0aed7ffc)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 7579
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xa5c603e1c27a96171487aea0649b01c56248d2e8"
  name: "MultiSigWallet (study family 216e3db7)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 7399
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x00000000046534fc66d46673efd54583bf8f38cd"
  name: "O2Settler (study family 4f56d5f1)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 7218
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x1ce81a8b3b321ebc6782edd99c5b0ac6a2f4adb1"
  name: "TradingVaultImplementation (study family ce8a294c)"
  instances: 45
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 7218
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x8e44663eee4bfbd9e46580d37973da90171cebcf"
  name: "AuthereumAccount (study family ee0b34e1)"
  instances: 35
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 7038
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x2a14b47e551288f3f5e35842970cc2bc78ceb47d"
  name: "EthErc20Vault (study family b3deddbc)"
  instances: 18
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 7038
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xbae1924736d8bab471e0e46960c55a092698d5f0"
  name: "TokenGatedAccount (study family c5a2bd8e)"
  instances: 188
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 7038
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x33009fc337c2d5c10c41b983e3965860fc8d1201"
  name: "unverified code (study family 1c4b1c3a)"
  instances: 103
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 6857
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb35c53c860f646231594a73946ecfd7907759009"
  name: "LinkdropMastercopy (study family e0dffb2c)"
  instances: 138
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 6857
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xdb0f8cc11d9641fbbf37ec1c216cef543810537a"
  name: "unverified code (study family 25134a84)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 6677
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x70f2202d85a4f0cad36e978976f84e982920a624"
  name: "DKGResultVerification (study family c50bddbe)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 6677
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xd665a161c687bb0818f53a0815e5b8b038d983d4"
  name: "OMNINFTLogic (study family 58d38680)"
  instances: 10
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 6677
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x7fc9c19ced994a8ef28df46be4c95772de5eeefd"
  name: "unverified code (study family a00c7986)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 6496
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xdfde2e8e3e48114ec492b397905fd2b1f014c936"
  name: "unverified code (study family bf1faaaa)"
  instances: 157
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 6496
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xd54ac8ce537d1a0e1a406f60704b61b65e3c1afc"
  name: "unverified code (study family f48c03ef)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 6316
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x17330b12d286e2b48d71bf84cab4469cf970920a"
  name: "unverified code (study family 04be25f8)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 6136
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x053513b3c1482da58725924ab168b6358dda66fc"
  name: "unverified code (study family 4e6eab5e)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 6136
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x15818fce7757fd827f3a1be6b68ca66d5d116302"
  name: "CyberVault (study family f4c3d903)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 5955
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x88ce0200850eb5579aeaaa64df3d7805c901bbb3"
  name: "unverified code (study family d3811243)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 5955
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x8094816e435b8ca77f2dfe240820c6c6ac784900"
  name: "unverified code (study family 78a87bfd)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 5775
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xc5124014d21e06208f2dcfac619d8a49484f1033"
  name: "BloctoAccountCloneableWallet (study family 3737a622)"
  instances: 963
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 5775
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb395c7f6e936e3d6ae96ab31e3f69ad37328ceb3"
  name: "wQUIL (study family de764465)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 5414
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x4391187cbcab7be1db403fcc71a2fc1be673863e"
  name: "BettingV2 (study family fb666473)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 5414
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x1c4a02fec7bc0c17cbc4084b362b192e12171196"
  name: "unverified code (study family f90e718b)"
  instances: 7
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 5414
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x1bc6388782796b54462ca27bbdb3ea335c0a746c"
  name: "ApeEscape (study family 3486d4b5)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 5233
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x2d035fc2d2147748edd3b3059e99bd0fbad929cb"
  name: "unverified code (study family b350786c)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 5053
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x4457ccc55820cadcd552694df26f41848f79e4b3"
  name: "unverified code (study family a6ef9a3f)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 5053
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x4d87bc56090ab96923a8a940fa5703a5811a1ba1"
  name: "LinkdropMastercopy (study family cf9048e8)"
  instances: 195
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 4872
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x1629da0810eb1ff313090e051f9a47e768353e51"
  name: "Archetype (study family b289ddf5)"
  instances: 37
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 4692
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xbab27afe3f6be3f39d70739eb846d53d7ffd0d11"
  name: "unverified code (study family 00e6ca7c)"
  instances: 19
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 4692
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xfdbbac8ea37efbab5e776e74e01a47a57d2d2ed3"
  name: "unverified code (study family 09b82a53)"
  instances: 12
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 4692
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xa7e55efa7177699544a11adc6c51b846c3bdc48f"
  name: "OwnbitMultiSigImplementation (study family a4064f89)"
  instances: 9
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 4511
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x2f925542d1689258be55f87e17fcd8b7480d76f0"
  name: "BonusDistributor (study family 8a47d6e2)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 4511
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xd5c93db749eb5e3e8c1e9311219985a54a0170b4"
  name: "unverified code (study family 64ecd791)"
  instances: 10
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 4511
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xa102b15710d0dd04ff269a8e13706f0a7ce573fa"
  name: "PulseSmartWallet (study family 5b696ec2)"
  instances: 332
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 4511
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb7da7b8ffca7ca4bff6b68024d4ba50ef337d049"
  name: "EnhancedVault (study family c6d8ed33)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 4331
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x82bfb461f3a718060e17af228541b54a18011f98"
  name: "Router (study family 7d7b8ec6)"
  instances: 31
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 4331
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x51e6775b7be2ea1d20ca02cfeeb04453366e72c8"
  name: "unverified code (study family 8014aea3)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 4331
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xff2618931df61f0cc22b3decc5bb0e4bd444ee17"
  name: "unverified code (study family 047762b3)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 4331
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x25563dfc1aa8310d1321b0d9d405e632ea9cb824"
  name: "unverified code (study family ac030ec6)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 4150
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x273567205659bc007124e228ed8505aa025bac00"
  name: "FckDice (study family 8d9bded7)"
  instances: 12
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 4150
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x9b58c0b0c2c9403e03a65bf7b7a2cb71b7b25ce0"
  name: "unverified code (study family e664b203)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 3970
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x0b20d5d59e14c71a948d55439019a2aaf74fa7b4"
  name: "FeeBoxETH (study family 768d868c)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 3970
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x42ecf9bde9078d659663da66b97c4823f762005e"
  name: "Native20 (study family 7fd26ba3)"
  instances: 5
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 3790
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x7c6c6b92364501827179164b5bee67082cc66721"
  name: "LinkdropMastercopy (study family f35b8199)"
  instances: 69
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 3790
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x9042314460be7690db3ad9c7c6f7d189d907a7c5"
  name: "FutureIcons (study family e12338c6)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 3609
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xf61cbe88a2ce59f816f1577903230239efdb274d"
  name: "unverified code (study family 0576ebc3)"
  instances: 62
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 3609
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x462b572089d3176c1b916aabe24bc23de459f5e1"
  name: "WittyPixelsTokenVault (study family be2d4251)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 3609
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb3bf6eb65f0fbfe4c75665db5b60d0e1b81957f6"
  name: "MultisigWallet (study family 68b0530d)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 3609
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x6eb0e558140025cb740f99979613a0876685f0be"
  name: "BlockChainCasino (study family b504ab88)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 3429
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xa288b938fe6d6bc70adb5c545a99985993e398f5"
  name: "unverified code (study family 9ab2da91)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 3429
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x941131e857a6100a37298c2c571c7f4c823caded"
  name: "unverified code (study family 7c54a2b2)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 3429
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x2ad3b1c08a30af13be89c63dc28de4e6cf076c2f"
  name: "TeaVaultV2 (study family c31faf26)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 3429
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x804298f4b87b011330fb853254ebe0cb84c77a63"
  name: "unverified code (study family 795fa4a4)"
  instances: 7
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 3429
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x2364134ef692d0c4a1ce809915f8f3c9be708d62"
  name: "unverified code (study family b83a5ae9)"
  instances: 18
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 3429
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x146f2ac6ffc0c953073598fb5d6fbe0976421d8e"
  name: "NNSRegistrarController (study family 3b0e2137)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 3429
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xf0b9e57528c1ebc2e104c7eb877a2af0fae7ae61"
  name: "unverified code (study family c7875b74)"
  instances: 265
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 3429
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x6b839666485b03964e68e4d21b9f359f301f0551"
  name: "Account (study family 8196b9d2)"
  instances: 385
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 3429
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x9ec6232742b6068ce733645af16ba277fa412b0a"
  name: "ParallelID (study family 19f51c6b)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 3429
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x27f06f6886b3adf40514ccd05cbaf745bb6e1eda"
  name: "DeoracleizedFeeDistributor (study family d8f737e4)"
  instances: 1866
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 3429
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xca44819097bc0d4d385e83e9e0708d92a979b6e6"
  name: "FairXYZDeployer (study family af121be1)"
  instances: 841
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 3248
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x15af685f93202ccd1e380a6e0b79563a3827726f"
  name: "unverified code (study family 8c4810c0)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 3248
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x9bd0474cc4f118efe56f9f781aa8f0f03d4e7a9c"
  name: "unverified code (study family 949b4867)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 3248
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb611401574061947abac7d2406711f115be22a6e"
  name: "AccessControlledOCR2Aggregator (study family 094a5af9)"
  instances: 382
  list: "every address running this code at block 26,438,999 (1 by 7702 delegation)"
  upgradeable: "no"
  value_usd: 3068
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb74172d5ab803799449df4d0ddd9eb15c7a12a03"
  name: "unverified code (study family 17fcf13f)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 3068
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xd21d15751ca9df6813ac5fb1ff366f05a28fda27"
  name: "unverified code (study family 21e8f447)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 3068
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xd4517dbeef443cf3d1d760abdd4268f12940c6f8"
  name: "TokenRewardV2 (study family 51b86c99)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 3068
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x784e6df1490ee2b49a293405e443e2f72279cb25"
  name: "unverified code (study family a4a9dc41)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 3068
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x603b6e737278eaa71a3a1630174f2452841a1c5c"
  name: "unverified code (study family b7bf95e0)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 2887
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x602e476c70feef069f5ba1c1b1138d13f6f60ee8"
  name: "LinkdropMastercopy (study family e5711031)"
  instances: 30
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 2887
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x63253e3352c0cae9f6ee64e61ed461ae23f9c8b6"
  name: "Attestations (study family 399c108c)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 2887
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xec4549cadce5da21df6e6422d448034b5233bfbc"
  name: "unverified code (study family 0f21c318)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 2887
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xcb57d171682817ad3c2dcab473770ac43725f65f"
  name: "unverified code (study family c24dc003)"
  instances: 17
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 2887
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xbfebc5ecac789643a61fadf15048a37dc9612dcf"
  name: "unverified code (study family 54b7a1c2)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 2707
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xd83e611af1bb562db4702fcca44f34a859950514"
  name: "unverified code (study family 037da16f)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 2707
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x31f8179866f10b87f08a956c14c5a377c83efb1a"
  name: "UpstreamCollectiveToken (study family 524c172f)"
  instances: 27
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 2707
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x6628ca85d822fb41ac745cb86bccb5dcbd90be05"
  name: "unverified code (study family 84eb89c6)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 2707
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xd58e8c1c83d598ad76b5f0e26b4a25cdb885d190"
  name: "UnderlyingOFTAdapter (study family e8f04f06)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 2707
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x1c67d8f07d7ef2d637e61ed3fbc3fa9aaf7a6267"
  name: "Archetype (study family f6f2e13c)"
  instances: 8
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 2707
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x752aeb29026a9f3bd7fbfe6dc7ed5ab35e405a6c"
  name: "NodeSetOperatorRewardDistributor (study family 4c2dc2bb)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 2707
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x34699696d60259bd5278518d043328be3c6179e6"
  name: "unverified code (study family a6348d82)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 2707
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x6bface5ec1dd1ba63d04d4ffefe12e72839659dc"
  name: "unverified code (study family 0586a373)"
  instances: 8
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 2707
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x1c80a8bb40d80679bb3615ad20215eec5a5e8ded"
  name: "UpstreamCollectiveToken (study family 14206458)"
  instances: 57
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 2526
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xf67bfdd598978d747ce6698540e65bc895da22d3"
  name: "MasterchefMasatoshiJuniorX (study family d59472cb)"
  instances: 31
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 2526
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xaa1b7ed99b4dc3a6bbf03654d85af89cfcaa49ed"
  name: "AutoMinterERC721 (study family 0bd5ca2b)"
  instances: 107
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 2526
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x4333ab5682cd4589330bd9cfcedd5e054a0e9d8d"
  name: "unverified code (study family 4d1dc785)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 2526
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x97405af0b849b5ef2d04f464b53480037b214eae"
  name: "unverified code (study family b49b28c5)"
  instances: 6
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 2346
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb8b1bc880cb6b2ab75418225f4fa4edc749f49ea"
  name: "GreyMarket (study family c1e47e40)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 2346
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xaefcf0171403deb760a2c3a2326cb492094dc4fc"
  name: "unverified code (study family a7bc2fd2)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 2346
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x1b5668ca8edfc8af5dcb9de014b4b08ed5d0615f"
  name: "AtomicLockContract (study family 92213bc2)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 2346
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x4ceb65c4f5b70d2afef97ffdd6c3bc1337f64697"
  name: "unverified code (study family a2c9e8ee)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 2346
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x39fbd1140cd1fc298f00c3ea64b3591de94c67e7"
  name: "BitEyeExchange (study family 5baafa54)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 2165
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xa2bf58cbaeffc76f8433b7b8492010ac8a51ef80"
  name: "unverified code (study family 76555dff)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 2165
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x9439f13a120bfe1420e010b4d946d6d0dc834846"
  name: "Wallet (study family 50f33a31)"
  instances: 273
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 2165
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb8cb3a53dbe2147f8d2be89af6932757163d0726"
  name: "unverified code (study family 1eadfd72)"
  instances: 8
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 2165
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x24218f732d5df76f9354269cb648e211907dea64"
  name: "Archetype (study family 70b391fd)"
  instances: 6
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 2165
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x701e55ccf6ba23706cdff5db26e30c72f5d59eff"
  name: "AlicenetMultiSigWallet (study family 96b42e2b)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 1985
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb5ae82b7677875875c5e526fb6bb2cfb325d9230"
  name: "AccessControlledOffchainAggregator (study family 7e64ca1f)"
  instances: 609
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 1985
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x333c9f5e2590dcdfcdfedf2e41023d7effaf44e8"
  name: "unverified code (study family 4b06462e)"
  instances: 5
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 1985
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xf06c0f48632dfb86921c140fc532da1ed3989e89"
  name: "unverified code (study family 4b69c618)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 1985
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb9879cd06c904c2fdbc75d03534929b5e842f3a0"
  name: "MemecoinFiresaleV1 (study family 9570ae10)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 1985
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x0922c267ff86ff17d8b20d2c4be9950e01a08d81"
  name: "unverified code (study family 7cb18973)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 1985
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xa274e2b88cb288bb6fab47729a5c13021e0dfe09"
  name: "Minter (study family 9775bd87)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 1985
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x3b8f6d6970a24a58b52374c539297ae02a3c4ae4"
  name: "Rabbit (study family 66ff2885)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 1985
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x54d75052225f16765cd9baaac24f5ca616852046"
  name: "PullSplit (study family a378d6fe)"
  instances: 218
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 1985
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x36d28b5c6af2ef894b5612c0563f39a3d9289c43"
  name: "unverified code (study family 29fe6f01)"
  instances: 107
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 1805
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xa8dd406bfb9cfc759eced17a9887f09addf913ca"
  name: "ScrollerAccount (study family 8a92c93a)"
  instances: 8268
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 1805
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x770023d55d09a9c110694827f1a6b32d5c2b373e"
  name: "RepoDriver (study family 25758761)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 1805
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x9e2c12d9240bf267fbebd510d47ac3abd4d9d9ee"
  name: "unverified code (study family 6a6626ea)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 1805
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xcaed49b77ad08345fba620a10ca4e4915a9c6f56"
  name: "unverified code (study family 9a77591e)"
  instances: 11
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 1805
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xc3f546ea8a2cbe7b8754505c95c05f81fcdf2c34"
  name: "CryptantCrabPrimordialMinter (study family 44b02ce2)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 1805
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x7f6f3012373b4fc7c33812402a880407eeac317c"
  name: "LuckVegas (study family a0ab4c69)"
  instances: 11
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 1805
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x3f15d92b2caaaacd865249ed0ff7aa413063ca41"
  name: "unverified code (study family 83f56cf2)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 1805
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb7d3f81e857692d13e9d63b232a90f4a1793189e"
  name: "Identity (study family 69199e45)"
  instances: 127
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 1805
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x128f4fbde99e0628d822f5082c164c82d9516171"
  name: "unverified code (study family 51d86b48)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 1624
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x808730240f0c7f650ad0fd33cd355ef422df59ce"
  name: "AutoMinterERC721A (study family 84893169)"
  instances: 124
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 1624
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xbc9fa7391d67fdae5b4b1ed4866c465d12e4127e"
  name: "ERC20Vault (study family 37bd711e)"
  instances: 110
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 1624
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x3583f79886aa6fcbd5d2575b3d27311399d447a6"
  name: "PushOracleReceiverV2 (study family 2e761ac4)"
  instances: 14
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 1444
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x74312363e45dcaba76c59ec49a7aa8a65a67eed3"
  name: "X2Y2_r1 (study family 0181b019)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 1444
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x5c24d7b4adfa7c6638307ce29bb5790338b9594e"
  name: "CloneableWallet (study family f0b83a6d)"
  instances: 179
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 1444
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x348119a721bf36efd7e2f7886ed3ada120490abe"
  name: "AutoMinterERC721 (study family 17d3e9ea)"
  instances: 481
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 1444
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb616cb62c7fdc02d7742a5ba58cd4f9603b8a611"
  name: "unverified code (study family 5184c14b)"
  instances: 326
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 1263
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb6e5f83b3d53d2c1e98d1e9d077def565e9347df"
  name: "CFHelpersVaultTemplatev1 (study family 43f84b41)"
  instances: 91
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 1083
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x2aae699ed04bbbd068f67a5b3c813ebb35f2c9e8"
  name: "GnosisSafeWithoutProxy (study family 6eb7b21b)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 1083
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xa811b6d840f3eed85a2e8b36e4738114bccd5e67"
  name: "unverified code (study family f90c050c)"
  instances: 3864
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 1083
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xdf75f7562aa976f96c76bec3942426a247df53d0"
  name: "UxuySmartLogic (study family 66614fc2)"
  instances: 624
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 1083
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x5bd129a87533f2902fbd4e68576aa844626b7f59"
  name: "LightAccount (study family 03bf1fb0)"
  instances: 5603
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 902
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x64c3edf7730b55bd55f9181b2f0bc5bf52f23faa"
  name: "HybridDeleGator (study family 9a2ecd67)"
  instances: 123
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 902
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x920bf81087c296d57b4f7f5fcfd96ca71582f066"
  name: "companyWallet (study family 08e10c23)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 902
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x7f44698c7d94ea548f830f156dc71069cc36bc38"
  name: "Sedition (study family 0d335599)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 902
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x75c671a40307826749b840269d085578ff756414"
  name: "GnosisSafeL2 (study family 0775fe28)"
  instances: 651
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 902
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xc7c216d955ead4214866179f20b32d9f7a588525"
  name: "unverified code (study family 1fd4b291)"
  instances: 22
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 722
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xbe634b030feaab661300667eaf82510a3a025413"
  name: "OneSig (study family 3b53e508)"
  instances: 23
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 722
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x896cb15542a50e084cb01138211daa110b1fe8f2"
  name: "unverified code (study family 28693709)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 722
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x2593c582b7a24d94ba0056b493fd4048bd99fc3f"
  name: "Portal (study family 2d092e82)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 722
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb677d6cd6186c98a80f117c5c8ede0994d945d67"
  name: "TokenERC20 (study family d15b20cd)"
  instances: 1110
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 722
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x415f5cbc212070719f607d18b620a6f7415dff74"
  name: "FishProxy (study family f35a72f7)"
  instances: 531
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 722
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x45d4ad700e1c1e961e55b4b5363c3c571435bc7d"
  name: "AyniStaking (study family 0d2e482a)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 541
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb94eb74361285c281fe84a18fd1d1c9f287c6e37"
  name: "RemoteEVMBridge (study family 40fccdcf)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 541
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x26206bfdee32128739f08aa12f57505a3a4ccaaf"
  name: "MultiBridge (study family 99787abb)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 541
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb78509ea22143e0753054478d67e2d765903da82"
  name: "unverified code (study family e01ef43f)"
  instances: 188
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 541
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x3384abd4c63810188e07524d86ff15fcef99010d"
  name: "BloctoAccountCloneableWallet (study family 03a06f8e)"
  instances: 219
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 541
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x1671556e9e1d563d3a2795a31923de12e33b2274"
  name: "unverified code (study family 8d7f2089)"
  instances: 1300
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 541
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb5bf8df8c116f35a02c7f348fc25c75abd2ace8b"
  name: "MintableOwnableToken (study family 2527beca)"
  instances: 1979
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 361
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xbce70f484b4312a14c71d8285a50260aeac4bb7c"
  name: "unverified code (study family 0e9fa910)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 361
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xc420f778d85cab30eedd314af965dd68541e275b"
  name: "ChainFundedPool (study family 6b86a9fd)"
  instances: 5
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 361
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x91ac260980952332226c7eba90a7945f7b3570be"
  name: "ManagedAccount (study family d4855157)"
  instances: 504
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 361
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xac12a5324cd7514b72cb10b95b3877bd570a75c0"
  name: "unverified code (study family a223192a)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x0e49f213201cce625295f8b04c02aed6b0138b7a"
  name: "unverified code (study family c1609274)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x38caf0349864babad8cc8a672418b9b15806b6d9"
  name: "unverified code (study family ae23ffa6)"
  instances: 134
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xdf97e5f22f7f1f457bc08600ea365b65b6b39bdb"
  name: "unverified code (study family 903c0ac4)"
  instances: 6
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xcf70e67a2c160f87d46792a868945bf2c0123ddf"
  name: "unverified code (study family 8c8161f5)"
  instances: 16
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x477a911f76c44a5d3e5e692c59945263f61426c4"
  name: "TokenPortal (study family f9d07893)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xa53bbf092ab7ea0a6ffb8aa5a9f59c9396b0455c"
  name: "unverified code (study family c25e286c)"
  instances: 42
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x8ecb522a1d48676a1f0080b9e575660f5e7657ec"
  name: "unverified code (study family 371cc97b)"
  instances: 35
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x22c6b2e3084ccbf980b472a18aa892c200b63dbc"
  name: "AyniNFTClaim (study family 047168cb)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x25cd94a4ac4211f8b91298f5a066d70d27f5c1ef"
  name: "FastPay (study family b7ca2977)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x44480f176110ee31b0837856fba41ce3a04d6f9e"
  name: "unverified code (study family 2cc64692)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xc4f4bb4cd9c2098dd1eb11e0055fd0e212c967fc"
  name: "unverified code (study family aa3d98eb)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xccb1138d047627552dd9f6c91b1218c10c933907"
  name: "unverified code (study family 11a35382)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x899b09fa62ba30e334adbf4a7d57b9dcfcd32617"
  name: "unverified code (study family 8222b273)"
  instances: 7
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x6bc9b0b0eb4490e0e1c3aa7b6bbf5aaf7303453c"
  name: "unverified code (study family 305bb568)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x20ea3be58cfe5c687a4bfd1ede068d8c456517af"
  name: "unverified code (study family 1df8bf4f)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb50ecdd02a79be4b8f8d1f1c0377d6c91f08862b"
  name: "WalletGardenNFT (study family b6a311a0)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x1779b8777b7c411428ccdfadc1ceae18f3ab4187"
  name: "unverified code (study family 711f854e)"
  instances: 124
  list: "every address running this code at block 26,438,999 (121 by 7702 delegation)"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x40056d114c87689e1724d8d19f3c75e2fff0e6ce"
  name: "unverified code (study family b41f3aa0)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xd62c71447bb5a0fda331a76e12456562842a329e"
  name: "AccountV3Upgradable (study family 7e80ede1)"
  instances: 13269
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xf8ab2dbe6c43bf1a856471182290f91d621ba76d"
  name: "UniversalBridgeV1 (study family 65ae3625)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb58b14bdefaf3cea66407e9ed15bb74c60aebefb"
  name: "RaribleUserToken (study family 793b4fe6)"
  instances: 2803
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb82a0803df982412daee9d82826395e3f0bed1a2"
  name: "AccessControlledOffchainAggregator (study family d46e2adf)"
  instances: 193
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x9a1cb9ee1abcd70a761724192b6b32c251f2f3aa"
  name: "unverified code (study family 142b21d4)"
  instances: 3737
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb88349328bcb41219b15e7d56c9d64692c8356af"
  name: "DualAggregator (study family 7b414d74)"
  instances: 46
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xa4f070629058767c0d5d70465082ec1b7d9ca5a4"
  name: "VerifyingPaymaster (study family 1ec730b0)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x183e9b247521fe2149516c98ce2dd0e2367bb6fa"
  name: "UTBFeeManager (study family a905692e)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xc1f46adf341145369eee9fbe0d84fa1cb0c24706"
  name: "NumeraiStaking (study family c04de267)"
  instances: 6
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x7f432c32231d1fbb397528431d6714acb4754795"
  name: "unverified code (study family 1bf370eb)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xcce758d01775d6c9fc822a4e33b70f019dbdc963"
  name: "unverified code (study family 777461c4)"
  instances: 5
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x2bd45d293f1e3b790f2923fb36782170b559d84c"
  name: "unverified code (study family 694a1849)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x26f77c6455518caf29a5414004c5a2ef441228b1"
  name: "SponsorPaymaster (study family 299f7893)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xd9ab5096a832b9ce79914329daee236f8eea0390"
  name: "ECDSAValidator (study family af33ec96)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb0999914b3de1be58ef2416af09bd2e7f8aad03c"
  name: "unverified code (study family 2f07018c)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xd1e6aae6c1d4c050c0763591150c5a90295c2fbe"
  name: "ValueETHUSD (study family 12bb3918)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x4789dc31aa8d22298275292f95b57dd8526c7955"
  name: "RiskRateOracle (study family 3d372378)"
  instances: 5
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb717f3b4c4d3aa40da1ee9c92f3d5e291bfd8d05"
  name: "SponsorPaymaster (study family cd78360b)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x1644a664b8d97957da6a8284d626c9aab93cb486"
  name: "unverified code (study family 7b468ad5)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb8e21d2ad752c7fd562b95f84d61a377d7b1411a"
  name: "ValueWBTCUSD (study family 7f5c8077)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x578f916aaa85a52b846a0cd3b84387be3a98d829"
  name: "PendlePTLooper (study family ffb57bdb)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x9a1d0059f5534e7a6c6c4dae390ebd3a731bd7dc"
  name: "ModuleTrades (study family 6da31684)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xd37a60e8c36e802d2e1a6321832ee85556beeb76"
  name: "CommitStore (study family 4a59acac)"
  instances: 13
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x7a37037c085584ee7dad50cd6a4ade1181c65b3b"
  name: "unverified code (study family 0a213e84)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xa6571b73489d4ebfa269a107208665df7c80aef5"
  name: "BridgeController (study family 87ffbc11)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x677ef7152a6c620d37fbf57d4882ec2bc53e2ccd"
  name: "NitroVerifier (study family 3efe18a9)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x366d88f03b8ef34eb49f32a927ff6e1609f694f2"
  name: "ECDSAPPSOracle (study family d482402e)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x000000000004598d17aad017bf0734a364c5588b"
  name: "unverified code (study family 084bc264)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x1b41ffaca6450020e0e6c757db91fcbef327dce1"
  name: "BronPaymaster (study family b2279754)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xdd233d8721f92c80fc29fe683dbd9e326207a6bf"
  name: "unverified code (study family 8791bc2c)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xc69f43741d379ce93bdaac9b5135ea3e697df1f8"
  name: "BlobstreamO (study family db7d5d36)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x9835a4e15fd34f8d3217beffaa011fab9b8bea0b"
  name: "PendlePTLooper (study family 15182103)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x36a8e347006e151f4a0e9559fea239439611777a"
  name: "RemoteDomainDepositor (study family f68e5698)"
  instances: 6
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xc04d73ee602179bc426791babe058aea406da3cf"
  name: "unverified code (study family 5924eda1)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x9a1d00899099d06fe50fb31f03db5345c45abb36"
  name: "ModuleTradesAdvanced (study family d4da0da5)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb62061b8c48afc6c978579eb4f466987123e3621"
  name: "unverified code (study family bd6c999d)"
  instances: 49
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x4443e09a19c5fda8d09f797821b322358e5bcf90"
  name: "NotusPaymaster (study family dd38d053)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xb9635eaa3c29c4678c5bd80d0b93e2a09432291f"
  name: "RampImplementation (study family 8ef474dd)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xc47e67676551bb74cabe6f1925172a8035955b82"
  name: "EcdsaOwnershipRegistryModule (study family 2635f88c)"
  instances: 5
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb59e7df2b636a66bff03ca554407b920bb150109"
  name: "unverified code (study family 8af55ca1)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x2c1543b147626f887faea0b6514593e22521d7ee"
  name: "TransferModule (study family b0278dd4)"
  instances: 6
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb7b84725790b8a179bb310aa51548ed2e6872af7"
  name: "LightAccount (study family e6aa3f41)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xbc81091a00e98a7fcb969102d921e85bfb4bfcbd"
  name: "ChronicleVAO_Galaxy_CLO_Consumer_1 (study family 9aea754c)"
  instances: 28
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x2d001ccffda16e6f1b59f94dfa1788e6ee8d8e7e"
  name: "MultisigCommitter (study family 77dfae21)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x5a2eb0cdb4aa8253924a488a77edfd24bb64407f"
  name: "Relay (study family 9711cae7)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x0b57b7333c43fe900d17a81bddc67c88c825afd6"
  name: "TokenContract (study family e3ba62c4)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x4555ac13d7338d9e671584c1d118c06b2a3c88ed"
  name: "unverified code (study family 10bf4481)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x183e3171eef801ce2a29fd48b3b21188f241875d"
  name: "SuperVaultExecutor (study family 244c0ef7)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x9d58779365b067d5d3fcc6e92d237acd06f1e6a1"
  name: "ArgentModule (study family 47e24077)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xa57016b153287da52b869f2a64dd73e7b97af6c6"
  name: "PriceFeedOracle (study family ef35b1fc)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x251e4b432d5c69d8f4d3d31aae4ae4f3c4816fc7"
  name: "RelayGatewayDepository (study family 57b6d95a)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xbbfa3b50b6b0fc26d5af0abcf5afb830fe897288"
  name: "StaticMessageIdMultisigIsm (study family f69c873c)"
  instances: 28
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x27d7b391e493bcc7fd81d317b0ac2e013f0b1ad6"
  name: "MultiSigGenVerifier (study family d2f0a7be)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x1ac760d5c985c635c18a3e5d9c5685f1ef2a721e"
  name: "ECDSAProofSystem (study family f8e7017d)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x3954a5bf350cb660a681152d7a30eb2124041f99"
  name: "unverified code (study family f0fe62ff)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xc10f8792926dc85feded347c245d41be7818cdf0"
  name: "unverified code (study family baac5e89)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xb7baaef3e72736d1fef03eea8ec3224c649e1d1b"
  name: "GnosisSafe (study family c09ca34d)"
  instances: 73
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x3bdb857afe9b51d8916d80240d2ade40d4d3f2f9"
  name: "FluidkeyEarnModule (study family 871a1f6d)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x47f00fd16ccfdcec08617373f524a5e68ac8a29a"
  name: "unverified code (study family b5fb6a6d)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x07696dcab55e62cfef953666b29fe1970518cb00"
  name: "WPearl (study family 7652d82c)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x4f8916cc1d9307364f0343e0a1e9c658b79daa46"
  name: "unverified code (study family c82dcacd)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xbf3e143e5076963a6dac3a522e5093ad88fbeae7"
  name: "unverified code (study family aad2124d)"
  instances: 10
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x81e5a46e60d5bc92b2f98f13a31793a51cdc56c3"
  name: "unverified code (study family 9d9cc3c7)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x9d8888ba6c653f315606bfb494eb679fd02000cb"
  name: "unverified code (study family 59850547)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb5fceefbb04ca0cdef87038be5a91f296229b54a"
  name: "OxideAccount (study family a6101ad8)"
  instances: 948
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x4773878c6cb3a1318a8c8d97edab3cc38320e9ce"
  name: "unverified code (study family f0c8961c)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x0bdde46b81c093b02a35591ade8d277cc68b6d69"
  name: "AccessControlledOffchainAggregator (study family 6e45cb03)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x26fdb12dfc046c116a5077fdaa3fd6c9e9ded091"
  name: "MultisigCommitter (study family 1eb7dd57)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x7408b27aa182380224563c3ba337cfa35f3231b9"
  name: "unverified code (study family 84eb3b59)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xc4f2704273598d51a0ec76a31c12553ec8f5a891"
  name: "DelegationContract (study family 49d1545a)"
  instances: 19
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x5f522c617bbab774027e11d417360b768e06f494"
  name: "unverified code (study family 7bbb6c79)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb933a1d21354102d32c32db2c62a62e416512631"
  name: "unverified code (study family bbacd88f)"
  instances: 22
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb84b0084895cd1d51152eda88ffc9459fec55a88"
  name: "unverified code (study family 2306de05)"
  instances: 40
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb5ebdec6da02119dd7beb4782c181261f8bfecc2"
  name: "Controller (study family 3f066d34)"
  instances: 9
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x232628c79982337ad0e576759d218640b382f230"
  name: "unverified code (study family 73455ae2)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x3bdb21ea8793acbf0ce18954865b7572694d037f"
  name: "KSZapRouterV3 (study family 2f9f33a9)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x92728968236cf856503ac4a15c21ebf1d7539fe7"
  name: "unverified code (study family ca78cca5)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xbdd3e80c97d443314bee0af74c903863f7dc319d"
  name: "unverified code (study family e4a7dee1)"
  instances: 22
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xbf5ee7c3713850e458a6d4b810dcf45d6080bd7e"
  name: "unverified code (study family 8c4245bf)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x980df04b4e8c40bc728198f998459700d97f083b"
  name: "unverified code (study family e510516c)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xd99571cc34bfc41bf469a8f346db4d32d7e957e1"
  name: "unverified code (study family 0f5943ea)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xc3ba43ff0a8e006c2aca1d9fd6443540b51372fa"
  name: "unverified code (study family 5ef3a079)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xc93803e782df6b94d757623b3116a969ce5fb936"
  name: "ScatterAggregatorRouter (study family 359de153)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x536384fcd25b576265b6775f383d5ac408ff9db7"
  name: "WalletFactory (study family 51b88864)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x94182a281bab6f36077c77a9fd8f6fc63bfa0492"
  name: "unverified code (study family 188f6ffa)"
  instances: 27
  list: "every address running this code at block 26,438,999 (21 by 7702 delegation)"
  upgradeable: "no"
- code: "0xc6d27843426f31ef378d0c2101384519811933cf"
  name: "unverified code (study family 7ef4cef6)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xc4c189fd5792197994c4acd9fad5244b6a16e056"
  name: "unverified code (study family 632c9e7b)"
  instances: 8
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x3f1603602e870bd4c6953333b35ec988eede4f9c"
  name: "unverified code (study family a74b8130)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x08ac2e0e625f0a2e5dd750325156512c01600457"
  name: "unverified code (study family f151381a)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xc295c2cf67c2f9811f9815db5cf0f99e0312dcf6"
  name: "NameRegistry (study family 301e717e)"
  instances: 5
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x4a92a3456818004ab8872b41beabdb6dfe9210c9"
  name: "VestingEarndrop (study family 8ac28c94)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x259144fba30da78075d07ecbbc3e36de5c6fd992"
  name: "unverified code (study family 7c63fe06)"
  instances: 5
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x134ccaaa4f1e4552ec8aecb9e4a2360ddcf8df76"
  name: "SyrupRouter (study family 2f946ab3)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xd400341aefed0bc75176714cfde82e8bdaa2d3b8"
  name: "HarvestingEIP1271 (study family c9134c07)"
  instances: 5
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xc368f93e2a3b24e4f41e26166613ee530d921b56"
  name: "WithdrawalExecutionPolicy (study family 1fc641d4)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x14413419452aaf089762a0c5e95ed2a13bbc488c"
  name: "EthCrossChainManager (study family 6d1aa67a)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb46b4773c5f53ff941533f5dfeffd0713f5f9f8e"
  name: "SuperValidator (study family 38be5710)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x846d961b1627212e070e0ece95f2251e73b53239"
  name: "EIP712TypedDataSafeModule (study family 7d342935)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x0cb5ceb2dbe1d42ae9791b1cdb4f11fde9e71675"
  name: "ScatterOfferer (study family d3ab88a8)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x46c2227c1d9fdeb7b3b85b71872c188314f65bdf"
  name: "PowerStaker (study family a57bf528)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x3d3158ea79a204aadb379f6a77fd3fd8fad5bc03"
  name: "unverified code (study family bd076bbd)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xd828370f26b30652a675b23057b50e9701cb07ae"
  name: "ChronicleVAO_Superstate_USTB_Consumer_2 (study family d55ca758)"
  instances: 7
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb75bb4c7aaacfa400758bf024c2ffefe17c9cbe3"
  name: "unverified code (study family dda85e24)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xd9d78c80b70bb432caf6920f8a0575cd7079a396"
  name: "unverified code (study family 975cebe0)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xc4c70d6f74437d153416f7fb68173e4cd2235e39"
  name: "unverified code (study family 9797f0d5)"
  instances: 33
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xbf25d8d83dfc1fdd094c58b177e8d3ff37cb833b"
  name: "unverified code (study family 67db7ba0)"
  instances: 12
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xf58cf2421e39a572f821cddf08bdf6dce673dc74"
  name: "unverified code (study family 88d5bb0c)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xb781595ba4dd7ae937a7b7890fae10662be653ee"
  name: "ApeBond (study family 62e00230)"
  instances: 14
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xd579979fe7478f13ee85a792023fe050b2df0140"
  name: "unverified code (study family 66bc1c85)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xbe9cc5cdbb6ae6a4378e2795099c5e951d3ec5e4"
  name: "PendleCrossChainSwapHub (study family 9792d0ac)"
  instances: 6
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x33d136c1501709ee020d7a8ca56d44dacb15e227"
  name: "ForeignAMB (study family f8c3d295)"
  instances: 13
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x3db744585f892dc77750b2f4376b4fc1dd66d510"
  name: "unverified code (study family 6bf5d9e2)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xbfc88418abb3054c16c21ba404387751a114847d"
  name: "BridgeAssist (study family 1783b96d)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xd66ddc6484f93422016b4c2c33baf711bcfb0ab4"
  name: "unverified code (study family fe5a12cb)"
  instances: 13
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x52c1f22b812f4b9a02d9f3b81e8c49bc081e3035"
  name: "ECDSAValidator (study family 371a0e74)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x0000000049c4957e14395934c8952cb00575f9c2"
  name: "unverified code (study family 286a540f)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x021890b9b6c1e77f5ea7fb8639336ff3a17849dd"
  name: "unverified code (study family d68ca87a)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xb942ec944a432ef9985cee4abc6996ad151a79e0"
  name: "MixinPaymaster (study family 178bb3f8)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xd275f00ee101d0d498b26e7ff73a66443f898f18"
  name: "unverified code (study family f16ce629)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x0bbc02ef7ce79a820b7edda8d5d409ae7615e636"
  name: "Crosschain (study family abfe2067)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x15477048dc9182717a560465ee9547cd11d51c39"
  name: "unverified code (study family 79f3f054)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xff9dbc41559ad67c8d885ac22e41b5a528f3962c"
  name: "unverified code (study family b56869f1)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x3ba17675f0d319c89d70722f6eb07790df0b254b"
  name: "unverified code (study family 405f8e89)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x31c628a15792331e1ec8ac3bbb5fbb56ad9cca02"
  name: "Exchange (study family 6550c9d1)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb9c6d2fd321a899de14e71ae8abeb0da0fef5f68"
  name: "unverified code (study family 845c32cd)"
  instances: 23
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xab3d96237328385f8988166c6d7788a63f48dda6"
  name: "AssetVault (study family 14989406)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x3cd98baef599923813f72169d3b0f24567b13639"
  name: "MultiBridge (study family 2966dcfd)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x10980d8f4542ebee4ef972fd909eee3d472294e9"
  name: "VaultHandlerV8Upgradable (study family b8b7116a)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xbd0d691d2784975d7c3cd9f12e37c7b3fb2027c2"
  name: "MultichainWalletMaster (study family 77ac903a)"
  instances: 26
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xaafefb601445063f27cf4cb621201b84d6fdaadd"
  name: "unverified code (study family 64e7994d)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xc8291c0603c8d06ae3c56be036dedc57c3b57169"
  name: "unverified code (study family 5988adb8)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xddf2a6644c1750e63eea74619c3b76535cbf5e0c"
  name: "FamilySpace (study family ded38fe6)"
  instances: 24
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xf9a3762563e34c77778e834b276ca2854688f9fe"
  name: "LightAccount (study family 17712074)"
  instances: 20
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xb9b4690c0b5d93c7256964c8f07a4e5ff7f7ea5c"
  name: "unverified code (study family 087720fa)"
  instances: 7
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xc4d0cf567f699252d4f2ab0aa918332933f21347"
  name: "Withdraw (study family 4b665faf)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xc7a2e29b7ef4543a3e7c50057d83bedfcde2fb0c"
  name: "unverified code (study family 1aea8b1d)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xd730df52f2575da8560d02d84fe39fbf518f5497"
  name: "unverified code (study family 5fdbad86)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x24a600b827a41e29be4b332829b5eb47ff282e92"
  name: "WadzActionAuthorizer (study family 33c55697)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xbbef2b8f30f72373f41238efba9c245ccae88245"
  name: "PolygonDataCommittee (study family 75848bf0)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xbabfb4936976573a9494a396ea078e6ecd926574"
  name: "V3DutchOrderReactor (study family 60cd266c)"
  instances: 6
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xc884a55146d8aac61982bab13bb505dbc7b8d3cc"
  name: "unverified code (study family 9869e9cf)"
  instances: 11
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xc927cd5aa9cbd163603da5030889860c72586669"
  name: "unverified code (study family f4e97349)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xd219ff97329ee70a2eb5baaef293ccd10a05809a"
  name: "PolygonDataCommittee (study family 92df77b5)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x077e2dedb33a40acbffd5a6d29bc88dbe8ca7a86"
  name: "SingletonPaymasterV8 (study family 4872c60c)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xac49c7ee67b6afe5f9693089e4b8f171d0432605"
  name: "HyperlogueCreator (study family e9541423)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x95053e3c177d99bccaa314d668b9b080f4a6de79"
  name: "unverified code (study family 496323aa)"
  instances: 5
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xa868b94b286e69c4c21801672e4e19ff3ce95192"
  name: "unverified code (study family 283463d1)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xc3a5d5023b9f7b0aebe9dd49b9b4d02c6877061f"
  name: "unverified code (study family 49484bc4)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x8e351774b73248e98adc053bf30a5e7d5c2105c7"
  name: "unverified code (study family d3736c65)"
  instances: 5
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x9cb9ae7480ee98a41373100d4304194043f02c9d"
  name: "unverified code (study family 0ac33ab0)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xce8635e5d0a0d2e9b9b8919d3a5d82ee390cc3d6"
  name: "CFHelpersVaultTemplatev1_1 (study family ea6ede94)"
  instances: 33
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xbfb1bd17d068d1d395942392b8c02853c6bafdc8"
  name: "ThreeFAdapter (study family e251f7ac)"
  instances: 5
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xc9dfef6702fcafde7d6aae08967a0848a5248bdb"
  name: "unverified code (study family ba6eaa6b)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x29ac686ac80eef807cce19bf1b7bb3b5b1b95b8e"
  name: "unverified code (study family 3df0c5bd)"
  instances: 15
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xbc9ea21892737cee8f25b1531d60354204706e9a"
  name: "unverified code (study family 2f03c691)"
  instances: 8
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x78024226f0f962a981d914be5b7a093cb064b6e9"
  name: "unverified code (study family 7bb7c36b)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xfc5be8ab7e408b850be734a9a97068b42704b9f1"
  name: "unverified code (study family 7efb22c1)"
  instances: 74
  list: "every address running this code at block 26,438,999 (73 by 7702 delegation)"
  upgradeable: "no"
- code: "0xb6c220d5fb70ff88a7490d47bc4c2000f74de78c"
  name: "SalesOrderUpgradeable (study family 35a259bf)"
  instances: 6
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xca9bb3fcdfb455962ee284a189cbfc2262970b39"
  name: "SuperDestinationValidator (study family 7818b7e5)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x8490c7b1f0a404d32cda9f9e5665c8bda66d0469"
  name: "unverified code (study family a43a8ac9)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x818f0804fbb93f4279529fd7474db6d7a65167db"
  name: "unverified code (study family 9c7d22d2)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x300777d580e4c6823e533defdcada788413cfee3"
  name: "unverified code (study family f123f01c)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xb5bc367e74815b073582dbd7f264009f9f3dee12"
  name: "unverified code (study family 04f08e7d)"
  instances: 987
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x113573c68c0b04b889672f76c9c50cd47fac1a13"
  name: "unverified code (study family 6303564a)"
  instances: 8
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xc9a87d3df7e0ba741372558b13fc45770810af39"
  name: "unverified code (study family 4ccd0c60)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xa6a02d654c9a941eb95e8a925655903ad77bbe6b"
  name: "unverified code (study family 2dae6051)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x14c88431d0f0d487c807c3c2e1c0ad09e8349f6b"
  name: "SubscriptionPayments (study family d1709b23)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xcf24efe3bad6bae085c7402c29859023c3a7844a"
  name: "InvoiceFactoryEVM (study family 397c9128)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x1e169a45fc37359e7b57d98402b23c10131546e3"
  name: "unverified code (study family 2c23649e)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xd5463f233c18ba404a79fe9da202d086b5599fe7"
  name: "unverified code (study family 14f212be)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x60b4c271eed9f03f2a37796ca97387f87e97ce89"
  name: "unverified code (study family ba7aa6a4)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb967b04c26d83e7f082190c84a789c30aeaf49da"
  name: "unverified code (study family 334f3bcb)"
  instances: 48
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xbaf948657daf4315098644c9b7c880146174ff4e"
  name: "ClaimIssuer (study family 31b465e6)"
  instances: 38
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb5896b4673a8755642094aabdc6d07de4e15a187"
  name: "DepositWallet (study family e1bb42c4)"
  instances: 33
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xbc51cb0b9b21972312450fd1b4c0451735dff0b4"
  name: "unverified code (study family a4be5529)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xc437df90b37c1db6657339e31bfe54627f0e7181"
  name: "CrossChainBridge_R2 (study family b9479c0d)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x316dffe3df247ef6a334854d9a92d841a7e329fd"
  name: "unverified code (study family f737bf9d)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xce29c86c9e559eaa10fb824a75566445095d417c"
  name: "unverified code (study family 3cb6d0db)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x625d78dbdf9d7cfcc9499bbe847fd29b1a8b7ed5"
  name: "unverified code (study family 0d310fa1)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xd901298e6855a909831d76ddfe69f8dcf2bd3828"
  name: "SignatureRewardDistributor (study family 90e8756f)"
  instances: 6
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x0eeb3852f67e6391454df07c7ebda9b30da444e3"
  name: "HelloBridge (study family 1a318bf5)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xc39e0302eef1cd9ec05fd9eb27188a6eec1d26fd"
  name: "ERC2612Verifier (study family 11635914)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb58d4162f9d8312f152aeac17af12b62fd235673"
  name: "unverified code (study family e69b8951)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x1eca6b8e7a5da3bb39b89188737f35e4fbfc7b2e"
  name: "YugeSale (study family edc84cf4)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x974a1f9fa9c59874ea77221c9e52bb5a5ed03429"
  name: "unverified code (study family 34e5e0d9)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x65c37f752d14d58cb3cee9ad1524db2bccc19498"
  name: "BSKTUtils (study family e9e526a4)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x26bf6056cba643a1f0c66d9f464e6d23a4d91930"
  name: "unverified code (study family 06fc8f0f)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xa4fd0dd242f7e51caee98de78d93d5b717b542e3"
  name: "SingletonPaymasterV7 (study family a6775737)"
  instances: 10
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xe052c9cfe22b5974dc821cba907f1daac7979c94"
  name: "Sponsored7702 (study family 81d3efe3)"
  instances: 3
  list: "every address running this code at block 26,438,999 (1 by 7702 delegation)"
  upgradeable: "no"
- code: "0x72107883a6df4d59662329e14f2365ba853d82c8"
  name: "unverified code (study family c477c387)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xc51552d3b5766f6117dbf0a38530f3630c92f273"
  name: "NAVOracle (study family fc9cf0ba)"
  instances: 11
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xba53172b83e62c9fc0157ec96223d397776a1a31"
  name: "unverified code (study family 935c64b6)"
  instances: 8
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xd743d5b09ecea67880c4bc326a18a874bafe246e"
  name: "unverified code (study family f80da18b)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x1c9327f8698860e4b57e1c4ffa43b292bc6a930b"
  name: "AlephVaultSettlement (study family b4328a40)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x10a0847c2d170008ddca7c3a688124f493630032"
  name: "RelayerManager (study family cde46488)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x789d89ebb2a882343044830a9d4d072737ffec92"
  name: "Quote (study family 10b3162e)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xaeefb95c15330aefa29ef71a432e9f9cf9b3bd0c"
  name: "unverified code (study family a5bd9ea8)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x626784d4af1e8d37b13b42f5fd2c9959c1711952"
  name: "unverified code (study family 90ce4a9e)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x3564eb5e11033d43ffff8edb58dd3d23eb932f00"
  name: "unverified code (study family e745191a)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x88e7dc15e79fb8531c7a853843d14c634b6c5bca"
  name: "GMIssuerManager (study family e2314373)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x534b95e0780b434026c8a9bfcefa7a9a4df846cc"
  name: "unverified code (study family bb3a9781)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x73731dacb1ee5906aa515512fcda2074d690487a"
  name: "MagpieStargateBridgeV3 (study family fa0e00bd)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xbbe830d5b5377c1bdedd94e87c0fb1cfd45f7555"
  name: "LegionTokenDistributor (study family 90288969)"
  instances: 74
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xbaea00c4c9bd79f19d71b6a6461c7086f4b4a363"
  name: "ForeignAMB (study family cfd35726)"
  instances: 12
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x44aadf7d16c96e34d2ba0b4d15eebd4792107bda"
  name: "PhalaClaimer (study family 30ea409d)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xd43a70d54e907b339bf77a31da25d30af4b4c73c"
  name: "HypernativeGuard (study family 1f6e24ca)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x3b1a5da88b7819f40092ba8707a3cd8b9bc5cb56"
  name: "GlobalRegistryService (study family f33edf29)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x2cdb0e0ce0ceee4c788f243698694d241df1655d"
  name: "FacetEthscriptionBridgeV6 (study family 34e2135e)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x2b255f240cca3b8581770c7c22dc1314eb3fd744"
  name: "FeeManager (study family 185db9f3)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xd83c448854838d4f50b9df1fa1afafb1f5483fee"
  name: "WeightedECDSASigner (study family 831d86dd)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x2238f90f51ab021c06cb28bd98f5f1ce04cbdf5c"
  name: "unverified code (study family eb1d0729)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x44d016b20a0c8f0a3791b3ea10ff09af0ece1dc2"
  name: "unverified code (study family f5654fc2)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x5ed753abc1c08668b5f2e706d69dc5db2799a4a6"
  name: "BatchSignedERC721OrdersFeature (study family 313953c0)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xd2a50aba1d93569726739808e9f69985ca222d40"
  name: "MynaWalletAuthorityManager (study family ec3bab3a)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xbf151b7be7208afb5f13040a2308bb84b55f5044"
  name: "unverified code (study family 0bd524d1)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x2a64caa7f12101f3410a7ef8dde27c0b4bd4eb35"
  name: "unverified code (study family 6dfaf498)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x930333dc07495977b3e075b57ee0cf3effd399dd"
  name: "TestCans (study family c6281a48)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x671df9ed06982b5c572bed6fa8d11d4fd532ef2f"
  name: "unverified code (study family 97e81932)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xcfc87f6579bac55cefd180165777abaa1847ffbd"
  name: "unverified code (study family d20e435d)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x0b1866692f2c4770c3fed4376090f4daec90c00e"
  name: "unverified code (study family b7dc5f9b)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x4237f965b1646d28303f33925f14d8e84c27b46c"
  name: "GatewayVerifier (study family b4e8682c)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x4dac8619dfc77361a0752faaba24f5df7a82e8f2"
  name: "unverified code (study family 4bd26e0b)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xd77b76a65a19715bdcb5ee223928af2919836a3e"
  name: "Federation (study family 366cdfb1)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x0cd548b851b330a97694a1f107ba8e1a8291cb61"
  name: "unverified code (study family cf2982ea)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x1ce2b1be96a082b1b1539f80d5d8f82ec06a0f9a"
  name: "BytecodeRepository (study family ce815443)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xbb0b08a9bf9b31185c5b925b1e32baf2d29e1b69"
  name: "STOFactoryManagedUpgradeable (study family 44610ee6)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xbcdccfa13c44c7c31f837cd5957540add2ffd8ee"
  name: "unverified code (study family 86c3174e)"
  instances: 10
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x3d93a07cda938a22ddc9b5c1fe4ea8fee3121b5f"
  name: "CFG (study family d5d2e8ac)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x38bd4363b7cd4040fac6eea5ef5d38e934aebd65"
  name: "unverified code (study family 78044b3c)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x4f624a90ae152e524b12258ce6aa9df6ed70ddfb"
  name: "unverified code (study family aabcde3f)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xa2232202443d852abf3e472877b94c075221faa6"
  name: "unverified code (study family c6cd598f)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x368e7478ff8c88c9002c32e1f576fabe2e9ddf7b"
  name: "SecuritizeOnRamp (study family 7488210b)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x100567077281235b446c81f0e2bd54c21979610d"
  name: "StrategyCefi (study family b35719ea)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x05d911538a95d955376b589a666578cb046d3307"
  name: "unverified code (study family c5f22fd1)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xbc6f75192f9d7e85421c28442f963b4e8af298dd"
  name: "unverified code (study family 9e7f43e4)"
  instances: 38
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xb802b54f8c8a16e68cf136bdd556d949710614e7"
  name: "MultiSigWalletMaster (study family 144eb546)"
  instances: 36
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xc18483bad1918e5579ad9983d80895e691a6cbe5"
  name: "unverified code (study family 2dd212e5)"
  instances: 8
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xb645ba7646a806d3aa0e383aac93d4a333ce92f3"
  name: "CHFD_VASP (study family 34b83e73)"
  instances: 8
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x0a32204744b0768290e28ec303a6194a7396c6a1"
  name: "unverified code (study family 497a812e)"
  instances: 7
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xc34e78005ff0b14893d94ca91d6758d15c04f8f7"
  name: "SingletonPaymasterV7 (study family 00f6d1a2)"
  instances: 5
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x06f6512a2f08df9f566b0843ee27326a688883b7"
  name: "ForeignBridgeNativeToErc (study family b4151b62)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xd585b4ab9d002a9b2e44ef0a40e914fef6c06ca5"
  name: "SubscriptionPayments (study family 3d3b16b8)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb76a65de9cae1df779b9bb3b328e48dc0864c73c"
  name: "PaymentSwapBurner (study family 1a1c9e67)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xb7f9a206ae8eba2d99e9fe4de7205202a3e9d755"
  name: "ClaimIssuer (study family d65034f7)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x103675510a219bd84ce91d1bcb82ca194d665a09"
  name: "TransferManager (study family afb78a1b)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x17a1905143166f67270e02f390083062e1f6b941"
  name: "Withdraw (study family c263401c)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xd08e8bb3d754641bbf6dd2e797b1b52703f00486"
  name: "unverified code (study family 0c5ef9d5)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x21d956eaecce336b714150b8cc8ce36905306bda"
  name: "StakingUpgradableV2 (study family 5d083b74)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x4b89c78aa42822e1bd24865a4fe44a138cac590f"
  name: "AyniStaking (study family e095da61)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xb80e0dc1f21670cfcc7c08a4273431f8bd2b4c91"
  name: "unverified code (study family bce83885)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xddc6625feca10438857dd8660c021cd1088806fb"
  name: "unverified code (study family 80caea2b)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x2e311692d5cffc0c72ffc8b31a845707ccc17c0b"
  name: "unverified code (study family 70c410fc)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xc3f44f5cbce27e19f02e66d0584b24767bc6c8be"
  name: "RateLimit (study family ccb0ad79)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x3eeaa85daf1433db18b243f10df888128bdde6eb"
  name: "unverified code (study family 63ae9ecf)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x0d257995f29c95ce12c697487f5d456e7c0165a5"
  name: "unverified code (study family 69b22718)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x457f785000ca495fae63aab38c9fc4b2965b106a"
  name: "RestrictedActionsGuard (study family 505f9fd3)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x8b1072d0d8be0f10552429861a9e2400c575699d"
  name: "ClaimIssuer (study family 883ba1d7)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x6d84f0831ffaf5ac1d811dc13540881d2862c539"
  name: "unverified code (study family abc45c5a)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x4e50adfc953551286bbd7fee2b2b846d1d227394"
  name: "unverified code (study family 3edf4ec9)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xbc283006fb7c9cbbb7f63442ec6937138c82d5a4"
  name: "ArtistCollection (study family 320d32da)"
  instances: 49
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xba4961de8ba4a3754f3ed3fe8b05903dc794cde3"
  name: "Tally (study family 24e32d7d)"
  instances: 6
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xc927a1e4c431babb798d705988ab036e2bdcf640"
  name: "ApprovedTransfer (study family b1b01ed0)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xd1006642fd2e35355e58f5ae077964c5a72b7d00"
  name: "unverified code (study family 3c2944f3)"
  instances: 2026
  list: "every address running this code at block 26,438,999 (2,025 by 7702 delegation)"
  upgradeable: "no"
- code: "0xb5e937676acdc6fd8585443b1c5b9b6eec6269d4"
  name: "TokenERC20 (study family 196f17ea)"
  instances: 504
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb653797907a17e29c38be0cf09de4f7dcc1bfde9"
  name: "TokenERC20 (study family dda37296)"
  instances: 861
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x10c785db70114d17a3cb694b2bb8170c87684342"
  name: "BloctoAccountCloneableWallet (study family 2de72ace)"
  instances: 152
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xee1270ab435413396a050ee0758907e805eae607"
  name: "unverified code (study family cd1f0b12)"
  instances: 779
  list: "every address running this code at block 26,438,999 (778 by 7702 delegation)"
  upgradeable: "no"
- code: "0xb645f43266969ff209dd2962fbcb0ad9f54109fe"
  name: "TokenERC20 (study family 98347180)"
  instances: 450
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0x98a7af3950c2bfaca4af6f18b4b209310c63bf59"
  name: "SlickSwapV1 (study family 1055d696)"
  instances: 159
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0x75462291e6fcf7250cd7c6feaea678b59ec7c0fc"
  name: "unverified code (study family fa597019)"
  instances: 213
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xfec266a3b8aed9ebe97400a7e4e3fa907ed4d8b0"
  name: "unverified code (study family 6804d878)"
  instances: 739
  list: "every address running this code at block 26,438,999 (738 by 7702 delegation)"
  upgradeable: "no"
- code: "0xb6ab24fd917bfe3b8734cee84abbc0c330295f7e"
  name: "unverified code (study family 24c34137)"
  instances: 211
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb57c84aaba0319e5fe481efc9518be541bf8bf29"
  name: "unverified code (study family 0fdf2040)"
  instances: 545102
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb57ec7f4c3372d590916d71669346a11c1a1d429"
  name: "unverified code (study family b780810f)"
  instances: 58303
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb57ccbe436722c07c66aefb85c15e438a31ac339"
  name: "Roles (study family cde8f1d1)"
  instances: 9959
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb57ed3b7b7be5a25356639145261530027d9390e"
  name: "unverified code (study family 887cafb6)"
  instances: 6579
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb57cde6af4d777f5f111ecd9953f44fe64a3cd7c"
  name: "NiftyERC721Token (study family be579c17)"
  instances: 5098
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb580d2eead23edf54facb7dc35d52b9148863f5c"
  name: "unverified code (study family 038a8573)"
  instances: 3772
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb581558952213203321e76e8af4f692abc08cd1e"
  name: "unverified code (study family 57a0f1e4)"
  instances: 2628
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb5c5a64e8c2916cf370465aeaab9ebda99dfdade"
  name: "unverified code (study family 78773c32)"
  instances: 1534
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb5dd936b19dc3b6bbadb11684733daa3a92b0cbb"
  name: "unverified code (study family be630529)"
  instances: 852
  list: "every address running this code at block 26,438,999 (851 by 7702 delegation)"
  upgradeable: "no"
- code: "0xb5bb2cdc78f3fac2f19e84c174b25de8a33d1d63"
  name: "TokenERC721 (study family 3a79904b)"
  instances: 737
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb5c957e73f276f607ead2a746e87e409fa3a4a73"
  name: "TokenERC721 (study family 1d775643)"
  instances: 617
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb5bd6d8e9b92203b94bc5b44189490b92de6793d"
  name: "Roles (study family d5275e6a)"
  instances: 492
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb600c54dc2dec8487c70fec6e6db0acfa7f8d590"
  name: "TokenERC20 (study family bde87a66)"
  instances: 468
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb595496501d4e2580325abbfd626761ace7d301d"
  name: "FrozenERC1155 (study family efbd2ced)"
  instances: 392
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb639703a86140b30d4a03968b468a12737b9d469"
  name: "Airdrop (study family e2ad46c2)"
  instances: 360
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb6b4f1f56361636c76f9701a9bb5b624e26234d8"
  name: "Roles (study family dd7c4d92)"
  instances: 357
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb5c2a29b87d1844e9dfb69d648f08f14530ffabc"
  name: "NiftyERC721Token (study family 4c03806f)"
  instances: 357
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb5ccf283ad21b6b996800a458da684fd86403da9"
  name: "unverified code (study family 38027af9)"
  instances: 344
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xb5b3f50168abe322f7c11f9e79f0a814923ebe55"
  name: "TokenERC1155 (study family bb8f467e)"
  instances: 289
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb5bfdafe519f1a722572b3eefe7db17ee111b555"
  name: "unverified code (study family 564b47f7)"
  instances: 273
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb633cf4c54833db3574edabbd324e5ba5436acd5"
  name: "SignatureDrop (study family 1afffc27)"
  instances: 272
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb58769c7a306ed4315a3e2a1fc21b79c7ecc812a"
  name: "unverified code (study family 80c2016c)"
  instances: 272
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb622716ed56fb618f8b9c414644255b0de3c8097"
  name: "TrustedForwarder (study family c2e6f3b3)"
  instances: 256
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb67e4f72512f5aa96c82ca58e02fbf841e53c2c8"
  name: "Delay (study family f0c09306)"
  instances: 252
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb7c13e86abeef9b4a64e5e38ea92e3208b4bd7c7"
  name: "unverified code (study family 66032ad8)"
  instances: 250
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb9d2d253514d15262330a186108e1ad0f97baf30"
  name: "SignatureDrop (study family cc5402c9)"
  instances: 243
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb81081740ea5dee93595cb77550f745fb28a37db"
  name: "unverified code (study family d045c2d9)"
  instances: 241
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb76035fca16a4c868332860af67b2ef0e9a39226"
  name: "TokenERC20 (study family a066538d)"
  instances: 235
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb604d187735c615fe8c4c1cd8ef62c93b1b415d4"
  name: "TokenERC1155 (study family d33da90d)"
  instances: 215
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb581eea5f6f26bcd9003366df617cf1f3935aab9"
  name: "TokenERC721 (study family c77e2b1d)"
  instances: 214
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb5e656a8330294670a064b1c0745339df9a531d4"
  name: "MintedTokenCappedCrowdsaleExt (study family be4639f0)"
  instances: 210
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb74231fccafc6f1b10a3f36e8c8433909e89dcfd"
  name: "SignatureDrop (study family 50e19225)"
  instances: 210
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb68ccdcd53b639d7e330cb9d0cf281ed220ae05d"
  name: "CreatorCollection (study family 7ee1302e)"
  instances: 209
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb6e3dece6f6731d1d8c44daea8ad5903959d7f56"
  name: "TokenCollection (study family 59d12741)"
  instances: 194
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb961b90c4e1f3717eecc04625efd2136f6c62adf"
  name: "TokenERC20 (study family 2324a018)"
  instances: 179
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb6f60256e54e0be8eb4754b8f4d46c62207445f0"
  name: "unverified code (study family 7ddc257e)"
  instances: 175
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xb5a0b4e55877c8fbc5cb9753dc6b8619cb810687"
  name: "MintableOwnableToken (study family e5b52728)"
  instances: 160
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb971b07146c8f3bd502763c22b1e35fcc3b82d1a"
  name: "GeneralTransferManager (study family baa4d4f3)"
  instances: 155
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb5d2fbdd5800ae26ed0a1dc0979fdea330cdb099"
  name: "SignatureDrop (study family 748fca50)"
  instances: 152
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb8e4a7c80444a484fa3cfaaf3f540c5366834b4a"
  name: "MintableOwnableToken (study family ca6b41cf)"
  instances: 145
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb607faf1ed5cc566fc1d705497b14dec71fc72cf"
  name: "FxGenArt721 (study family 5b1f0b39)"
  instances: 141
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb59a5c9f708d824fd30dfe2a65c8c2b566d6f6f7"
  name: "unverified code (study family 7008ed6a)"
  instances: 137
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb67b19d3a5bb819732c1465ae58b6c006ae4c902"
  name: "unverified code (study family d8cbe550)"
  instances: 133
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xba4a459e5d50e030199e4f485ee47ecc5c66d438"
  name: "TokenERC721 (study family eb2f1dae)"
  instances: 133
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb979b5eac91bf62da1d1f856f5b16aeb877fb884"
  name: "AutoMinterERC721 (study family e17cbf5c)"
  instances: 128
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb5a52a52c484c7dca846794b723dad6af6108f08"
  name: "unverified code (study family 61ff3c02)"
  instances: 123
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb6704dd58fff8db60619a72d79bf074d59889e6f"
  name: "TokenCollection (study family 593ad07f)"
  instances: 119
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb75bd8fa48c7c727bfbaef44ccd8a9083801f27a"
  name: "TokenERC721 (study family 0c957675)"
  instances: 115
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb68144374b2153ccc0956ed886be3321e64eb1cf"
  name: "WaymontSafeAdvancedSigner (study family ebbf0691)"
  instances: 115
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb71a312ff8cd4b81b6790cf4b730ab8ee93e2c32"
  name: "TokenCollection (study family 0efa34b9)"
  instances: 106
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb9f00db866fa934eb1ac3bb97fe0a412c0b63b5e"
  name: "unverified code (study family 580d55bf)"
  instances: 104
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xb66c94c85d97e73c29ec6fbf60ad7c3f7613a5b4"
  name: "MintedTokenCappedCrowdsaleExt (study family f4a8c24f)"
  instances: 102
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xba5784adc72eb02781b57e3360f04cd482e8ac04"
  name: "DepositCollect (study family 35cdcaab)"
  instances: 101
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, 1077 families of the reading list"
  date: 2026-11-19
  verdict: reported
  rating: LOW
related: []
reviews: []
---

## Summary

Each family below accepts signatures from a key that a function can replace. Once that key's account has code its signatures stop counting; its holder rotates first, or the owner afterwards. 1,077 families, 1,410,319 addresses, $6.5B held. Another 16,203 small template copies of the same shape are not listed.

## Evidence

Each family's recovery sites were read, judged from bytecode or placed by a measured rule; 542 families were also replayed on real transactions.
