---
id: layerzero-dvn-ecdsa-signers
title: "LayerZero DVNs: forging the ECDSA signer quorums of an OApp's required DVNs verifies fake cross-chain messages that release bridged funds (Stargate pools alone USD 51M)"
project: layerzero
status: confirmed
severity: MEDIUM
patterns: [PQ-5]
primitives: [ecrecover]
trigger: committee-keys
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0xa59ba433ac34d2927232918ef5b2eaafcf130ba5"
  implementation: null
  name: DVN (Twinstake)
  upgradeable: config-only
  admin: "signer quorum (1 of 2) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 80434
- address: "0x589dedbd617e0cbcb916a9223f4d1300c294236b"
  implementation: null
  name: DVN (LayerZero Labs)
  upgradeable: config-only
  admin: "signer quorum (2 of 3) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; OApps choose DVNs in ReceiveUln302 config"
  value_usd: 51334998
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 121361
- address: "0x8fafae7dd957044088b3d0f67359c327c6200d18"
  implementation: null
  name: DVN (Stargate; deprecated in LayerZero metadata)
  upgradeable: config-only
  admin: "signer quorum (2 of 3) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-15
  txs_30d: 117
- address: "0xd56e4eab23cb81f43168f9f45211eb027b9ac7cc"
  implementation: null
  name: VerifierNetwork (Google Cloud)
  upgradeable: config-only
  admin: "signer quorum (2 of 3) via onlySelf setSigner/setQuorum; ECDSA scheme fixed; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 4140
- address: "0x3b0531eb02ab4ad72e7a531180beef9493a00dd2"
  implementation: null
  name: DVN (USDT0)
  upgradeable: config-only
  admin: "signer quorum (1 of 2) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 29031
- address: "0x380275805876ff19055ea900cdb2b46a94ecf20d"
  implementation: null
  name: DVN (Horizen)
  upgradeable: config-only
  admin: "signer quorum (2 of 2) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 43467
- address: "0x06559ee34d85a88317bf0bfe307444116c631b67"
  implementation: null
  name: DVN (P2P)
  upgradeable: config-only
  admin: "signer quorum (1 of 1) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 6209
- address: "0xc9ca319f6da263910fd9b037ec3d817a814ef3d8"
  implementation: null
  name: DVN (BitGo; deprecated in LayerZero metadata)
  upgradeable: config-only
  admin: "signer quorum (3 of 3) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-15
  txs_30d: 1361
- address: "0xa4fe5a5b9a846458a70cd0748228aed3bf65c2cd"
  implementation: null
  name: "DVN (Canary)"
  upgradeable: config-only
  admin: "signer quorum (1 of 1) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x5a54fe5234e811466d5366846283323c954310b2"
  implementation: "0x3eea8d627ab6983fffc7027ee623fd7699343fc1"
  name: "TSS DVN proxy (OptimizedTransparentUpgradeableProxy, implementation unverified)"
  upgradeable: "yes"
  admin: "ProxyAdmin 0x967baf657ec4d4b1cb00b06f7cc6e8ba604e3ac8 (owner EOA 0x7b80f2924e3ad59a55f4bcc38ab63480599be6c8) upgrades implementation 0x3eea8d627ab6983fffc7027ee623fd7699343fc1; owner() EOA 0x18606e2abaa0ba15cc1d0d3b55521bd2247e4d2e; quorum 2 of 2"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x373a6e5c0c4e89e24819f00aa37ea370917aaff4"
  implementation: null
  name: "DVN (Deutsche Telekom)"
  upgradeable: config-only
  admin: "signer quorum (1 of 1) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x38654142f5e672ae86a1b21523aafc765e6a1e08"
  implementation: null
  name: "DVN (Frax)"
  upgradeable: config-only
  admin: "signer quorum (2 of 3) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x58249a2ec05c1978bf21df1f5ec1847e42455cf4"
  implementation: null
  name: "DVN (Luganodes)"
  upgradeable: config-only
  admin: "signer quorum (1 of 1) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x89ca15937e1033af26fe4c5e976216e8c8179408"
  implementation: null
  name: "DVN (WBTC Canary)"
  upgradeable: config-only
  admin: "signer quorum (1 of 1) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x3a4636e9ab975d28d3af808b4e1c9fd936374e30"
  implementation: null
  name: "DVN (Nansen)"
  upgradeable: config-only
  admin: "signer quorum (1 of 1) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0xb0b2ef168f52f6d1e42f461e11117295ef992daf"
  implementation: null
  name: "DVN (Paxos)"
  upgradeable: config-only
  admin: "signer quorum (1 of 1) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x7518f30bd5867b5fa86702556245dead173afe46"
  implementation: null
  name: "DVN (Superform)"
  upgradeable: config-only
  admin: "signer quorum (1 of 1) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x7a23612f07d81f16b26cf0b5a4c3eca0e8668df2"
  implementation: null
  name: "DVN (BWare; deprecated in LayerZero metadata)"
  upgradeable: config-only
  admin: "signer quorum (1 of 1) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x02041731cb8cbae90838bb8632c359fc0c2b0775"
  implementation: null
  name: "DVN (Zeeve)"
  upgradeable: config-only
  admin: "signer quorum (1 of 1) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0xe552485d02edd3067fe7fcbd4dd56bb1d3a998d2"
  implementation: null
  name: "DVN (BCW Group)"
  upgradeable: config-only
  admin: "signer quorum (1 of 1) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0xaf75bfd402f3d4ee84978179a6c87d16c4bd1724"
  implementation: null
  name: "DVN (Omni X)"
  upgradeable: config-only
  admin: "signer quorum (1 of 1) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x554833698ae0fb22ecc90b01222903fd62ca4b47"
  implementation: null
  name: "DVN (Mantle03)"
  upgradeable: config-only
  admin: "signer quorum (2 of 2) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x7e65bdd15c8db8995f80abf0d6593b57dc8be437"
  implementation: null
  name: "DVN (Animoca-Blockdaemon)"
  upgradeable: config-only
  admin: "signer quorum (1 of 1) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x241c66a979125f230c239e79d103e0c2128c6618"
  implementation: null
  name: "DVN (Ondo)"
  upgradeable: config-only
  admin: "signer quorum (1 of 1) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0xdb979d0a36af0525afa60fc265b1525505c55d79"
  implementation: null
  name: "DVN (LayerZero Labs)"
  upgradeable: config-only
  admin: "signer quorum (3 of 3) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x3f965b507a3ab2dd945c1796c973b206af4e5fcb"
  implementation: null
  name: "DVN (Citrea)"
  upgradeable: config-only
  admin: "signer quorum (1 of 1) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0xe2e558c85e00b4d7529433c1cc78ab678cf62538"
  implementation: null
  name: "DVN (Bera)"
  upgradeable: config-only
  admin: "signer quorum (1 of 1) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0xf4064220871e3b94ca6ab3b0cee8e29178bf47de"
  implementation: null
  name: "DVN (Twinstake)"
  upgradeable: config-only
  admin: "signer quorum (1 of 2) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0xc61af5706b80ca941a0aab1c7b3d7a953e4dd8c4"
  implementation: null
  name: "DVN (Fidelity Center for Applied Technology)"
  upgradeable: config-only
  admin: "signer quorum (1 of 2) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x94aafe0a92a8300f0a2100a7f3de47d6845747a9"
  implementation: null
  name: "DVN (P-OPS)"
  upgradeable: config-only
  admin: "signer quorum (1 of 1) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x38179d3bfa6ef1d69a8a7b0b671ba3d8836b2ae8"
  implementation: null
  name: "DVN (Gitcoin; deprecated in LayerZero metadata)"
  upgradeable: config-only
  admin: "signer quorum (1 of 1) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0xcc35923c43893cc31f2815e216afd7efb60f1fb0"
  implementation: null
  name: "DVN (Curve)"
  upgradeable: config-only
  admin: "signer quorum (1 of 2) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x2f0ba3dbb93cf087e32c15aab46726fdb4fb24cf"
  implementation: null
  name: "DVN (Horizen)"
  upgradeable: config-only
  admin: "signer quorum (2 of 2) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x864b42dddc43a610e7506c163048c087f0b406ef"
  implementation: null
  name: "DVN (Animoca-Blockdaemon)"
  upgradeable: config-only
  admin: "signer quorum (1 of 1) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0xf34d1b07c64c4f4d492ae3ddd0aab0658a2975eb"
  implementation: null
  name: "DVN (Ondo Staging)"
  upgradeable: config-only
  admin: "signer quorum (1 of 1) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x0ae4e6a9a8b01ee22c6a49af22b674a4e033a23d"
  implementation: null
  name: "DVN (MIM)"
  upgradeable: config-only
  admin: "signer quorum (1 of 1) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x6c70db9ce65fa37499c1f1a150a6440fc9c7273a"
  implementation: null
  name: "DVN (Wyoming; deprecated in LayerZero metadata)"
  upgradeable: config-only
  admin: "signer quorum (1 of 1) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x96a2894042dfec802a23b1ad02f0314ac24b6010"
  implementation: null
  name: "DVN (MantleCross)"
  upgradeable: config-only
  admin: "signer quorum (2 of 2) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x53af943a880b93eb53c8e39def519ae4dcaab0ef"
  implementation: null
  name: "DVN (FBTC New)"
  upgradeable: config-only
  admin: "signer quorum (3 of 3) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x95729ea44326f8add8a9b1d987279dbdc1dd3dff"
  implementation: null
  name: "DVN (Lagrange; deprecated in LayerZero metadata)"
  upgradeable: config-only
  admin: "signer quorum (1 of 1) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x15fadad87913c3bb95f8f9f2e2b287e71ba7817d"
  implementation: null
  name: "DVN (Gitcoin)"
  upgradeable: config-only
  admin: "signer quorum (1 of 1) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x92ef4381a03372985985e70fb15e9f081e2e8d14"
  implementation: null
  name: "DVN (Portal)"
  upgradeable: config-only
  admin: "signer quorum (1 of 1) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x4184dd22692c8b50d8d7ee0d7b6028e45dbf8108"
  implementation: null
  name: "DVN (EigenZero)"
  upgradeable: config-only
  admin: "signer quorum (2 of 3) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x4066b6e7bfd761b579902e7e8d03f4feb9b9536e"
  implementation: null
  name: "DVN (Quantoz)"
  upgradeable: config-only
  admin: "signer quorum (1 of 1) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x006e1248be5e40b4a4e7099397719df7ab872de7"
  implementation: null
  name: "DVN (Predicate; deprecated in LayerZero metadata)"
  upgradeable: config-only
  admin: "signer quorum (1 of 1) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x868e6393aea25e8c7e58bc5d4c90a5237c573ff6"
  implementation: null
  name: "DVN (Mantle Bank)"
  upgradeable: config-only
  admin: "signer quorum (2 of 2) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x98b2e2aa4694680ed610d4f0a9bb78e8f7f1f200"
  implementation: null
  name: "DVN (B-Harvest)"
  upgradeable: config-only
  admin: "signer quorum (1 of 1) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x394fe81886baf6e2d5bee37ffa24b07133c320c6"
  implementation: null
  name: "DVN (StablecoinX)"
  upgradeable: config-only
  admin: "signer quorum (1 of 1) via onlySelf setSigner/setQuorum and quorumChangeAdmin; ECDSA scheme fixed; not a proxy; OApps choose DVNs in ReceiveUln302 config"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
families: []
fix:
  layer: new-deployment
  who_acts: each DVN operator (deploy a DVN that verifies post-quantum signatures or proofs); LayerZero's OneSig 0xbe010a7e3686fdf65e93344ab664d065a0b02478 (5 of 9, owner of EndpointV2 and ReceiveUln302) for default DVN configs; each OApp delegate with a custom config
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/layerzero-dvn-ecdsa-signers
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_0.jsonl,out_1.jsonl,out_2.jsonl,out_3.jsonl,out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: review (Review04)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/layerzero-dvn-ecdsa-signers/escrow-and-dvns.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: []
---

## Summary

A LayerZero V2 message is delivered on Ethereum when every required DVN (decentralised verifier network) of the
receiving OApp has called `ReceiveUln302.verify`; each DVN contract accepts a call only with a quorum of secp256k1
signatures from its signer set (PQ-5). A quantum attacker who recovers the signer keys of an OApp's required DVNs
(a quorum is 1 to 3 keys per DVN; a signer's public key follows from any signature it posted) can verify a
fabricated packet and make the OApp release or mint funds. This finding lists all 48 mainnet DVNs that called
`ecrecover` in the year to March 2026 (2.1M transactions); 34 of them accept a single signature (quorum 1). One
consumer, Stargate V2's three pools, holds USD 51.3M behind four of them. Rated MEDIUM, step 4: no protocol change
is needed; DVN operators deploy post-quantum DVNs and LayerZero's OneSig (defaults) and OApp delegates (custom
configs) point at them.

## Mechanism

- `DVN.execute(ExecuteParam[])` (`onlyRole(ADMIN_ROLE)`) hashes each target call and checks
  `MultiSig.verifySignatures(hash, signatures)`: `signatures.length == quorum * 65`, then `ECDSA.tryRecover` per
  65-byte slice, ascending signer order, each in `signers` (`MultiSig.sol` lines 88–97). The call is then made, in
  practice `ReceiveUln302.verify(packetHeader, payloadHash, confirmations)`; once all required DVNs have verified,
  anyone can commit the payload hash to `EndpointV2` and the OApp's `lzReceive` executes it.
- `quorumChangeAdmin(ExecuteParam)` grants `ADMIN_ROLE` to any address on quorum signatures alone, so a forged quorum
  does not also need an admin key. `setSigner`/`setQuorum` are `onlySelf`: signers can rotate, but only to other
  ECDSA keys.
- `0xd56e4eab…` is the older `VerifierNetwork` contract with the same `uln/MultiSig.verifySignatures` logic.
- Pattern PQ-5. Source excerpts: [`source-excerpts.md`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/layerzero-dvn-ecdsa-signers/source-excerpts.md).

## Evidence

- CHECKED (Sourcify-verified source of the first eight; `DVN.sol` and `Worker.sol` of `0x589dedbd…` read in full):
  the functions above; no proxy, no upgrade function. The other 39 standard DVNs are Blockscout-verified contracts
  named `DVN` with the same runtime sizes (17,973 or 20,004 bytes) and empty EIP-1967 slots.
- CHECKED (`eth_call` at block 26,431,548): `quorum()/signerSize()` = Twinstake 1/2, LayerZero Labs 2/3, Stargate
  2/3, Google 2/3, USDT0 1/2, Horizen 2/2, P2P 1/1, BitGo 3/3; all `vid() = 101` (Ethereum).
- CHECKED (remote, one request per read at block 26,431,701): `quorum()`, `signerSize()`, `vid()`, EIP-1967 slots,
  `owner()` and balances of the other 40 (table below). `0x5a54fe52…` (TSS) is the exception: an
  `OptimizedTransparentUpgradeableProxy` to unverified implementation `0x3eea8d62…`, ProxyAdmin `0x967baf65…` owned
  by EOA `0x7b80f292…`, `owner()` EOA `0x18606e2a…`, quorum 2 of 2, no `vid()`; its check is known only from the
  `ecrecover` trace (bytecode-level).
- CHECKED (LayerZero metadata API, `ethereum.dvns`, fetched 2026-11-17): operator names above; the draft's
  "Nethermind" for `0xa59ba433…` is wrong (Twinstake); `0x8fafae7d…` (Stargate) and `0xc9ca319f…` (BitGo) are marked
  deprecated but still verified packets in the last 30 days.
- CHECKED (`ReceiveUln302.getUlnConfig` at block 26,431,551): Stargate USDC and native pools, eids 30110 and 30184,
  require Horizen, LayerZero Labs, Canary (`0xa4fe5a5b…`) and Twinstake, no optional DVNs; same as the default
  (`getUlnConfig(address(0), eid)`). `EndpointV2` and `ReceiveUln302` are owned by OneSig `0xbe010a7e…`, threshold
  5 of 9 signers.
- CHECKED (balances at block 26,431,551): Stargate pools USDC `0xc0263958…` 41,755,713 USDC; USDT `0x933597a3…`
  2,982,176 USDT; native `0x77b20437…` 3,641.55 ETH.
- CHECKED (precompile trace `data/agg/y1_caller.parquet` against the metadata list): 48 mainnet DVNs called
  `ecrecover`; the first eight account for 2,010,380 transactions, the other 40 for 105,851
  ([`escrow-and-dvns.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/layerzero-dvn-ecdsa-signers/escrow-and-dvns.json)).
- CHECKED (ETH balance and Blockscout ERC-20 balances): none of the 48 holds anything but token dust (under USD 0.01).
- CHECKED (on-chain read at block 26,431,214): DVNs hold nothing ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/layerzero-dvn-ecdsa-signers/onchain.json));
  CHECKED (Xatu): activity in [`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/layerzero-dvn-ecdsa-signers/activity.json).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xa59ba433…` DVN (Twinstake, 1/2) | config-only | — (Stargate pools, below) | 2026-11-16 | 80,434 |
| `0x589dedbd…` DVN (LayerZero Labs, 2/3) | config-only | — (escrow: Stargate pools USD 51.3M) | 2026-11-16 | 121,361 |
| `0x8fafae7d…` DVN (Stargate, 2/3, deprecated) | config-only | — | 2026-11-15 | 117 |
| `0xd56e4eab…` VerifierNetwork (Google, 2/3) | config-only | — | 2026-11-16 | 4,140 |
| `0x3b0531eb…` DVN (USDT0, 1/2) | config-only | — | 2026-11-16 | 29,031 |
| `0x38027580…` DVN (Horizen, 2/2) | config-only | — (Stargate pools, below) | 2026-11-16 | 43,467 |
| `0x06559ee3…` DVN (P2P, 1/1) | config-only | — | 2026-11-16 | 6,209 |
| `0xc9ca319f…` DVN (BitGo, 3/3, deprecated) | config-only | — | 2026-11-15 | 1,361 |

- Escrow: the funds sit in the OApps (OFT adapters, Stargate pools, lockboxes), each with its own DVN set; their
  total on mainnet is not measured here. Stargate V2's USDC, USDT and native pools hold USD 51.3M (2026-11-17, ETH at
  USD 1,811.62), recorded once, on the LayerZero Labs DVN entry, as a lower bound. Forging them needs four DVN quorums
  (Horizen 2 of 2, LayerZero Labs 2 of 3, Canary 1 of 1, Twinstake 1 of 2: six keys), all ECDSA.
- The other 40 DVNs (on-chain reads at block 26,431,701; operator from LayerZero metadata; ecrecover transactions in
  the year to March 2026). Their 30-day activity was not measured (`last_active` and `txs_30d` null).

| DVN | Operator | Quorum | Upgradeable | ecrecover txs (y1) |
|---|---|---|---|---|
| `0xa4fe5a5b…` | Canary | 1 of 1 | config-only | 18,721 |
| `0x5a54fe52…` | TSS | 2 of 2 | proxy, upgradeable | 16,772 |
| `0x373a6e5c…` | Deutsche Telekom | 1 of 1 | config-only | 13,458 |
| `0x38654142…` | Frax | 2 of 3 | config-only | 9,426 |
| `0x58249a2e…` | Luganodes | 1 of 1 | config-only | 7,430 |
| `0x89ca1593…` | WBTC Canary | 1 of 1 | config-only | 6,918 |
| `0x3a4636e9…` | Nansen | 1 of 1 | config-only | 5,317 |
| `0xb0b2ef16…` | Paxos | 1 of 1 | config-only | 4,322 |
| `0x7518f30b…` | Superform | 1 of 1 | config-only | 3,393 |
| `0x7a23612f…` | BWare (deprecated) | 1 of 1 | config-only | 3,178 |
| `0x02041731…` | Zeeve | 1 of 1 | config-only | 2,899 |
| `0xe552485d…` | BCW Group | 1 of 1 | config-only | 2,713 |
| `0xaf75bfd4…` | Omni X | 1 of 1 | config-only | 2,641 |
| `0x55483369…` | Mantle03 | 2 of 2 | config-only | 1,788 |
| `0x7e65bdd1…` | Animoca-Blockdaemon | 1 of 1 | config-only | 987 |
| `0x241c66a9…` | Ondo | 1 of 1 | config-only | 913 |
| `0xdb979d0a…` | LayerZero Labs | 3 of 3 | config-only | 714 |
| `0x3f965b50…` | Citrea | 1 of 1 | config-only | 695 |
| `0xe2e558c8…` | Bera | 1 of 1 | config-only | 683 |
| `0xf4064220…` | Twinstake | 1 of 2 | config-only | 611 |
| `0xc61af570…` | Fidelity Center for Applied Technology | 1 of 2 | config-only | 502 |
| `0x94aafe0a…` | P-OPS | 1 of 1 | config-only | 461 |
| `0x38179d3b…` | Gitcoin (deprecated) | 1 of 1 | config-only | 410 |
| `0xcc35923c…` | Curve | 1 of 2 | config-only | 219 |
| `0x2f0ba3db…` | Horizen | 2 of 2 | config-only | 178 |
| `0x864b42dd…` | Animoca-Blockdaemon | 1 of 1 | config-only | 113 |
| `0xf34d1b07…` | Ondo Staging | 1 of 1 | config-only | 107 |
| `0x0ae4e6a9…` | MIM | 1 of 1 | config-only | 100 |
| `0x6c70db9c…` | Wyoming (deprecated) | 1 of 1 | config-only | 68 |
| `0x96a28940…` | MantleCross | 2 of 2 | config-only | 35 |
| `0x53af943a…` | FBTC New | 3 of 3 | config-only | 33 |
| `0x95729ea4…` | Lagrange (deprecated) | 1 of 1 | config-only | 14 |
| `0x15fadad8…` | Gitcoin | 1 of 1 | config-only | 11 |
| `0x92ef4381…` | Portal | 1 of 1 | config-only | 5 |
| `0x4184dd22…` | EigenZero | 2 of 3 | config-only | 5 |
| `0x4066b6e7…` | Quantoz | 1 of 1 | config-only | 5 |
| `0x006e1248…` | Predicate (deprecated) | 1 of 1 | config-only | 3 |
| `0x868e6393…` | Mantle Bank | 2 of 2 | config-only | 1 |
| `0x98b2e2aa…` | B-Harvest | 1 of 1 | config-only | 1 |
| `0x394fe818…` | StablecoinX | 1 of 1 | config-only | 1 |

## Remediation

- Post-quantum replacement: DVN contracts that verify post-quantum signatures (ML-DSA or hash-based, e.g. through
  ERC-7913 verifiers) or a STARK proof of the attestation; rotating keys with `setSigner` does not help because the
  scheme is fixed.
- Who acts: each DVN operator deploys a new DVN (new deployment); LayerZero's OneSig `0xbe010a7e…` (5 of 9) updates
  the default DVN configs in `ReceiveUln302`; every OApp with a custom config sets its own through `EndpointV2`
  `setConfig` (its delegate). An OApp that has renounced its delegate keeps whatever config it has; not measured.
- No protocol change is needed; EIP-8151 does not apply (DVN signers are EOA keys).

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review04): MEDIUM kept (step 4: new DVN deployments plus config changes by LayerZero's OneSig and OApp delegates; no protocol change). `alternative` key-rotation-only -> configurable-verifier (OApps repoint their DVN set); operators named from LayerZero metadata (0xa59ba433 is Twinstake, not Nethermind); escrow example Stargate V2 USD 51.3M added; 40 uncovered mainnet DVNs reported, Canary 0xa4fe5a5b should be added here.
- 2026-11-17 review (Review04, second pass): added the other 40 mainnet DVNs that called ecrecover (Canary 0xa4fe5a5b, TSS proxy 0x5a54fe52 and 38 more) with quorum, signer count and upgradeability read at block 26,431,701. MEDIUM kept, step 4: every one is a standard LayerZero DVN whose operator redeploys and whose consumers repoint (TSS is additionally upgradeable by its ProxyAdmin owner); none holds value, so step 5 changes nothing.
