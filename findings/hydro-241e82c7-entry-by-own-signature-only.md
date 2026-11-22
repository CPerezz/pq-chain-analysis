---
id: hydro-241e82c7-entry-by-own-signature-only
format: 2
title: Hydro traders whose accounts take real code can no longer place orders
status: confirmed
severity: INFORMATIONAL
justification: Breaks only for a trader moving its own account to real code; ETH out needs a 2,300-gas-ready address.
category: migration-notice
pattern: PQ-21
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x241e82c79452f51fbfc89fac6d912e021db1a3b7'
  name: Hydro
  code: verified
  code_url: https://etherscan.io/address/0x241e82c79452f51fbfc89fac6d912e021db1a3b7#code
  copies: 1
  admin: '0x0a294e9b3af4c3579ea6584f3e26914b2daa72ca'
value:
  usd: 244415
  whose: users
  basis: held
activity:
  txs_90d: 71
  last: 2026-11-10
impact: funds-locked
action: Tell traders an account with real code cannot have orders matched; withdraw ETH first unless the new code
  accepts a 2,300-gas transfer.
evidence_level: source
checks:
- id: taker-sig
  source: '0x241e82c79452f51fbfc89fac6d912e021db1a3b7'
  file: Hydro.sol
  line: 713
  has: OrderInfo memory takerOrderInfo = getOrderInfo(state, params.takerOrderParam, params.orderAddressSet);
  says: matchOrders checks the taker order through getOrderInfo
  for:
  - evidence-1
  - what
- id: maker-sig
  source: '0x241e82c79452f51fbfc89fac6d912e021db1a3b7'
  file: Hydro.sol
  line: 723
  has: OrderInfo memory makerOrderInfo = getOrderInfo(state, params.makerOrderParams[i], params.orderAddressSet);
  says: matchOrders checks every maker order through getOrderInfo
  for:
  - evidence-1
  - what
- id: order-sig
  source: '0x241e82c79452f51fbfc89fac6d912e021db1a3b7'
  file: Hydro.sol
  lines:
  - 810
  - 813
  has: Signature.isValidSignature(orderInfo.orderHash, orderParam.trader, orderParam.signature), "INVALID_ORDER_SIGNATURE"
  says: getOrderInfo reverts unless the order's signature is valid for its trader
  for:
  - action
  - evidence-1
  - what
- id: sig-methods
  source: '0x241e82c79452f51fbfc89fac6d912e021db1a3b7'
  file: Hydro.sol
  lines:
  - 4277
  - 4288
  has: recovered = ecrecover(hash, v, signature.r, signature.s); } else { revert("INVALID_SIGN_METHOD");
  says: the signature is recovered with ecrecover (eth_sign or EIP-712); any other method reverts
  for:
  - evidence-2
  - what
- id: sig-compare
  source: '0x241e82c79452f51fbfc89fac6d912e021db1a3b7'
  file: Hydro.sol
  line: 4290
  has: return signerAddress == recovered;
  says: the recovered address must equal the order's trader
  for:
  - action
  - evidence-2
  - justification
  - what
- id: deposit-credit
  source: '0x241e82c79452f51fbfc89fac6d912e021db1a3b7'
  file: Hydro.sol
  line: 4462
  has: transferIn(state, asset, BalancePath.getCommonPath(msg.sender), amount);
  says: a deposit is credited to the depositor's own balance
  for:
  - whose
- id: batch-withdraw
  source: '0x241e82c79452f51fbfc89fac6d912e021db1a3b7'
  file: Hydro.sol
  lines:
  - 1725
  - 1730
  has: Transfer.withdraw( state, msg.sender, asset, amount );
  says: withdraw in batch pays the caller from its own balance, with no signature
  for:
  - action
  - evidence-3
  - justification
  - what
- id: batch-transfer
  source: '0x241e82c79452f51fbfc89fac6d912e021db1a3b7'
  file: Hydro.sol
  lines:
  - 1754
  - 1755
  has: require(fromBalancePath.user == msg.sender, "CAN_NOT_MOVE_OTHER_USER_ASSET");
  says: transfer in batch moves only the caller's own balances
  for:
  - notes
- id: batch-repay
  source: '0x241e82c79452f51fbfc89fac6d912e021db1a3b7'
  file: Hydro.sol
  lines:
  - 1841
  - 1847
  has: LendingPool.repay( state, msg.sender, marketID, asset, amount );
  says: repay in batch repays the caller's debt, with no signature
  for:
  - notes
- id: insurance
  call: '0x241e82c79452f51fbfc89fac6d912e021db1a3b7'
  fn: getInsuranceBalance(address)(uint256)
  args:
  - '0x000000000000000000000000000000000000000E'
  is: '742899770597657179'
  says: the protocol's own insurance balance of 0.74 ETH is held here beside users' deposits
  for:
  - notes
- id: signer-delegation
  code: '0x8f13e164e10ff6b87f9a9db4f3e29e7bff6d320d'
  is: delegation
  says: the trader recovered in the traced match holds an EIP-7702 delegation, which EIP-8151 still recovers
  for:
  - notes
- id: window-tx
  tx: '0xc0f233922c661635afbf5b0b36e8597528fa5943b1942be5316238645d401c47'
  ok: true
  says: the traced transaction with a Hydro match succeeded
  for:
  - notes
- id: eip
  ref: https://github.com/ethereum/EIPs/blob/8194528a2ee9a4893a398a5871c470ab0ac3b09a/EIPS/eip-8151.md
  says: EIP-8151 returns no address for an account with real code and still recovers one with an EIP-7702 delegation
  for:
  - what
- id: eth-transfer
  source: '0x241e82c79452f51fbfc89fac6d912e021db1a3b7'
  file: Hydro.sol
  line: 4481
  has: payableUser.transfer(amount);
  says: ETH withdrawal pays with a plain transfer, which forwards only a 2,300-gas stipend
  for:
  - action
  - evidence-3
  - justification
  - what
- id: insurance-grow
  source: '0x241e82c79452f51fbfc89fac6d912e021db1a3b7'
  file: Hydro.sol
  line: 2320
  has: state.pool.insuranceBalances[asset] = state.pool.insuranceBalances[asset].add(recentBorrowInterest.sub(recentSupplyInterest));
  says: the insurance balance grows only from the interest rate spread between borrowers and suppliers
  for:
  - whose
- id: insurance-claim
  source: '0x241e82c79452f51fbfc89fac6d912e021db1a3b7'
  file: Hydro.sol
  line: 1465
  has: LendingPool.claimInsurance(state, auction.debtAsset, actualRepayAmount.sub(actualBidderRepay));
  says: the insurance balance is spent only through claimInsurance, called when a liquidation auction's bidder underpays,
    to cover lenders' bad debt
  for:
  - whose
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

Hydro matches a trade only if each order carries its trader's ECDSA signature. A trader whose account takes real code can no longer have orders matched; an EIP-7702 delegation still works. Tokens still withdraw by direct call; ETH only if the account's new code accepts a 2,300-gas transfer.

## Evidence

- [matchOrders](https://etherscan.io/address/0x241e82c79452f51fbfc89fac6d912e021db1a3b7#code) checks the taker order and each maker order, and rejects any whose signature does not recover to its trader.
- The [signature check](https://etherscan.io/address/0x241e82c79452f51fbfc89fac6d912e021db1a3b7#code) takes only ECDSA (signed message or EIP-712) and has no path for an account with real code.
- [batch](https://etherscan.io/address/0x241e82c79452f51fbfc89fac6d912e021db1a3b7#code) withdraws only to the caller, with no signature; ETH goes out by a transfer that forwards 2,300 gas.

## Reviewer notes

### Mechanism

matchOrders (external, lines 384-389) calls Exchange.matchOrders (702-746): the caller must be the relayer or its delegate (708), then getOrderInfo is called for the taker order (713) and for every maker order (723). getOrderInfo (781-819) requires Signature.isValidSignature(orderHash, orderParam.trader, signature) (809-812). Signature.isValidSignature (4264-4291) recovers with ecrecover, either over the eth_sign prefix or the raw EIP-712 hash, and returns signerAddress == recovered; any other method reverts. There is no on-chain order book, no exemption when the trader is the caller, and no ERC-1271 path. Balances move through batch (ExternalFunctions 32-39, BatchActions 1649-1681): deposit credits msg.sender (4442-4466), withdraw pays msg.sender only (1708-1730), transfer requires both paths to belong to msg.sender (1754-1755), borrow, repay, supply and unsupply act for msg.sender. Transfer.withdraw (4469-4489) sends ETH with payableUser.transfer (4481), a 2,300-gas stipend, so an account needing more gas cannot take ETH out; tokens go by safeTransfer.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: erc1271 / direct-path: Signature.isValidSignature has only two ECDSA methods (4264-4291); matchOrders checks every order even when the trader is the caller; no on-chain order book. Auction fills buy collateral only, not an order.
- Ruled out: own-signature-only-exit: funds are not behind the signature; withdraw, transfer and repay in batch act for msg.sender, no signature. ETH withdrawal uses a 2,300-gas transfer (4481) paying msg.sender only, so an account needing more gas cannot take ETH out; noted in the card and action.
- Ruled out: rechecked-later: an order's signature is checked at each match, but a later failure only leaves the rest of the order unfilled; no party that already relied on it loses.
- Ruled out: path-closed: no pause or trading switch in matchOrders. The trace window has one Hydro match (0xc0f23392...c47, block 26,377,003, succeeded); its trader, 0x8f13...320d, holds an EIP-7702 delegation, which still recovers.
- Ruled out: gas / breaks-by-itself: the scanner found no constant gas on the recovery (ec_gas_const null) and the dossier has no replays; real match gas limits were not measured.
- Ruled out: wrong-code / unused-implementation: not a proxy; the address holds 120.33 ETH and tokens at the block and emits its own events. The delegate-called libraries do not recover.
- Ruled out: whose / value-whose: deposits credit the depositing user (4462). The insurance balance (0.74 ETH) grows from the interest spread (2320) and leaves only via claimInsurance (2209-2227), from an expired auction (1465), covering lenders' bad debt; no owner payout exists, so whose = users.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
