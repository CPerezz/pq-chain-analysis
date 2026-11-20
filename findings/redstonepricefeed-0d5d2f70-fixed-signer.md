---
id: redstonepricefeed-0d5d2f70-fixed-signer
title: "RedstonePriceFeed: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0d5d2f7009680bdb2b042b072ea31dcbb364bc2d"
  family: "b90bd588e750bfd94446754a9ab16535"
  copies: 15
  name: "RedstonePriceFeed"
  upgradeable: "no"
  rating: LOW
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "Gearbox governance (PriceOracleV3 configurator; ACL owner Timelock 0xa133C9A92Fb8dDB962Af1cbae58b2723A0bdf23b)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "The adapter is immutable, but its consumer replaces it by a setting (precedent: consumer swappable → LOW). It is already swapped out in the main oracle. Not checked: whether 0x9563e47c is still the price feed in some other Gearbox oracle, and the liveness of the governor 0x29B97F37… behind the timelock. If the reviewer wants that proven, MEDIUM (oracle feed, nothing held) is the floor."
---

## Summary

Gearbox RedstonePriceFeed for pumpBTC/USD. Its 5 signers and threshold are immutable (5 of 5, so any one RedStone key taking code stops updates). The feed holds nothing, and its consumer path, a Gearbox PriceOracleV3, swaps feeds by a setting.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: RedStone (variant): signer looked up in a list of addresses fixed in the adapter's code; a threshold of distinct signers. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- @26438999: signerAddress0-4 = RedStone primary-prod keys 0x8BB8F32D…, 0xdEB22f54…, 0x51Ce04Be…, 0xDD682daE…, 0x9c5AE89C…; signer5-9 = 0; getUniqueSignersThreshold()=5; all 5 keys have no code and nonce 0 (off-chain signers); source: immutables set in the constructor, no setter
- @26438999: lastPayloadTimestamp=1736959650 (Jan 2025), so the feed has been dormant since then; balance 0
- Consumer: CompositePriceFeed 0x9563e47cd1786361a95df73454432d61da22f7cb holds this address in code ('pumpBTC / USD Redstone price feed * BTC / USD')
- Gearbox PriceOracleV3 0x599f585D… (AddressProvider 0x9ea7b04D… PRICE_ORACLE v300): priceFeeds(pumpBTC)=0x3a4549be… @26438999, a different composite. The configurator already swapped this feed out by a setting; ACL 0x523dA3a8… owner = Timelock 0xa133C9A9… (delay 129600 s)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 15 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Gearbox points the consumer at a new RedstonePriceFeed with replaceable or post-quantum signers (setPriceFeed); no change to this address is needed or possible

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
