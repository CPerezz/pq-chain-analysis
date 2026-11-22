---
id: ethereummultifeedadapterwithoutroundsv3-d72a6ba4-data-signers
format: 2
title: RedStone price feeds accept node signatures a quantum attacker can forge
status: confirmed
severity: MEDIUM
justification: Forged node and updater keys push false prices to lenders; RedStone's Safe can fix it by upgrading
  the proxy.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd72a6ba4a87ddb33e801b3f1c7750b2d0911fc6c'
  name: EthereumMultiFeedAdapterWithoutRoundsV3
  project: redstone
  code: verified
  code_url: https://etherscan.io/address/0x0c6c73865429e1d87b7b817b95bb1f38f2136529#code
  proxy_of: '0x0c6c73865429e1d87b7b817b95bb1f38f2136529'
  copies: 1
  upgradeable: 'yes'
  admin: '0x8223a6271d1e0bda019ee55d545d7b86eff1f573'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 135328
impact: funds-loss
action: Upgrade the adapter to verify post-quantum node signatures and have RedStone's nodes sign with post-quantum
  keys.
evidence_level: source
checks:
- id: c1
  source: '0x0c6c73865429e1d87b7b817b95bb1f38f2136529'
  file: contracts/__C7/@redstone-finance/evm-connector/contracts/libs/SignatureLib.sol
  line: 27
  has: signerAddress = ecrecover(signedHash, v, r, s);
  says: the package signer comes from ecrecover
  for:
  - action
  - evidence-1
  - justification
  - what
- id: v3-gate
  source: '0x0c6c73865429e1d87b7b817b95bb1f38f2136529'
  file: contracts/ethereumMultiFeed/EthereumMultiFeedAdapterWithoutRoundsV3.sol
  has: return block.timestamp > lastBlockTimestamp;
  line: 17
  says: an update proceeds only on the whitelisted-sender branch
  for:
  - evidence-2
  - justification
  - what
- id: v3-main
  source: '0x0c6c73865429e1d87b7b817b95bb1f38f2136529'
  file: contracts/ethereumMultiFeed/EthereumMultiFeedAdapterWithoutRoundsV3.sol
  has: msg.sender == MAIN_UPDATER_ADDRESS ||
  line: 11
  says: the sender is compared against the main updater address
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
  who: Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not
    reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: HIGH
reviews: []
related: []
---

## What happens

The adapter stores oracle prices from data packages whose node signatures it checks with ECDSA recovery, and it accepts updates sent by whitelisted updater addresses. A quantum attacker who recovers enough node keys and one updater key can push any price to the protocols that read these feeds.

## Evidence

- [recoverSignerAddress](https://etherscan.io/address/0x0c6c73865429e1d87b7b817b95bb1f38f2136529#code) takes the package signer from ECDSA recovery over the signed hash.
- [_validateBlockTimestamp](https://etherscan.io/address/0x0c6c73865429e1d87b7b817b95bb1f38f2136529#code) allows an update when the sender is one of the updater addresses.

## Reviewer notes

### Mechanism

updateDataFeedsValuesPartial(dataFeedsIds) calls getOracleNumericValuesAndTimestampFromTxMsg (RedstoneConsumerBase). That function parses the data packages appended to calldata. For each package, SignatureLib.recoverSignerAddress reads r, s and v from calldata (lines 20-25) and calls ecrecover(signedHash, v, r, s) (line 27). It reverts only on address(0). getAuthorisedSignerIndex maps the recovered signer to one of five constant node addresses. A value needs getUniqueSignersThreshold() = 3 distinct signers, and _tryToUpdateDataFeed then stores the median. In V3, _validateBlockTimestamp (lines 9-20) returns block.timestamp > lastBlockTimestamp only when msg.sender is MAIN_UPDATER_ADDRESS, FALLBACK_UPDATER_ADDRESS, MANUAL_UPDATER_ADDRESS or one of the Gelato addresses; otherwise it returns false and the update is skipped. Per the finding, the updaters are EOAs whose keys a quantum attacker recovers the same way as the node keys. Consumers read getValueForDataFeed or priceOf. The proxy's ProxyAdmin is owned by a 2-of-3 Safe, which can upgrade the implementation.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The adapter itself holds no funds; the loss falls on consumer protocols, which were not measured.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
