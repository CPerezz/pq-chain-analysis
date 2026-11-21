---
id: contract-aab0039d-owner-keys
format: 2
title: Multisig wallet pays out on three ECDSA signer keys it cannot replace
status: candidate
severity: MEDIUM
justification: Three forged signer keys empty the wallet; its code and signer setup cannot change, so the funds
  have to move.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xaab0039de2a8dba8696ee4d42c0d1aa30d7e1059'
  code: bytecode
  code_url: https://etherscan.io/address/0xaab0039de2a8dba8696ee4d42c0d1aa30d7e1059#code
  proxy_of: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  copies: 1
  upgradeable: 'no'
value:
  usd: 56
  basis: held
activity: {}
impact: funds-loss
action: Move what the wallet holds to a wallet with post-quantum signers; this wallet's setup cannot run again.
evidence_level: bytecode
checks:
- id: clone
  code: '0xaab0039de2a8dba8696ee4d42c0d1aa30d7e1059'
  is: contract
  bytes: 45
  says: the address is a 45-byte minimal clone; its code is that of 0x0d424072
  for:
  - evidence-1
- id: five
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: '0x60058282905014'
  says: init compares the length of the signer list with 5 (then reverts with Invalid number of signers)
  for:
  - what
- id: sender-signer
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: '0x4e6f6e2d7369676e657220696e206f6e6c795369676e6572206d6574686f64'
  says: the spend functions revert with 'Non-signer in onlySigner method' when the caller is not a signer
  for:
  - justification
  - what
- id: two-sigs
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: '0x746f207365636f6e645369676e6572'
  says: the two recovered signers must differ ('firstSigner should not be equal to secondSigner')
  for:
  - evidence-1
  - justification
  - what
- id: not-sender
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: '0x746f206d73672e73656e646572'
  says: each recovered signer must differ from the caller ('... should not be equal to msg.sender')
  for:
  - what
- id: sig-len
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: '0x6041825114'
  says: each signature must be 65 bytes long
  for:
  - evidence-1
- id: ecrecover
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: '0x600186828585604051'
  says: the code calls the recovery precompile (address 1) with hash, v, r, s
  for:
  - evidence-1
  - justification
  - what
- id: token-transfer
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: '0x63a9059cbb'
  says: the token spend calls transfer(address,uint256) on the token
  for:
  - what
- id: no-1271
  selector: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: the code never asks a signer contract through ERC-1271
  for:
  - action
  - evidence-1
  - justification
  - what
- id: initialized
  storage: '0xaab0039de2a8dba8696ee4d42c0d1aa30d7e1059'
  slot: '0x1'
  is: '0x0000000000000000000000000000000000000000000000000000000000000100'
  says: initialized is set and safe mode is off
  for:
  - evidence-3
  - what
- id: init-closed
  call: '0xaab0039de2a8dba8696ee4d42c0d1aa30d7e1059'
  fn: init(address[])
  args:
  - - '0x0000000000000000000000000000000000000001'
    - '0x0000000000000000000000000000000000000002'
    - '0x0000000000000000000000000000000000000003'
    - '0x0000000000000000000000000000000000000004'
    - '0x0000000000000000000000000000000000000005'
  reverts_with: Contract already initialized
  says: the function that sets the signers cannot run again on this wallet
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-a
  call: '0xaab0039de2a8dba8696ee4d42c0d1aa30d7e1059'
  fn: isSigner(address)(bool)
  args:
  - '0xda224f2ebc40c96340b26d0368844e8921d62c94'
  is: true
  says: the sender of the February 2026 token payout is a signer
  for:
  - evidence-2
- id: signer-a-eoa
  code: '0xda224f2ebc40c96340b26d0368844e8921d62c94'
  is: empty
  says: that signer is a plain key account
  for:
  - evidence-2
  - what
- id: signer-b
  call: '0xaab0039de2a8dba8696ee4d42c0d1aa30d7e1059'
  fn: isSigner(address)(bool)
  args:
  - '0x520ba4843d56fa5b6692bcf44f3db50c319e0643'
  is: true
  says: the sender of the ETH payout is a signer
  for:
  - notes
- id: signer-b-eoa
  code: '0x520ba4843d56fa5b6692bcf44f3db50c319e0643'
  is: empty
  says: that signer is a plain key account
  for:
  - what
- id: signer-c
  call: '0xaab0039de2a8dba8696ee4d42c0d1aa30d7e1059'
  fn: isSigner(address)(bool)
  args:
  - '0xecec161d6794312cc39ddac8fbdb9610a043b6e6'
  is: true
  says: the address recovered from both payouts' second signature is a signer
  for:
  - notes
- id: signer-c-eoa
  code: '0xecec161d6794312cc39ddac8fbdb9610a043b6e6'
  is: empty
  says: that signer is a plain key account
  for:
  - what
- id: tx-token
  tx: '0x048e5a2c1bdcd911b1fcd5bbfadc6546ab24b2b19a759544e7cde3791aea045a'
  to: '0xaab0039de2a8dba8696ee4d42c0d1aa30d7e1059'
  ok: true
  says: a token payout through this wallet succeeded
  for:
  - evidence-2
- id: tx-eth
  tx: '0xe33782f5b5ab50f6988fb8058bca794f8de14f79ee7bdefe314b838b80dd2dca'
  to: '0xaab0039de2a8dba8696ee4d42c0d1aa30d7e1059'
  ok: true
  says: an ETH payout through this wallet succeeded
  for:
  - notes
- id: eth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0xaab0039de2a8dba8696ee4d42c0d1aa30d7e1059'
  is: '31200000000000000'
  says: the wallet holds 0.0312 ETH
  for:
  - what
- id: signer-1
  call: '0xaab0039de2a8dba8696ee4d42c0d1aa30d7e1059'
  fn: isSigner(address)(bool)
  args:
  - '0xda224f2ebc40c96340b26d0368844e8921d62c94'
  is: true
  says: 0xda224f2e… is one of this wallet's five signers
  for:
  - what
- id: signer-1-key
  code: '0xda224f2ebc40c96340b26d0368844e8921d62c94'
  is: empty
  says: 'signer 0xda224f2e… has no code: an account controlled by an ECDSA key'
  for:
  - what
- id: signer-1-nonce
  nonce: '0xda224f2ebc40c96340b26d0368844e8921d62c94'
  is: 32
  says: signer 0xda224f2e… has sent 32 transactions, so its public key is on-chain
  for:
  - notes
- id: signer-2
  call: '0xaab0039de2a8dba8696ee4d42c0d1aa30d7e1059'
  fn: isSigner(address)(bool)
  args:
  - '0x520ba4843d56fa5b6692bcf44f3db50c319e0643'
  is: true
  says: 0x520ba484… is one of this wallet's five signers
  for:
  - what
- id: signer-2-key
  code: '0x520ba4843d56fa5b6692bcf44f3db50c319e0643'
  is: empty
  says: 'signer 0x520ba484… has no code: an account controlled by an ECDSA key'
  for:
  - what
- id: signer-2-nonce
  nonce: '0x520ba4843d56fa5b6692bcf44f3db50c319e0643'
  is: 5
  says: signer 0x520ba484… has sent 5 transactions, so its public key is on-chain
  for:
  - notes
- id: signer-3
  call: '0xaab0039de2a8dba8696ee4d42c0d1aa30d7e1059'
  fn: isSigner(address)(bool)
  args:
  - '0x3b85353aed81135474ae3d280fa8dddfa5d0069f'
  is: true
  says: 0x3b85353a… is one of this wallet's five signers
  for:
  - what
- id: signer-3-key
  code: '0x3b85353aed81135474ae3d280fa8dddfa5d0069f'
  is: empty
  says: 'signer 0x3b85353a… has no code: an account controlled by an ECDSA key'
  for:
  - what
- id: signer-3-nonce
  nonce: '0x3b85353aed81135474ae3d280fa8dddfa5d0069f'
  is: 0
  says: signer 0x3b85353a… has never sent a transaction
  for:
  - notes
- id: signer-4
  call: '0xaab0039de2a8dba8696ee4d42c0d1aa30d7e1059'
  fn: isSigner(address)(bool)
  args:
  - '0xad032fc20b9aa93ba92d2513197a7014cc9a118e'
  is: true
  says: 0xad032fc2… is one of this wallet's five signers
  for:
  - what
- id: signer-4-key
  code: '0xad032fc20b9aa93ba92d2513197a7014cc9a118e'
  is: empty
  says: 'signer 0xad032fc2… has no code: an account controlled by an ECDSA key'
  for:
  - what
- id: signer-4-nonce
  nonce: '0xad032fc20b9aa93ba92d2513197a7014cc9a118e'
  is: 0
  says: signer 0xad032fc2… has never sent a transaction
  for:
  - notes
- id: signer-5
  call: '0xaab0039de2a8dba8696ee4d42c0d1aa30d7e1059'
  fn: isSigner(address)(bool)
  args:
  - '0xecec161d6794312cc39ddac8fbdb9610a043b6e6'
  is: true
  says: 0xecec161d… is one of this wallet's five signers
  for:
  - what
- id: signer-5-key
  code: '0xecec161d6794312cc39ddac8fbdb9610a043b6e6'
  is: empty
  says: 'signer 0xecec161d… has no code: an account controlled by an ECDSA key'
  for:
  - what
- id: signer-5-nonce
  nonce: '0xecec161d6794312cc39ddac8fbdb9610a043b6e6'
  is: 0
  says: signer 0xecec161d… has never sent a transaction
  for:
  - notes
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
  who: Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not
    reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: CRITICAL
reviews: []
related: []
---

## What happens

This wallet pays out ETH and tokens when one of its five signers sends the transaction and two other signers sign it with ECDSA. The signers are set once, at setup, which cannot run again. A quantum computer that forges three signer keys can empty it. It holds 0.03 ETH.

## Evidence

- The [wallet code](https://etherscan.io/address/0x0d424072d658e6abd92c36f8fc16fd6479ae15a0#code) recovers two 65-byte ECDSA signatures and never asks a signer contract.
- A [token payout](https://etherscan.io/tx/0x048e5a2c1bdcd911b1fcd5bbfadc6546ab24b2b19a759544e7cde3791aea045a) in February 2026 was sent by one signer, a plain key account.
- Setup is closed: calling it again [reverts](https://etherscan.io/address/0xaab0039de2a8dba8696ee4d42c0d1aa30d7e1059) with "Contract already initialized".

## Reviewer notes

### Mechanism

The address is an EIP-1167 clone of unverified 0x0d424072. Read from the disassembled runtime (the decompiler emptied both spend functions; it was used for init and the getters). 0xca34837b (to, value, data, expireTime, bytes[2] sigs) and 0x72276991 (to, value, token, expireTime, bytes[2] sigs) both start with signers[msg.sender] (0x0286, 0x05a3), hash keccak256("ETHER"|"ERC20", to, value, data|token, expireTime) packed, and call 0x0817: recover each 65-byte signature with ecrecover (0x0d49, STATICCALL to address 1 with all gas, low-s check), require block.timestamp <= expireTime, both recovered addresses in signers, different from each other and from msg.sender; in safe mode the destination must be a signer. Then CALL(to, value, data) or token.transfer. The signer mapping (slot 0) is written only in init(address[]) (0xc6044c46: exactly five, non-zero), guarded by the initialized byte of slot 1; the other two SSTOREs set initialized and safeMode. No DELEGATECALL, no SELFDESTRUCT. Three signers of this clone are known: 0xda224f2e and 0x520ba484 sent spends, and 0xecec161d is recovered offline from the signatures of 0xe33782f5 and 0x048e5a2c with the hash above; all three are plain key accounts. The other two signers are in the creation calldata, which I did not read.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 path for a signer with code: neither isValidSignature selector is in the code, and the only STATICCALL is the one to the recovery precompile.
- Ruled out: a function that replaces signers or upgrades: the code has nine selectors (initialized, safeMode, signers, isSigner, init, activateSafeMode, two spends) and three SSTOREs; init reverts on this address.
- Ruled out: an unused clone: slot 1 reads initialized, three signers answer isSigner true, and it sent payouts in 2025 and 2026 (0x048e5a2c, 0xe33782f5).
- Ruled out: the five signer keys of the old bundled card (0x7f6a0886, 0x6761ee52, 0x1458e52d, 0xd59a643b, 0xe4af0df0): isSigner is false for all five on this clone; it has its own signer set.
- Ruled out: a spend without signatures: both spend functions reach the two-signature check; a signer alone can only call activateSafeMode, which restricts destinations to signers.
- Ruled out: a fixed gas amount for the recovery: the STATICCALL forwards all gas (GAS opcode).
- Ruled out: value: the tool's $56 is 0.0312 ETH and one priced token; USDT balance is 0. The wallet moved large USDT amounts earlier (0x048e5a2c), so it is rated as a wallet in use that is near empty at the block.
- Ruled out: Signers: read by Claude from setup tx 0xba44854a5e…, each confirmed by isSigner.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
