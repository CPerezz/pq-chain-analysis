---
id: nativerfqpool-c419e673-rfq-signer
format: 2
title: Native RFQ pool accepts ECDSA market-maker quotes a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Quote checks are ECDSA in a non-upgradeable pool; the owner can only rotate signers, so the fix is
  a new deployment.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc419e67388df0c0cfad15584fc5fc7e67a234c17'
  name: NativeRFQPool
  project: native
  code: verified
  code_url: https://etherscan.io/address/0xc419e67388df0c0cfad15584fc5fc7e67a234c17#code
  copies: 1
  upgradeable: 'no'
  admin: '0x83fc28e6962e41e38f7854308eff827e3f6b906b'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 100857
impact: funds-loss
action: Deploy a pool whose quote checks use a post-quantum scheme and move the vault's credit pool and allowances
  to it.
evidence_level: source
checks:
- id: c1
  source: '0xc419e67388df0c0cfad15584fc5fc7e67a234c17'
  file: src/NativeRFQPool.sol
  line: 235
  has: require(quote.signer == ECDSA.recover(digest, quote.signature), ErrorsLib.InvalidSignature());
  says: The quote signature is checked by ECDSA recovery against quote.signer.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xc419e67388df0c0cfad15584fc5fc7e67a234c17'
  file: lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: ECDSA.recover uses the ecrecover precompile.
  for:
  - evidence-1
- id: c3
  source: '0xc419e67388df0c0cfad15584fc5fc7e67a234c17'
  file: src/NativeRFQPool.sol
  line: 168
  has: function setSigner(address signer, bool isSigner) external onlyOwner {
  says: The owner can add or remove quote signers.
  for:
  - action
  - evidence-3
  - justification
- id: s-router
  source: '0xc419e67388df0c0cfad15584fc5fc7e67a234c17'
  file: src/NativeRFQPool.sol
  has: require(msg.sender == router, ErrorsLib.OnlyNativeRouter());
  line: 87
  says: Only the router can call tradeRFQT.
  for:
  - what
- id: s-wl
  source: '0xc419e67388df0c0cfad15584fc5fc7e67a234c17'
  file: src/NativeRFQPool.sol
  has: require(rfqSigners[quote.signer], ErrorsLib.InvalidSigner());
  line: 213
  says: The quote signer must be whitelisted.
  for:
  - what
- id: s-pay
  source: '0xc419e67388df0c0cfad15584fc5fc7e67a234c17'
  file: src/NativeRFQPool.sol
  has: IERC20(token).safeTransferFrom(treasury, receiver, value);
  line: 208
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
- study: eip-8151-impact
  who: Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not
    reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

This pool executes router-forwarded RFQ trades and pays the taker from its treasury. It accepts a quote if ECDSA recovers its whitelisted signer from the signature. A quantum attacker with a market-maker key and the router signer key can pay treasury tokens to any recipient.

## Evidence

- [_verifyPMMSignature](https://etherscan.io/address/0xc419e67388df0c0cfad15584fc5fc7e67a234c17#code) requires quote.signer to equal ECDSA.recover of the quote signature.
- [_transferFromTreasury](https://etherscan.io/address/0xc419e67388df0c0cfad15584fc5fc7e67a234c17#code) moves the buyer token from the treasury to the quote's recipient.
- [setSigner](https://etherscan.io/address/0xc419e67388df0c0cfad15584fc5fc7e67a234c17#code) lets the owner add or remove signers but not change the signature scheme.

## Reviewer notes

### Mechanism

NativeRouter calls tradeRFQT (line 86, msg.sender == router at line 87). After the nonce check, _verifyPMMSignature (lines 212-236) requires rfqSigners[quote.signer] (line 213) and quote.signer == ECDSA.recover(digest, quote.signature) (line 235), which uses ecrecover (ECDSA.sol line 139). If isCreditPool, _transferAndCallback calls CreditVault.swapCallback (line 189), then _transferFromTreasury does safeTransferFrom(treasury, receiver, value) (line 208). treasury is the CreditVault, which per kev grants this pool an unlimited allowance. The owner can only rotate signers via setSigner (line 168); the contract is not a proxy.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The pool holds about no funds itself; exposure is the treasury's allowance.
- Ruled out: A forged pool quote alone does not suffice; the router's signer check must also pass.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
