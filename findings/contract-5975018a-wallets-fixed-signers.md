---
id: contract-5975018a-wallets-fixed-signers
format: 2
title: USDG owner wallet locks if all three signers move to real code
status: candidate
severity: INFORMATIONAL
justification: Breaks only if signers move their own accounts to real code; the wallet's signers cannot be replaced.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5975018ae3e81c69264443c81aca461ca3fd2ad0'
  code: bytecode
  code_url: https://etherscan.io/address/0x5975018ae3e81c69264443c81aca461ca3fd2ad0#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 722
  whose: operator
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Move the USDG owner role and the ETH to a wallet with replaceable signers before the signers move their
  accounts to real code.
evidence_level: bytecode
checks:
- id: signers
  storage: '0x5975018ae3e81c69264443c81aca461ca3fd2ad0'
  slot: 0
  is: 3
  says: the wallet's signer array has three entries
  for:
  - justification
  - what
- id: signer0
  call: '0x5975018ae3e81c69264443c81aca461ca3fd2ad0'
  fn: signers(uint256)(address)
  args:
  - 0
  is: '0x863B37865df215EAbc5530E106F9e7acc9f53082'
  says: first signer
  for:
  - evidence-2
  - what
  - whose
- id: signer1
  call: '0x5975018ae3e81c69264443c81aca461ca3fd2ad0'
  fn: signers(uint256)(address)
  args:
  - 1
  is: '0x1d9c49d99874B70E16994c1C367a42024D94E7da'
  says: second signer
  for:
  - evidence-2
  - what
  - whose
- id: signer2
  call: '0x5975018ae3e81c69264443c81aca461ca3fd2ad0'
  fn: signers(uint256)(address)
  args:
  - 2
  is: '0x006f9837bDd2f0fa9b2Cebd8B5413aD3A7437e15'
  says: third signer
  for:
  - evidence-2
  - what
  - whose
- id: code0
  code: '0x863b37865df215eabc5530e106f9e7acc9f53082'
  is: empty
  says: first signer has no code
  for:
  - evidence-2
- id: code1
  code: '0x1d9c49d99874b70e16994c1c367a42024d94e7da'
  is: empty
  says: second signer has no code
  for:
  - evidence-2
- id: code2
  code: '0x006f9837bdd2f0fa9b2cebd8b5413ad3a7437e15'
  is: empty
  says: third signer has no code
  for:
  - evidence-2
- id: usdgowner
  call: '0x1c0b9c1995ea61f8fb505e4d94aa32b0c024899e'
  fn: owner()(address)
  is: '0x5975018ae3e81c69264443c81aca461ca3fd2ad0'
  says: the USDG token's owner is this wallet
  for:
  - action
  - evidence-2
  - what
  - whose
- id: ownerfn
  bytecode: '0x5975018ae3e81c69264443c81aca461ca3fd2ad0'
  has: 7472616e736665724f776e657273686970
  says: the wallet's USDG admin function includes a transferOwnership operation
  for:
  - action
- id: etherfn
  bytecode: '0x5975018ae3e81c69264443c81aca461ca3fd2ad0'
  has: '4554484552'
  says: the wallet has a signed ETH-send operation (ETHER prefix)
  for:
  - action
  - what
- id: caller
  bytecode: '0x5975018ae3e81c69264443c81aca461ca3fd2ad0'
  has: 600080611bc533611367565b1515611bd057600080fd5b
  says: the verify routine requires isSigner(msg.sender) or reverts
  for:
  - what
- id: recover
  bytecode: '0x5975018ae3e81c69264443c81aca461ca3fd2ad0'
  has: 61196683611bb9565b61196f81611367565b151561197a57600080fd5b3373ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff1614156119b357600080fd5b
  says: the recovered address must be a signer and differ from the caller, else revert
  for:
  - evidence-1
  - justification
  - what
- id: ecrecover
  bytecode: '0x5975018ae3e81c69264443c81aca461ca3fd2ad0'
  has: 206040516020810390808403906000865af11580
  says: the signature is recovered by a CALL forwarding all gas (target pushed as 0x01)
  for:
  - evidence-1
  - what
- id: sstore
  bytecode: '0x5975018ae3e81c69264443c81aca461ca3fd2ad0'
  has: 600183600a81101515611c8657fe5b0181905550
  says: 'the wallet''s only storage write: sequence id into slot 1+i, i<10 (signer array is slot 0)'
  for:
  - action
  - justification
  - what
- id: no1271
  bytecode: '0x5975018ae3e81c69264443c81aca461ca3fd2ad0'
  has: 1626ba7e
  absent: true
  says: no ERC-1271 isValidSignature selector in the code
  for:
  - evidence-1
  - what
- id: no1271old
  bytecode: '0x5975018ae3e81c69264443c81aca461ca3fd2ad0'
  has: 20c13b0b
  absent: true
  says: no legacy ERC-1271 isValidSignature(bytes,bytes) selector in the code
  for:
  - evidence-1
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: HIGH
reviews: []
related: []
---

## What happens

This 2-of-3 wallet holds ETH and is the owner of the USDG token. Each action needs a call from one signer and an ECDSA signature from a different one. The three signers are fixed; once all their accounts take real code, the wallet cannot act. An EIP-7702 delegation keeps working.

## Evidence

- [The wallet](https://etherscan.io/address/0x5975018ae3e81c69264443c81aca461ca3fd2ad0#code) accepts a co-signer only if ecrecover returns one of its signers other than the caller; it has no ERC-1271 path.
- [USDG](https://etherscan.io/address/0x1c0b9c1995ea61f8fb505e4d94aa32b0c024899e#readProxyContract) names this wallet as its owner; the wallet's three signers are plain accounts today.

## Reviewer notes

### Mechanism

Unverified 7,356-byte wallet (WalletSimple-like, solc 0.4). Storage: slot 0 = signers array (3 entries), slots 1-10 = recent sequence ids, slot 11 = the USDG token proxy 0x1c0b9c19. Three action functions: 0x97f6c448 sends ETH (prefix ETHER), 0x98f44b9a sends ERC-20 tokens (prefix ERC20), 0x63f69f73 calls the token's transferOwnership, updateMasterMinter, updatePauser, updateBlacklister or changeAdmin (prefix USDG). Each first requires isSigner(msg.sender), then the shared verify routine: recover the 65-byte signature through precompile 1 with all gas forwarded (output zeroed before the call, so an empty return gives address 0), require expireTime >= now, tryInsertSequenceId (caller must be a signer, id within 10,000 of the lowest stored), require isSigner(recovered) and recovered != msg.sender. The disassembly has exactly one SSTORE (the sequence-id write to slot 1+i, i<10), no DELEGATECALL, CREATE or SELFDESTRUCT, so nothing rewrites slot 0 after deployment. The fallback only logs deposits. Under EIP-8151 a signer whose account takes real code still works as the caller but cannot be the recovered co-signer; the wallet locks only when no signer account without real code is left to sign.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: ERC-1271 or code-size branch for a signer with code: no 1626ba7e or 20c13b0b in the code; the recovered address is only compared with the stored signers and the caller.
- Ruled out: a function that replaces signers: the only SSTORE writes a sequence-id slot (1+i, i<10); slot 0 holds 3 signers set at deployment.
- Ruled out: unused implementation: not a proxy target; it has its own state (3 signers, sequence ids 1-6 used, next id 7) and is the USDG owner.
- Ruled out: direct path without a signature: every state-changing selector calls the verify routine; the other selectors are views (signers, isSigner, getNextSequenceId, the token address getter).
- Ruled out: fixed gas or a break with nobody migrating: the recovery forwards all gas (GAS before CALL to address 1).
- Ruled out: signer keys already contracts: all three signers have no code at the block; two have nonce 0, presumed live.
- Ruled out: USDG owner role: changeAdmin is in the code but the token's proxy admin slot holds 0x6e40c83f..., not this wallet; that admin could also upgrade the token, so the card does not claim the owner role is lost for good, only that this wallet cannot use it.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
