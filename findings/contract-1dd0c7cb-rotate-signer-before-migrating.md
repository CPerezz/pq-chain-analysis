---
id: contract-1dd0c7cb-rotate-signer-before-migrating
format: 2
title: Enjin bridge refuses a manager's signatures once its account takes real code
status: candidate
severity: INFORMATIONAL
justification: Nothing breaks unless a manager moves to real code, and the managers can replace a manager key first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1dd0c7cbf5b420648fe37edcdc64cbe30842e3b2'
  code: decompiled
  code_url: code/0x0c31d06242074c64ddf2925323b9a75ecf6b37a68c2694aa7599cc6912dbf280.sol
  proxy_of: '0x5d4f0193f5adf132c371c541753d89c077b3f199'
  copies: 2
  family: dbfd3be12e9c8e20ec0ad55e80b25f27
  upgradeable: 'yes'
  admin: '0x7944d6b3b7683296a1e53bde91797796abb31588'
value:
  usd: 0
  basis: held
activity: {}
impact: liveness
action: Add a replacement manager and remove the old key before any manager's account moves to real code.
evidence_level: bytecode
checks:
- id: ecrec
  bytecode: '0x5d4f0193f5adf132c371c541753d89c077b3f199'
  has: 601f1981019281900390910190855afa158015
  says: the implementation calls the ecrecover precompile (address 1) with all remaining gas
  for:
  - evidence-1
  - justification
  - what
- id: invsig
  bytecode: '0x5d4f0193f5adf132c371c541753d89c077b3f199'
  has: 4272696467654d616e616765723a20696e76616c6964207369676e6174757265
  says: 'the code rejects a recovered signer with ''BridgeManager: invalid signature'''
  for:
  - evidence-1
  - justification
  - what
- id: enjin
  bytecode: '0x5d4f0193f5adf132c371c541753d89c077b3f199'
  has: 456e6a696e41737365744272696467653a2063616e6e6f742062652070726f636573736564207477696365
  says: the code names itself EnjinAssetBridge in its revert text
  for:
  - what
- id: no1271
  bytecode: '0x5d4f0193f5adf132c371c541753d89c077b3f199'
  has: 1626ba7e
  absent: true
  says: no ERC-1271 isValidSignature selector in the code
  for:
  - evidence-1
  - what
- id: mgrcount
  storage: '0x1dd0c7cbf5b420648fe37edcdc64cbe30842e3b2'
  slot: '0x2'
  is: 3
  says: three managers are registered
  for:
  - action
  - evidence-2
  - what
- id: mgr1
  storage: '0x1dd0c7cbf5b420648fe37edcdc64cbe30842e3b2'
  slot: '0xf59bbde00a742103d60550bfe1d1fcd5c35de55475d24a7a4b50028b6712a7b2'
  is: 1
  says: 0x5f071b5b29bc3bbaa4480c134b4da56cd2d35fbe is manager number 1
  for:
  - evidence-2
  - what
- id: mgr2
  storage: '0x1dd0c7cbf5b420648fe37edcdc64cbe30842e3b2'
  slot: '0x5a173c6d89a70cfaf56e8920343442786f3166f2da9a17acd40446d55d7e0290'
  is: 2
  says: 0x0c49daa59ac390c7b87027f5fa6bd2ec83bea349 is manager number 2
  for:
  - evidence-2
  - what
- id: mgr3
  storage: '0x1dd0c7cbf5b420648fe37edcdc64cbe30842e3b2'
  slot: '0xf145a024a3fe612ecdc88db70ee687c534c9771f04d958ac5f0255d93e95800f'
  is: 3
  says: 0x073cc6d7b0fa2da1d112a8963d1917f585214f3f is manager number 3
  for:
  - evidence-2
  - what
- id: code1
  code: '0x5f071b5b29bc3bbaa4480c134b4da56cd2d35fbe'
  is: empty
  says: manager 1 has no code
  for:
  - evidence-2
- id: code2
  code: '0x0c49daa59ac390c7b87027f5fa6bd2ec83bea349'
  is: empty
  says: manager 2 has no code
  for:
  - evidence-2
- id: code3
  code: '0x073cc6d7b0fa2da1d112a8963d1917f585214f3f'
  is: empty
  says: manager 3 has no code
  for:
  - evidence-2
- id: enabled
  call: '0x1dd0c7cbf5b420648fe37edcdc64cbe30842e3b2'
  fn: enabled()(bool)
  is: false
  says: the bridge is disabled at the block
  for:
  - evidence-2
  - what
- id: disabledstr
  bytecode: '0x5d4f0193f5adf132c371c541753d89c077b3f199'
  has: 456e6a696e4272696467653a204272696467652064697361626c6564
  says: 'the code refuses calls with ''EnjinBridge: Bridge disabled'''
  for:
  - what
- id: onlymgr
  bytecode: '0x5d4f0193f5adf132c371c541753d89c077b3f199'
  has: 4272696467654d616e616765723a206f6e6c79206d616e61676572
  says: 'manager functions check the caller with ''BridgeManager: only manager'''
  for:
  - evidence-3
- id: propose
  bytecode: '0x5d4f0193f5adf132c371c541753d89c077b3f199'
  has: 70726f706f73654272696467654d616e61676572206973206e6f7420617070726f766564
  says: proposing a new manager needs approval ('proposeBridgeManager is not approved')
  for:
  - action
  - evidence-3
  - justification
- id: accept
  selector: '0x5d4f0193f5adf132c371c541753d89c077b3f199'
  fn: acceptBridgeManager()
  says: a proposed manager accepts with acceptBridgeManager
  for:
  - action
  - evidence-3
- id: remove
  bytecode: '0x5d4f0193f5adf132c371c541753d89c077b3f199'
  has: 72656d6f76654272696467654d616e61676572206973206e6f7420617070726f766564
  says: removing a manager needs approval ('removeBridgeManager is not approved')
  for:
  - action
  - evidence-3
  - justification
- id: setenabled
  selector: '0x5d4f0193f5adf132c371c541753d89c077b3f199'
  fn: setEnabled(bool)
  says: the code has setEnabled(bool) (0x328d8f72), which the decompiled code shows as a manager-only setter of
    the enabled flag
  for:
  - notes
- id: enjtwice
  bytecode: '0x5d4f0193f5adf132c371c541753d89c077b3f199'
  has: 456e6a696e4272696467653a207472616e736665722063616e6e6f742062652070726f636573736564207477696365
  says: the code refuses an ENJ transfer 'processed twice', the guard of the signed release
  for:
  - what
- id: siglen
  bytecode: '0x5d4f0193f5adf132c371c541753d89c077b3f199'
  has: 4272696467654d616e616765723a20696e76616c6964207369676e6174757265206c656e677468
  says: 'the code requires a single signature of fixed length (''BridgeManager: invalid signature length'')'
  for:
  - evidence-1
  - what
- id: enjbal
  call: '0xf629cbd94d3791c9250152bd8dfbdf380e2a3b9c'
  fn: balanceOf(address)(uint256)
  args:
  - '0x1dd0c7cbf5b420648fe37edcdc64cbe30842e3b2'
  is: 0
  says: the bridge holds no ENJ (the token stored at slot 0x3f)
  for:
  - evidence-2
- id: enjslot
  storage: '0x1dd0c7cbf5b420648fe37edcdc64cbe30842e3b2'
  slot: '0x3f'
  is: '0xf629cbd94d3791c9250152bd8dfbdf380e2a3b9c'
  says: the bridge's ENJ token is 0xf629cbd9…3b9c (slot 0x3f)
  for:
  - evidence-2
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews:
- who: r-1dd0c7cb, the row's refuter
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: Sent back once (the signed releases are live despite the disabled flag); re-rendered once by Claude
    for the code line (decompiled, not verified). A third refuter agrees on every part; sheet read by Claude. Enjin
    bridge: three manager keys, rotation by direct calls. Stays a candidate.'
related: []
---

## What happens

This Enjin bridge releases ENJ and items on one signature from one of its three managers. Its enabled flag is off at this block and stops other signed actions; the signed releases skip it and stay open. A manager whose account takes real code stops counting; an EIP-7702 delegation keeps working.

## Evidence

- [The bridge code](https://etherscan.io/address/0x5d4f0193f5adf132c371c541753d89c077b3f199#code) recovers one signature with ecrecover, rejects non-managers, and has no ERC-1271 check.
- [The bridge](https://etherscan.io/address/0x1dd0c7cbf5b420648fe37edcdc64cbe30842e3b2#readProxyContract) has three managers, all without code; its enabled flag is off and it holds no ENJ.
- [Managers](https://etherscan.io/address/0x5d4f0193f5adf132c371c541753d89c077b3f199#code) add and remove managers through approvals given by direct calls, not by signatures.

## Reviewer notes

### Mechanism

Proxy to unverified code 0x5d4f0193 (read from the decompiler). The signed releases (0x5fcf462e pays ENJ, token at slot 0x3f; 0x6de2b0c3 and 0x3c3aa281 send ERC-1155 items, slot 0x73) refuse a transfer processed twice, take one 65-byte signature, recover it with ecrecover (all remaining gas) and require a manager (mapping at slot 1), else 'BridgeManager: invalid signature'. They do not test the enabled flag; other signed actions (0x11228f62, 0x12ffd09f, 0x30be741c, ...) do. No msg.sender path, no ERC-1271 call. Manager-only direct calls: setEnabled(bool); 0x67ce2157 and 0x54bc3cb1 record approvals; proposeBridgeManager (2 approvals) then acceptBridgeManager adds a manager; removeBridgeManager (2 approvals, more than 2 managers) removes one. Approvals are direct calls, so a manager with real code still takes part in a rotation. At the block: enabled() false, three EOA managers (count at slot 2), transfer nonce 7,474.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: a fixed gas amount on the recovery: the ecrecover STATICCALL is preceded by GAS (bytes 855afa at pc 23,215).
- Ruled out: an ERC-1271 path: the selector 1626ba7e is absent from the implementation's code.
- Ruled out: unused implementation: this proxy is initialized (three managers, transfer nonce 7,474); the other copy, implementation 0x5d4f0193, has no managers (slot 2 is 0).
- Ruled out: a closed path: enabled() is false, but the signed releases skip it. Re-run at the block with sig 0x111111111111111111111111111111111111111111111111111111111111111100000000000000000000000000000000000000000000000000000000000000011b: 0x5fcf462e (uint8,uint256,address,uint256,bytes)=(2,987654321,0xdEaD,5555,sig), 0x6de2b0c3 (uint8,uint256,uint256,address,uint256,bytes)=(2,987654321,1,0xdEaD,5,sig), 0x3c3aa281 (uint8,uint256,address,uint256[],uint256[],bytes)=(2,987654321,0xdEaD,[1],[1],sig) revert 'BridgeManager: invalid signature'; 0x11228f62 (uint256,uint32,bytes)=(1,2,sig) reverts 'Bridge disabled'. No check kind calls an unnamed selector, so what-2 rests on these reads and the decompiled bodies.
- Ruled out: a rechecked signature: a manager's signature on a pending release fails if that manager moves to real code before it is submitted, but any other manager can sign it again; judged a notice. Reviewer may weigh this.
- Ruled out: a direct path for the signed bridge actions: none seen in the decompiled code; the signed functions have no manager-only twin.

### Questions

- Value: $0 counts ETH (0) and ENJ (balanceOf 0) only. Items of the ERC-1155 at 0xfaafdc07907ff5120a76b34b731b278c38d6043c that the bridge may hold for past transfers (transfer nonce 7,474) are not read: no token IDs are known.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
