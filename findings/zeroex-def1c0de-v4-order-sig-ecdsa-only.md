---
id: zeroex-def1c0de-v4-order-sig-ecdsa-only
format: 2
title: 0x Exchange Proxy takes ECDSA order signatures a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged maker or taker signatures spend approvals; MEDIUM as the owner can replace the features via
  migrate.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xdef1c0ded9bec7f1a1670819833240f027b25eff'
  name: ZeroEx
  project: 0x
  code: verified
  code_url: https://etherscan.io/address/0xdef1c0ded9bec7f1a1670819833240f027b25eff#code
  copies: 1
  admin: '0x618f9c67ce7bf1a50afa1e7e0238422601b0ff6e'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 78
impact: funds-loss
action: Migrate order and meta-transaction features to ERC-1271 or ERC-7913 checks of the full signature, or roll
  them back.
evidence_level: source
checks:
- id: m-sig
  source: '0xdef1c0ded9bec7f1a1670819833240f027b25eff'
  file: /home/cluracan/code/0x-monorepo/contracts/zero-ex/contracts/src/features/Ownable.sol
  has: function migrate(address target, bytes calldata data, address newOwner)
  line: 97
  says: The proxy exposes a migrate function.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: m-onlyowner
  source: '0xdef1c0ded9bec7f1a1670819833240f027b25eff'
  file: /home/cluracan/code/0x-monorepo/contracts/zero-ex/contracts/src/features/Ownable.sol
  has: onlyOwner
  line: 100
  says: migrate is restricted to the owner.
  for:
  - evidence-1
  - justification
  - what
- id: m-delegate
  source: '0xdef1c0ded9bec7f1a1670819833240f027b25eff'
  file: /home/cluracan/code/0x-monorepo/contracts/zero-ex/contracts/src/features/Ownable.sol
  has: LibMigrate.delegatecallMigrateFunction(target, data);
  line: 111
  says: migrate delegatecalls the migrator in the proxy's context.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: owner-read
  source: '0xdef1c0ded9bec7f1a1670819833240f027b25eff'
  file: /home/cluracan/code/0x-monorepo/contracts/zero-ex/contracts/src/features/Ownable.sol
  has: return LibOwnableStorage.getStorage().owner;
  line: 122
  says: owner() returns the stored owner of the proxy.
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
  who: Review08 (verified feature sources and on-chain reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (study families read or judged, the registry text read; not executed; not reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: ''
  pattern: PQ-1
reviews: []
related: []
---

## What happens

The ZeroEx proxy has an owner who can run a migration that executes new code in the proxy's context, replacing the features it routes to.

## Evidence

- [migrate](https://etherscan.io/address/0xdef1c0ded9bec7f1a1670819833240f027b25eff#code) is restricted to the owner and delegatecalls a migrator contract.
- [owner](https://etherscan.io/address/0xdef1c0ded9bec7f1a1670819833240f027b25eff#code) returns the owner stored in the proxy, the account that can upgrade features.

## Reviewer notes

### Mechanism

The proxy's fallback routes selectors to feature implementations. Per kev's review of the features, which are not shown in these files: LibSignature.getSignerOfHash (lines 67-111) uses only ecrecover for EIP712/ETHSIGN on a fixed (type,v,r,s) struct. NativeOrdersSettlement._fillLimitOrderPrivate (396-400) and _fillRfqOrderPrivate (503-509) accept the order if the recovered signer is order.maker or a signer registered with registerAllowedOrderSigner. OtcOrdersFeature.fillTakerSignedOtcOrder recovers the taker. MetaTransactionsFeature recovers mtx.signer. A forged signature therefore spends the maker's or taker's approvals to the proxy. Fix path shown here: Ownable.migrate (line 97, onlyOwner) delegatecalls a migrator (line 111), so the 2-of-4 ZeroExGovernor owner can replace or roll back these features.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The proxy's own balance is dust and is not the exposure.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
