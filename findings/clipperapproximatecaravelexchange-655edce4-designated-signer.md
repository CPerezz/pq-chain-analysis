---
id: clipperapproximatecaravelexchange-655edce4-designated-signer
format: 2
title: Clipper Caravel pool trusts a fixed ECDSA key that quantum attackers forge
status: confirmed
severity: MEDIUM
justification: 'Signer is immutable, so Clipper must deploy a new exchange and LPs must move: one team''s release,
  MEDIUM.'
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x655edce464cc797526600a462a8154650eee4b77'
  name: ClipperApproximateCaravelExchange
  project: clipper
  code: verified
  code_url: https://etherscan.io/address/0x655edce464cc797526600a462a8154650eee4b77#code
  copies: 1
  upgradeable: 'no'
  admin: '0xd8cc0304de58fce5147796606db14500d94b5ef2'
value:
  usd: 342139
  basis: held
activity:
  txs_90d: 17
impact: funds-loss
action: Deploy a new exchange whose quote check verifies a post-quantum signature, and have LPs move via burnToWithdraw.
evidence_level: source
checks:
- id: c1
  source: '0x655edce464cc797526600a462a8154650eee4b77'
  file: contracts/ClipperCommonExchange.sol
  line: 362
  has: address signingAddress = ECDSA.recover(theDigest, theSignature.v, theSignature.r, theSignature.s);
  says: verifyDigestSignature recovers the quote signer with ECDSA.
  for:
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x655edce464cc797526600a462a8154650eee4b77'
  file: contracts/ClipperCommonExchange.sol
  line: 366
  has: signingAddress = ECDSA.recover(keccak256(abi.encodePacked(theDigest, tx.origin)), theSignature.v, theSignature.r,
    theSignature.s);
  says: A second ECDSA recovery accepts digests bound to tx.origin.
  for:
  - what
- id: s-immut
  source: '0x655edce464cc797526600a462a8154650eee4b77'
  file: contracts/ClipperCommonExchange.sol
  has: address immutable public DESIGNATED_SIGNER;
  line: 37
  says: The signer address is immutable.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: s-ctor
  source: '0x655edce464cc797526600a462a8154650eee4b77'
  file: contracts/ClipperCommonExchange.sol
  has: DESIGNATED_SIGNER = theSigner;
  line: 117
  says: The signer is set once in the constructor.
  for:
  - evidence-2
  - justification
- id: s-cmp
  source: '0x655edce464cc797526600a462a8154650eee4b77'
  file: contracts/ClipperCommonExchange.sol
  has: revert ClipperDataValidation();
  line: 368
  says: A signature not recovering to the signer reverts.
  for:
  - evidence-1
  - what
- id: s-mint
  source: '0x655edce464cc797526600a462a8154650eee4b77'
  file: contracts/ClipperCommonExchange.sol
  has: _mint(sender, poolTokens);
  line: 207
  says: Deposits mint the pool token amount given in the signed quote.
  for:
  - what
- id: s-burn
  source: '0x655edce464cc797526600a462a8154650eee4b77'
  file: contracts/ClipperCommonExchange.sol
  has: function burnToWithdraw(uint256 amount) external {
  line: 261
  says: Pool token holders withdraw without a signature.
  for:
  - action
  - evidence-3
  - what
- id: s-prop
  source: '0x655edce464cc797526600a462a8154650eee4b77'
  file: contracts/ClipperCommonExchange.sol
  has: toTransfer = (myFraction*getLastBalance(theToken)) / ONE_IN_TEN_DECIMALS;
  line: 254
  says: Withdrawals pay each pool asset pro rata.
  for:
  - evidence-3
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: review (Review04)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

The exchange accepts deposits, single-asset withdrawals and swaps only with an ECDSA quote signature that recovers to DESIGNATED_SIGNER, a key fixed at deployment. A quantum attacker who recovers that key signs a deposit minting pool tokens for nothing, then withdraws the pool.

## Evidence

- [verifyDigestSignature](https://etherscan.io/address/0x655edce464cc797526600a462a8154650eee4b77#code) reverts unless ECDSA recovers DESIGNATED_SIGNER.
- [DESIGNATED_SIGNER](https://etherscan.io/address/0x655edce464cc797526600a462a8154650eee4b77#code) is immutable and set once in the constructor.
- [burnToWithdraw](https://etherscan.io/address/0x655edce464cc797526600a462a8154650eee4b77#code) pays out pool assets pro rata to burned pool tokens.

## Reviewer notes

### Mechanism

ClipperCommonExchange.verifyDigestSignature (lines 361-371) calls ECDSA.recover on the EIP-712 digest (line 362). If the result is not DESIGNATED_SIGNER, it calls ECDSA.recover on keccak256(digest, tx.origin) (line 366). If that also fails, it reverts with ClipperDataValidation (line 368). There is no ERC-1271 path. DESIGNATED_SIGNER is immutable (line 37) and set in the constructor (line 117), with no setter. Deposit digests bind poolTokens (hashDeposit, hashSingleDeposit), so a forged signature lets _mintOrVesting mint arbitrary pool tokens (line 207). burnToWithdraw (line 261) then pays each asset pro rata via _proportionalWithdrawal (line 254). Withdrawal and swap digests likewise fix asset and output amounts chosen by the signer. The owner can only add assets, set the triage role and transfer ownership. The triage role can stop trading, which blocks the signed paths but not burnToWithdraw.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The pool token's ECDSA permit only moves LP token allowances; it is auxiliary to this finding.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
