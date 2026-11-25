---
id: nativerfqpool-9af2f3c0-rfq-signer
format: 2
title: Native RFQ pool trusts ECDSA market-maker quotes a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Quote checks are ECDSA-only; the owner can rotate signers but not the scheme, so Native must deploy
  new pools.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x9af2f3c0cd35283e13f7087e2b34b1444b57a44c'
  name: NativeRFQPool
  project: native
  code: verified
  code_url: https://etherscan.io/address/0x9af2f3c0cd35283e13f7087e2b34b1444b57a44c#code
  copies: 1
  upgradeable: 'no'
  admin: '0x83fc28e6962e41e38f7854308eff827e3f6b906b'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a pool that verifies market-maker quotes with a post-quantum scheme and whitelist it in place of
  this one.
evidence_level: source
checks:
- id: c1
  source: '0x9af2f3c0cd35283e13f7087e2b34b1444b57a44c'
  file: lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: ECDSA recovery uses the ecrecover precompile.
  for:
  - what
- id: c2
  source: '0x9af2f3c0cd35283e13f7087e2b34b1444b57a44c'
  file: src/NativeRFQPool.sol
  line: 233
  has: require(quote.signer == ECDSA.recover(digest, quote.signature), ErrorsLib.InvalidSignature());
  says: Quote acceptance requires the ECDSA-recovered address to be the quote signer.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c5
  source: '0x9af2f3c0cd35283e13f7087e2b34b1444b57a44c'
  file: src/NativeRFQPool.sol
  line: 167
  has: function setSigner(address signer, bool isSigner) external onlyOwner {
  says: The owner can only add or remove signer addresses.
  for:
  - action
  - evidence-3
  - justification
- id: router-only
  source: '0x9af2f3c0cd35283e13f7087e2b34b1444b57a44c'
  file: src/NativeRFQPool.sol
  has: require(msg.sender == router, ErrorsLib.OnlyNativeRouter());
  line: 85
  says: Only the router can call tradeRFQT.
  for:
  - what
- id: pay
  source: '0x9af2f3c0cd35283e13f7087e2b34b1444b57a44c'
  file: src/NativeRFQPool.sol
  has: IERC20(token).safeTransferFrom(treasury, receiver, value);
  line: 207
  says: The pool pays the recipient from the treasury.
  for:
  - evidence-2
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review17 (Sourcify source, on-chain and Blockscout reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This pool executes router-sent RFQ trades and pays the taker from its treasury once a whitelisted market maker's ECDSA quote signature checks out. A quantum attacker with a recovered market-maker key could forge quotes that move treasury tokens.

## Evidence

- [_verifyPMMSignature](https://etherscan.io/address/0x9af2f3c0cd35283e13f7087e2b34b1444b57a44c#code) requires quote.signer to equal the ECDSA-recovered address.
- [_transferFromTreasury](https://etherscan.io/address/0x9af2f3c0cd35283e13f7087e2b34b1444b57a44c#code) sends buyer tokens from the treasury to the quote recipient.
- [setSigner](https://etherscan.io/address/0x9af2f3c0cd35283e13f7087e2b34b1444b57a44c#code) lets the owner add or remove signer addresses, not change the scheme.

## Reviewer notes

### Mechanism

NativeRFQPool.tradeRFQT (line 84) requires msg.sender == router (line 85), marks the nonce used, then calls _verifyPMMSignature (line 101). That function checks rfqSigners[quote.signer] (line 212), builds an EIP-712 digest and requires quote.signer == ECDSA.recover(digest, quote.signature) (line 233), which calls ecrecover (ECDSA.sol line 139). _transferAndCallback then calls CreditVault.swapCallback if isCreditPool and _transferFromTreasury does safeTransferFrom(treasury, receiver, value) (line 207). The owner can only toggle signers via setSigner (line 167) or setTreasury; the contract is not upgradeable. A trade also needs the router's own ECDSA signer check.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: This pool holds about $0 and had no calls in the 30-day window; kev's census reports it is not a credit pool and has zero vault allowance.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
