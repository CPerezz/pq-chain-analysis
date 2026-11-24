---
id: upgradeableuniswapv3investmentpackagevault-1355ef83-rotate-signer-before-migrating
format: 2
title: Investment vault stops settling if a settle signer's account takes real code
status: candidate
severity: INFORMATIONAL
justification: Breaks only if a settle signer moves its account to real code; the owner can replace that signer
  first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1355ef836463061a2933d0f7215c4c0ef4f671fc'
  name: UpgradeableUniswapV3InvestmentPackageVault
  code: verified
  code_url: https://etherscan.io/address/0x690b23e237be0f9e862998ad58f3d0c51c35b975#code
  proxy_of: '0x690b23e237be0f9e862998ad58f3d0c51c35b975'
  copies: 7
  family: b0b818c637f3ce11dfa01db5a7a52c48
  upgradeable: 'yes'
  admin: '0x28c0cedfbebffd2fcc96b13e929fc81abf290560'
value:
  usd: 0
  whose: users
  basis: held
activity: {}
impact: liveness
action: Replace a settle signer with setSettleSigner before that signer's account moves to real code.
evidence_level: source
checks:
- id: ecdsa
  source: '0x690b23e237be0f9e862998ad58f3d0c51c35b975'
  file: contracts/UpgradeableInvestmentPackageBase.sol
  line: 510
  has: address signer = ECDSA.recover(digest, signatures[i]);
  says: each signature is recovered with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: member
  source: '0x690b23e237be0f9e862998ad58f3d0c51c35b975'
  file: contracts/UpgradeableInvestmentPackageBase.sol
  line: 511
  has: require(settleSigners[signer], "invalid signer");
  says: the recovered address must be a stored settle signer
  for:
  - evidence-1
  - justification
  - what
- id: required
  source: '0x690b23e237be0f9e862998ad58f3d0c51c35b975'
  file: contracts/UpgradeableInvestmentPackageBase.sol
  line: 518
  has: require(validCount >= requiredSettleSignatures, "insufficient signatures");
  says: the distinct valid signers must reach the required number
  for:
  - evidence-1
  - what
- id: settle
  source: '0x690b23e237be0f9e862998ad58f3d0c51c35b975'
  file: contracts/UpgradeableInvestmentPackageBase.sol
  line: 308
  has: _verifySettleSignatures(
  says: settlePurchase checks the settle signatures before paying out
  for:
  - what
- id: refund
  source: '0x690b23e237be0f9e862998ad58f3d0c51c35b975'
  file: contracts/UpgradeableInvestmentPackageBase.sol
  line: 279
  has: _verifySignatures(getRefundDigest(refundId, buyer, totalPaid), signatures);
  says: refundPurchase checks the signers' signatures on the refund
  for:
  - what
  - whose
- id: refund-pay
  source: '0x690b23e237be0f9e862998ad58f3d0c51c35b975'
  file: contracts/UpgradeableInvestmentPackageBase.sol
  line: 281
  has: _transferUsdt(buyer, totalPaid);
  says: a refund pays the buyer's USDT back to the buyer
  for:
  - whose
- id: rotate
  source: '0x690b23e237be0f9e862998ad58f3d0c51c35b975'
  file: contracts/UpgradeableInvestmentPackageBase.sol
  lines:
  - 237
  - 240
  has: function setSettleSigner(address signer, bool allowed) external onlyOwner {
  says: the owner adds or removes a settle signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: owner
  call: '0x1355ef836463061a2933d0f7215c4c0ef4f671fc'
  fn: owner()(address)
  is: '0x28c0cedfbebffd2fcc96b13e929fc81abf290560'
  says: the owner that can replace settle signers
  for:
  - action
  - evidence-2
  - justification
  - what
- id: owner-code
  code: '0x28c0cedfbebffd2fcc96b13e929fc81abf290560'
  is: empty
  says: the owner is an account without code
  for:
  - action
  - evidence-2
  - justification
- id: count
  call: '0x1355ef836463061a2933d0f7215c4c0ef4f671fc'
  fn: settleSignerCount()(uint256)
  is: '3'
  says: three settle signers are stored
  for:
  - evidence-3
  - what
- id: reqd
  call: '0x1355ef836463061a2933d0f7215c4c0ef4f671fc'
  fn: requiredSettleSignatures()(uint8)
  is: '3'
  says: all three are required
  for:
  - evidence-3
  - what
- id: paused
  call: '0x1355ef836463061a2933d0f7215c4c0ef4f671fc'
  fn: paused()(bool)
  is: 'false'
  says: the vault is not paused
  for:
  - evidence-3
- id: held
  call: '0xdac17f958d2ee523a2206206994597c13d831ec7'
  fn: balanceOf(address)(uint256)
  args:
  - '0x1355ef836463061a2933d0f7215c4c0ef4f671fc'
  is: '0'
  says: the vault holds no USDT
  for:
  - evidence-3
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews:
- who: r-1355ef83, the row's refuter
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  note: 'agree: what-2 (minor, not blocking): ''until the owner replaces it'' omits that the owner could instead
    lower requiredSettleSignatures or upgrade; it would be more exact to say ''until the owner replaces it (or lowers
    the quorum)'''
- who: claude-main, the reader who settled the row
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: Author and refuter agree (47 checks). Sheet read by Claude. Investment vault proxy: settle and refund
    need all 3 of 3 stored settle signers; the owner (an EOA) can swap a signer first (add the new one before removing
    the old). For the wording pass: the owner could also lower the quorum (setRequiredSettleSignatures) or upgrade.
    Candidate: the three signers cannot be listed without logs.'
related: []
---

## What happens

Settling a purchase or refunding a buyer's USDT needs ECDSA signatures from all three of the vault's stored settle signers. If one signer moves its account to real code, its signature stops counting and both stop until the owner replaces it. An EIP-7702 delegation keeps working.

## Evidence

- The [verified source](https://etherscan.io/address/0x690b23e237be0f9e862998ad58f3d0c51c35b975#code) recovers each signature with ECDSA and accepts it only from a stored settle signer.
- The [owner](https://etherscan.io/address/0x28c0cedfbebffd2fcc96b13e929fc81abf290560), an account without code, can add or remove settle signers with setSettleSigner.
- The [vault](https://etherscan.io/address/0x1355ef836463061a2933d0f7215c4c0ef4f671fc) holds no USDT, is not paused, and needs 3 of its 3 settle signers.

## Reviewer notes

### Mechanism

The address is an ERC-1967 proxy to UpgradeableUniswapV3InvestmentPackageVault. settlePurchase (line 308) and refundPurchase (line 279), both callable by the sweep address alone, call _verifySignatures (lines 506-519): each signature goes through ECDSA.recover, the signer must be in the settleSigners mapping, duplicates are refused, and the count must reach requiredSettleSignatures. With 3 required and 3 stored, one signer with real code stops both paths. setSettleSigner and batchSetSettleSigners (lines 237-247, onlyOwner) change the set; removal reverts if the count would fall below the required number, so the owner adds the new signer before removing the old one, or lowers the requirement first (setRequiredSettleSignatures, line 249). The owner can also upgrade the implementation (_authorizeUpgrade, line 538). No function lets the owner move USDT out without signatures.

### Checks

- Header facts: this address alone, at block 26,438,999; 7 addresses run this code.
- Ruled out: an ERC-1271 or code-size path for signers with code: _verifySignatures has none (lines 506-519), and the source has no isValidSignature call.
- Ruled out: unused implementation: this address is the initialized proxy (owner 0x28c0…0560, 3 signers); the bare implementation 0x690b…b975 has owner zero and no signers.
- Ruled out: a fixed gas budget for the recovery: ECDSA.recover calls ecrecover through Solidity, with no constant gas, so the change does not break it by itself.
- Ruled out: a signature others relied on before it is checked: the signatures approve the settlement or refund at the moment the sweep address submits it.
- Ruled out: the six copies: each proxy reads the same owner, the same sweep address and 3 of 3 settle signers at the block; the implementation itself is uninitialized.
- Ruled out: a closed path: the vault is not paused and package 1 is enabled; the sweep address 0x6b6f…71ad is an account without code that has sent no transaction.

### Questions

- The three settle signer addresses are not read: they sit in a mapping and are known only from SettleSignerUpdated events or the initialization call, which this review could not read. If one of them already holds real code, the vault breaks at activation with nobody migrating, and this is a rated finding instead of a notice.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
