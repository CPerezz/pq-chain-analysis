---
id: contract-4d216d26-owner-keys
format: 2
title: Multisig wallet trusts five fixed ECDSA signer keys that cannot be replaced
status: candidate
severity: MEDIUM
justification: Forging three signer keys takes all it holds; signers cannot change, but they can still move the
  funds out.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4d216d2682f3997f6c19420beee4530d08d0ea5f'
  code: bytecode
  code_url: https://etherscan.io/address/0x4d216d2682f3997f6c19420beee4530d08d0ea5f#code
  proxy_of: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  copies: 1
  upgradeable: 'no'
value:
  usd: 90
  basis: held
activity: {}
impact: funds-loss
action: Move the wallet's funds to a wallet with post-quantum signers; this wallet's five signer keys cannot be
  replaced.
evidence_level: bytecode
checks:
- id: dispatch
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 8063abe3219c1161004e578063abe3219c146101e1578063c6044c461461020c578063ca34837b14610235578063fc0f392d1461025e576100c9565b8063158ef93e14610113578063722769911461013e578063736c0d5b146101675780637df73e27146101a4576100c956
  says: the dispatcher lists eight functions and sends any other selector to the deposit fallback; none sets a signer
  for:
  - action
  - evidence-1
  - justification
  - what
- id: recover
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 60018682858560405160008152602001604052604051610e519493929190611e83565b6020604051602081039080840390855afa15
  says: the signature check calls the ecrecover precompile (address 1) with all remaining gas
  for:
  - evidence-1
  - what
- id: no-1271
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 1626ba7e
  absent: true
  says: the code never asks a signer through ERC-1271 isValidSignature(bytes32,bytes)
  for:
  - evidence-1
- id: no-1271-legacy
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 20c13b0b
  absent: true
  says: nor through the legacy isValidSignature(bytes,bytes)
  for:
  - notes
- id: need2
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 7369676e6174757265206e6565642032
  says: the payout check holds the revert reason for a signature count other than two
  for:
  - what
- id: distinct
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 66697273745369676e65722073686f756c64206e6f7420626520657175616c20
  says: the payout check holds revert reasons requiring the two signers to differ from each other and from the sender
  for:
  - what
- id: pay-nonsigner
  call: '0x4d216d2682f3997f6c19420beee4530d08d0ea5f'
  data: '0xca34837b000000000000000000000000000000000000000000000000000000000000dead000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000c00000000000000000000000000000000000000000000000000000000000000041010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101011b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202021c00000000000000000000000000000000000000000000000000000000000000'
  from: '0x000000000000000000000000000000000000dEaD'
  reverts_with: Non-signer in onlySigner method
  says: the ETH/call payout (0xca34837b) refuses a sender that is not a signer
  for:
  - evidence-1
  - justification
  - what
- id: pay-badsig
  call: '0x4d216d2682f3997f6c19420beee4530d08d0ea5f'
  data: '0xca34837b000000000000000000000000000000000000000000000000000000000000dead000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000c00000000000000000000000000000000000000000000000000000000000000041010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101011b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202021c00000000000000000000000000000000000000000000000000000000000000'
  from: '0x7f6a0886e9c06635802c823b1e01fa5ace23012f'
  reverts_with: Invalid signer
  says: from a signer, the same payout refuses two signatures that do not recover to signers
  for:
  - action
  - evidence-1
  - justification
  - what
- id: tok-nonsigner
  call: '0x4d216d2682f3997f6c19420beee4530d08d0ea5f'
  data: '0x72276991000000000000000000000000000000000000000000000000000000000000dead0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000dead000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000c00000000000000000000000000000000000000000000000000000000000000041010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101011b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202021c00000000000000000000000000000000000000000000000000000000000000'
  from: '0x000000000000000000000000000000000000dEaD'
  reverts_with: Non-signer in onlySigner method
  says: the token payout (0x72276991) refuses a sender that is not a signer
  for:
  - evidence-1
  - what
- id: tok-badsig
  call: '0x4d216d2682f3997f6c19420beee4530d08d0ea5f'
  data: '0x72276991000000000000000000000000000000000000000000000000000000000000dead0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000dead000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000c00000000000000000000000000000000000000000000000000000000000000041010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101011b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202021c00000000000000000000000000000000000000000000000000000000000000'
  from: '0x7f6a0886e9c06635802c823b1e01fa5ace23012f'
  reverts_with: Invalid signer
  says: from a signer, the token payout refuses two signatures that do not recover to signers
  for:
  - evidence-1
  - what
- id: init-done
  call: '0x4d216d2682f3997f6c19420beee4530d08d0ea5f'
  data: '0xc6044c4600000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000005000000000000000000000000000000000000000000000000000000000000dead000000000000000000000000000000000000000000000000000000000000dead000000000000000000000000000000000000000000000000000000000000dead000000000000000000000000000000000000000000000000000000000000dead000000000000000000000000000000000000000000000000000000000000dead'
  from: '0x000000000000000000000000000000000000dEaD'
  reverts_with: Contract already initialized
  says: init, the only function that writes signers, already ran here and cannot run again
  for:
  - action
  - evidence-2
  - justification
  - what
- id: five
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 496e76616c6964206e756d626572206f66207369676e657273
  says: init rejects any signer count other than its fixed number
  for:
  - what
- id: safe-off
  call: '0x4d216d2682f3997f6c19420beee4530d08d0ea5f'
  fn: safeMode()(bool)
  is: false
  says: 'safe mode is off: payouts may go to any address'
  for:
  - evidence-2
- id: eth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x4d216d2682f3997f6c19420beee4530d08d0ea5f'
  is: 50001320000000000
  says: the wallet holds 0.05 ETH
  for:
  - what
- id: signer1
  call: '0x4d216d2682f3997f6c19420beee4530d08d0ea5f'
  fn: isSigner(address)(bool)
  args:
  - '0x7f6a0886e9c06635802c823b1e01fa5ace23012f'
  is: true
  says: 0x7f6a0886e9c06635802c823b1e01fa5ace23012f is a signer of this wallet
  for:
  - evidence-2
  - what
- id: eoa1
  code: '0x7f6a0886e9c06635802c823b1e01fa5ace23012f'
  is: empty
  says: signer 0x7f6a0886e9c06635802c823b1e01fa5ace23012f is a plain key account with no code
  for:
  - evidence-2
- id: signer2
  call: '0x4d216d2682f3997f6c19420beee4530d08d0ea5f'
  fn: isSigner(address)(bool)
  args:
  - '0x6761ee52d24b4519f2ad3c7b80d6d5b57b825b74'
  is: true
  says: 0x6761ee52d24b4519f2ad3c7b80d6d5b57b825b74 is a signer of this wallet
  for:
  - evidence-2
  - what
- id: eoa2
  code: '0x6761ee52d24b4519f2ad3c7b80d6d5b57b825b74'
  is: empty
  says: signer 0x6761ee52d24b4519f2ad3c7b80d6d5b57b825b74 is a plain key account with no code
  for:
  - evidence-2
- id: signer3
  call: '0x4d216d2682f3997f6c19420beee4530d08d0ea5f'
  fn: isSigner(address)(bool)
  args:
  - '0x1458e52d23b531df0e5a2b0d8db43d85018069f9'
  is: true
  says: 0x1458e52d23b531df0e5a2b0d8db43d85018069f9 is a signer of this wallet
  for:
  - evidence-2
  - what
- id: eoa3
  code: '0x1458e52d23b531df0e5a2b0d8db43d85018069f9'
  is: empty
  says: signer 0x1458e52d23b531df0e5a2b0d8db43d85018069f9 is a plain key account with no code
  for:
  - evidence-2
- id: signer4
  call: '0x4d216d2682f3997f6c19420beee4530d08d0ea5f'
  fn: isSigner(address)(bool)
  args:
  - '0xd59a643bbb558cdbfdc1f9747aa171218bdc3357'
  is: true
  says: 0xd59a643bbb558cdbfdc1f9747aa171218bdc3357 is a signer of this wallet
  for:
  - evidence-2
  - what
- id: eoa4
  code: '0xd59a643bbb558cdbfdc1f9747aa171218bdc3357'
  is: empty
  says: signer 0xd59a643bbb558cdbfdc1f9747aa171218bdc3357 is a plain key account with no code
  for:
  - evidence-2
- id: signer5
  call: '0x4d216d2682f3997f6c19420beee4530d08d0ea5f'
  fn: isSigner(address)(bool)
  args:
  - '0xe4af0df01622386bf1d3589ba325c66293850632'
  is: true
  says: 0xe4af0df01622386bf1d3589ba325c66293850632 is a signer of this wallet
  for:
  - evidence-2
  - what
- id: eoa5
  code: '0xe4af0df01622386bf1d3589ba325c66293850632'
  is: empty
  says: signer 0xe4af0df01622386bf1d3589ba325c66293850632 is a plain key account with no code
  for:
  - evidence-2
- id: nonce1
  nonce: '0x7f6a0886e9c06635802c823b1e01fa5ace23012f'
  is: 311
  says: signer 0x7f6a… has sent 311 transactions, so its public key is on chain
  for:
  - notes
- id: nonce2
  nonce: '0x6761ee52d24b4519f2ad3c7b80d6d5b57b825b74'
  is: 63
  says: signer 0x6761… has sent 63 transactions, so its public key is on chain
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
reviews:
- who: r-4d216d26, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Kev''s first-study finding, MEDIUM candidate (PQ-12, bytecode): a custodian multisig clone of 0x0d424072
    whose spend needs a signer as sender plus two other signers'' ECDSA signatures (three keys); the five signers
    were set once at setup and no function replaces them, so the only fix is the signers moving the funds. Claude
    read the signer set from the setup block and added isSigner, code and nonce checks (logreads/custodian-clones-signers.md).
    Two refuters agree; Claude read the sheet. (Settled again: the second refuter re-submitted its unchanged agreement
    with three added value checks, which reset the row.)'
related: []
---

## What happens

This multisig wallet pays out ETH or tokens when one of its five signers sends the request with ECDSA signatures from two other signers. The signers were set once and no function replaces them, so whoever forges three of the five keys can take all it holds, including 0.05 ETH.

## Evidence

- [Implementation code](https://etherscan.io/address/0x0d424072d658e6abd92c36f8fc16fd6479ae15a0#code): both payouts need a signer as sender and two signatures from signers; nothing changes signers.
- [This wallet](https://etherscan.io/address/0x4d216d2682f3997f6c19420beee4530d08d0ea5f) is set up with five signers, all plain key accounts, and safe mode off.

## Reviewer notes

### Mechanism

The address is a 45-byte EIP-1167 clone of unverified 0x0d424072. Dispatcher (bytecode 0x13-0x7e): initialized 0x158ef93e, safeMode 0xabe3219c, init 0xc6044c46, payout 0xca34837b (address to, uint256 value, bytes data, uint256 expireTime, bytes[2] signatures), token payout 0x72276991 (address to, uint256 value, address token, uint256 expireTime, bytes[2] signatures), activateSafeMode 0xfc0f392d, signers 0x736c0d5b, isSigner 0x7df73e27; anything else goes to the deposit fallback. Payout at 0x5a3: isSigner(msg.sender) (0x349) else 'Non-signer in onlySigner method'; hashes the operation; routine 0x817 requires exactly two signatures, recovers each (OpenZeppelin-style ECDSA, STATICCALL to 0x01 with GAS at 0xe62), requires both recovered addresses to be signers ('Invalid signer'), not expired, distinct from each other and from msg.sender; then CALLs `to` with value and data (token payout calls transfer 0xa9059cbb). Safe mode (one-way, any signer) only limits destinations to signers. init stores exactly five signers once (initialized flag, slot 1 byte 1). No signer setter, no upgrade, no DELEGATECALL or SELFDESTRUCT, no ERC-1271. So spending needs three distinct signer keys: the transaction sender plus two signatures.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 path: neither 0x1626ba7e nor 0x20c13b0b is in the code.
- Ruled out: a signer setter or upgrade: the dispatcher has none and init reverts 'Contract already initialized'.
- Ruled out: an unused copy: this address is initialized with five signers and holds 0.05 ETH plus two priced tokens (about $90).
- Ruled out: fixed gas: the recovery forwards all gas (GAS before STATICCALL), so no fixed-gas-recovery finding.
- Ruled out: a separate EIP-8151 notice may apply (fixed signers: once three signers move their accounts to real code the wallet cannot pay out); not folded into this card.
- Ruled out: other clones of 0x0d424072 with the same signers are separate rows; this card covers this address only.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
