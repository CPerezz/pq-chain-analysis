---
id: aori-8635c874-order-sig-ecdsa-only
format: 2
title: Paused older Aori accepts ECDSA-only orders that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Order signatures are ECDSA-only in immutable logic; the fix is a new deployment, and the owner keeps
  it paused.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x8635c874b0fcb361fb9a2f5218852d4b7fc5ace3'
  name: Aori
  project: aori
  code: verified
  code_url: https://etherscan.io/address/0x8635c874b0fcb361fb9a2f5218852d4b7fc5ace3#code
  copies: 1
  upgradeable: 'no'
  admin: '0xb4afac168ca0cce40c5b4d4e8e49a1e18a630b40'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1
impact: funds-loss
action: Keep this deployment paused and move users to a version that checks ERC-1271 signatures for contract accounts.
evidence_level: source
checks:
- id: c1
  source: '0x8635c874b0fcb361fb9a2f5218852d4b7fc5ace3'
  file: contracts/AoriUtils.sol
  line: 59
  has: address recovered = ECDSA.recover(digest, signature);
  says: validateDeposit recovers the order signer with ECDSA.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x8635c874b0fcb361fb9a2f5218852d4b7fc5ace3'
  file: contracts/Aori.sol
  line: 116
  has: function pause() external onlyOwner {
  says: The owner can pause the contract.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c4
  source: '0x8635c874b0fcb361fb9a2f5218852d4b7fc5ace3'
  file: contracts/AoriUtils.sol
  has: require(recovered == order.offerer, "InvalidSignature");
  line: 60
  says: Deposit requires the ECDSA-recovered signer to equal the offerer.
  for:
  - evidence-1
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review13 (deployer trace, selector match against verified Aori, owner/pause reads; former finding unidentified-7dec965c-user-sig-ecdsa-only)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
- study: top-callers-classification
  who: Review23 (finding review)
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

This older Aori deployment takes ERC-20 order deposits and accepts the offerer's order signature only if ECDSA recovers the offerer. A quantum attacker who recovers a user's key could sign an order paying themselves and have a solver pull the user's approved tokens if the owner unpauses it.

## Evidence

- [validateDeposit](https://etherscan.io/address/0x8635c874b0fcb361fb9a2f5218852d4b7fc5ace3#code) recovers the signer with ECDSA and requires it to equal the order's offerer.
- [pause](https://etherscan.io/address/0x8635c874b0fcb361fb9a2f5218852d4b7fc5ace3#code) is owner-only and stops all contract operations.

## Reviewer notes

### Mechanism

Aori.deposit(Order, bytes signature) (onlySolver, whenNotPaused) calls AoriUtils.validateDeposit, which at line 59 does ECDSA.recover(digest, signature) and at line 60 requires recovered == order.offerer. There is no isValidSignature call and no account-code check. After validation the contract pulls order.inputAmount of order.inputToken from the offerer via safeTransferFrom. Recipient and outputAmount are signer-chosen, so a forged signature from a recovered secp256k1 key yields an order paying the attacker. This deployment is paused per kev's on-chain read, so deposits revert while paused. The owner can pause (line 116) and unpause (line 124); there is no upgrade path.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract holds about $0; exposure is users' leftover approvals, not measured.
- Ruled out: Paused at the time of the census, so not exploitable unless unpaused.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
