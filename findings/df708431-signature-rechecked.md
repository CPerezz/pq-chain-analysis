---
id: df708431-signature-rechecked
title: "0xdf708431 (tagged deployed by Threshold Network: Deployer 1): a signature checked again after others relied on it"
status: not-affected
severity: NONE
patterns: [PQ-15]
impact: none
contracts:
- address: "0xdf708431162ba247ddae362d2c919e0fbafcf9de"
  family: "e20f92ec2c4cf86e40cd1e9e59a905ae"
  copies: 2
  label: "deployed by Threshold Network: Deployer 1"
  upgradeable: "no"
  rating: NONE
  value_usd: 30154
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 161
  last_active: 2026-11-06
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
  ref: "triage entry eip-8151-signature-rechecked"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "Not affected: the signature check guards only new groups, and Keep's registry disabled this operator contract for good on 2020-11-11, so nothing uses that path; the ETH it holds leaves without any signature. Not 'rechecked' either: the study's own reading has the signatures checked once, at submission. The study's CRITICAL was a ceiling (D-018), never a reading. Fact-checked by Claude on 2026-11-20 at Anon's question."
---

## Summary

KeepRandomBeaconOperator (Keep v1 random beacon, verified source). Its only ECDSA check is on DKG results: at least 48 of a new group's 64 members must sign, checked once at submission in the linked library 0xaac423edc4e3ee9ef81517e8093d52737165b71f; random numbers and slashing proofs use BLS. Keep's registry disabled this operator contract for good on 2020-11-11, so no request reaches it any more. Its 16.71 ETH are operators' unclaimed rewards, paid out without any signature.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: Keep v1 random beacon: a DKG result counts only with signatures of the group's members, each recovered (OpenZeppelin recover) and compared with the member at its index, checked when the result is…. Read by hand.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source (Blockscout, verified): DKGResultVerification.verify needs signatures from at least groupThreshold + (groupSize - groupThreshold)/2 = 48 of 64 members, each recovered and compared with the member at its index, at submission only; the submitter chooses which signatures to include
- KeepRegistry 0x1a9589f56c969d6b0d3787ea02322476ead3fb05: operatorContracts(0xdf708431) = Disabled (read at the latest block 26,455,6xx; the node was down), set by OperatorContractDisabled in tx 0x68da31c439fd057f044f510e83a09ec8968015e35a0fcf82c19eaca921b205f5 on 2020-11-11; approveOperatorContract only accepts contracts in status New, so it cannot be re-approved
- KeepRandomBeaconServiceImplV1.selectOperatorContract counts only approved operator contracts (it reverts today: no groups); sign() and createGroup() here are onlyServiceContract
- Transactions (Blockscout): tickets, 76 DKG results and 1,970 relay entries from 2020-09-16 to 2020-11-11, nothing since but withdrawGroupMemberRewards (463 in all, 49 in the 90 days before the pinned block, the last on 2026-11-04)
- withdrawGroupMemberRewards(operator, groupIndex) is open to anyone, takes no signature and pays the operator's share to its beneficiary in TokenStaking; balance 16.71 ETH; no owner, no proxy, no upgrade function

## Impact and exposure

- Value held at block 26,438,999: $30,154 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 161 transactions called it in the 90 days before that block; last on 2026-11-06.

## Remediation

New deployments that check once, or accept ERC-1271; until then parties settle before migrating a signing address.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
