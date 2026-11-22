---
id: creditvault-e3d41d19-rfq-signer
format: 2
title: Native CreditVault trusts an ECDSA signer a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Vault payouts rest on one ECDSA signer key; the owner can rotate it but only a new vault deployment
  fixes it.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe3d41d19564922c9952f692c5dd0563030f5f2ef'
  name: CreditVault
  project: native
  code: verified
  code_url: https://etherscan.io/address/0xe3d41d19564922c9952f692c5dd0563030f5f2ef#code
  copies: 1
  upgradeable: 'no'
  admin: '0x9b9dc7c56e18cfda57d402ca7ded491b1544dc56'
value:
  usd: 6756809
  basis: held
activity:
  txs_90d: 207649
impact: funds-loss
action: Deploy a vault whose settle, collateral and liquidation approvals verify post-quantum signatures, then move
  funds to it.
evidence_level: source
checks:
- id: c1
  source: '0xe3d41d19564922c9952f692c5dd0563030f5f2ef'
  file: src/CreditVault.sol
  line: 561
  has: address recoveredSigner = ECDSA.recover(digest, signature);
  says: Settlement approval recovers the ECDSA signer of the digest.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xe3d41d19564922c9952f692c5dd0563030f5f2ef'
  file: src/CreditVault.sol
  line: 585
  has: address recoveredSigner = ECDSA.recover(digest, signature);
  says: Collateral removal approval recovers the ECDSA signer.
  for:
  - evidence-2
  - what
- id: c3
  source: '0xe3d41d19564922c9952f692c5dd0563030f5f2ef'
  file: src/CreditVault.sol
  line: 610
  has: address recoveredSigner = ECDSA.recover(digest, signature);
  says: Liquidation approval recovers the ECDSA signer.
  for:
  - evidence-2
  - what
- id: c4
  source: '0xe3d41d19564922c9952f692c5dd0563030f5f2ef'
  file: lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: Recovery uses the secp256k1 ecrecover precompile.
  for:
  - what
- id: c5
  source: '0xe3d41d19564922c9952f692c5dd0563030f5f2ef'
  file: src/CreditVault.sol
  line: 459
  has: function setSigner(address _signer) external onlyOwner {
  says: Owner can change the signer address only.
  for:
  - action
  - evidence-3
  - justification
- id: lib-mod
  source: '0xe3d41d19564922c9952f692c5dd0563030f5f2ef'
  file: src/CreditVault.sol
  has: (traders[trader] && trader == msg.sender)
  line: 622
  says: Settlement callers must be a whitelisted trader or its settler.
  for:
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

The CreditVault holds Native's RFQ liquidity and pays out settlements, collateral removals and liquidations when an ECDSA signature recovers to its signer. A quantum attacker who derives the signer key and holds a whitelisted trader or liquidator key can approve payouts of vault tokens.

## Evidence

- [_verifySettleSignature](https://etherscan.io/address/0xe3d41d19564922c9952f692c5dd0563030f5f2ef#code) requires ECDSA.recover of the digest to equal signer.
- [Collateral removal and liquidation checks](https://etherscan.io/address/0xe3d41d19564922c9952f692c5dd0563030f5f2ef#code) use the same ECDSA recovery against signer.
- [setSigner](https://etherscan.io/address/0xe3d41d19564922c9952f692c5dd0563030f5f2ef#code) lets the owner replace the signer address but not the signature scheme.

## Reviewer notes

### Mechanism

settle, removeCollateral and liquidate call _verifySettleSignature (line 561), _verifyRemoveCollateralSignature (585) and _verifyLiquidationSignature (610). Each builds an EIP-712 digest including the owner-set recipient and requires ECDSA.recover(digest, signature) == signer; ECDSA.recover calls ecrecover (ECDSA.sol 139). Callers must pass onlyTraderOrSettler (lines 620-627) or onlyLiquidator (629-632), so a forged signer approval also needs a whitelisted trader, settler or liquidator key. Per-trader daily rebalance caps (_updateRebalanceCap, 523-540) limit withdrawals where a limit is set. The owner can rotate the signer via setSigner (459) but the scheme stays ECDSA; the contract is not a proxy.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable: no proxy, so the verification code cannot be swapped in place.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
