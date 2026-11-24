---
id: launchfactory-235b8701-rotate-signer-before-migrating
format: 2
title: Token launches stop if the price signer moves its account to real code
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless the price signer moves to real code, and the owner can replace that key first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x235b870118c492e862670aec2b3b7e7a92915628'
  name: LaunchFactory
  code: verified
  code_url: https://etherscan.io/address/0x235b870118c492e862670aec2b3b7e7a92915628#code
  copies: 1
  upgradeable: 'no'
  admin: '0x6a684c214dd48a163a3025be50718419062e144a'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 13
  last: 2026-09-08
impact: liveness
action: Replace the price signer with setPriceSigner before moving that signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x235b870118c492e862670aec2b3b7e7a92915628'
  file: src/LaunchFactory.sol
  line: 275
  has: if (ECDSA.recover(digest, p.priceSignature) != priceSigner) revert BadPriceSignature();
  says: the price signature is recovered with ECDSA and must come from the stored priceSigner, or the call reverts
  for:
  - evidence-1
  - justification
  - what
- id: gate
  source: '0x235b870118c492e862670aec2b3b7e7a92915628'
  file: src/LaunchFactory.sol
  lines:
  - 222
  - 229
  has: _verifyPrice(p);
  says: _create calls _verifyPrice after the pause and quote checks and before it deploys anything
  for:
  - evidence-1
  - what
- id: create1
  source: '0x235b870118c492e862670aec2b3b7e7a92915628'
  file: src/LaunchFactory.sol
  line: 195
  has: (token, key, poolId) = _create(p, 0);
  says: createLaunch goes through _create
  for:
  - evidence-1
  - what
- id: create2
  source: '0x235b870118c492e862670aec2b3b7e7a92915628'
  file: src/LaunchFactory.sol
  line: 212
  has: (token, key, poolId) = _create(p, devBuyValue);
  says: createLaunchAndBuy goes through _create
  for:
  - evidence-1
  - what
- id: deploy
  source: '0x235b870118c492e862670aec2b3b7e7a92915628'
  file: src/LaunchFactory.sol
  line: 233
  has: 'token = address(new LaunchToken{salt: salt}(p.name, p.symbol, p.metadataUri, msg.sender, address(hook)));'
  says: _create deploys the new token after the price check
  for:
  - what
- id: ecrecover
  source: '0x235b870118c492e862670aec2b3b7e7a92915628'
  file: lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  lines:
  - 190
  - 193
  has: address signer = ecrecover(hash, v, r, s);
  says: the library calls the ecrecover precompile with no gas constant and treats a zero result as an invalid signature
  for:
  - justification
  - what
- id: setter
  source: '0x235b870118c492e862670aec2b3b7e7a92915628'
  file: src/LaunchFactory.sol
  lines:
  - 157
  - 161
  has: priceSigner = signer;
  says: setPriceSigner stores a new price signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: setteronly
  source: '0x235b870118c492e862670aec2b3b7e7a92915628'
  file: src/LaunchFactory.sol
  line: 157
  has: function setPriceSigner(address signer) external onlyOwner {
  says: only the owner can call setPriceSigner
  for:
  - action
  - evidence-2
  - justification
  - what
- id: owner
  call: '0x235b870118c492e862670aec2b3b7e7a92915628'
  fn: owner()(address)
  is: '0x6a684c214dd48a163a3025be50718419062e144a'
  says: the owner that can replace the price signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: ownercode
  code: '0x6a684c214dd48a163a3025be50718419062e144a'
  is: empty
  says: the owner is an account without code
  for:
  - evidence-2
  - justification
- id: ownernonce
  nonce: '0x6a684c214dd48a163a3025be50718419062e144a'
  is: 62
  says: the owner has sent 62 transactions, so it is a key in use
  for:
  - notes
- id: signer
  call: '0x235b870118c492e862670aec2b3b7e7a92915628'
  fn: priceSigner()(address)
  is: '0x038c66bda2e892559295599c32d2c5831a448385'
  says: the price signer stored at the block
  for:
  - evidence-3
- id: signercode
  code: '0x038c66bda2e892559295599c32d2c5831a448385'
  is: empty
  says: the price signer is an account without code
  for:
  - evidence-3
- id: rotated
  call: '0x235b870118c492e862670aec2b3b7e7a92915628'
  fn: priceSigner()(address)
  at: 25931034
  is: '0x77b25ace2eb0bdc7b4dbb064a79ced4d9b6ef62c'
  says: one block before the replacement the stored price signer was another address
  for:
  - evidence-2
- id: paused
  call: '0x235b870118c492e862670aec2b3b7e7a92915628'
  fn: paused()(bool)
  is: false
  says: launches are not paused
  for:
  - evidence-3
- id: quote
  call: '0x235b870118c492e862670aec2b3b7e7a92915628'
  fn: quotes(address)(bool,uint8,string)
  args:
  - '0x95ad61b0a150d79219dcf64e1e6cc01f0b64c4ce'
  is:
  - true
  - 18
  - SHIB
  says: at least one quote asset is enabled, so a launch can pass the quote check
  for:
  - notes
- id: hookfactory
  call: '0x01b565f243f45f86fb4332868de6978d456d28cc'
  fn: factory()(address)
  is: '0x235b870118c492e862670aec2b3b7e7a92915628'
  says: the hook this factory uses names this factory
  for:
  - notes
- id: hook
  call: '0x235b870118c492e862670aec2b3b7e7a92915628'
  fn: hook()(address)
  is: '0x01b565f243f45f86fb4332868de6978d456d28cc'
  says: the hook is set
  for:
  - notes
- id: launches
  call: '0x235b870118c492e862670aec2b3b7e7a92915628'
  fn: launchCount()(uint256)
  is: 1
  says: one launch has been created here
  for:
  - notes
- id: launchtx
  tx: '0x4731871b9a50c5f3b59a74e4eb48de60b3b42a8c12e9bfb8a49dbd6c6918bb4b'
  to: '0x235b870118c492e862670aec2b3b7e7a92915628'
  ok: true
  says: the one launch, a successful call to this factory
  for:
  - notes
- id: domain
  source: '0x235b870118c492e862670aec2b3b7e7a92915628'
  file: src/LaunchFactory.sol
  line: 111
  has: EIP712("StockpadLaunchFactory", "1")
  says: the source names the signing domain StockpadLaunchFactory
  for:
  - notes
- id: signernonce
  nonce: '0x038c66bda2e892559295599c32d2c5831a448385'
  is: 379
  says: the price signer's account has sent 379 transactions
  for:
  - notes
- id: pending
  call: '0x235b870118c492e862670aec2b3b7e7a92915628'
  fn: pendingOwner()(address)
  is: '0x0000000000000000000000000000000000000000'
  says: no ownership transfer is pending
  for:
  - notes
- id: domainlive
  call: '0x235b870118c492e862670aec2b3b7e7a92915628'
  fn: eip712Domain()(bytes1,string,string,uint256,address,bytes32,uint256[])
  is:
  - '0x0f'
  - StockpadLaunchFactory
  - '1'
  - 1
  - '0x235b870118c492e862670aec2b3b7e7a92915628'
  - '0x0000000000000000000000000000000000000000000000000000000000000000'
  - []
  says: the deployed code reports the signing domain named in the source
  for:
  - notes
- id: rotatedafter
  call: '0x235b870118c492e862670aec2b3b7e7a92915628'
  fn: priceSigner()(address)
  at: 25931035
  is: '0x038c66bda2e892559295599c32d2c5831a448385'
  says: from block 25,931,035 the stored price signer is the current one
  for:
  - evidence-2
- id: rotatetx
  tx: '0xc5733be31f5a0f21c83b40fa59f15076ac6124e2279fe035dbf4c39de8d7026f'
  to: '0x235b870118c492e862670aec2b3b7e7a92915628'
  ok: true
  says: the transaction in block 25,931,035 that replaced the price signer, a successful call to this factory
  for:
  - evidence-2
- id: quote-aaplon
  call: '0x235b870118c492e862670aec2b3b7e7a92915628'
  fn: quotes(address)(bool,uint8,string)
  args:
  - '0x14c3abf95cb9c93a8b82c1cdcb76d72cb87b2d4c'
  is:
  - true
  - 18
  - AAPLon
  says: the AAPLon quote asset is enabled
  for:
  - notes
- id: quote-spyon
  call: '0x235b870118c492e862670aec2b3b7e7a92915628'
  fn: quotes(address)(bool,uint8,string)
  args:
  - '0xfedc5f4a6c38211c1338aa411018dfaf26612c08'
  is:
  - true
  - 18
  - SPYon
  says: the SPYon quote asset is enabled
  for:
  - notes
- id: quote-tslaon
  call: '0x235b870118c492e862670aec2b3b7e7a92915628'
  fn: quotes(address)(bool,uint8,string)
  args:
  - '0xf6b1117ec07684d3958cad8beb1b302bfd21103f'
  is:
  - true
  - 18
  - TSLAon
  says: the TSLAon quote asset is enabled
  for:
  - notes
- id: quote-spcxon
  call: '0x235b870118c492e862670aec2b3b7e7a92915628'
  fn: quotes(address)(bool,uint8,string)
  args:
  - '0xc9eef266834730340a55b6cc24621b31baf55581'
  is:
  - true
  - 18
  - SPCXon
  says: the SPCXon quote asset is enabled
  for:
  - notes
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews:
- who: r-235b8701, the row's refuter
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: Wording pass (''real code''); a fresh refuter agrees on every part; Claude read the changed sentences.
    Kept as before (LaunchFactory). The refuter first cited replay runs this dossier does not have; the tool refused
    them and it withdrew them.'
related: []
---

## What happens

This factory launches a new token only when its stored price signer has signed the quote asset's price with ECDSA. If that signer's account moves to real code, new launches revert until the owner sets a new signer.

## Evidence

- The [verified source](https://etherscan.io/address/0x235b870118c492e862670aec2b3b7e7a92915628#code) recovers the price signature with ECDSA and reverts unless it comes from the stored price signer; both launch functions run this check.
- The [owner](https://etherscan.io/address/0x6a684c214dd48a163a3025be50718419062e144a), an account without code, can replace the signer with setPriceSigner; an [earlier call](https://etherscan.io/tx/0xc5733be31f5a0f21c83b40fa59f15076ac6124e2279fe035dbf4c39de8d7026f) already replaced it.
- The current [price signer](https://etherscan.io/address/0x038c66bda2e892559295599c32d2c5831a448385) is an account without code, and launches are not paused.

## Reviewer notes

### Mechanism

createLaunch (LaunchFactory.sol line 195) and createLaunchAndBuy (line 212) both call _create, which reverts when paused or when the quote is not enabled, then calls _verifyPrice (line 229) before it deploys the token (line 233). _verifyPrice (lines 270-276) hashes (quote, usdPrice, deadline) under the EIP-712 domain StockpadLaunchFactory and requires ECDSA.recover(digest, signature) == priceSigner. OpenZeppelin's ECDSA calls the precompile with no gas constant and reverts on a zero result (ECDSA.sol lines 190-193). The signed price sets the pool's opening price. priceSigner is written only by the constructor (line 116) and by setPriceSigner (line 159, onlyOwner, refuses zero). At the block: priceSigner 0x038c...8385 has no code (nonce 379); owner 0x6a68...144a has no code (nonce 62), pendingOwner is zero; paused is false; the hook is set and its factory() is this address; launchCount is 1. That launch (block 25,927,941) carries a signature that recovers to 0x77b2...f62c, the first signer, also the sender and the treasury. Tx 0xc573...026f (block 25,931,035) emitted PriceSignerSet and installed the current signer. The factory holds nothing: the fee goes to the treasury in the same call (line 260) and creationFee is 0, so whose is left empty. Project left empty: the source names only the signing domain (line 111), and more than one launchpad uses the name Stockpad.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 path for a signer with code: none. Line 275 is the only signature check in LaunchFactory.sol; LaunchHook.sol, LaunchToken.sol and FeeEscrow.sol contain no recovery.
- Ruled out: a launch without the signature: createLaunch and createLaunchAndBuy are the only entries and both reach _verifyPrice (lines 195, 212, 229).
- Ruled out: an unset key or a key with code: priceSigner() is 0x038c...8385, code empty, nonce 379.
- Ruled out: a setter nobody can call: the owner has no code and nonce 62; priceSigner() changed from 0x77b2... to 0x038c... in block 25,931,035, and only setPriceSigner writes it after deployment.
- Ruled out: a path closed for good: paused() is false, hook() is set, and five quotes are enabled (SHIB, AAPLon, SPYon, TSLAon, SPCXon).
- Ruled out: a signature checked again later: it is checked once, inside the launch call, and is not stored.
- Ruled out: other code at this address: not a proxy, verified as LaunchFactory, own state (launchCount 1); eip712Domain() returns the source's name.
- Ruled out: a fixed gas amount: none (ECDSA.sol line 190).
- Ruled out: outside the checks: Sourcify lists the hook as verified with a LaunchHook.sol identical to the bundled one; Blockscout's 13 logs for this address show one PriceSignerSet and no QuoteDisabled.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
