---
id: contract-54805468-owner-keys
format: 2
title: Quantum-forged owner keys could move this multisig's funds
status: candidate
severity: MEDIUM
justification: Forged owner keys could take all funds; the code is fixed, so the fix is the active owners moving
  the funds out.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x548054687ef6c56c6d82e8269e5fd93d8b88fcb2'
  code: decompiled
  code_url: code/0x4ebc7febeb43a35adca250c4cf18331ba3a7379bf5478beb17fc45cc7889bf1f.sol
  proxy_of: '0x8ff1ae80507d4c714456b7535e736ef4cfdaea19'
  copies: 1
  upgradeable: 'no'
value:
  usd: 64484362
  basis: held
activity:
  txs_90d: 188
impact: funds-loss
action: Move the funds, with one transfer signed by 9 owners, to a wallet whose signers can be post-quantum.
evidence_level: bytecode
checks:
- id: ecrecover
  bytecode: '0x8ff1ae80507d4c714456b7535e736ef4cfdaea19'
  has: 6001878783815181106113e157634e487b7160e01b600052603260045260246000fd5b6020026020010151601b6113f59190613ab4565b87848151811061141557634e487b7160e01b600052603260045260246000fd5b602002602001015187858151811061143d57634e487b7160e01b600052603260045260246000fd5b60200260200101516040516000815260200160405260405161146294939291906131c9565b6020604051602081039080840390855afa158015611484573d
  says: for each signature the implementation calls address 1 (ecrecover) with v+27, r and s, forwarding all gas;
    this is its only STATICCALL
  for:
  - evidence-1
  - justification
  - what
- id: lows
  bytecode: '0x8ff1ae80507d4c714456b7535e736ef4cfdaea19'
  has: 7f7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0
  says: the signature loop bounds s by half the secp256k1 order, an ECDSA-only check
  for:
  - evidence-1
  - what
- id: isowner
  bytecode: '0x8ff1ae80507d4c714456b7535e736ef4cfdaea19'
  has: 6001600160a01b031681526020019081526020016000205460001415611fd85760
  says: each recovered address is looked up in the owner mapping (slot 1) and the check fails if it is not an owner
  for:
  - evidence-1
  - what
- id: no1271
  selector: '0x8ff1ae80507d4c714456b7535e736ef4cfdaea19'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: the implementation never asks a signer contract through ERC-1271
  for:
  - evidence-1
  - what
- id: no1271legacy
  selector: '0x8ff1ae80507d4c714456b7535e736ef4cfdaea19'
  fn: isValidSignature(bytes,bytes)
  absent: true
  says: nor through the legacy ERC-1271 interface
  for:
  - evidence-1
  - what
- id: fntransfer
  selector: '0x8ff1ae80507d4c714456b7535e736ef4cfdaea19'
  fn: transfer(address,address,uint256,bytes32,uint8[],bytes32[],bytes32[],uint256)
  says: transfer takes arrays of v, r, s signatures
  for:
  - action
  - what
- id: fnbatch
  selector: '0x8ff1ae80507d4c714456b7535e736ef4cfdaea19'
  fn: batchTransfer(address,address[],uint256[],bytes32,uint8[],bytes32[],bytes32[],uint256)
  says: batchTransfer takes arrays of v, r, s signatures
  for:
  - action
  - what
- id: fnexecute
  selector: '0x8ff1ae80507d4c714456b7535e736ef4cfdaea19'
  fn: execute(address,uint256,bytes,bytes32,uint8[],bytes32[],bytes32[],uint256)
  says: execute makes an arbitrary call and takes arrays of v, r, s signatures
  for:
  - what
- id: fnreplace
  selector: '0x8ff1ae80507d4c714456b7535e736ef4cfdaea19'
  fn: replaceOwner(address[],address[],uint256,bytes32,uint8[],bytes32[],bytes32[],uint256)
  says: owners are replaced with arrays of v, r, s signatures
  for:
  - what
- id: required
  call: '0x548054687ef6c56c6d82e8269e5fd93d8b88fcb2'
  fn: getRequired()(uint256)
  is: 9
  says: 9 owner signatures are required at the block
  for:
  - action
  - evidence-2
  - justification
  - what
- id: owners
  call: '0x548054687ef6c56c6d82e8269e5fd93d8b88fcb2'
  fn: getOwners()(address[])
  is:
  - '0xa76d273815d9607f12ea03c9792b6b144e44bf19'
  - '0xf62312ceba7ad05d6da14c8a6dbde29d386eb50f'
  - '0xc7a84c919c7169a2e611db4a2ed8719cfa898684'
  - '0x0afb636c74df66b72b4cbf14f0ec9f79d42e90c4'
  - '0xb7d84ff7125553143ff7641dc6eb5c71c1395893'
  - '0x901c06088f7a8acb75f8076a06c89f40660ec4f6'
  - '0x61446a584643c04e0ee59b318061391f94c86e8d'
  - '0xd3fe7af745705ad8bc7490c026ffb3dc94ba4b39'
  - '0x570eaec51b09200fb05db932b1fa672b3eaa0edc'
  - '0xdd0a5ff8670abef3ba9dff9a46f1489dcdc6d999'
  - '0x5980f6358774489c77611ce2a7c029aa91ea209c'
  - '0x803c499a17f043cf55713641aacf5731261ea58e'
  - '0x88fc757292754bf22bbbb7044bab5eac65e4c953'
  - '0x16c373a363e0e75d423319b736bbb794eb54eab6'
  - '0x2c3ad9dc8b0205dc5b8b095ebdaca7767b04ae97'
  says: the wallet has these 15 owners
  for:
  - evidence-2
  - what
- id: owner1
  code: '0xa76d273815d9607f12ea03c9792b6b144e44bf19'
  is: empty
  says: owner 1 is a plain key with no code
  for:
  - evidence-2
- id: owner2
  code: '0xf62312ceba7ad05d6da14c8a6dbde29d386eb50f'
  is: empty
  says: owner 2 is a plain key with no code
  for:
  - evidence-2
- id: owner3
  code: '0xc7a84c919c7169a2e611db4a2ed8719cfa898684'
  is: empty
  says: owner 3 is a plain key with no code
  for:
  - evidence-2
- id: owner4
  code: '0x0afb636c74df66b72b4cbf14f0ec9f79d42e90c4'
  is: empty
  says: owner 4 is a plain key with no code
  for:
  - evidence-2
- id: owner5
  code: '0xb7d84ff7125553143ff7641dc6eb5c71c1395893'
  is: empty
  says: owner 5 is a plain key with no code
  for:
  - evidence-2
- id: owner6
  code: '0x901c06088f7a8acb75f8076a06c89f40660ec4f6'
  is: empty
  says: owner 6 is a plain key with no code
  for:
  - evidence-2
- id: owner7
  code: '0x61446a584643c04e0ee59b318061391f94c86e8d'
  is: empty
  says: owner 7 is a plain key with no code
  for:
  - evidence-2
- id: owner8
  code: '0xd3fe7af745705ad8bc7490c026ffb3dc94ba4b39'
  is: empty
  says: owner 8 is a plain key with no code
  for:
  - evidence-2
- id: owner9
  code: '0x570eaec51b09200fb05db932b1fa672b3eaa0edc'
  is: empty
  says: owner 9 is a plain key with no code
  for:
  - evidence-2
- id: owner10
  code: '0xdd0a5ff8670abef3ba9dff9a46f1489dcdc6d999'
  is: empty
  says: owner 10 is a plain key with no code
  for:
  - evidence-2
- id: owner11
  code: '0x5980f6358774489c77611ce2a7c029aa91ea209c'
  is: empty
  says: owner 11 is a plain key with no code
  for:
  - evidence-2
- id: owner12
  code: '0x803c499a17f043cf55713641aacf5731261ea58e'
  is: empty
  says: owner 12 is a plain key with no code
  for:
  - evidence-2
- id: owner13
  code: '0x88fc757292754bf22bbbb7044bab5eac65e4c953'
  is: empty
  says: owner 13 is a plain key with no code
  for:
  - evidence-2
- id: owner14
  code: '0x16c373a363e0e75d423319b736bbb794eb54eab6'
  is: empty
  says: owner 14 is a plain key with no code
  for:
  - evidence-2
- id: owner15
  code: '0x2c3ad9dc8b0205dc5b8b095ebdaca7767b04ae97'
  is: empty
  says: owner 15 is a plain key with no code
  for:
  - evidence-2
- id: tx
  tx: '0x70f0eb79c96a1076d276f59b5ec39ee7a4601053a3ba61a185f8eb2a070adb8b'
  to: '0x548054687ef6c56c6d82e8269e5fd93d8b88fcb2'
  ok: true
  says: a batchTransfer sent by owner 0xa76d2738 with owner signatures succeeded at block 26,390,456
  for:
  - action
  - evidence-2
  - justification
- id: lastactive
  call: '0x548054687ef6c56c6d82e8269e5fd93d8b88fcb2'
  fn: getLastActivatedTime()(uint256)
  is: 1794825935
  says: the last signed operation was at timestamp 1,794,825,935, about 40 hours before the block
  for:
  - justification
  - what
- id: proxyfactory
  bytecode: '0x548054687ef6c56c6d82e8269e5fd93d8b88fcb2'
  has: 7f000000000000000000000000657975f60cd55b81e0c029dd0572d5e678b3a9cf6001600160a01b03166334c5c27e
  says: the wallet's code holds the factory address as a constant and calls its getWalletImpl()
  for:
  - evidence-3
  - justification
  - proxy_of
  - upgradeable
  - what
- id: proxydelegate
  bytecode: '0x548054687ef6c56c6d82e8269e5fd93d8b88fcb2'
  has: 6000808284865af4
  says: the wallet delegatecalls the address the factory returns
  for:
  - evidence-3
  - proxy_of
  - what
- id: getimpl
  call: '0x657975f60cd55b81e0c029dd0572d5e678b3a9cf'
  fn: getWalletImpl()(address)
  is: '0x8ff1ae80507d4c714456b7535e736ef4cfdaea19'
  says: the factory returns implementation 0x8ff1ae80
  for:
  - evidence-3
  - justification
  - proxy_of
  - upgradeable
  - what
- id: implconst
  bytecode: '0x657975f60cd55b81e0c029dd0572d5e678b3a9cf'
  has: 7f0000000000000000000000008ff1ae80507d4c714456b7535e736ef4cfdaea199056
  says: getWalletImpl returns the implementation as a constant in the factory's code
  for:
  - evidence-3
  - justification
  - upgradeable
  - what
- id: decay
  bytecode: '0x8ff1ae80507d4c714456b7535e736ef4cfdaea19'
  has: 5b6105536203f48061054d6004
  says: getRequired lowers the count by one per 259,200 seconds (3 days) once the wallet has been idle past its
    interval
  for:
  - what
- id: switch
  call: '0x548054687ef6c56c6d82e8269e5fd93d8b88fcb2'
  fn: isSecuritySwitchOn()(bool)
  is: true
  says: the inactivity rule is switched on
  for:
  - what
- id: interval
  call: '0x548054687ef6c56c6d82e8269e5fd93d8b88fcb2'
  fn: getDeactivatedInterval()(uint256)
  is: 15552000
  says: the idle interval is 15,552,000 seconds, 180 days
  for:
  - what
- id: floor
  bytecode: '0x8ff1ae80507d4c714456b7535e736ef4cfdaea19'
  has: 11156105745760005461056c908261151c565b91505061057a565b50600190505b
  says: getRequired never falls below 1
  for:
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review03 (registry review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (study families read, judged from bytecode or placed by rules; not reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

This multisig sends tokens and ETH, makes calls and replaces owners when 9 of its 15 owners sign with ECDSA. Its code cannot change, so anyone who forges 9 owner keys with a quantum computer can take what it holds. After 180 days without a signature the 9 falls by one every 3 days, down to 1.

## Evidence

- The [implementation's bytecode](https://etherscan.io/address/0x8ff1ae80507d4c714456b7535e736ef4cfdaea19#code) recovers each signature with ECDSA, counts it only for an owner, and never asks ERC-1271.
- 9 of 15 owners, all plain keys, must sign; they signed [this transfer](https://etherscan.io/tx/0x70f0eb79c96a1076d276f59b5ec39ee7a4601053a3ba61a185f8eb2a070adb8b).
- The wallet runs the implementation its [factory](https://etherscan.io/address/0x657975f60cd55b81e0c029dd0572d5e678b3a9cf#code) returns, a constant in that factory's code.

## Reviewer notes

### Mechanism

The 394-byte wallet keeps factory 0x657975f6 as a constant, staticcalls its getWalletImpl() on every call with data and delegatecalls the answer, 0x8ff1ae80. The factory's runtime has no SLOAD or SSTORE and returns that address as a PUSH32 constant, so the implementation cannot change; the implementation has no DELEGATECALL, CALLCODE or SELFDESTRUCT. Its signed functions (transfer, batchTransfer, execute, addOwner, removeOwner, replaceOwner, changeOwnerRequirement, changeSecurityParams) all jump to one check (0x1230): array lengths equal, count at most the owner count and at least getRequired(); for each (v, r, s) v must be 0 or 1, s at most half the order, then ecrecover at address 1 with all gas; then every recovered address must be in the owner mapping (slot 1) and distinct. No function reads msg.sender. getRequired() is the stored 9 unless the security switch is on and the wallet has been idle past getDeactivatedInterval (180 days): then it falls by one per 3 days, down to 1. At the block the switch is on, the last signed operation was about 40 hours earlier, and 9 of 15 are required. All 15 owners have no code. A CRQC holder who derives 9 owner keys from their on-chain signatures can sign a transfer or execute and take the balance; adding owners does not help, every signature is ECDSA. MEDIUM (quantum-exposure, step 3): nobody can change the verification; the fix is the owners moving the funds, which they do routinely.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: ERC-1271 path: neither 0x1626ba7e nor 0x20c13b0b is in the implementation; its EXTCODESIZE is a token-call helper.
- Ruled out: A direct call by an owner: no function reads msg.sender; every signed function jumps to the one signature check.
- Ruled out: Upgrade: the factory has no SLOAD/SSTORE and returns a constant implementation; it has no DELEGATECALL or upgrade selector.
- Ruled out: Dormant: 188 calls in the 90 days to the block; last signed operation about 40 hours before it.
- Ruled out: Lower threshold today: getRequired() and getOwnerRequiredParam() both return 9; inactivity only lowers it after 180 idle days.
- Ruled out: Copies: dossier lists none. Old finding names 4 sibling wallets by prefix only (0xca7fbeb7, 0x573487d9, 0xe391cca8, 0x5096d787); not reviewed here.
- Ruled out: Gas: old file also tagged a sender-gas-limit notice; no replay in this dossier and the recovery forwards all gas, so no fixed gas amount here.
- Ruled out: Whose money: operator not identified; whether the USDT is its own or customers' is not shown, so whose is left empty.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
