---
id: contract-197f58de-signed-shortcut-lost
format: 2
title: VaultCraft Idle junior adapter holders with real code lose permit, keep approve
status: candidate
severity: INFORMATIONAL
justification: Breaks only if a share holder moves its own account to real code; approve still works for it.
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x197f58de2559097d956b4192e8f89a2f36190a48'
  code: bytecode
  code_url: https://etherscan.io/address/0x197f58de2559097d956b4192e8f89a2f36190a48#code
  proxy_of: '0xfc1437d21e1ec7602c5e726f4a7ff35bc6c163cd'
  copies: 11
  family: c6d7781c5cf3c1cb87ad2ec1a672be31
  admin: '0x564fbe59c448743fa9382e691a0320458f6dcde5'
value:
  usd: 180
  basis: held
activity: {}
impact: liveness
action: Tell share holders to approve spenders with approve instead of permit before they move their accounts to
  real code.
evidence_level: bytecode
checks:
- id: clone
  bytecode: '0x197f58de2559097d956b4192e8f89a2f36190a48'
  has: 363d3d373d3d3d363d73fc1437d21e1ec7602c5e726f4a7ff35bc6c163cd5af4
  says: this address is a minimal clone that delegates every call to the implementation
  for:
  - what
- id: clone-usdc
  bytecode: '0x29be2a691394f635a9ac506a238cc201baa52351'
  has: 363d3d373d3d3d363d73fc1437d21e1ec7602c5e726f4a7ff35bc6c163cd5af4
  says: the USDC copy is a clone of the same implementation
  for:
  - what
- id: clone-usdt
  bytecode: '0xe48d33e869f874d6bee3701bef22ae72c60a3b3c'
  has: 363d3d373d3d3d363d73fc1437d21e1ec7602c5e726f4a7ff35bc6c163cd5af4
  says: the USDT copy is a clone of the same implementation
  for:
  - what
- id: name
  call: '0x197f58de2559097d956b4192e8f89a2f36190a48'
  fn: name()(string)
  is: VaultCraft Idle Junior Dai Stablecoin Adapter
  says: this address is the VaultCraft Idle junior DAI adapter
  for:
  - what
- id: copy-usdc
  call: '0x29be2a691394f635a9ac506a238cc201baa52351'
  fn: symbol()(string)
  is: vcIdlJ-USDC
  says: a copy is the USDC adapter
  for:
  - what
- id: copy-usdt
  call: '0xe48d33e869f874d6bee3701bef22ae72c60a3b3c'
  fn: symbol()(string)
  is: vcIdlJ-USDT
  says: a copy is the USDT adapter
  for:
  - what
- id: supply
  call: '0x197f58de2559097d956b4192e8f89a2f36190a48'
  fn: totalSupply()(uint256)
  is: '319419499849562532001786155'
  says: shares are outstanding at the block
  for:
  - evidence-3
- id: assets
  call: '0x197f58de2559097d956b4192e8f89a2f36190a48'
  fn: totalAssets()(uint256)
  is: '386114123923479599'
  says: the shares are backed by 0.386 DAI
  for:
  - evidence-3
- id: dai-held
  call: '0x6b175474e89094c44da98b954eedeac495271d0f'
  fn: balanceOf(address)(uint256)
  args:
  - '0x197f58de2559097d956b4192e8f89a2f36190a48'
  is: '179744655230149501152'
  says: the address holds 179.74 DAI
  for:
  - evidence-3
- id: paused
  call: '0x197f58de2559097d956b4192e8f89a2f36190a48'
  fn: paused()(bool)
  is: 'false'
  says: the vault is not paused at the block
  for:
  - notes
- id: permit-sel
  selector: '0xfc1437d21e1ec7602c5e726f4a7ff35bc6c163cd'
  fn: permit(address,address,uint256,uint256,uint8,bytes32,bytes32)
  says: the code has a permit function
  for:
  - action
  - what
- id: typehash
  bytecode: '0xfc1437d21e1ec7602c5e726f4a7ff35bc6c163cd'
  has: 6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9
  says: the code holds the EIP-2612 Permit type hash
  for:
  - evidence-1
- id: ec-compare
  bytecode: '0xfc1437d21e1ec7602c5e726f4a7ff35bc6c163cd'
  has: fa158015611350573d6000803e3d6000fd5b5050604051601f1901519150506001600160a01b03811615806113855750876001600160a01b0316816001600160a01b031614155b156113ae5760405163bf18af43
  says: after the recovery the code reverts unless the recovered address is non-zero and equals the owner argument
  for:
  - evidence-1
  - justification
  - what
- id: full-gas
  bytecode: '0xfc1437d21e1ec7602c5e726f4a7ff35bc6c163cd'
  has: 855afa158015611350
  says: the recovery call passes all remaining gas, not a fixed amount
  for:
  - evidence-1
- id: no-1271
  bytecode: '0xfc1437d21e1ec7602c5e726f4a7ff35bc6c163cd'
  has: 1626ba7e
  absent: true
  says: the code never asks a signer contract through ERC-1271
  for:
  - evidence-1
  - what
- id: signer-empty
  code: '0x86ddf911d9f2f209ff6a697b5d654e8561198dbe'
  is: empty
  says: the test signer is a plain key with no code
  for:
  - evidence-2
- id: permit-ok
  call: '0x197f58de2559097d956b4192e8f89a2f36190a48'
  data: '0xd505accf00000000000000000000000086ddf911d9f2f209ff6a697b5d654e8561198dbe000000000000000000000000000000000000000000000000000000000000dead00000000000000000000000000000000000000000000000000000000000003e800000000000000000000000000000000000000000000000000000000f4865700000000000000000000000000000000000000000000000000000000000000001b3af2565ad6cf4eb6952a2306dc92d7e6f8e6c874b90152954b59e34330923a7b217730050bb5f5c35423306369b8aab0dd8ff6bfe81dfab56c45867e5a43f547'
  is: 0x
  says: a permit signed with ECDSA by a plain key is accepted
  for:
  - evidence-2
  - what
- id: permit-bad
  call: '0x197f58de2559097d956b4192e8f89a2f36190a48'
  data: '0xd505accf00000000000000000000000086ddf911d9f2f209ff6a697b5d654e8561198dbe000000000000000000000000000000000000000000000000000000000000dead00000000000000000000000000000000000000000000000000000000000003e900000000000000000000000000000000000000000000000000000000f4865700000000000000000000000000000000000000000000000000000000000000001b3af2565ad6cf4eb6952a2306dc92d7e6f8e6c874b90152954b59e34330923a7b217730050bb5f5c35423306369b8aab0dd8ff6bfe81dfab56c45867e5a43f547'
  reverts_with: '0xbf18af430000000000000000000000000ef8043619b9989c4ff27afa1042040addcbb990'
  says: a signature that does not recover to the owner reverts with the recovered address
  for:
  - evidence-2
  - what
- id: approve-direct
  call: '0x197f58de2559097d956b4192e8f89a2f36190a48'
  fn: approve(address,uint256)(bool)
  args:
  - '0x000000000000000000000000000000000000dEaD'
  - '1000'
  from: '0x86ddf911d9f2f209ff6a697b5d654e8561198dbe'
  is: 'true'
  says: a holder can set the same allowance by a direct call with no signature
  for:
  - action
  - justification
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews:
- who: r-197f58de, the row's refuter
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: Sent back once (the title named only the DAI copy; the $1,419 was called holders'' money). The redone
    card names the VaultCraft Idle junior adapter family and leaves whose empty: the $1,419 is idle underlying at
    three copies, outside each vault''s totalAssets. A fresh refuter agrees, disassembling the implementation; sheet
    read by Claude. INFORMATIONAL (was LOW); candidate (unverified).'
related: []
---

## What happens

Holders of VaultCraft Idle junior adapters (DAI, USDC, USDT) can approve by signed permit or by a direct approve call. The permit counts only if ECDSA recovers the holder's own address. A holder whose account takes real code, not an EIP-7702 delegation, loses permit; approve still works.

## Evidence

- [permit](https://etherscan.io/address/0xfc1437d21e1ec7602c5e726f4a7ff35bc6c163cd#code) recovers the signer of an EIP-712 Permit with full gas and reverts unless it is the owner; no ERC-1271 call.
- [A permit](https://etherscan.io/address/0x197f58de2559097d956b4192e8f89a2f36190a48#code) signed by a plain key passes at the block; a tampered one reverts with the recovered address.
- [Here](https://etherscan.io/address/0x197f58de2559097d956b4192e8f89a2f36190a48#code) the shares are backed by 0.386 DAI; the 179.74 DAI held at the address is outside that figure.

## Reviewer notes

### Mechanism

0x197f58de2559097d956b4192e8f89a2f36190a48 is an EIP-1167 clone of the unverified 0xfc1437d21e1ec7602c5e726f4a7ff35bc6c163cd, as are the USDC copy 0x29be2a69... and the USDT copy 0xe48d33e8.... The shares (name VaultCraft Idle Junior Dai Stablecoin Adapter, symbol vcIdlJ-DAI) carry an EIP-2612 permit (selector 0xd505accf, Permit type hash in the code). After the STATICCALL to the ecrecover precompile, which forwards all remaining gas (GAS then STATICCALL), the code reverts with custom error 0xbf18af43(recovered) unless the recovered address is non-zero and equals the owner argument; no ERC-1271 selector (0x1626ba7e) is in the code. approve(address,uint256) sets an allowance for the caller with no signature. At block 26,438,999 this clone is not paused and has 319419499849562532001786155 shares outstanding; totalAssets() is 386114123923479599 (0.386 DAI) while DAI.balanceOf(this) is 179744655230149501152 (179.74 DAI), so the tokens held at the address are not what backs the shares. A permit eth_call from a fresh no-code key succeeds and a tampered one reverts with the recovered address. The row's value counts tokens held at the 11 addresses, mostly USDC at 0x29be... (1,187.12 USDC); whose those tokens are is not established.

### Checks

- Header facts: this address alone, at block 26,438,999; 11 addresses run this code.
- Ruled out: an ERC-1271 or code-size path: the selector 0x1626ba7e is absent and the recovered address is compared directly with the owner argument.
- Ruled out: a fixed gas budget for the precompile: the call passes GAS, so the higher price does not break it by itself.
- Ruled out: an unused implementation: this clone is initialized, not paused, and has shares outstanding.
- Ruled out: a re-checked signature: the permit only sets an allowance at once; nothing checks it again later.
- Ruled out: a claim on whose the held tokens are: the 179.74 DAI here and the 1,187.12 USDC at 0x29be... are not counted in totalAssets(), so no check shows they belong to share holders; whose is left empty.

### Questions

- Whose are the underlying tokens held directly at the adapter addresses (179.74 DAI here, 1,187.12 USDC at 0x29be...), given they are outside totalAssets()?

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
