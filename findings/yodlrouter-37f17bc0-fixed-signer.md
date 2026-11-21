---
id: yodlrouter-37f17bc0-fixed-signer
format: 2
title: Yodl router rejects signed exchange rates if its rate key moves to real code
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless the rate key's account takes real code; the key is a constant, so a new router
  is then needed.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x37f17bc0e317aaaf663908ddbbca296e2119eb2b'
  name: YodlRouter
  project: yodl
  code: verified
  code_url: https://etherscan.io/address/0x37f17bc0e317aaaf663908ddbbca296e2119eb2b#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  whose: operator
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Keep the rate signing account free of code, or deploy a router with a new rate key before moving it.
evidence_level: source
checks:
- id: const
  source: '0x37f17bc0e317aaaf663908ddbbca296e2119eb2b'
  file: src/AbstractYodlRouter.sol
  line: 18
  has: address public constant RATE_VERIFIER = 0xc71f6e1e4665d319610afA526BE529202cA13bB7;
  says: the rate key is a constant in the code, which no function can change
  for:
  - action
  - evidence-1
  - justification
  - what
- id: const-call
  call: '0x37f17bc0e317aaaf663908ddbbca296e2119eb2b'
  fn: RATE_VERIFIER()(address)
  is: '0xc71f6e1e4665d319610afa526be529202ca13bb7'
  says: the deployed code holds that same rate key
  for:
  - evidence-1
- id: recover
  source: '0x37f17bc0e317aaaf663908ddbbca296e2119eb2b'
  file: src/AbstractYodlRouter.sol
  line: 261
  has: return ECDSA.recover(ethSignedMessageHash, priceFeed.signature) == RATE_VERIFIER;
  says: a rate is accepted only when ECDSA recovery of its signature gives the constant key; there is no other branch
  for:
  - action
  - evidence-1
  - justification
  - what
- id: ext-branch
  source: '0x37f17bc0e317aaaf663908ddbbca296e2119eb2b'
  file: src/AbstractYodlRouter.sol
  line: 141
  has: if (priceFeeds[0].feedType == EXTERNAL_FEED) {
  says: the signature is checked only when the first feed is an external rate
  for:
  - evidence-3
  - what
- id: ext-revert
  source: '0x37f17bc0e317aaaf663908ddbbca296e2119eb2b'
  file: src/AbstractYodlRouter.sol
  lines:
  - 142
  - 144
  has: revert("Invalid signature for external price feed");
  says: exchangeRate reverts when the rate signature does not verify
  for:
  - evidence-3
  - what
- id: chainlink
  source: '0x37f17bc0e317aaaf663908ddbbca296e2119eb2b'
  file: src/AbstractYodlRouter.sol
  line: 146
  has: priceFeedOne = AggregatorV3Interface(priceFeeds[0].feedAddress);
  says: any other feed type is read as a Chainlink feed, with no signature
  for:
  - evidence-3
  - what
- id: nofeed
  source: '0x37f17bc0e317aaaf663908ddbbca296e2119eb2b'
  file: src/AbstractYodlRouter.sol
  line: 134
  has: return (amount, [address(0), address(0)], [int256(1), int256(1)]);
  says: with no feed the amount is returned unchanged, with no signature
  for:
  - evidence-3
  - what
- id: pay-token
  source: '0x37f17bc0e317aaaf663908ddbbca296e2119eb2b'
  file: src/routers/YodlTransferRouter.sol
  line: 88
  has: (outAmountGross, priceFeedsUsed, prices) = exchangeRate(params.priceFeeds, params.amount);
  says: a payment with a feed calls exchangeRate, so its revert reverts the payment
  for:
  - what
- id: key-empty
  code: '0xc71f6e1e4665d319610afa526be529202ca13bb7'
  is: empty
  says: the rate key's account holds no code at the block
  for:
  - evidence-2
  - justification
- id: key-nonce
  nonce: '0xc71f6e1e4665d319610afa526be529202ca13bb7'
  is: 0
  says: the rate key's account has sent no transaction
  for:
  - evidence-2
- id: sweep
  source: '0x37f17bc0e317aaaf663908ddbbca296e2119eb2b'
  file: src/AbstractYodlRouter.sol
  lines:
  - 206
  - 215
  has: TransferHelper.safeTransfer(token, yodlFeeTreasury, IERC20(token).balanceOf(address(this)));
  says: anyone can send whatever the router holds to the fee treasury
  for:
  - whose
- id: treasury
  call: '0x37f17bc0e317aaaf663908ddbbca296e2119eb2b'
  fn: yodlFeeTreasury()(address)
  is: '0x57a48f1c8734de572094ca7fdc0ba7e3919067cf'
  says: the fee treasury that sweep pays
  for:
  - whose
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

This payment router converts invoice amounts with a Chainlink feed or with a rate signed by one key fixed in its code. If that key's account moves to real code, payments that use a signed rate revert. Payments with a Chainlink feed or no conversion keep working.

## Evidence

- [verifyRateSignature](https://etherscan.io/address/0x37f17bc0e317aaaf663908ddbbca296e2119eb2b#code) recovers the signer of a rate with ECDSA and compares it with the constant RATE_VERIFIER.
- The [rate key's account](https://etherscan.io/address/0xc71f6e1e4665d319610afa526be529202ca13bb7) holds no code and has sent no transaction.
- [exchangeRate](https://etherscan.io/address/0x37f17bc0e317aaaf663908ddbbca296e2119eb2b#code) checks the signature only for an external rate; a Chainlink feed or no feed skips it.

## Reviewer notes

### Mechanism

verifyRateSignature (AbstractYodlRouter.sol, lines 253-262) hashes currency, amount and deadline, returns false after the deadline, and otherwise returns ECDSA.recover(...) == RATE_VERIFIER, a compile-time constant (line 18). exchangeRate (lines 121-181) calls it only when priceFeeds[0].feedType is EXTERNAL_FEED and reverts on false (lines 141-144); with a Chainlink feed it reads the feed (line 146), with two null feeds it returns the amount unchanged (line 134). All five payment functions call exchangeRate when a feed is given (yodlWithToken line 88, yodlWithExternal 95, yodlWithAcross 59, yodlWithCurve 56, yodlWithUniswap 57). The contract has no owner, no setter and no delegatecall, so the key changes only by deploying a new router. Under EIP-8151 a recovery of a key whose account has code gives address(0); OpenZeppelin's ECDSA.recover then reverts, so the payment reverts either way. Rates carry a deadline and are checked once, inside the payment that uses them: nothing relies on a signature after the fact. The router holds nothing at the block; whatever is left in it goes to the fee treasury through the public sweep.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size path for the rate key: verifyRateSignature has only ECDSA.recover (lines 253-262).
- Ruled out: a setter or upgrade: RATE_VERIFIER is a constant (line 18); no function in src/ writes it; the tool reads no proxy, no delegatecall, no owner.
- Ruled out: the key already holding code or being another address: RATE_VERIFIER() returns 0xc71f6e1e4665d319610afA526BE529202cA13bB7, whose code is empty and nonce 0 at block 26,438,999.
- Ruled out: a path closed for good: the contract has no pause or switch; signed rates only need a deadline in the future (line 257).
- Ruled out: a direct path: it exists and the card says so. A payer can use a Chainlink feed or pass the converted amount with no feed; only the signed-rate conversion is lost.
- Ruled out: a signature relied on later: the rate is checked once, inside the payment; nothing stored depends on it.
- Ruled out: a break with nobody migrating: OpenZeppelin's ECDSA calls the precompile with all remaining gas; the scanner found no constant gas amount (ec_gas_const null).
- Ruled out: use at the block: the dossier shows 0 transactions in 90 days and no recovery in the trace window, so this router looks idle. The contract's own nonce is 1 (it deployed nothing). No check kind shows activity, so the card does not speak of it.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
