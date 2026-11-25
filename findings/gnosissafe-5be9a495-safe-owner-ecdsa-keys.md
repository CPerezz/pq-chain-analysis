---
id: gnosissafe-5be9a495-safe-owner-ecdsa-keys
format: 2
title: Three forged owner keys let a quantum attacker empty this Safe and upgrade WLFI
status: confirmed
severity: MEDIUM
justification: 'Fixable without a protocol change, but only if the owners act: 3 of 5 sign to swap each key for
  a post-quantum signer.'
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5be9a4959308a0d0c7bc0870e319314d8d957dbb'
  name: GnosisSafe
  code: verified
  code_url: https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code
  proxy_of: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  copies: 1
  upgradeable: 'yes'
value:
  usd: 581612573
  whose: mixed
  basis: held
activity: {}
impact: funds-loss
action: Swap each owner via swapOwner for a post-quantum contract signer that answers the legacy isValidSignature(bytes,bytes).
evidence_level: source
checks:
- id: singleton
  storage: '0x5be9a4959308a0d0c7bc0870e319314d8d957dbb'
  slot: '0x0'
  is: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  says: slot 0 of the proxy holds the Safe 1.3.0 singleton, the code every call runs
  for:
  - upgradeable
- id: proxycode
  source: '0x5be9a4959308a0d0c7bc0870e319314d8d957dbb'
  file: GnosisSafeProxy.sol
  line: 36
  has: let success := delegatecall(gas(), _singleton, 0, calldatasize(), 0, 0)
  says: the proxy forwards every call to the singleton in slot 0
  for:
  - upgradeable
- id: version
  call: '0x5be9a4959308a0d0c7bc0870e319314d8d957dbb'
  fn: VERSION()(string)
  is: 1.3.0
  says: the Safe answers version 1.3.0
  for:
  - notes
- id: threshold
  call: '0x5be9a4959308a0d0c7bc0870e319314d8d957dbb'
  fn: getThreshold()(uint256)
  is: 3
  says: three owner approvals are needed
  for:
  - evidence-2
  - justification
  - what
- id: owners
  call: '0x5be9a4959308a0d0c7bc0870e319314d8d957dbb'
  fn: getOwners()(address[])
  is:
  - '0x0cb30cc659e9cfa2a4bea140eb3577a51aa2f661'
  - '0xc0670953bc75aaa28f93464bb6907154a035b576'
  - '0x2adacc76089b26b03189d999991134052458e515'
  - '0x2652067bc90dd89bb67ae6f08a723d58b05e543b'
  - '0x407f66afb4f9876637accc3246099a2f9705c178'
  says: the Safe has five owners
  for:
  - evidence-2
  - what
- id: code1
  code: '0x0cb30cc659e9cfa2a4bea140eb3577a51aa2f661'
  is: empty
  says: 'owner 1 has no code: an ordinary ECDSA account, no EIP-7702 delegation'
  for:
  - evidence-2
  - what
- id: code2
  code: '0xc0670953bc75aaa28f93464bb6907154a035b576'
  is: empty
  says: 'owner 2 has no code: an ordinary ECDSA account, no EIP-7702 delegation'
  for:
  - evidence-2
  - what
- id: code3
  code: '0x2adacc76089b26b03189d999991134052458e515'
  is: empty
  says: 'owner 3 has no code: an ordinary ECDSA account, no EIP-7702 delegation'
  for:
  - evidence-2
  - what
- id: code4
  code: '0x2652067bc90dd89bb67ae6f08a723d58b05e543b'
  is: empty
  says: 'owner 4 has no code: an ordinary ECDSA account, no EIP-7702 delegation'
  for:
  - evidence-2
  - what
- id: code5
  code: '0x407f66afb4f9876637accc3246099a2f9705c178'
  is: empty
  says: 'owner 5 has no code: an ordinary ECDSA account, no EIP-7702 delegation'
  for:
  - evidence-2
  - what
- id: nonce1
  nonce: '0x0cb30cc659e9cfa2a4bea140eb3577a51aa2f661'
  min: 1
  says: owner 1 has sent transactions, so its public key is on-chain
  for:
  - evidence-2
  - what
- id: nonce2
  nonce: '0xc0670953bc75aaa28f93464bb6907154a035b576'
  min: 1
  says: owner 2 has sent transactions, so its public key is on-chain
  for:
  - evidence-2
  - what
- id: nonce3
  nonce: '0x2adacc76089b26b03189d999991134052458e515'
  min: 1
  says: owner 3 has sent transactions, so its public key is on-chain
  for:
  - evidence-2
  - what
- id: nonce4
  nonce: '0x2652067bc90dd89bb67ae6f08a723d58b05e543b'
  min: 1
  says: owner 4 has sent transactions, so its public key is on-chain
  for:
  - evidence-2
  - what
- id: nonce5
  nonce: '0x407f66afb4f9876637accc3246099a2f9705c178'
  min: 1
  says: owner 5 has sent transactions, so its public key is on-chain
  for:
  - evidence-2
  - what
- id: intx
  tx: '0x8cf0a7fc3b32193bc45277a3ed907fab286d10675d83833fc2c92de1d13b9584'
  to: '0x5be9a4959308a0d0c7bc0870e319314d8d957dbb'
  ok: true
  says: the Safe executed a signed transaction at block 26,437,049, so it is in use
  for:
  - what
- id: checksig
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 145
  has: checkSignatures(txHash, txHashData, signatures);
  says: execTransaction checks threshold-many signatures over the transaction hash
  for:
  - evidence-1
  - what
- id: exec
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 176
  has: 'success = execute(to, value, data, operation, gasPrice == 0 ? (gasleft() - 2500) : safeTxGas);'
  says: after the signature check, execTransaction runs the call the owners signed
  for:
  - evidence-1
  - upgradeable
  - what
- id: ecdsa
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  lines:
  - 292
  - 300
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: a signature slot with v other than 0 or 1 is recovered with ecrecover
  for:
  - evidence-1
  - what
- id: isowner
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 301
  has: require(currentOwner > lastOwner && owners[currentOwner] != address(0) && currentOwner != SENTINEL_OWNERS,
    "GS026");
  says: each recovered or named address must be a distinct owner
  for:
  - evidence-1
  - what
- id: erc1271
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  lines:
  - 257
  - 285
  has: require(ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE,
    "GS024");
  says: 'v == 0: a contract owner is asked through legacy ERC-1271 with a signature of any length'
  for:
  - action
  - evidence-1
  - justification
- id: approved
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  lines:
  - 286
  - 291
  has: require(msg.sender == currentOwner || approvedHashes[currentOwner][dataHash] != 0, "GS025");
  says: 'v == 1: an owner that is the sender or approved the hash on-chain counts'
  for:
  - evidence-1
- id: anycall
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/base/Executor.sol
  line: 23
  has: success := call(txGas, to, value, add(data, 0x20), mload(data), 0, 0)
  says: the signed transaction is any call with any value
  for:
  - what
- id: delegate
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/base/Executor.sol
  line: 18
  has: success := delegatecall(txGas, to, add(data, 0x20), mload(data), 0, 0)
  says: a signed delegatecall can rewrite any storage, including the singleton in slot 0
  for:
  - upgradeable
- id: swap
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/base/OwnerManager.sol
  lines:
  - 94
  - 111
  has: owners[newOwner] = owners[oldOwner];
  says: swapOwner replaces one owner with another address
  for:
  - action
  - justification
- id: self
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/common/SelfAuthorized.sol
  line: 8
  has: require(msg.sender == address(this), "GS031");
  says: owner changes run only as a call from the Safe itself, that is a signed execTransaction
  for:
  - action
  - justification
- id: noguard
  storage: '0x5be9a4959308a0d0c7bc0870e319314d8d957dbb'
  slot: '0x4a204f620c8c5ccdca3fd54d003badd85ba500436a431f0cbda4f558c93c34c8'
  is: 0
  says: no guard is set
  for:
  - what
- id: nomodules
  call: '0x5be9a4959308a0d0c7bc0870e319314d8d957dbb'
  fn: getModulesPaginated(address,uint256)(address[],address)
  args:
  - '0x0000000000000000000000000000000000000001'
  - 10
  is:
  - []
  - '0x0000000000000000000000000000000000000001'
  says: no module is enabled, so nothing executes without owner signatures
  for:
  - what
- id: eth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x5be9a4959308a0d0c7bc0870e319314d8d957dbb'
  is: 97153224397198210
  says: the Safe holds 0.097 ETH
  for:
  - notes
- id: wlfi
  call: '0xda5e1988097297dcdc1f90d4dfe7909e847cbef6'
  fn: balanceOf(address)(uint256)
  args:
  - '0x5be9a4959308a0d0c7bc0870e319314d8d957dbb'
  is: 12620954712407985733934658203
  says: the Safe holds 12.62 billion of the token 0xda5e1988 (symbol WLFI)
  for:
  - what
  - whose
- id: magic
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/interfaces/ISignatureValidator.sol
  line: 6
  has: bytes4 internal constant EIP1271_MAGIC_VALUE = 0x20c13b0b;
  says: the Safe expects the legacy isValidSignature(bytes,bytes) magic value 0x20c13b0b, not the final ERC-1271
    0x1626ba7e
  for:
  - action
  - evidence-1
  - justification
- id: tokenowner
  call: '0xda5e1988097297dcdc1f90d4dfe7909e847cbef6'
  fn: owner()(address)
  is: '0x5be9a4959308a0d0c7bc0870e319314d8d957dbb'
  says: this Safe is the owner of the WLFI token
  for:
  - evidence-3
  - whose
- id: adminslot
  storage: '0xda5e1988097297dcdc1f90d4dfe7909e847cbef6'
  slot: '0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103'
  is: '0x7f533afa9e994b7e44673188034f9ce52886a0c0'
  says: the WLFI token proxy's EIP-1967 admin is the ProxyAdmin 0x7f533afa
  for:
  - evidence-3
  - what
  - whose
- id: paowner
  call: '0x7f533afa9e994b7e44673188034f9ce52886a0c0'
  fn: owner()(address)
  is: '0x5be9a4959308a0d0c7bc0870e319314d8d957dbb'
  says: this Safe owns the ProxyAdmin of the WLFI token
  for:
  - evidence-3
  - what
  - whose
- id: paupgrade
  call: '0x7f533afa9e994b7e44673188034f9ce52886a0c0'
  data: '0x9623609d000000000000000000000000da5e1988097297dcdc1f90d4dfe7909e847cbef600000000000000000000000073fe14ff5a25e4363a72828cccd8444f0748fde700000000000000000000000000000000000000000000000000000000000000600000000000000000000000000000000000000000000000000000000000000000'
  from: '0x5be9a4959308a0d0c7bc0870e319314d8d957dbb'
  is: 0x
  says: called by this Safe, the ProxyAdmin's upgradeAndCall on the WLFI token proxy succeeds
  for:
  - evidence-3
  - what
  - whose
- id: panotother
  call: '0x7f533afa9e994b7e44673188034f9ce52886a0c0'
  data: '0x9623609d000000000000000000000000da5e1988097297dcdc1f90d4dfe7909e847cbef600000000000000000000000073fe14ff5a25e4363a72828cccd8444f0748fde700000000000000000000000000000000000000000000000000000000000000600000000000000000000000000000000000000000000000000000000000000000'
  from: '0x0000000000000000000000000000000000000bad'
  reverts_with: '0x118cdaa70000000000000000000000000000000000000000000000000000000000000bad'
  says: called by any other address, upgradeAndCall reverts with OwnableUnauthorizedAccount
  for:
  - evidence-3
  - what
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
- study: eip-8151-impact
  who: Claude (source of 1.3.0 read, two real transactions replayed four ways; not reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: confirmed
  rating: ''
  pattern: PQ-12
reviews:
- who: r-5be9a495, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Kev''s first-study finding, MEDIUM (PQ-12): a 3-of-5 Safe 1.3.0 whose five owners are plain ECDSA
    keys with exposed public keys; it holds about $581.6M (mostly WLFI) and owns the WLFI token and its ProxyAdmin,
    so three forged keys can also upgrade WLFI and reach every holder (whose: mixed). Fix: swapOwner to post-quantum
    signer contracts answering Safe 1.3.0''s legacy isValidSignature(bytes,bytes). Second version after a return;
    two refuters agree; Claude read the sheet.'
related: []
---

## What happens

This Safe runs any call that 3 of its 5 owners sign, and it controls upgrades of the WLFI token. All five owners are plain ECDSA accounts whose public keys are on-chain. A quantum computer that derives three keys can empty the Safe and upgrade WLFI to take any holder's tokens.

## Evidence

- [The Safe's code](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) counts owners' ECDSA signatures, legacy ERC-1271 answers or approved hashes, then runs the signed call.
- [This Safe](https://etherscan.io/address/0x5be9a4959308a0d0c7bc0870e319314d8d957dbb#readProxyContract) needs 3 of 5 owners; all five are accounts without code that have sent transactions.
- [WLFI's ProxyAdmin](https://etherscan.io/address/0x7f533afa9e994b7e44673188034f9ce52886a0c0#readContract) is owned by this Safe and upgrades the token; the Safe is also the token's owner().

## Reviewer notes

### Mechanism

The 171-byte GnosisSafeProxy delegates every call to the Safe 1.3.0 singleton 0xd9db270c in slot 0. execTransaction (GnosisSafe.sol 111-176) calls checkSignatures: threshold (3) slots in ascending owner order (240-303). v == 0 asks a contract owner through the legacy isValidSignature(bytes,bytes), magic 0x20c13b0b (line 285, ISignatureValidator.sol 6), so a signer that answers only the final ERC-1271 isValidSignature(bytes32,bytes) fails with GS024; v == 1 accepts the sender or an approveHash; other v recover with ecrecover. Each address must be an owner (GS026, line 301). execute then runs any call or delegatecall; a delegatecall can rewrite slot 0. No guard and no module are set. The five owners have no code and nonces 42, 67, 3, 416, 525, so their public keys are exposed; a CRQC derives three and signs anything. swapOwner (OwnerManager.sol 94-111) is self-authorized, so 3 of 5 must sign each swap. The Safe holds 12.62B WLFI and 0.097 ETH, is owner() of the WLFI token 0xda5e1988, and owns the OZ 5.0.0 ProxyAdmin 0x7f533afa held in the token's EIP-1967 admin slot. An eth_call of upgradeAndCall(WLFI, current impl, '') from the Safe succeeds and from any other address reverts with OwnableUnauthorizedAccount, so signed Safe transactions can replace WLFI's code and with it every holder's balance. In use: tx 0x8cf0a7fc (block 26,437,049) executed with three owners recovered.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: unused implementation (dossier note: 13 proxies point here): 0x333ec6cd's slot 0 does hold this address, so some proxies delegate to this Safe proxy, but this address is itself an initialized Safe in use (5 owners, threshold 3, nonce 518, a successful execTransaction at block 26,437,049); the card is about this address alone.
- Ruled out: an ERC-1271 or approved-hash path that would shield these owners: it exists (v == 0, v == 1), but all five owners are accounts without code, so their ECDSA signatures still count.
- Ruled out: an unset or unexposed key: all five owners have nonce 3 or more.
- Ruled out: a module or guard that limits or bypasses owners: getModulesPaginated returns none and the guard slot is zero.
- Ruled out: an EIP-8151 effect on this address: not this card's subject. The family's replays (0xd34b6a89, 0x16a1d468, 0x5b42f691) are other Safes' transactions, not cited here; any gas-limit notice for the singleton family is a separate finding.
- Ruled out: that the Safe's keys reach only its own funds: it owns WLFI's ProxyAdmin, which alone can upgrade the token (a call from another address reverts), so holders' WLFI is exposed too; whose is mixed.
- Ruled out: a fix through the final ERC-1271 interface: Safe 1.3.0 only asks the legacy isValidSignature(bytes,bytes) for 0x20c13b0b; otherwise upgrade the singleton first.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
