---
id: live4wellreserve-91462f61-rotate-signer-before-migrating
format: 2
title: Deposit refunds stop if the stored signer key's account takes real code
status: confirmed
severity: INFORMATIONAL
justification: Breaks only if the signer key's account takes real code; the owner can replace the key first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x91462f61d4e2882d0c9a15290f06eaabbef726cc'
  name: Live4WellReserve
  code: verified
  code_url: https://etherscan.io/address/0xbf5fe9bfe3e4dfaf4082a3ea88528c14ab11bea8#code
  proxy_of: '0xbf5fe9bfe3e4dfaf4082a3ea88528c14ab11bea8'
  copies: 2
  family: 898d74c3469842575b34625592360ebd
  upgradeable: 'yes'
  admin: '0x20cd03e1fd42197bf0872efd5926b6acaaa9053b'
value:
  usd: 0
  basis: held
activity: {}
impact: liveness
action: Replace the signer with setSigner before that key's account takes real code, if refunds ever reopen.
evidence_level: source
checks:
- id: ecdsa
  source: '0xbf5fe9bfe3e4dfaf4082a3ea88528c14ab11bea8'
  file: contracts/Live4WellReserve.sol
  lines:
  - 53
  - 61
  has: ) == signer,
  says: checkValidity recovers the signature with ECDSA and requires it to equal the stored signer
  for:
  - evidence-1
  - justification
  - what
- id: refund
  source: '0xbf5fe9bfe3e4dfaf4082a3ea88528c14ab11bea8'
  file: contracts/Live4WellReserve.sol
  line: 77
  has: checkValidity(signature, "l4w-refund");
  says: refund checks the signer's signature before paying the deposit back
  for:
  - evidence-1
  - what
- id: deposit
  source: '0xbf5fe9bfe3e4dfaf4082a3ea88528c14ab11bea8'
  file: contracts/Live4WellReserve.sol
  line: 79
  has: _withdraw(msg.sender, DEPOSIT_AMOUNT);
  says: a refund pays back the deposit amount
  for:
  - what
- id: amount
  call: '0x91462f61d4e2882d0c9a15290f06eaabbef726cc'
  fn: DEPOSIT_AMOUNT()(uint256)
  is: 200000000000000000
  says: the deposit is 0.2 ETH
  for:
  - notes
- id: setter
  source: '0xbf5fe9bfe3e4dfaf4082a3ea88528c14ab11bea8'
  file: contracts/Live4WellReserve.sol
  lines:
  - 122
  - 124
  has: function setSigner(address _signer) external onlyOwner {
  says: the owner can replace the signer key
  for:
  - action
  - evidence-1
  - justification
  - what
- id: owner
  call: '0x91462f61d4e2882d0c9a15290f06eaabbef726cc'
  fn: owner()(address)
  is: '0x20cd03e1fd42197bf0872efd5926b6acaaa9053b'
  says: the owner that can call setSigner
  for:
  - action
  - justification
  - what
- id: ownercode
  code: '0x20cd03e1fd42197bf0872efd5926b6acaaa9053b'
  is: empty
  says: the owner is an account without code
  for:
  - notes
- id: signer
  call: '0x91462f61d4e2882d0c9a15290f06eaabbef726cc'
  fn: signer()(address)
  is: '0xbd00597fe18f5ef1c57f440545ec64e19efc2c7a'
  says: the stored signer key is set
  for:
  - notes
- id: signercode
  code: '0xbd00597fe18f5ef1c57f440545ec64e19efc2c7a'
  is: empty
  says: the signer account has no code yet
  for:
  - notes
- id: signernonce
  nonce: '0xbd00597fe18f5ef1c57f440545ec64e19efc2c7a'
  is: 0
  says: the signer key has sent no transaction
  for:
  - notes
- id: state
  call: '0x91462f61d4e2882d0c9a15290f06eaabbef726cc'
  fn: auctionState()(uint8)
  is: 2
  says: the reserve is stopped and concluding; refund needs state 3
  for:
  - evidence-2
  - what
- id: winners
  call: '0x91462f61d4e2882d0c9a15290f06eaabbef726cc'
  fn: winnersCount()(uint256)
  is: 523
  says: 523 winners are set
  for:
  - evidence-2
  - what
- id: dep522
  call: '0x91462f61d4e2882d0c9a15290f06eaabbef726cc'
  fn: getDepositedUsers(uint256,uint256)(address[])
  args:
  - 522
  - 100000
  is:
  - '0x47137f7ba819d4044f126c3d086c1289b3b7e57f'
  says: the depositor list has a 523rd entry
  for:
  - evidence-2
  - what
- id: dep523
  call: '0x91462f61d4e2882d0c9a15290f06eaabbef726cc'
  fn: getDepositedUsers(uint256,uint256)(address[])
  args:
  - 523
  - 100000
  is: []
  says: 'and no 524th: 523 depositors'
  for:
  - evidence-2
  - what
- id: refunded
  call: '0x91462f61d4e2882d0c9a15290f06eaabbef726cc'
  fn: getRefundedUsersCount()(uint256)
  is: 0
  says: no refund has been made
  for:
  - evidence-2
- id: bal
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x91462f61d4e2882d0c9a15290f06eaabbef726cc'
  is: 0
  says: the reserve holds no ETH (Multicall3 balance read)
  for:
  - evidence-2
  - what
- id: implinit
  storage: '0xbf5fe9bfe3e4dfaf4082a3ea88528c14ab11bea8'
  slot: '0xf0c57e16840df040f15088dc2f81fe391c3923bec73e23a9662efc9c229c6a00'
  is: '0x000000000000000000000000000000000000000000000000ffffffffffffffff'
  says: the implementation copy has its initializers disabled
  for:
  - notes
- id: implsigner
  call: '0xbf5fe9bfe3e4dfaf4082a3ea88528c14ab11bea8'
  fn: signer()(address)
  is: '0x0000000000000000000000000000000000000000'
  says: the implementation copy has no signer
  for:
  - notes
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

Refunds of this reserve's 0.2 ETH deposits need a signature, checked with ECDSA, from a stored signer key the owner can replace. The reserve is concluded: 523 winners are set for 523 depositors and it holds no ETH. If the key's account took real code, refunds would fail until a new key is set.

## Evidence

- [checkValidity](https://etherscan.io/address/0xbf5fe9bfe3e4dfaf4082a3ea88528c14ab11bea8#code) requires the stored signer to sign each refund; setSigner lets the owner replace it.
- [The reserve](https://etherscan.io/address/0x91462f61d4e2882d0c9a15290f06eaabbef726cc) is in its concluding state, with 523 winners for 523 depositors, no refunds made and no ETH held.

## Reviewer notes

### Mechanism

The proxy runs Live4WellReserve (UUPS). refund (lines 73-81) needs auctionState 3, a deposit by the caller and no earlier refund, then calls checkValidity (lines 49-63): ECDSA.recover of the eth-signed hash of (msg.sender, "l4w-refund") must equal the stored signer, else it reverts; OZ ECDSA reverts on a zero result. setSigner (lines 122-124, onlyOwner) replaces the key. At block 26,438,999: signer 0xbd00...2c7a has no code and nonce 0; owner and upgrader are 0x20cd...053b, an account with no code; auctionState is 2 (concluding); winnersCount is 523 and the depositor list holds 523 addresses; no refund was made; the proxy holds 0 ETH, so withdrawSales already took the balance (nonWinners = 0 leaves no refund reserve). A refund now would also fail for lack of ETH; the owner can reopen deposits (setAuctionState) or change winnersCount, so the path is not closed for good.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-size path for the signer: checkValidity has only ECDSA.recover, and the source has no isValidSignature.
- Ruled out: unused implementation: this address is the initialized proxy (owner and signer set); its one copy is the implementation 0xbf5f...ea8, whose initializers are disabled and whose signer is unset.
- Ruled out: key state: the signer is set, has no code and has sent no transaction, so it is presumed live.
- Ruled out: path closed for good: no, the owner can set the state and the winner count again; at the block no refund is owed and no ETH is held, which the card says.
- Ruled out: direct path: no refund path without the signature; withdrawSales pays only the owner.
- Ruled out: breaks by itself: ECDSA uses the ecrecover builtin, which forwards all gas; nothing fails with nobody migrating.
- Ruled out: rechecked later: the signature is the operator's refund approval, used at once by the caller; nobody relies on it beforehand.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
