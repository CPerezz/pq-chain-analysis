---
id: safe-owner-ecdsa-keys
title: "Safe multisigs: recovering threshold-many ECDSA owner keys moves everything in 48 tracked Safes (USD 8.75B held, mostly LEO and WLFI tokens) and about 49,000 more"
project: safe
status: confirmed
severity: MEDIUM
patterns: [PQ-12]
primitives: [ecrecover]
trigger: owner-keys
impact: funds-loss
alternative: alternative-exists
role: core
contracts:
- address: "0xf20b338752976878754518183873602902360704"
  implementation: "0x41675c099f32341bf84bfc5382af534df5c7461a"
  name: "SafeProxy → Safe 1.4.1 (3 of 4)"
  upgradeable: "yes"
  admin: "owners, 3 of 4 (all EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0x41675c099f32341bf84bfc5382af534df5c7461a"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-14
  txs_30d: 114
- address: "0x5b92e431f93024ea3ec20b311d83ac6035bd50e1"
  implementation: "0xd9db270c1b5e3bd161e8c8503c55ceabee709552"
  name: "SafeProxy → Safe 1.3.0 (2 of 3)"
  upgradeable: "yes"
  admin: "owners, 2 of 3 (all EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0xd9db270c1b5e3bd161e8c8503c55ceabee709552"
  value_usd: 2666692
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-12
  txs_30d: 6
- address: "0x4353e2df4e3444e97e20b2bda165bdd9a23913ab"
  implementation: "0x41675c099f32341bf84bfc5382af534df5c7461a"
  name: "SafeProxy → Safe 1.4.1 (3 of 4)"
  upgradeable: "yes"
  admin: "owners, 3 of 4 (all EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0x41675c099f32341bf84bfc5382af534df5c7461a; modules: AllowanceModule"
  value_usd: 290
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-09-07
  txs_30d: 0
- address: "0x2bf916f8169ed2a77324d3e168284fc252ae4087"
  implementation: "0xff51a5898e281db6dfc7855790607438df2ca44b"
  name: "SafeProxy → Safe 1.5.0 (2 of 4)"
  upgradeable: "yes"
  admin: "owners, 2 of 4 (all EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0xff51a5898e281db6dfc7855790607438df2ca44b; modules: AllowanceModule"
  value_usd: 48973864
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 1967
- address: "0x0632dcc37b1fabf2cad20538a5390d23c830962e"
  implementation: "0xd9db270c1b5e3bd161e8c8503c55ceabee709552"
  name: "110-byte proxy → Safe 1.3.0 (2 of 3)"
  upgradeable: "yes"
  admin: "owners, 2 of 3 (all EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0xd9db270c1b5e3bd161e8c8503c55ceabee709552; modules: AllowanceModule"
  value_usd: 32919368
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-05-13
  txs_30d: 0
- address: "0x7440cd37c794c4bcf1748915098280706c9b6099"
  implementation: "0x41675c099f32341bf84bfc5382af534df5c7461a"
  name: "SafeProxy → Safe 1.4.1 (2 of 3)"
  upgradeable: "yes"
  admin: "owners, 2 of 3 (all EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0x41675c099f32341bf84bfc5382af534df5c7461a"
  value_usd: 39855640
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-05-13
  txs_30d: 0
- address: "0x738744237b7fd97af670d9ddf54390c24263cea8"
  implementation: "0xd9db270c1b5e3bd161e8c8503c55ceabee709552"
  name: "SafeProxy → Safe 1.3.0 (2 of 3)"
  upgradeable: "yes"
  admin: "owners, 2 of 3 (all EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0xd9db270c1b5e3bd161e8c8503c55ceabee709552"
  value_usd: 779
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-04-15
  txs_30d: 0
- address: "0x3f963b4c8e2473683c9d48189e27440f76307214"
  implementation: "0x41675c099f32341bf84bfc5382af534df5c7461a"
  name: "SafeProxy → Safe 1.4.1 (2 of 4)"
  upgradeable: "yes"
  admin: "owners, 2 of 4 (all EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0x41675c099f32341bf84bfc5382af534df5c7461a"
  value_usd: 23418484
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-12
  txs_30d: 8
- address: "0x7ce3ec6845780e8f69b1a19edf8148d7cbb77a7d"
  implementation: "0xd9db270c1b5e3bd161e8c8503c55ceabee709552"
  name: "SafeProxy → Safe 1.3.0 (2 of 4)"
  upgradeable: "yes"
  admin: "owners, 2 of 4 (all EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0xd9db270c1b5e3bd161e8c8503c55ceabee709552"
  value_usd: 24862867
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-12
  txs_30d: 10
- address: "0x56e60979d5934a05d22606b0455d52f59f20a6a0"
  implementation: "0xd9db270c1b5e3bd161e8c8503c55ceabee709552"
  name: "SafeProxy → Safe 1.3.0 (2 of 4)"
  upgradeable: "yes"
  admin: "owners, 2 of 4 (all EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0xd9db270c1b5e3bd161e8c8503c55ceabee709552; modules: AllowanceModule"
  value_usd: 22430971
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-13
  txs_30d: 1
- address: "0x2291f52bddc937b5b840d15e551e1da8c80c2b3c"
  implementation: "0x41675c099f32341bf84bfc5382af534df5c7461a"
  name: "SafeProxy → Safe 1.4.1 (1 of 1)"
  upgradeable: "yes"
  admin: "owners, 1 of 1 (all EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0x41675c099f32341bf84bfc5382af534df5c7461a"
  value_usd: 23676376
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-08-20
  txs_30d: 0
- address: "0xa7b84c346fda049715a0ca9e7310d272545a338b"
  implementation: "0x41675c099f32341bf84bfc5382af534df5c7461a"
  name: "SafeProxy → Safe 1.4.1 (2 of 3)"
  upgradeable: "yes"
  admin: "owners, 2 of 3 (all EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0x41675c099f32341bf84bfc5382af534df5c7461a"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-12-15
  txs_30d: 0
- address: "0xc61b9bb3a7a0767e3179713f3a5c7a9aedce193c"
  implementation: "0x34cfac646f301356faa8b21e94227e3583fe3f5f"
  name: "SafeProxy → Safe 1.1.1 (3 of 5)"
  upgradeable: "yes"
  admin: "owners, 3 of 5 (all EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0x34cfac646f301356faa8b21e94227e3583fe3f5f"
  value_usd: 6065465698
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-06-16
  txs_30d: 0
- address: "0x4e8a4894275780f571aad53122e641d9f50ff04f"
  implementation: "0xd9db270c1b5e3bd161e8c8503c55ceabee709552"
  name: "SafeProxy → Safe 1.3.0 (3 of 5)"
  upgradeable: "yes"
  admin: "owners, 3 of 5 (all EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0xd9db270c1b5e3bd161e8c8503c55ceabee709552"
  value_usd: 1
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-12
  txs_30d: 76
- address: "0x0cb1d4a24292bb89862f599ac5b10f42b6de07e4"
  implementation: "0x34cfac646f301356faa8b21e94227e3583fe3f5f"
  name: "SafeProxy → Safe 1.1.1 (2 of 4)"
  upgradeable: "yes"
  admin: "owners, 2 of 4 (all EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0x34cfac646f301356faa8b21e94227e3583fe3f5f; modules: AllowanceModule"
  value_usd: 41302508
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-12
  txs_30d: 2
- address: "0xdca6ab9508d28c0eb7b120b8252041edcb56753f"
  implementation: "0x34cfac646f301356faa8b21e94227e3583fe3f5f"
  name: "SafeProxy → Safe 1.1.1 (2 of 3)"
  upgradeable: "yes"
  admin: "owners, 2 of 3 (all EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0x34cfac646f301356faa8b21e94227e3583fe3f5f; modules: AllowanceModule"
  value_usd: 86998241
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-14
  txs_30d: 2
- address: "0xcde525bd723090284ee2f958c729d83cf117aff9"
  implementation: "0xd9db270c1b5e3bd161e8c8503c55ceabee709552"
  name: "SafeProxy → Safe 1.3.0 (3 of 6)"
  upgradeable: "yes"
  admin: "owners, 3 of 6 (one owner is Safe 0x705199fe, rest EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0xd9db270c1b5e3bd161e8c8503c55ceabee709552"
  value_usd: 36236922
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-10-30
  txs_30d: 1
- address: "0x4fb312915b779b1339388e14b6d079741ca83128"
  implementation: "0xd9db270c1b5e3bd161e8c8503c55ceabee709552"
  name: "SafeProxy → Safe 1.3.0 (3 of 6)"
  upgradeable: "yes"
  admin: "owners, 3 of 6 (all EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0xd9db270c1b5e3bd161e8c8503c55ceabee709552"
  value_usd: 459408
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-08-28
  txs_30d: 0
- address: "0x29065a4c1f2f20d1e263930088890d6f49fe715a"
  implementation: "0xd9db270c1b5e3bd161e8c8503c55ceabee709552"
  name: "SafeProxy → Safe 1.3.0 (3 of 6)"
  upgradeable: "yes"
  admin: "owners, 3 of 6 (all EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0xd9db270c1b5e3bd161e8c8503c55ceabee709552"
  value_usd: 31933111
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-15
  txs_30d: 312
- address: "0x81ad394c0fa87e99ca46e1aca093bee020f203f4"
  implementation: "0x41675c099f32341bf84bfc5382af534df5c7461a"
  name: "SafeProxy → Safe 1.4.1 (6 of 11)"
  upgradeable: "yes"
  admin: "owners, 6 of 11 (all EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0x41675c099f32341bf84bfc5382af534df5c7461a"
  value_usd: 978683
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-11
  txs_30d: 6
- address: "0x69d1bbd881817795811e3e2973716ddc98bfe9b2"
  implementation: "0x41675c099f32341bf84bfc5382af534df5c7461a"
  name: "SafeProxy → Safe 1.4.1 (1 of 2)"
  upgradeable: "yes"
  admin: "owners, 1 of 2 (all EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0x41675c099f32341bf84bfc5382af534df5c7461a; modules: AllowanceModule"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-05-25
  txs_30d: 0
- address: "0x52cfa98fb7339f6e2e70f2f68acbb7b7dcebe46a"
  implementation: "0xd9db270c1b5e3bd161e8c8503c55ceabee709552"
  name: "SafeProxy → Safe 1.3.0 (2 of 5)"
  upgradeable: "yes"
  admin: "owners, 2 of 5 (all EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0xd9db270c1b5e3bd161e8c8503c55ceabee709552; modules: AllowanceModule"
  value_usd: 31550968
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-13
  txs_30d: 18
- address: "0x748aed55d2a85d84e30558ed4798b0a47cb7dde6"
  implementation: "0x41675c099f32341bf84bfc5382af534df5c7461a"
  name: "SafeProxy → Safe 1.4.1 (3 of 5)"
  upgradeable: "yes"
  admin: "owners, 3 of 5 (all EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0x41675c099f32341bf84bfc5382af534df5c7461a"
  value_usd: 21703295
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-10-23
  txs_30d: 3
- address: "0xdb6e9e7390e9acc34619e56efa48ade01cff6f12"
  implementation: "0x41675c099f32341bf84bfc5382af534df5c7461a"
  name: "SafeProxy → Safe 1.4.1 (3 of 5)"
  upgradeable: "yes"
  admin: "owners, 3 of 5 (all EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0x41675c099f32341bf84bfc5382af534df5c7461a; modules: Zodiac Roles"
  value_usd: 2401510
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-06
  txs_30d: 10
- address: "0xfa771871d3d5c85e156d3d379e2ff7699c4d6a66"
  implementation: "0xd9db270c1b5e3bd161e8c8503c55ceabee709552"
  name: "SafeProxy → Safe 1.3.0 (4 of 6)"
  upgradeable: "yes"
  admin: "owners, 4 of 6 (all EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0xd9db270c1b5e3bd161e8c8503c55ceabee709552"
  value_usd: 1
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-13
  txs_30d: 16
- address: "0xe40d278afd00e6187db21ff8c96d572359ef03bf"
  implementation: "0xd9db270c1b5e3bd161e8c8503c55ceabee709552"
  name: "SafeProxy → Safe 1.3.0 (2 of 5)"
  upgradeable: "yes"
  admin: "owners, 2 of 5 (all EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0xd9db270c1b5e3bd161e8c8503c55ceabee709552"
  value_usd: 65266334
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-13
  txs_30d: 10
- address: "0x507b3f6d4f85c451f7914006c647391a1afb96d6"
  implementation: "0x41675c099f32341bf84bfc5382af534df5c7461a"
  name: "SafeProxy → Safe 1.4.1 (3 of 7)"
  upgradeable: "yes"
  admin: "owners, 3 of 7 (all EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0x41675c099f32341bf84bfc5382af534df5c7461a"
  value_usd: 28386257
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-10-30
  txs_30d: 2
- address: "0x2195cb272e3302dd234867bc85ca67b8560e3cdd"
  implementation: "0xd9db270c1b5e3bd161e8c8503c55ceabee709552"
  name: "SafeProxy → Safe 1.3.0 (2 of 3)"
  upgradeable: "yes"
  admin: "owners, 2 of 3 (all EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0xd9db270c1b5e3bd161e8c8503c55ceabee709552"
  value_usd: 10212
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-06-10
  txs_30d: 0
- address: "0x2a7bc14200aafde5b8541683f7131c8117079b59"
  implementation: "0x41675c099f32341bf84bfc5382af534df5c7461a"
  name: "SafeProxy → Safe 1.4.1 (2 of 3)"
  upgradeable: "yes"
  admin: "owners, 2 of 3 (all EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0x41675c099f32341bf84bfc5382af534df5c7461a"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-12-18
  txs_30d: 0
- address: "0x96f49d0e9724dfd8780fa667ac37a993f005cb94"
  implementation: "0x41675c099f32341bf84bfc5382af534df5c7461a"
  name: "SafeProxy → Safe 1.4.1 (3 of 4)"
  upgradeable: "yes"
  admin: "owners, 3 of 4 (all EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0x41675c099f32341bf84bfc5382af534df5c7461a"
  value_usd: 181
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-14
  txs_30d: 33
- address: "0x245cc372c84b3645bf0ffe6538620b04a217988b"
  implementation: "0xd9db270c1b5e3bd161e8c8503c55ceabee709552"
  name: "SafeProxy → Safe 1.3.0 (4 of 8)"
  upgradeable: "yes"
  admin: "owners, 4 of 8 (all EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0xd9db270c1b5e3bd161e8c8503c55ceabee709552"
  value_usd: 58161525
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-15
  txs_30d: 44
- address: "0x8180d59b7175d4064bdfa8138a58e9babffda44a"
  implementation: "0xd9db270c1b5e3bd161e8c8503c55ceabee709552"
  name: "SafeProxy → Safe 1.3.0 (2 of 4)"
  upgradeable: "yes"
  admin: "owners, 2 of 4 (all EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0xd9db270c1b5e3bd161e8c8503c55ceabee709552"
  value_usd: 29241665
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-11
  txs_30d: 13
- address: "0x705199fe234a7a2f1bc8b95dd7d08284c8f467f1"
  implementation: "0xd9db270c1b5e3bd161e8c8503c55ceabee709552"
  name: "SafeProxy → Safe 1.3.0 (3 of 10)"
  upgradeable: "yes"
  admin: "owners, 3 of 10 (all EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0xd9db270c1b5e3bd161e8c8503c55ceabee709552"
  value_usd: 32582036
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-14
  txs_30d: 4
- address: "0xa99f29a2fbdcafbf057b3d8efc47cfcee670bb43"
  implementation: "0xd9db270c1b5e3bd161e8c8503c55ceabee709552"
  name: "SafeProxy → Safe 1.3.0 (5 of 9)"
  upgradeable: "yes"
  admin: "owners, 5 of 9 (1 EIP-7702 EOA, rest EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0xd9db270c1b5e3bd161e8c8503c55ceabee709552; modules: AllowanceModule"
  value_usd: 42390098
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-10-23
  txs_30d: 1
- address: "0xacce2d0b77bcb844a1b95c64696b071ab8c7ada3"
  implementation: "0xd9db270c1b5e3bd161e8c8503c55ceabee709552"
  name: "SafeProxy → Safe 1.3.0 (2 of 4)"
  upgradeable: "yes"
  admin: "owners, 2 of 4 (all EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0xd9db270c1b5e3bd161e8c8503c55ceabee709552; modules: CoboSafeAccount"
  value_usd: 1
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-06-10
  txs_30d: 0
- address: "0x68a99f89e475a078645f4bac491360afe255dff1"
  implementation: "0x34cfac646f301356faa8b21e94227e3583fe3f5f"
  name: "SafeProxy → Safe 1.1.1 (4 of 7)"
  upgradeable: "yes"
  admin: "owners, 4 of 7 (all EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0x34cfac646f301356faa8b21e94227e3583fe3f5f"
  value_usd: 115470261
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-09-08
  txs_30d: 0
- address: "0x63b2c1985e1d061fe3ff050ef44c7174292d7334"
  implementation: "0x41675c099f32341bf84bfc5382af534df5c7461a"
  name: "SafeProxy → Safe 1.4.1 (2 of 2)"
  upgradeable: "yes"
  admin: "owners, 2 of 2 (all EOAs), via self-call (swapOwner/addOwnerWithThreshold, changeMasterCopy); singleton 0x41675c099f32341bf84bfc5382af534df5c7461a; modules: AllowanceModule"
  value_usd: 29720216
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-14
  txs_30d: 6
families:
- code: "0x41675c099f32341bf84bfc5382af534df5c7461a"
  name: SafeProxy instances of Safe 1.4.1 that called ecrecover in the trace
  instances: 24988
  list: docs/lookup (any address can be checked on the site)
  upgradeable: "yes"
  value_usd: null
  value_basis: null
  value_as_of: null
- code: "0xd9db270c1b5e3bd161e8c8503c55ceabee709552"
  name: GnosisSafeProxy instances of GnosisSafe 1.3.0 that called ecrecover in the trace
  instances: 23360
  list: docs/lookup (any address can be checked on the site)
  upgradeable: "yes"
  value_usd: null
  value_basis: null
  value_as_of: null
- code: "0x34cfac646f301356faa8b21e94227e3583fe3f5f"
  name: GnosisSafeProxy instances of GnosisSafe 1.1.1 that called ecrecover in the trace
  instances: 587
  list: docs/lookup (any address can be checked on the site)
  upgradeable: "yes"
  value_usd: null
  value_basis: null
  value_as_of: null
fix:
  layer: account-migration
  who_acts: each Safe's owners (threshold of current owners), replacing EOA owners with post-quantum signer contracts via swapOwner; Safe (the team) for a post-quantum signer contract or module and wallet support
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/safe-owner-ecdsa-keys
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_0.jsonl,out_1.jsonl,out_2.jsonl,out_3.jsonl,out_4.jsonl,out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: review (Review04)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/safe-owner-ecdsa-keys/safes.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (source of 1.3.0 read, two real transactions replayed four ways; not reviewed by a person)"
  ref: "studies/eip-8151-impact, replays of 2026-11-19"
  date: 2026-11-19
  verdict: confirmed
  rating: ''
related: []
---

## Summary

A Safe executes any transaction (`execTransaction`) once `checkNSignatures` has seen threshold-many owner approvals,
and an EOA owner approves with a secp256k1 signature (PQ-12). A quantum attacker who recovers threshold-many owner
keys (public keys follow from any signature the owner has posted) can transfer everything, change owners or swap the
singleton. The 48 Safes tracked here hold USD 8.75B (2026-11-17), of which USD 5.94B is LEO in `0xc61b9bb3…` and
USD 580M is WLFI in `0x5be9a495…`; 215 of their 219 distinct owners are plain EOAs and 3 more are EIP-7702 EOAs. Rated MEDIUM, step 4: the Safe
already accepts contract owners through ERC-1271 with the full signature, so each Safe's owners can swap their EOAs
for post-quantum signer contracts in place.

## Mechanism

- `Safe.checkNSignatures` (`Safe.sol` lines 311–333 for 1.4.1; same logic in 1.1.1, 1.3.0 and 1.5.0) walks
  threshold-many 65-byte signature slots. The `v` byte selects the scheme per slot: `v == 0` contract signature,
  checked with `ISignatureValidator(owner).isValidSignature(data, contractSignature)` on the full-length signature
  (legacy magic `0x20c13b0b` up to 1.4.1); `v == 1` an on-chain `approveHash` by the owner or `msg.sender == owner`;
  `v > 30` `ecrecover` of the eth_sign hash; otherwise `ecrecover(dataHash, v, r, s)`. Each recovered or named
  address must be an owner, in ascending order.
- An EOA owner can only be satisfied through `ecrecover` (or a transaction it sends), so its key is the exposure; a
  contract owner can only be satisfied through its own `isValidSignature` or `approveHash`, so replacing an EOA owner
  with a post-quantum signer contract removes that owner's ECDSA path. This is the alternative that exists today.
- Owners and singleton change only through the Safe calling itself (`swapOwner`, `addOwnerWithThreshold`,
  `removeOwner`, `changeThreshold`, `changeMasterCopy`), which needs the same threshold. Enabled modules execute
  without owner signatures under their own rules.
- Source excerpts: [`source-excerpts.md`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/safe-owner-ecdsa-keys/source-excerpts.md).

## Evidence

- CHECKED (Sourcify/Blockscout-verified singletons `0x41675c09…` 1.4.1, `0xd9db270c…` 1.3.0, `0x34cfac64…` 1.1.1,
  `0xff51a589…` 1.5.0): `checkNSignatures` as above.
- CHECKED (`eth_call` and storage at block 26,431,566; [`safes.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/safe-owner-ecdsa-keys/safes.json)):
  for every Safe `getThreshold`, `getOwners`, `VERSION`, singleton (slot 0), guard slot, `getModulesPaginated`.
  Versions: 22 × 1.3.0, 20 × 1.4.1, 5 × 1.1.1, 1 × 1.5.0. No Safe has a guard set. Modules on 14 Safes:
  AllowanceModule `0xcfbfac74…` (12), Zodiac Roles (2: `0xdca57e6e…`, `0xc3c2b189…`), CoboSafeAccount
  `0xe2327603…` (1).
- CHECKED (`eth_getCode`, nonce of all 219 distinct owners): 215 EOAs (41 with nonce 0), 3 EIP-7702-delegated EOAs
  (still ECDSA keys; in `0x690f0581…`, `0xa99f29a2…`, `0x220866b1…`), and 1 contract: Safe `0x705199fe…` (itself in
  this list, 3 of 10) owns a seat in `0xcde525bd…`.
- CHECKED (draft corrections): `0x2bf916f8…` runs Safe 1.5.0 (singleton `0xff51a589…`), not 1.3.0;
  `0x0632dcc3…` is a 110-byte non-standard proxy whose slot 0 is the 1.3.0 singleton `0xd9db270c…` and answers
  `VERSION() = 1.3.0`.
- CHECKED (on-chain read at block 26,431,214): holdings ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/safe-owner-ecdsa-keys/onchain.json));
  CHECKED (Xatu, any function): activity ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/safe-owner-ecdsa-keys/activity.json)).
- CHECKED (precompile trace): the three family counts below are SafeProxy instances of each singleton that called
  `ecrecover` in the trace.
- CHECKED (executed, study `eip-8151-impact`, 2026-11-19): two `execTransaction` calls on Safe 1.3.0 proxies,
  replayed on the reference implementation of the fork from the parent block's state, with only the `ecrecover`
  precompile changed. In both the owner that signed is not the sender.

  | Transaction | Today's rules | EIP-8151 | EIP-8151, code at the owner | EIP-8151, 7702 delegation at the owner |
  |---|---|---|---|---|
  | `0x9795079ee42bdd783f91553f91aa528e306071427a701a4b298c5a341d1305a0` (block 26,434,381, position 2) | success, 460,388 gas, equal to the receipt | success, 463,488 gas | **revert** | success, 463,488 gas |
  | `0x16a1d468122d1a5ae05007fb587fdefc8ef631d4fc6ee7f4c714340835a16208` (block 26,435,836, position 0) | success, 97,531 gas, equal to the receipt | **revert** | revert | revert |

  The second transaction was sent with 1,941 gas to spare. A recovery of a cold address costs 3,100 more under the
  EIP, so it fails with nobody migrated: the sender's gas limit is at fault, not the Safe.

## Impact and exposure

Owner and threshold structure (from `safes.json`, holdings from `onchain.json`):

| Threshold | Safes | Held |
|---|---|---|
| 1 (`0x2291f52b…` 1 of 1, `0x69d1bbd8…` 1 of 2) | 2 | $23.7M |
| 2 | 18 | $479.2M |
| 3 | 18 | $7.12B (incl. LEO $5.94B) |
| 4 to 6 | 10 | $1.13B |

Signer sets run from 1 to 11 owners (`0x81ad394c…` 6 of 11). A one-owner threshold needs one recovered key.

| Safe | Version | Threshold | Modules | Held now | Last active | 30-day txs |
|---|---|---|---|---|---|---|
| `0xf20b3387…` | 1.4.1 | 3 of 4 | — | — | 2026-11-14 | 114 |
| `0x5b92e431…` | 1.3.0 | 2 of 3 | — | $2.7M | 2026-11-12 | 6 |
| `0x4353e2df…` | 1.4.1 | 3 of 4 | AllowanceModule | $290 | 2026-09-07 | 0 |
| `0x7ee29373…` | 1.4.1 | 3 of 5 | — | $90.1M | 2026-11-15 | 15 |
| `0x2bf916f8…` | 1.5.0 | 2 of 4 | AllowanceModule | $49.0M | 2026-11-16 | 1967 |
| `0x0632dcc3…` | 1.3.0 | 2 of 3 | AllowanceModule | $32.9M | 2026-05-13 | 0 |
| `0x7440cd37…` | 1.4.1 | 2 of 3 | — | $39.9M | 2026-05-13 | 0 |
| `0x73874423…` | 1.3.0 | 2 of 3 | — | $779 | 2026-04-15 | 0 |
| `0x3f963b4c…` | 1.4.1 | 2 of 4 | — | $23.4M | 2026-11-12 | 8 |
| `0x690f0581…` | 1.3.0 | 3 of 7 (1 EIP-7702 EOA) | Zodiac Roles, AllowanceModule | $18.0M | 2026-11-13 | 13 |
| `0x9fc3dc01…` | 1.4.1 | 3 of 5 | — | $80.6M | 2026-08-24 | 0 |
| `0x7ce3ec68…` | 1.3.0 | 2 of 4 | — | $24.9M | 2026-11-12 | 10 |
| `0x56e60979…` | 1.3.0 | 2 of 4 | AllowanceModule | $22.4M | 2026-11-13 | 1 |
| `0x2291f52b…` | 1.4.1 | 1 of 1 | — | $23.7M | 2026-08-20 | 0 |
| `0xa7b84c34…` | 1.4.1 | 2 of 3 | — | — | 2025-12-15 | 0 |
| `0xc61b9bb3…` | 1.1.1 | 3 of 5 | — | $6.07B | 2026-06-16 | 0 |
| `0x4e8a4894…` | 1.3.0 | 3 of 5 | — | $1 | 2026-11-12 | 76 |
| `0x225d3822…` | 1.4.1 | 3 of 4 | — | $45.0M | 2026-10-27 | 1 |
| `0x0cb1d4a2…` | 1.1.1 | 2 of 4 | AllowanceModule | $41.3M | 2026-11-12 | 2 |
| `0xee136c03…` | 1.3.0 | 4 of 7 | — | $226.8M | 2026-09-15 | 0 |
| `0xdca6ab95…` | 1.1.1 | 2 of 3 | AllowanceModule | $87.0M | 2026-11-14 | 2 |
| `0xd67f25ef…` | 1.4.1 | 4 of 7 | — | $88.1M | 2026-10-28 | 1 |
| `0xcde525bd…` | 1.3.0 | 3 of 6 (one owner is Safe 0x705199fe) | — | $36.2M | 2026-10-30 | 1 |
| `0x4fb31291…` | 1.3.0 | 3 of 6 | — | $459k | 2026-08-28 | 0 |
| `0x29065a4c…` | 1.3.0 | 3 of 6 | — | $31.9M | 2026-11-15 | 312 |
| `0x81ad394c…` | 1.4.1 | 6 of 11 | — | $979k | 2026-11-11 | 6 |
| `0x69d1bbd8…` | 1.4.1 | 1 of 2 | AllowanceModule | — | 2026-05-25 | 0 |
| `0x52cfa98f…` | 1.3.0 | 2 of 5 | AllowanceModule | $31.6M | 2026-11-13 | 18 |
| `0x7c697d6c…` | 1.3.0 | 3 of 5 | — | $83.4M | 2026-10-22 | 1 |
| `0x748aed55…` | 1.4.1 | 3 of 5 | — | $21.7M | 2026-10-23 | 3 |
| `0xf95334a8…` | 1.4.1 | 4 of 7 | — | $68.1M | 2026-08-24 | 0 |
| `0xdb6e9e73…` | 1.4.1 | 3 of 5 | Zodiac Roles | $2.4M | 2026-11-06 | 10 |
| `0xfa771871…` | 1.3.0 | 4 of 6 | — | $1 | 2026-11-13 | 16 |
| `0xe40d278a…` | 1.3.0 | 2 of 5 | — | $65.3M | 2026-11-13 | 10 |
| `0x507b3f6d…` | 1.4.1 | 3 of 7 | — | $28.4M | 2026-10-30 | 2 |
| `0x2195cb27…` | 1.3.0 | 2 of 3 | — | $10k | 2026-06-10 | 0 |
| `0xc0614578…` | 1.4.1 | 4 of 7 | AllowanceModule | $123.8M | 2026-10-14 | 0 |
| `0x2a7bc142…` | 1.4.1 | 2 of 3 | — | — | 2025-12-18 | 0 |
| `0x96f49d0e…` | 1.4.1 | 3 of 4 | — | $181 | 2026-11-14 | 33 |
| `0x5be9a495…` | 1.3.0 | 3 of 5 | — | $580.2M | 2026-11-03 | 5 |
| `0x245cc372…` | 1.3.0 | 4 of 8 | — | $58.2M | 2026-11-15 | 44 |
| `0x8180d59b…` | 1.3.0 | 2 of 4 | — | $29.2M | 2026-11-11 | 13 |
| `0x705199fe…` | 1.3.0 | 3 of 10 | — | $32.6M | 2026-11-14 | 4 |
| `0xa99f29a2…` | 1.3.0 | 5 of 9 (1 EIP-7702 EOA) | AllowanceModule | $42.4M | 2026-10-23 | 1 |
| `0xacce2d0b…` | 1.3.0 | 2 of 4 | CoboSafeAccount | $1 | 2026-06-10 | 0 |
| `0x68a99f89…` | 1.1.1 | 4 of 7 | — | $115.5M | 2026-09-08 | 0 |
| `0x63b2c198…` | 1.4.1 | 2 of 2 | AllowanceModule | $29.7M | 2026-11-14 | 6 |
| `0x220866b1…` | 1.1.1 | 4 of 6 (1 EIP-7702 EOA) | — | $406.2M | 2026-10-25 | 2 |

- Values are held balances priced at market (2026-11-17). Two Safes are dominated by a single token: `0xc61b9bb3…`
  (LEO, USD 5.94B of 6.07B) and `0x5be9a495…` (WLFI, USD 580M); what an attacker could realise from them is far
  below the quoted value.
- Same code elsewhere: 24,988 Safe 1.4.1, 23,360 Safe 1.3.0 and 587 Safe 1.1.1 proxies called `ecrecover` in the
  trace; their holdings are not measured here.

## Remediation

- Post-quantum replacement: owners that are contracts verifying a post-quantum signature (ML-DSA, SLH-DSA or
  similar) through `isValidSignature` (legacy `bytes` interface for ≤ 1.4.1, `bytes32` for 1.5.0), or post-quantum
  smart accounts that sign with `approveHash`. Each Safe then runs `swapOwner` for every EOA owner. The singleton
  does not need to change; `changeMasterCopy` is available if a later Safe version is wanted.
- Who acts: each Safe's current owners (one threshold transaction per owner swap). Safe (the team) can help with a
  reviewed post-quantum signer contract and wallet support. Modules must be reviewed too: AllowanceModule delegates
  and Roles members are separate signers.
- EIP-7702-delegated owners remain ECDSA keys; they must be swapped like EOAs. No protocol change is needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: owners can move to post-quantum signers in place (contract owners, modules or upgrade)).
- 2026-11-17 review (Review04): MEDIUM kept (step 4: each Safe's owners can swap EOA owners for post-quantum signer contracts in place). Re-read threshold, owners, version, singleton, guard and modules of all 48 Safes at block 26,431,566 and typed all 219 owners; corrected 0x2bf916f8 (Safe 1.5.0) and 0x0632dcc3 (implementation 0xd9db270c).
- 2026-11-19 (study `eip-8151-impact`): `GnosisSafe.sol` 1.3.0, `checkNSignatures` lines 248 to 302, read again. An
  owner can sign in four ways: a contract signature through `isValidSignature` (`v == 0`), an approved hash
  (`v == 1`: the owner is `msg.sender` or called `approveHash`), and two `ecrecover` forms. What EIP-8151, as
  written, does here: when an owner's address has real code its two `ecrecover` forms stop (the transaction
  reverts: executed, see Evidence; by the source the reason is `GS026`, line 301; the reason string was not
  decoded from the replay), and the two other forms remain (source read, not executed). So
  an owner that migrates loses a way of signing and keeps its right, as long as its new account can call the Safe
  or answers `isValidSignature`. A 7702-delegated owner is not affected. On activation day each ECDSA owner
  signature costs 3,100 gas more when the owner's address is cold; 4,400 of 14,826 recoveries by this singleton in
  blocks 26,339,000 to 26,438,999 ran with less than that to spare in some frame.
