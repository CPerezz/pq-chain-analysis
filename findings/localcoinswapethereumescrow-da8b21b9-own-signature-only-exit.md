---
id: localcoinswapethereumescrow-da8b21b9-own-signature-only-exit
format: 2
title: LocalCoinSwap escrow parties must settle trades before moving to real code
status: candidate
severity: INFORMATIONAL
justification: 'Breaks only for a party that moves to real code: it then cannot cancel or dispute, so its ETH waits
  on the other side.'
category: migration-notice
pattern: PQ-16
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xda8b21b94668300ddbc0ecbaf57530d396287848'
  name: LocalCoinSwapEthereumEscrow
  code: verified
  code_url: https://etherscan.io/address/0xda8b21b94668300ddbc0ecbaf57530d396287848#code
  copies: 1
  upgradeable: 'no'
  admin: '0x665f3e7a712c470c7c5036ed0f762f936dfe36a7'
value:
  usd: 2215
  whose: users
  basis: held
activity:
  txs_90d: 0
impact: funds-locked
action: Tell sellers and buyers to cancel, release or settle any open trade before they move their account to real
  code.
evidence_level: source
checks:
- id: recover
  source: '0xda8b21b94668300ddbc0ecbaf57530d396287848'
  file: LocalCoinSwapEthereumEscrow.sol
  line: 694
  has: return ecrecover(_prefixedHash, _v, _r, _s);
  says: signatures are recovered with plain ecrecover
  for:
  - justification
  - what
- id: dispute
  source: '0xda8b21b94668300ddbc0ecbaf57530d396287848'
  file: LocalCoinSwapEthereumEscrow.sol
  line: 158
  has: require(_signature == _buyer || _signature == _seller, "Must be buyer or seller");
  says: the arbitrator settles a dispute only with a signature recovered to the buyer or seller
  for:
  - action
  - evidence-1
  - justification
  - what
- id: sellercancel
  source: '0xda8b21b94668300ddbc0ecbaf57530d396287848'
  file: LocalCoinSwapEthereumEscrow.sol
  lines:
  - 419
  - 426
  has: return doSellerCancel(
  says: a seller cancel happens in relay when the recovered sender is the seller
  for:
  - action
  - evidence-2
  - justification
  - what
- id: deposit
  source: '0xda8b21b94668300ddbc0ecbaf57530d396287848'
  file: LocalCoinSwapEthereumEscrow.sol
  line: 123
  has: require(msg.value == _value && msg.value > 0, "Incorrect ether sent");
  says: escrows are funded with the trade's ETH
  for:
  - what
  - whose
- id: fees
  call: '0xda8b21b94668300ddbc0ecbaf57530d396287848'
  fn: feesAvailableForWithdraw()(uint256)
  is: '0'
  says: no collected fees are held, so the ETH held is not the operator's fees
  for:
  - whose
- id: release-direct
  source: '0xda8b21b94668300ddbc0ecbaf57530d396287848'
  file: LocalCoinSwapEthereumEscrow.sol
  line: 200
  has: require(msg.sender == _seller, "Must be seller");
  says: the seller can still release the ETH to the buyer by a direct call, without a signature
  for:
  - justification
- id: buyercancel-direct
  source: '0xda8b21b94668300ddbc0ecbaf57530d396287848'
  file: LocalCoinSwapEthereumEscrow.sol
  lines:
  - 236
  - 237
  has: return doBuyerCancel(
  says: the buyer can still cancel and return the ETH to the seller by a direct call, without a signature
  for:
  - justification
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: HIGH
reviews:
- who: r-da8b21b9, the row's refuter
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: Sent back after the wording-pass refuter found a false justification and an understated impact. The
    redone card: a migrated party cannot cancel or dispute, and getting its ETH back waits on the other side (direct
    release and buyerCancel pay the other party); impact funds-locked. A fresh refuter agrees; sheet read by Claude.
    INFORMATIONAL; candidate (which trades the 1.227 ETH belongs to needs logs).'
related: []
---

## What happens

This escrow holds a seller's ETH for a trade. A seller cancels, and the arbitrator settles a dispute, only with an ECDSA signature of the seller or buyer. A party that moved to real code cannot sign, so its ETH stays locked unless the other side acts.

## Evidence

- [resolveDispute](https://etherscan.io/address/0xda8b21b94668300ddbc0ecbaf57530d396287848#code) requires a signature that recovers to the buyer or the seller.
- [relay](https://etherscan.io/address/0xda8b21b94668300ddbc0ecbaf57530d396287848#code) is the only route to a seller cancel, and it needs the seller's recovered signature.

## Reviewer notes

### Mechanism

recoverAddress (lines 686-695) calls ecrecover on a prefixed hash. resolveDispute (143-184) is onlyArbitrator, and it requires the recovered address to be _buyer or _seller (line 158). doSellerCancel, which returns the ETH to the seller after the payment window, is reached only from relay (line 424-426), where the recovered sender must equal _seller. The direct-call functions are release (seller), disableSellerCancel (buyer), buyerCancel (buyer) and sellerRequestCancel (seller), and none of them calls doSellerCancel. So a seller with code can get its ETH back only if the buyer cancels or signs a dispute. A buyer that marked the trade paid gets the ETH only if the seller releases or a dispute is signed by one of them. At the block the contract holds 1.227 ETH, feesAvailableForWithdraw is 0, and the arbitrator and relayer are 0x877cf5f0...5ce5.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 path: recoverAddress uses plain ecrecover and there is no other signature check (lines 686-695).
- Ruled out: a direct seller cancel: no external function calls doSellerCancel; only relay does (line 426).
- Ruled out: an admin rescue of ETH: withdrawFees is capped by feesAvailableForWithdraw (line 308), which is 0, and the token functions move only ERC-20s.

### Questions

- Which open trades the 1.227 ETH belongs to cannot be read from the contract without scanning its logs.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
