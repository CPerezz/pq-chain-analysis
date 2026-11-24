---
id: localcryptosethescrows-ede26ccc-own-signature-only-exit
format: 2
title: LocalCryptos escrow parties lose disputes if their accounts take real code
status: candidate
severity: INFORMATIONAL
justification: Breaks only if a buyer or seller moves its account to real code; release and cancel stay open by
  direct call.
category: migration-notice
pattern: PQ-16
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xede26ccc85ae521d06b5ef2604952a421c9124b6'
  name: LocalCryptosETHEscrows
  project: localcryptos
  code: verified
  code_url: https://etherscan.io/address/0xede26ccc85ae521d06b5ef2604952a421c9124b6#code
  copies: 1
  upgradeable: 'no'
  admin: '0x47d70d729c6efd464cc49ebb6f4ee240219ecb9e'
value:
  usd: 6170
  whose: users
  basis: held
activity:
  txs_90d: 0
impact: funds-locked
action: Tell buyers and sellers to finish open trades (release, cancel, or a dispute resolved on chain) before moving
  their accounts to real code.
evidence_level: source
checks:
- id: resolve
  source: '0xede26ccc85ae521d06b5ef2604952a421c9124b6'
  file: LocalCryptosETHEscrows.sol
  has: require(_signature == _buyer || _signature == _seller, "Must be buyer or seller");
  says: resolveDispute goes on only if the recovered signer is the trade's buyer or seller
  line: 184
  for:
  - evidence-1
  - justification
  - what
- id: resolve-arb
  source: '0xede26ccc85ae521d06b5ef2604952a421c9124b6'
  file: LocalCryptosETHEscrows.sol
  has: ) external onlyArbitrator {
  says: only the arbitrator can call resolveDispute
  line: 179
  for:
  - evidence-1
  - what
- id: recover
  source: '0xede26ccc85ae521d06b5ef2604952a421c9124b6'
  file: LocalCryptosETHEscrows.sol
  has: return ecrecover(_prefixedHash, _v, _r, _s);
  says: signatures are recovered with ecrecover alone, with no ERC-1271 path
  line: 744
  for:
  - action
  - evidence-1
  - what
- id: paid
  source: '0xede26ccc85ae521d06b5ef2604952a421c9124b6'
  file: LocalCryptosETHEscrows.sol
  has: escrows[_tradeHash].sellerCanCancelAfter = 0;
  says: marking a trade paid sets sellerCanCancelAfter to 0
  line: 560
  for:
  - evidence-2
  - what
- id: no-cancel
  source: '0xede26ccc85ae521d06b5ef2604952a421c9124b6'
  file: LocalCryptosETHEscrows.sol
  has: if(_escrow.sellerCanCancelAfter <= 1 || _escrow.sellerCanCancelAfter > block.timestamp) {
  says: the seller cannot cancel a trade whose sellerCanCancelAfter is 0
  line: 625
  for:
  - evidence-2
  - what
- id: release-direct
  source: '0xede26ccc85ae521d06b5ef2604952a421c9124b6'
  file: LocalCryptosETHEscrows.sol
  has: require(msg.sender == _seller, "Must be seller");
  says: the seller can release by calling directly, without a signature
  line: 218
  for:
  - action
  - justification
- id: buyer-cancel-direct
  source: '0xede26ccc85ae521d06b5ef2604952a421c9124b6'
  file: LocalCryptosETHEscrows.sol
  has: require(msg.sender == _buyer, "Must be buyer");
  says: the buyer can cancel by calling directly, without a signature
  line: 254
  for:
  - action
  - justification
- id: owner-fees
  source: '0xede26ccc85ae521d06b5ef2604952a421c9124b6'
  file: LocalCryptosETHEscrows.sol
  has: require(_amount <= feesAvailableForWithdraw, "Amount is higher than amount available");
  says: the owner can withdraw ETH only up to the recorded fees
  line: 344
  for:
  - evidence-2
  - what
- id: payable
  source: '0xede26ccc85ae521d06b5ef2604952a421c9124b6'
  file: LocalCryptosETHEscrows.sol
  has: ) payable external {
  says: createEscrow is the only payable function; escrowed ETH comes from sellers' deposits
  line: 132
  for:
  - whose
- id: fees-zero
  call: '0xede26ccc85ae521d06b5ef2604952a421c9124b6'
  fn: feesAvailableForWithdraw()(uint256)
  is: '0'
  says: no ETH held is recorded as collected fees
  for:
  - evidence-2
  - whose
- id: arbitrator
  call: '0xede26ccc85ae521d06b5ef2604952a421c9124b6'
  fn: arbitrator()(address)
  is: '0xa38f728c9431a4248753c63423518faf4de63e18'
  says: the arbitrator is set
  for:
  - notes
- id: arbitrator-eoa
  code: '0xa38f728c9431a4248753c63423518faf4de63e18'
  is: empty
  says: the arbitrator is a key-held account with no code
  for:
  - notes
- id: resolve-msg
  source: '0xede26ccc85ae521d06b5ef2604952a421c9124b6'
  file: LocalCryptosETHEscrows.sol
  lines:
  - 180
  - 183
  has: INSTRUCTION_RESOLVE
  says: the dispute signature is recovered inside resolveDispute, when the arbitrator submits it
  for:
  - action
- id: no-reset
  source: '0xede26ccc85ae521d06b5ef2604952a421c9124b6'
  file: LocalCryptosETHEscrows.sol
  line: 666
  has: if(_escrow.sellerCanCancelAfter != 1) {
  says: a seller's cancel request cannot reopen cancelling once a trade is marked paid
  for:
  - what
- id: release-to-buyer
  source: '0xede26ccc85ae521d06b5ef2604952a421c9124b6'
  file: LocalCryptosETHEscrows.sol
  line: 534
  has: transferMinusFees(_buyer, _value, _gasFees, _fee);
  says: a release pays the escrowed ETH to the buyer
  for:
  - what
- id: cancel-to-seller
  source: '0xede26ccc85ae521d06b5ef2604952a421c9124b6'
  file: LocalCryptosETHEscrows.sol
  line: 598
  has: transferMinusFees(_seller, _value, _gasFees, 0);
  says: a buyer's cancel pays the escrowed ETH back to the seller
  for:
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: HIGH
reviews:
- who: r-ede26ccc, the row's refuter
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: Sent back once (the action suggested pre-signing, which cannot help; the lock condition named the
    wrong party); the new card fixes both. A fresh refuter agrees on every part; sheet read by Claude. INFORMATIONAL
    (was HIGH). Stays a candidate (open escrows not read).'
related: []
---

## What happens

LocalCryptos' ETH escrow settles a dispute only with the buyer's or seller's signature. A party whose account takes real code cannot sign; an EIP-7702 delegation still can. If the counterparty refuses (a seller who won't release, or a buyer who marked paid and won't cancel), the ETH stays locked.

## Evidence

- [resolveDispute](https://etherscan.io/address/0xede26ccc85ae521d06b5ef2604952a421c9124b6#code) is arbitrator-only and requires the recovered signer to be the trade's buyer or seller.
- After [mark-paid](https://etherscan.io/address/0xede26ccc85ae521d06b5ef2604952a421c9124b6#code) the seller cannot cancel, and the owner can withdraw only recorded fees, which are zero.

## Reviewer notes

### Mechanism

resolveDispute (lines 169-202) is callable only by the arbitrator (0xa38f…3e18, an account with no code at the block). It recovers a signature over (tradeID, INSTRUCTION_RESOLVE) with recoverAddress (lines 736-745: personal-sign prefix, plain ecrecover, no ERC-1271) at the moment the arbitrator submits it, and requires it to equal _buyer or _seller (line 184); the arbitrator picks the split (_buyerPercent). A signature given in advance therefore fails if the signer has real code by then. Every other party action has a direct-call form checked on msg.sender: release (seller, 218), disableSellerCancel (buyer, 236), buyerCancel (buyer, 254), sellerCancel (seller, 272), sellerRequestCancel (seller, 290). Release pays the buyer (534); buyerCancel pays the seller (598). Once the buyer marks paid (line 560), doSellerCancel returns false (625) and doSellerRequestCancel cannot reopen it (666). Either party's signature suffices for a dispute, so the lock needs the party with real code to face a counterparty that will not act: a buyer with real code whose seller will not release can only cancel (ETH to seller); a seller with real code whose buyer marked paid and will not cancel can only release (ETH to buyer). The owner has no ETH rescue: withdrawFees is capped by feesAvailableForWithdraw (line 344, 0 at the block), and the token functions handle ERC-20 only. The contract is not upgradeable.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: ERC-1271 or a code-size branch: recoverAddress is plain ecrecover (lines 736-745).
- Ruled out: direct path for disputes: none; resolveDispute is the only function that pays out by arbitrator decision, and it requires a party signature (line 184).
- Ruled out: admin rescue of escrowed ETH: withdrawFees is capped by recorded fees (line 344; feesAvailableForWithdraw() = 0 at the block); the token functions move ERC-20s only.
- Ruled out: breaks by itself: Solidity's ecrecover forwards all gas, and the dossier's scan has no fixed gas constant; nothing here fails with nobody migrating.
- Ruled out: proxy/unused implementation: not a proxy, initialized in its constructor; the arbitrator is set (0xa38f…3e18, no code, nonce 3577).
- Ruled out: separate notices not folded in: createEscrow needs a signature from inviterAddress (line 145; 0xf008…6420, replaceable by the owner through setInviterAddress), and batchRelay accepts party instructions by signature with direct-call alternatives. Those are a rotate-signer and a signed-shortcut issue, not this one.

### Questions

- Whether any escrow is still open at the block was not read: open trades are not enumerable without event logs. The contract holds 3.42 ETH with zero recorded fees and had no transactions in the 90 days to the block.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
