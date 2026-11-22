---
id: contract-59708733-owner-keys
format: 2
title: Unidentified multisig wallet trusts five fixed ECDSA signer keys
status: confirmed
severity: MEDIUM
justification: Forging three of five fixed signer keys drains it; three signers must move the funds.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x59708733fbbf64378d9293ec56b977c011a08fd2'
  code: bytecode
  code_url: https://etherscan.io/address/0x59708733fbbf64378d9293ec56b977c011a08fd2#code
  proxy_of: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  copies: 1
  upgradeable: 'no'
value:
  usd: 145993053
  basis: held
activity: {}
impact: funds-loss
action: Have three of the five signers move the funds to a wallet whose signers use post-quantum signatures.
evidence_level: executed
checks:
- id: eth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x59708733fbbf64378d9293ec56b977c011a08fd2'
  is: '44686007253352256164100'
  says: the wallet holds 44,686 ETH
  for:
  - what
- id: usdc
  call: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  fn: balanceOf(address)(uint256)
  args:
  - '0x59708733fbbf64378d9293ec56b977c011a08fd2'
  is: '65371027767696'
  says: the wallet holds 65.37M USDC
  for:
  - what
- id: signer1
  call: '0x59708733fbbf64378d9293ec56b977c011a08fd2'
  fn: isSigner(address)(bool)
  args:
  - '0x6761ee52d24b4519f2ad3c7b80d6d5b57b825b74'
  is: 'true'
  says: 0x6761ee52 is a signer
  for:
  - what
- id: signer2
  call: '0x59708733fbbf64378d9293ec56b977c011a08fd2'
  fn: isSigner(address)(bool)
  args:
  - '0x7f6a0886e9c06635802c823b1e01fa5ace23012f'
  is: 'true'
  says: 0x7f6a0886 is a signer
  for:
  - what
- id: spend-replay
  replay: '0x14a78281e3923fea2a4a03b5f67e7468485f90610049cb50f31c4ba46b237144'
  run: today
  ok: true
  says: a real spend sent straight to this wallet succeeds today
  for:
  - evidence-1
  - what
- id: spend-replay-code
  replay: '0x14a78281e3923fea2a4a03b5f67e7468485f90610049cb50f31c4ba46b237144'
  run: eip8151_signer_code
  ok: false
  says: the same spend reverts when the recovered signer has real code, so the wallet trusts the recovered ECDSA
    signer
  for:
  - evidence-1
  - justification
  - what
- id: init-closed
  call: '0x59708733fbbf64378d9293ec56b977c011a08fd2'
  fn: init(address[])()
  args:
  - - '0x7f6a0886e9c06635802c823b1e01fa5ace23012f'
  reverts_with: Contract already initialized
  says: init, the only function that sets signers, cannot run again
  for:
  - action
  - evidence-2
  - justification
  - what
- id: no-1271
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 631626ba7e
  absent: true
  says: no isValidSignature selector in the wallet code
  for:
  - justification
- id: onlysigner
  call: '0x59708733fbbf64378d9293ec56b977c011a08fd2'
  data: '0xca34837b000000000000000000000000ed9ab5bc05a0152b9dc2f7902e8369af7bc187710000000000000000000000000000000000000000000000a2a15d09519be0000000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000000006af405f700000000000000000000000000000000000000000000000000000000000000c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000c00000000000000000000000000000000000000000000000000000000000000041369c63f51bf1385dfc694f01fe3730dd02c6fba4ce9d5dd8ff8b7a2191e6b07371c8b49082b74f870d3946aa8a98016440c912613f4e3c0b8e4aad447b1ba6b61b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000418a6d331ece03d994d2ddc597bf1c8f7e5ea382b7208b414cdd263d1b4e5093c31cb2d65aa176be58a00150adfbf646eac4b208cf1c8426741ac9d51bde7ea3d91c00000000000000000000000000000000000000000000000000000000000000'
  from: '0x000000000000000000000000000000000000dEaD'
  reverts_with: Non-signer in onlySigner method
  says: 'the real spend sent by a non-signer reverts: the sender must be a signer'
  for:
  - action
  - evidence-2
  - justification
  - what
- id: need2
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 7369676e6174757265206e6565642032
  says: the spend requires two signatures
  for:
  - action
  - evidence-2
  - justification
  - what
- id: distinct
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 746f207365636f6e645369676e6572
  says: 'the code refuses a first signer equal to the second (''...to secondSigner''): the two signers must differ'
  for:
  - evidence-2
  - justification
  - what
- id: not-sender
  bytecode: '0x0d424072d658e6abd92c36f8fc16fd6479ae15a0'
  has: 746f206d73672e73656e646572
  says: a revert text requires the signers to differ from msg.sender
  for:
  - evidence-2
  - justification
  - what
- id: signer-1
  call: '0x59708733fbbf64378d9293ec56b977c011a08fd2'
  fn: isSigner(address)(bool)
  args:
  - '0x7f6a0886e9c06635802c823b1e01fa5ace23012f'
  is: true
  says: 0x7f6a0886… is one of this wallet's five signers
  for:
  - what
- id: signer-1-key
  code: '0x7f6a0886e9c06635802c823b1e01fa5ace23012f'
  is: empty
  says: 'signer 0x7f6a0886… has no code: an account controlled by an ECDSA key'
  for:
  - what
- id: signer-1-nonce
  nonce: '0x7f6a0886e9c06635802c823b1e01fa5ace23012f'
  is: 311
  says: signer 0x7f6a0886… has sent 311 transactions, so its public key is on-chain
  for:
  - notes
- id: signer-2
  call: '0x59708733fbbf64378d9293ec56b977c011a08fd2'
  fn: isSigner(address)(bool)
  args:
  - '0x6761ee52d24b4519f2ad3c7b80d6d5b57b825b74'
  is: true
  says: 0x6761ee52… is one of this wallet's five signers
  for:
  - what
- id: signer-2-key
  code: '0x6761ee52d24b4519f2ad3c7b80d6d5b57b825b74'
  is: empty
  says: 'signer 0x6761ee52… has no code: an account controlled by an ECDSA key'
  for:
  - what
- id: signer-2-nonce
  nonce: '0x6761ee52d24b4519f2ad3c7b80d6d5b57b825b74'
  is: 63
  says: signer 0x6761ee52… has sent 63 transactions, so its public key is on-chain
  for:
  - notes
- id: signer-3
  call: '0x59708733fbbf64378d9293ec56b977c011a08fd2'
  fn: isSigner(address)(bool)
  args:
  - '0x1458e52d23b531df0e5a2b0d8db43d85018069f9'
  is: true
  says: 0x1458e52d… is one of this wallet's five signers
  for:
  - what
- id: signer-3-key
  code: '0x1458e52d23b531df0e5a2b0d8db43d85018069f9'
  is: empty
  says: 'signer 0x1458e52d… has no code: an account controlled by an ECDSA key'
  for:
  - what
- id: signer-3-nonce
  nonce: '0x1458e52d23b531df0e5a2b0d8db43d85018069f9'
  is: 0
  says: signer 0x1458e52d… has never sent a transaction
  for:
  - notes
- id: signer-4
  call: '0x59708733fbbf64378d9293ec56b977c011a08fd2'
  fn: isSigner(address)(bool)
  args:
  - '0xd59a643bbb558cdbfdc1f9747aa171218bdc3357'
  is: true
  says: 0xd59a643b… is one of this wallet's five signers
  for:
  - what
- id: signer-4-key
  code: '0xd59a643bbb558cdbfdc1f9747aa171218bdc3357'
  is: empty
  says: 'signer 0xd59a643b… has no code: an account controlled by an ECDSA key'
  for:
  - what
- id: signer-4-nonce
  nonce: '0xd59a643bbb558cdbfdc1f9747aa171218bdc3357'
  is: 0
  says: signer 0xd59a643b… has never sent a transaction
  for:
  - notes
- id: signer-5
  call: '0x59708733fbbf64378d9293ec56b977c011a08fd2'
  fn: isSigner(address)(bool)
  args:
  - '0xe4af0df01622386bf1d3589ba325c66293850632'
  is: true
  says: 0xe4af0df0… is one of this wallet's five signers
  for:
  - what
- id: signer-5-key
  code: '0xe4af0df01622386bf1d3589ba325c66293850632'
  is: empty
  says: 'signer 0xe4af0df0… has no code: an account controlled by an ECDSA key'
  for:
  - what
- id: signer-5-nonce
  nonce: '0xe4af0df01622386bf1d3589ba325c66293850632'
  is: 0
  says: signer 0xe4af0df0… has never sent a transaction
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

This wallet holds 44,686 ETH and 65.4M USDC and pays out when a signer sends a spend carrying ECDSA signatures of two other signers. Its five signers were set once by init, which cannot run again, so forging three of the five keys sends the funds out.

## Evidence

- [A real spend](https://etherscan.io/tx/0x14a78281e3923fea2a4a03b5f67e7468485f90610049cb50f31c4ba46b237144) of 3,000 ETH reverts when its recovered signer's account has real code.
- The [wallet code](https://etherscan.io/address/0x0d424072d658e6abd92c36f8fc16fd6479ae15a0#code) requires a signer as sender plus two distinct signatures; init refuses a second call.

## Reviewer notes

### Mechanism

EIP-1167 clone of unverified 0x0d424072. Dispatcher selectors: 158ef93e initialized(), 72276991, 736c0d5b signers(address), 7df73e27 isSigner(address), abe3219c safeMode(), c6044c46 init(address[]) (requires not initialized and exactly 5 signers, sets signers mapping), ca34837b spend (to, value, data, expireTime, signatures), fc0f392d activateSafeMode (onlySigner). No other selectors, no ERC-1271 selector. At block 26,438,999 initialized() is true and all five signers 0x7f6a0886, 0x6761ee52, 0x1458e52d, 0xd59a643b, 0xe4af0df0 are isSigner and EOAs. Spend is onlySigner (non-signer sender reverts 'Non-signer in onlySigner method') and requires two signatures ('signature need 2') from signers distinct from each other and from msg.sender: quorum three of five.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: a signer replacement: init(address[]) is the only writer of the signers and it refuses once initialized() is true, which it is at the block.
- Ruled out: unused implementation: this address is the clone in use (real spends in the window, 44,686 ETH held).
- Ruled out: EIP-8151 breaking it by itself: the eip8151 replay run succeeds; only the signer-with-code run reverts. A delegated signer still works (eip8151_signer_delegated run succeeds).
- Ruled out: other clones of 0x0d424072 (the old card's 0x70213959 and 21 others) are separate wallets and not part of this card.
- Ruled out: an ERC-1271 path: the implementation code has no 1626ba7e selector push.
- Ruled out: Signers: the five addresses of setup transaction 0x6aa6908fda… (block 19,146,255), found by Claude in that block and each confirmed by isSigner at the block; all distinct, none has code.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
