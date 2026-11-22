---
id: predepositguarantee-f4bf42c6-predeposit-bls12-381
format: 2
title: Lido predeposits rely on BLS validator keys a quantum attacker can break
status: confirmed
severity: MEDIUM
justification: 'BLS keys are quantum-breakable; Lido DAO can fix it only by upgrading the verifier once validators
  get PQ keys: MEDIUM.'
category: quantum-exposure
pattern: PQ-6
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xf4bf42c6d6a0e38825785048124dbad6c9eaaac3'
  name: PredepositGuarantee
  project: lido
  code: verified
  code_url: https://etherscan.io/address/0xe78717192c45736df0e4be55c0219ee7f9addd0d#code
  proxy_of: '0xe78717192c45736df0e4be55c0219ee7f9addd0d'
  copies: 1
  upgradeable: 'yes'
  admin: '0x3e40d73eb977dc6a537af587d48316fee66e9c8c'
value:
  usd: 5414
  basis: held
activity:
  txs_90d: 27
impact: funds-loss
action: Upgrade PredepositGuarantee to verify post-quantum validator signatures once the beacon chain adopts them.
evidence_level: source
checks:
- id: c1
  source: '0xe78717192c45736df0e4be55c0219ee7f9addd0d'
  file: contracts/0.8.25/vaults/predeposit_guarantee/CLProofVerifier.sol
  line: 160
  has: bytes32 leaf = BLS12_381.sha256Pair(BLS12_381.pubkeyRoot(_witness.pubkey), _withdrawalCredentials);
  says: withdrawal credentials are proven against the validator pubkey on the beacon chain
  for:
  - what
- id: c5
  source: '0xe78717192c45736df0e4be55c0219ee7f9addd0d'
  file: contracts/0.8.25/vaults/predeposit_guarantee/PredepositGuarantee.sol
  line: 275
  has: BLS12_381.verifyDepositMessage(
  says: verifyDepositMessage calls the BLS12-381 deposit signature check
  for:
  - action
  - evidence-2
  - justification
  - what
- id: pd-verify
  source: '0xe78717192c45736df0e4be55c0219ee7f9addd0d'
  file: contracts/0.8.25/vaults/predeposit_guarantee/PredepositGuarantee.sol
  has: verifyDepositMessage(_deposit, _depositsY[i], withdrawalCredentials);
  line: 438
  says: predeposit verifies each deposit's BLS signature
  for:
  - evidence-1
  - justification
  - what
- id: pd-lock
  source: '0xe78717192c45736df0e4be55c0219ee7f9addd0d'
  file: contracts/0.8.25/vaults/predeposit_guarantee/PredepositGuarantee.sol
  has: balance.locked += uint128(totalDepositAmount);
  line: 423
  says: predeposit locks the node operator's guarantee balance
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
  who: Review07 (registry review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

Before a stVault's 1 ETH predeposit it checks the validator's BLS signature and locks the operator's guarantee. A quantum attacker with the validator key can front-run it; the vault is then repaid from that guarantee.

## Evidence

- [predeposit](https://etherscan.io/address/0xe78717192c45736df0e4be55c0219ee7f9addd0d#code) checks each deposit's BLS signature before depositing.
- [verifyDepositMessage](https://etherscan.io/address/0xe78717192c45736df0e4be55c0219ee7f9addd0d#code) runs the BLS12-381 deposit-signature check.
- [predeposit](https://etherscan.io/address/0xe78717192c45736df0e4be55c0219ee7f9addd0d#code) locks the node operator's guarantee for each predeposit.

## Reviewer notes

### Mechanism

predeposit (PredepositGuarantee.sol line 397) requires msg.sender to be the node operator's depositor (line 406), locks PREDEPOSIT_AMOUNT per validator from the operator's guarantee (line 423) and calls verifyDepositMessage (line 438), which calls BLS12_381.verifyDepositMessage (line 275): a BLS12-381 pairing check of the deposit signature against the validator pubkey. If a CL proof later shows the validator has other withdrawal credentials (front-run), proveInvalidValidatorWC (line 563) pays the vault 1 ETH from the operator's locked guarantee (lines 590-602). A quantum attacker who derives the BLS secret key from the published pubkey can sign a first deposit with its own credentials and land it first.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Outsiders cannot call predeposit; only the operator's depositor can.
- Ruled out: Vault funds beyond the 1 ETH predeposit are sent only after withdrawal credentials are proven.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
