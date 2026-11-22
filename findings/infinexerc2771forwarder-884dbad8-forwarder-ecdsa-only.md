---
id: infinexerc2771forwarder-884dbad8-forwarder-ecdsa-only
format: 2
title: Infinex forwarder relays ECDSA-signed requests a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forwarder is immutable and ECDSA-only; each account must rotate keys or drop it once Infinex ships
  post-quantum keys
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x884dbad85355edd71fac528fe613eb4cd1b4e3a9'
  name: InfinexERC2771Forwarder
  project: infinex
  code: verified
  code_url: https://etherscan.io/address/0x884dbad85355edd71fac528fe613eb4cd1b4e3a9#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1608
impact: funds-loss
action: Ship post-quantum account keys so each account can rotate its sudo and operation keys and remove this forwarder
evidence_level: source
checks:
- id: c1
  source: '0x884dbad85355edd71fac528fe613eb4cd1b4e3a9'
  file: src/forwarder/InfinexERC2771Forwarder.sol
  line: 229
  has: (address recovered, ECDSA.RecoverError err,) = _hashTypedDataV4(
  says: the request hash is built for recovery
  for:
  - evidence-1
- id: c2
  source: '0x884dbad85355edd71fac528fe613eb4cd1b4e3a9'
  file: src/forwarder/InfinexERC2771Forwarder.sol
  line: 241
  has: ).tryRecover(request.signature);
  says: the signer is recovered with ECDSA tryRecover
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c4
  source: '0x884dbad85355edd71fac528fe613eb4cd1b4e3a9'
  file: lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 142
  has: address signer = ecrecover(hash, v, r, s);
  says: recovery uses the ecrecover precompile
  for:
  - evidence-1
  - justification
  - what
- id: v219
  source: '0x884dbad85355edd71fac528fe613eb4cd1b4e3a9'
  file: src/forwarder/InfinexERC2771Forwarder.sol
  has: isValid && recovered == request.from
  line: 219
  says: a request is valid only if the recovered signer equals from
  for:
  - action
  - evidence-2
  - justification
  - what
- id: e285
  source: '0x884dbad85355edd71fac528fe613eb4cd1b4e3a9'
  file: src/forwarder/InfinexERC2771Forwarder.sol
  has: abi.encodePacked(request.data, request.from)
  line: 285
  says: from is appended to the call data (ERC-2771)
  for:
  - evidence-3
  - what
- id: e287
  source: '0x884dbad85355edd71fac528fe613eb4cd1b4e3a9'
  file: src/forwarder/InfinexERC2771Forwarder.sol
  has: 'request.to.call{ gas: request.gas, value: request.value }(data)'
  line: 287
  says: the forwarder calls the target with the request
  for:
  - evidence-3
  - justification
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
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

The forwarder relays signed requests to Infinex accounts and appends the request's from address as the caller. It accepts a request when ECDSA recovery of the signature returns from, so a quantum attacker who recovers an account key can act as that key.

## Evidence

- [_recoverForwardRequestSigner](https://etherscan.io/address/0x884dbad85355edd71fac528fe613eb4cd1b4e3a9#code) recovers the signer with ECDSA tryRecover.
- [_validate](https://etherscan.io/address/0x884dbad85355edd71fac528fe613eb4cd1b4e3a9#code) accepts a request when the recovered address equals from.
- [_execute](https://etherscan.io/address/0x884dbad85355edd71fac528fe613eb4cd1b4e3a9#code) calls the target with from appended to the data.

## Reviewer notes

### Mechanism

execute/executeBatch call _execute (line 261), which calls _validate (line 211). _validate calls _recoverForwardRequestSigner (lines 228-244): it hashes the EIP-712 ForwardRequest(from,to,value,gas,nonce,data) and calls tryRecover(request.signature) (line 241), which uses ecrecover (ECDSA.sol line 142). signerMatch requires recovered == request.from (line 219). On success, _execute marks the nonce and calls request.to with request.data plus from appended (lines 285-287), which ERC-2771 accounts treat as the caller. There is no ERC-1271 or other verification path, and no owner or upgrade function in the contract.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No owner, admin or upgrade function in the forwarder
- Ruled out: Forwarder holds no meaningful funds itself

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
