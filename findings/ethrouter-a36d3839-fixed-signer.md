---
id: ethrouter-a36d3839-fixed-signer
title: "EthRouter: signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xa36d383955340bac63f7211dcccb4f446c2b8e28"
  family: "06179e8157861343ca3b87e12b626f9a"
  name: "EthRouter"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody: not affected"
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
  verdict: refuted
  rating: NONE
  note: "Misattributed: this address runs zero ecrecover calls of its own."
---

## Summary

EthRouter (Caviar NFT-AMM router) does not call ecrecover itself: facts.json reports n_ec=0, complete=true for its own bytecode. The ecrecover calls in this dossier's source tree belong to ReservoirOracle.sol (an abstract base EthRouter does not inherit -- it only imports the Message struct to decode calldata it forwards) and to solmate's unrelated ERC20.permit. The actual stolen-NFT-oracle check, if any, runs inside the separate Pair.sol contract, a different deployed address.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Caviar pair: the price message must be signed by the Reservoir oracle address (text cut; fixed in the oracle contract by design) / solmate permit: the recovered address must be the owner named in the…. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- facts.json (all_codes_of_the_family): n_ec=0, complete=true for 0xa36d3839's code
- EthRouter.sol does not import or inherit ReservoirOracle; `contract EthRouter is ERC721TokenReceiver` (dossier source, src/EthRouter.sol:45)
- ecrecover occurrences are in lib/caviar/lib/oracle/contracts/ReservoirOracle.sol (abstract, unused here) and lib/solmate/src/tokens/ERC20.sol (a different token's permit)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

n/a

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
