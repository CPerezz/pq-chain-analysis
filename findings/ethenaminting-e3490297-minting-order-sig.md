---
id: ethenaminting-e3490297-minting-order-sig
format: 2
title: EthenaMinting takes ECDSA orders quantum attackers could forge for benefactors
status: confirmed
severity: MEDIUM
justification: Benefactor funds stay forgeable via the ECDSA branch; MEDIUM as Ethena can deploy a new minter without
  it.
category: quantum-exposure
pattern: PQ-2
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe3490297a08d6fc8da46edb7b6142e4f461b62d3'
  name: EthenaMinting
  project: ethena
  code: verified
  code_url: https://etherscan.io/address/0xe3490297a08d6fc8da46edb7b6142e4f461b62d3#code
  copies: 1
  upgradeable: 'no'
  admin: '0xe8dc0fab349ea169283c48ccfd09d797e6db7c94'
value:
  usd: 67770702
  basis: held
activity:
  txs_90d: 6496
impact: funds-loss
action: Deploy a minting contract without the EIP712 ECDSA branch and have the timelock point USDe's minter at it.
evidence_level: source
checks:
- id: c1
  source: '0xe3490297a08d6fc8da46edb7b6142e4f461b62d3'
  file: contracts/EthenaMinting.sol
  line: 504
  has: address signer = ECDSA.recover(taker_order_hash, signature.signature_bytes);
  says: The EIP712 branch recovers the order signer with ECDSA.recover.
  for:
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xe3490297a08d6fc8da46edb7b6142e4f461b62d3'
  file: lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: ECDSA.tryRecover calls the ecrecover precompile.
  for:
  - evidence-3
- id: sel-branch
  source: '0xe3490297a08d6fc8da46edb7b6142e4f461b62d3'
  file: contracts/EthenaMinting.sol
  has: if (signature.signature_type == SignatureType.EIP712) {
  line: 503
  says: The signature type in the order selects the ECDSA branch.
  for:
  - action
  - evidence-1
  - justification
- id: c-deleg
  source: '0xe3490297a08d6fc8da46edb7b6142e4f461b62d3'
  file: contracts/EthenaMinting.sol
  has: signer == order.benefactor || delegatedSigner[signer][order.benefactor] == DelegatedSignerStatus.ACCEPTED
  line: 505
  says: The recovered signer must be the benefactor or its accepted delegate.
  for:
  - evidence-2
  - what
- id: wl
  source: '0xe3490297a08d6fc8da46edb7b6142e4f461b62d3'
  file: contracts/EthenaMinting.sol
  has: if (!_whitelistedBenefactors.contains(order.benefactor)) {
  line: 518
  says: Only whitelisted benefactors' orders pass.
  for:
  - what
- id: c-benef
  source: '0xe3490297a08d6fc8da46edb7b6142e4f461b62d3'
  file: contracts/EthenaMinting.sol
  has: if (!_approvedBeneficiariesPerBenefactor[order.benefactor].contains(order.beneficiary)) {
  line: 522
  says: A beneficiary other than the benefactor must be approved by the benefactor.
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
  who: Review10 (source and on-chain review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (the study family's recovery functions read, a real transaction replayed four ways; not reviewed by
    a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: confirmed
  rating: ''
  pattern: PQ-2
reviews: []
related: []
---

## What happens

EthenaMinting executes signed USDe mint and redeem orders for whitelisted benefactors. EIP712 orders pass if ECDSA recovers the benefactor or a delegate it accepted. A quantum attacker with such a key can sign orders moving that benefactor's collateral or USDe.

## Evidence

- [verifyOrder](https://etherscan.io/address/0xe3490297a08d6fc8da46edb7b6142e4f461b62d3#code) takes the EIP712 branch when the signature type says so and recovers the signer with ECDSA.
- [verifyOrder](https://etherscan.io/address/0xe3490297a08d6fc8da46edb7b6142e4f461b62d3#code) accepts the recovered signer if it is the benefactor or a delegated signer marked ACCEPTED.
- [ECDSA.tryRecover](https://etherscan.io/address/0xe3490297a08d6fc8da46edb7b6142e4f461b62d3#code) calls the ecrecover precompile.

## Reviewer notes

### Mechanism

mint (onlyRole MINTER_ROLE) and redeem (onlyRole REDEEMER_ROLE) call verifyOrder (L496-535). At L503 the caller-supplied signature_type selects EIP712, which runs ECDSA.recover (L504, ecrecover at ECDSA.sol L139). L505 accepts a signer equal to order.benefactor or with delegatedSigner[signer][benefactor] == ACCEPTED. The EIP1271 branch (L509-514) is the alternative, but the signer picks the branch, so a benefactor that migrates to post-quantum authorisation at the same address stays forgeable with its old ECDSA key. L518 requires the benefactor to be whitelisted and L521-525 restrict beneficiaries to the benefactor's approved list. A valid order pulls the benefactor's collateral on mint or burns its USDe on redeem.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract's own collateral cannot be sent to the attacker: beneficiaries must be the benefactor or approved by it.
- Ruled out: Orders run only when submitted by MINTER_ROLE or REDEEMER_ROLE holders.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
