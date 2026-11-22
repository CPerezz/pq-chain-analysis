---
id: pmm-8d90113a-order-sig-ecdsa-first
format: 2
title: Tokenlon PMM accepts ECDSA order signatures a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: A recovered user key signs swaps pulling approved tokens; contract is immutable, the operator multisig
  can replace it.
category: quantum-exposure
pattern: PQ-2
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x8d90113a1e286a5ab3e496fbd1853f265e5913c6'
  name: PMM
  project: tokenlon
  code: verified
  code_url: https://etherscan.io/address/0x8d90113a1e286a5ab3e496fbd1853f265e5913c6#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 47509
  basis: held
activity:
  txs_90d: 8155
impact: funds-loss
action: Deploy a PMM that checks ERC-1271 with the full signature for addresses with code, then repoint UserProxy
  and deauthorize this one.
evidence_level: source
checks:
- id: c1
  source: '0x8d90113a1e286a5ab3e496fbd1853f265e5913c6'
  file: PMM.sol
  line: 1479
  has: return ecrecover(
  says: the user address is recovered with ecrecover
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x8d90113a1e286a5ab3e496fbd1853f265e5913c6'
  file: PMM.sol
  line: 1270
  has: function transferOwnership(address _newOperator) external onlyOperator {
  says: the operator role is transferable by the operator
  for:
  - justification
- id: settle
  source: '0x8d90113a1e286a5ab3e496fbd1853f265e5913c6'
  file: PMM.sol
  has: IERC20(makerAssetAddr).safeTransfer(receiver, settleAmount);
  line: 1471
  says: settlement pays the maker asset to the receiver
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
  who: Review02 (registry review)
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
reviews: []
related: []
---

## What happens

PMM fills a user's signed order, recovering the user from the signature with ecrecover and paying the output to a receiver taken from that signature. A quantum attacker who recovers a user's ECDSA key signs a fill that pulls the user's approved tokens and sends the proceeds to the attacker.

## Evidence

- [_ecrecoverAddress](https://etherscan.io/address/0x8d90113a1e286a5ab3e496fbd1853f265e5913c6#code) derives the user with ecrecover over the transaction hash and receiver.
- [_settle](https://etherscan.io/address/0x8d90113a1e286a5ab3e496fbd1853f265e5913c6#code) sends the maker asset to the receiver named in the signature.

## Reviewer notes

### Mechanism

UserProxy.toPMM forwards to PMM.fill, which runs _assertTransaction. That function sets user = _ecrecoverAddress(transactionHash, userSignature), with ecrecover at line 1479 over keccak256(transactionHash, receiver). It consults ERC-1271 on the fee-recipient only when the recovered address differs. decodeUserSignature limits the signature to 85/86 bytes, so the wallet path cannot carry a post-quantum signature. spender.spendFromUser(user, ...) then pulls the user's tokens approved to AllowanceTarget. _settle (line 1460) pays the receiver taken from the signature. The contract is not a proxy. Its operator can hand over the operator role (transferOwnership, line 1270) but cannot change verification.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract's own balance is fee residue, not what a forged signature releases.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
