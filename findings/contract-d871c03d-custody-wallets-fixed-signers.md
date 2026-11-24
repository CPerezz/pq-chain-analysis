---
id: contract-d871c03d-custody-wallets-fixed-signers
format: 2
title: Wallet locks if five of its eight fixed signers move to real code
status: candidate
severity: INFORMATIONAL
justification: Nothing breaks unless signers move to real code; the signers are fixed, so the funds must move out
  first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd871c03dd4e1ce40b51280ce58c6450b2e060d2e'
  code: bytecode
  code_url: https://etherscan.io/address/0xd871c03dd4e1ce40b51280ce58c6450b2e060d2e#code
  copies: 2
  family: c8330e19b6b243e08158ce45883a5cfb
  upgradeable: 'no'
value:
  usd: 36271805
  basis: held
activity:
  txs_90d: 9
impact: funds-locked
action: Have four signers move the funds to a wallet whose signers can be replaced, before any signer's account
  takes real code.
evidence_level: bytecode
checks:
- id: signers
  call: '0xd871c03dd4e1ce40b51280ce58c6450b2e060d2e'
  fn: getSigners()(address[])
  is:
  - '0xba912a89eaf5badedeefb5d0142b9a4e0ce4d72f'
  - '0xc6108297b1f8e48afcd1bf72f3ca90e278097617'
  - '0x9d526d948f3ccd4af716485cc2806d5062466e61'
  - '0x5032281fee2bbf5c1422f75cd726135aff468f23'
  - '0x28b8221798bc0db33555cfc6c31aa7c3ee5a698c'
  - '0x031fbe1a0e4dc88e1bf797355293fb217d0ff111'
  - '0x14da72f479481e9548078800623884ce45436ed9'
  - '0x3a4f9ec5748f095792489a65c5ddd33a3c141c18'
  says: the wallet's stored signer list has eight addresses
  for:
  - action
  - evidence-3
  - justification
  - what
- id: threshold
  call: '0xd871c03dd4e1ce40b51280ce58c6450b2e060d2e'
  fn: THRESHOLD()(uint256)
  is: 4
  says: the threshold is four
  for:
  - justification
  - what
- id: dispatch
  bytecode: '0xd871c03dd4e1ce40b51280ce58c6450b2e060d2e'
  has: 60806040526004361061007e575f3560e01c8063785ffb371161004d578063785ffb371461018b57806392e2d31b146101b557806394cf795e146101dd578063f54b5f6a14610207576100d3565b80631fcf5799146100d7578063248876ef146100ff5780633bb4d99e146101275780635d00bb121461014f576100d3565b366100d3573373ffffffffffffffffffffffffffffffffffffffff167fe1fffcc4923d04b559f4d29a8bfc6cda04eb5b0d3c460751c2402c5c5cc9109c346040516100c99190612207565b60405180910390a2005b5f5ffd
  says: the dispatcher has exactly these eight selectors; empty calldata logs a deposit, anything else reverts
  for:
  - action
  - evidence-2
  - justification
  - what
- id: exact
  bytecode: '0xd871c03dd4e1ce40b51280ce58c6450b2e060d2e'
  has: 7f000000000000000000000000000000000000000000000000000000000000000460ff168282905014
  says: the transfer compares the number of signatures for equality with the immutable threshold 4 (pc 2325)
  for:
  - action
  - evidence-1
  - what
- id: exactmsg
  bytecode: '0xd871c03dd4e1ce40b51280ce58c6450b2e060d2e'
  has: 4e756d626572206f662070726f7669646564207369676e61747572657320646f
  says: revert text 'Number of provided signatures does not match threshold'
  for:
  - evidence-1
  - what
- id: ecrec
  bytecode: '0xd871c03dd4e1ce40b51280ce58c6450b2e060d2e'
  has: 5b5f6001888888886040515f81526020016040526040516121679493929190613de6565b6020604051602081039080840390855afa
  says: each signature is recovered by a STATICCALL to precompile 0x01 with all remaining gas (pc 8516-8568)
  for:
  - action
  - evidence-1
  - what
- id: recmsg
  bytecode: '0xd871c03dd4e1ce40b51280ce58c6450b2e060d2e'
  has: 436f756c64206e6f74207265636f766572207369676e657220666f7220736967
  says: 'revert text ''Could not recover signer for signature at index'': a failed recovery reverts the transfer'
  for:
  - evidence-1
  - what
- id: match
  bytecode: '0xd871c03dd4e1ce40b51280ce58c6450b2e060d2e'
  has: 5b6001805490508160ff161015611177578273ffffffffffffffffffffffffffffffffffffffff1660018260ff1681548110611089576110886127d4565b5b905f5260205f20015f9054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff160361116457
  says: the recovered address is compared with each entry of the storage array at slot 1, the signer list (pc 4171)
  for:
  - action
  - evidence-1
  - what
- id: matchmsg
  bytecode: '0xd871c03dd4e1ce40b51280ce58c6450b2e060d2e'
  has: 20776173206e6f742076616c6964
  says: 'revert text '' was not valid'' after ''Signature no. '': a recovered address not in the list reverts'
  for:
  - evidence-1
  - what
- id: twice
  bytecode: '0xd871c03dd4e1ce40b51280ce58c6450b2e060d2e'
  has: 207369676e6564207477696365
  says: 'revert text '' signed twice'': the same signer cannot count twice'
  for:
  - evidence-1
  - what
- id: no1271
  bytecode: '0xd871c03dd4e1ce40b51280ce58c6450b2e060d2e'
  has: 1626ba7e
  absent: true
  says: the ERC-1271 isValidSignature(bytes32,bytes) selector is not in the code
  for:
  - evidence-2
  - what
- id: no1271old
  bytecode: '0xd871c03dd4e1ce40b51280ce58c6450b2e060d2e'
  has: 20c13b0b
  absent: true
  says: the legacy isValidSignature(bytes,bytes) selector is not in the code
  for:
  - evidence-2
  - what
- id: addw
  bytecode: '0xd871c03dd4e1ce40b51280ce58c6450b2e060d2e'
  has: '60038590806001815401808255'
  says: adding an authority pushes onto the array at slot 3, not the signer list (pc 1987)
  for:
  - evidence-2
  - justification
  - what
- id: remw
  bytecode: '0xd871c03dd4e1ce40b51280ce58c6450b2e060d2e'
  has: 5b6003600160038054
  says: removing an authority works on the array at slot 3, not the signer list (pc 1120)
  for:
  - evidence-2
  - justification
  - what
- id: sig1
  code: '0xba912a89eaf5badedeefb5d0142b9a4e0ce4d72f'
  is: empty
  says: signer 1 has no code
  for:
  - evidence-3
- id: sig2
  code: '0xc6108297b1f8e48afcd1bf72f3ca90e278097617'
  is: empty
  says: signer 2 has no code
  for:
  - evidence-3
- id: sig3
  code: '0x9d526d948f3ccd4af716485cc2806d5062466e61'
  is: empty
  says: signer 3 has no code
  for:
  - evidence-3
- id: sig4
  code: '0x5032281fee2bbf5c1422f75cd726135aff468f23'
  is: empty
  says: signer 4 has no code
  for:
  - evidence-3
- id: sig5
  code: '0x28b8221798bc0db33555cfc6c31aa7c3ee5a698c'
  is: empty
  says: signer 5 has no code
  for:
  - evidence-3
- id: sig6
  code: '0x031fbe1a0e4dc88e1bf797355293fb217d0ff111'
  is: empty
  says: signer 6 has no code
  for:
  - evidence-3
- id: sig7
  code: '0x14da72f479481e9548078800623884ce45436ed9'
  is: empty
  says: signer 7 has no code
  for:
  - evidence-3
- id: sig8
  code: '0x3a4f9ec5748f095792489a65c5ddd33a3c141c18'
  is: empty
  says: signer 8 has no code
  for:
  - evidence-3
- id: eth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0xd871c03dd4e1ce40b51280ce58c6450b2e060d2e'
  is: '20100010900000000000000'
  says: the wallet holds 20,100.0109 ETH
  for:
  - notes
- id: dep
  tx: '0xff50847b47ba7dd7e8996a6a0c79583047673e17c931bb3b3d643ae37c7263d9'
  to: '0x3262f13a39efaca789ae58390441c9ed76bc658a'
  ok: true
  says: a multisig transaction in block 26,385,048 whose execution sent 10,000 ETH to this wallet (its Deposit log)
  for:
  - notes
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: HIGH
reviews:
- who: r-d871c03d, the row's refuter
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 're-rated: An unverified 4-of-8 ECDSA wallet holding 20,100 ETH with no function that replaces a signer.
    INFORMATIONAL, PQ-17, candidate (bytecode evidence, read with a decompiler''s help; was HIGH): nothing breaks
    unless five of the eight signers move their accounts to real code, and the funds can be moved first; the same
    reading as the two wallets of this kind settled before. Author A-d871c03d asked for the signer comparison to
    be re-derived; refuter R-d871c03d made its 12 attempts against the code and agreed with no objection. The reader
    changed nothing. Whose funds stay not established.'
related: []
---

## What happens

This multisig wallet sends ETH or tokens only when exactly four of its eight signers sign the transfer with ECDSA. No function changes the signer list. Signers whose accounts take real code (not an EIP-7702 delegation) stop counting; if five do, the funds lock for good.

## Evidence

- Its [code](https://etherscan.io/address/0xd871c03dd4e1ce40b51280ce58c6450b2e060d2e#code) recovers each signature with ECDSA; exactly four must come from different stored signers.
- The other [functions](https://etherscan.io/address/0xd871c03dd4e1ce40b51280ce58c6450b2e060d2e#code) manage nonces and nonce-blocking keys; none rewrites the signers or asks a signer contract.
- None of the [eight signers](https://etherscan.io/address/0xd871c03dd4e1ce40b51280ce58c6450b2e060d2e#readContract) has real code yet.

## Reviewer notes

### Mechanism

Unverified code, read from its disassembly. Dispatcher: eight selectors (blockNonce, isNonceUsed, THRESHOLD, getSigners, a transfer 0x92e2d31b(address,address,uint256,uint8,bytes,uint256,bytes[]), add/remove of nonce-blocking authorities 0x3bb4d99e/0x248876ef, their getter 0xf54b5f6a); empty calldata logs a deposit, other calldata reverts. The transfer needs an unused nonce, a signature count equal to the immutable THRESHOLD (4), a non-zero recipient, then loops the signatures (pc 0x0fd9): each is recovered via precompile 0x01 with all remaining gas (pc 8567-8568), a failed recovery reverts, the address must equal an entry of the signer array at slot 1 (getSigners, 8 entries), and a bitmap rejects the same signer twice. It then marks the nonce and sends ETH or, after a symbol/decimals check, a token. The runtime's only SSTOREs write slot 2 (used nonces) and slot 3 (authorities); slot 1 is written by no function. No DELEGATECALL, CALLCODE, CREATE or SELFDESTRUCT exists; its two CALLs (pc 2885, 6132) are the ETH and token sends. Adding or removing an authority needs the same four signatures. A signer with real code recovers to nothing under EIP-8151, so its signature reverts; with five such signers no four remain.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-size path for signers: neither 0x1626ba7e nor 0x20c13b0b is in the code; the one EXTCODESIZE (pc 6165) is in the token-send helper, not on the signer path.
- Ruled out: a setter, owner, upgrade or rescue: no selector writes slot 1, no DELEGATECALL or SELFDESTRUCT; owner() and admin() do not answer (tool facts).
- Ruled out: a direct path: signers have no on-chain approval function; funds leave only through the signed transfer (the two CALL sites).
- Ruled out: path closed or unused: holds 20,100.0109 ETH; deposited 10,000+10,000+100 ETH in the 90 days before the block by 0x3262f13a39efaca789ae58390441c9ed76bc658a (txs 0xff50847b, 0x4e7d19ba, 0x2c01341e). blockNonce authority 0xde3ac2e250ce4a2b0c1f1b31d6ed9a69b1f8c1ba only burns single nonces.
- Ruled out: rechecked-later: each signature is checked once, when the transfer executes; nobody relies on it before, so this is not a voided voucher.
- Ruled out: breaks by itself: recovery forwards all remaining gas; four recoveries cost ~12,400 gas more, a sender gas-limit matter with no replay in the dossier to cite.
- Ruled out: key state: all eight signers have no code and nonce 0 at the block (keys used only off-chain), presumed live.
- Ruled out: whose money: not shown; the deposits came from a multisig that is not identified, so whose is left empty.
- Ruled out: copies: the row counts 2 addresses with this code; the dossier names no other copy, and its state was not read.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
