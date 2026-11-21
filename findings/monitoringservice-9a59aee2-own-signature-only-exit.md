---
id: monitoringservice-9a59aee2-own-signature-only-exit
format: 2
title: Raiden nodes whose accounts take real code can no longer be monitored
status: confirmed
severity: INFORMATIONAL
justification: Breaks only if a node moves its own account to real code; that node then cannot have a service defend
  its channel.
category: migration-notice
pattern: PQ-16
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x9a59aee20caa038a01cd2ccc016573a03ae26a05'
  name: MonitoringService
  project: raiden
  code: verified
  code_url: https://etherscan.io/address/0x9a59aee20caa038a01cd2ccc016573a03ae26a05#code
  copies: 5
  family: da0c35c1e1ea7dcfd0de6838c1e06649
  upgradeable: 'no'
value:
  usd: 0
  whose: users
  basis: held
activity: {}
impact: liveness
action: Tell node operators that a node with real code cannot be monitored here; an EIP-7702 delegation keeps working.
evidence_level: source
checks:
- id: raiden
  source: '0x9a59aee20caa038a01cd2ccc016573a03ae26a05'
  file: MonitoringService.sol
  line: 2575
  has: // Raiden Service Bundle contract to use for checking if MS has deposits
  says: the verified source names the Raiden Service Bundle
  for:
  - what
- id: on-behalf
  source: '0x9a59aee20caa038a01cd2ccc016573a03ae26a05'
  file: MonitoringService.sol
  lines:
  - 2654
  - 2655
  has: the participant on whose behalf the MS acts.
  says: the non-closing participant is the node the monitoring service acts for
  for:
  - action
  - evidence-1
  - justification
  - what
- id: reward-call
  source: '0x9a59aee20caa038a01cd2ccc016573a03ae26a05'
  file: MonitoringService.sol
  lines:
  - 2686
  - 2694
  has: require(raiden_node_address == non_closing_participant, "Bad reward proof");
  says: updateReward, called first by monitor, requires the reward proof to recover to the non-closing participant
  for:
  - evidence-1
  - what
- id: reward-proof
  source: '0x9a59aee20caa038a01cd2ccc016573a03ae26a05'
  file: MonitoringService.sol
  lines:
  - 2955
  - 2956
  has: signature_address = ECVerify.ecverify(message_hash, signature);
  says: the reward proof is recovered with ecrecover and must equal the non-closing participant
  for:
  - action
  - evidence-1
  - justification
  - what
- id: registered
  source: '0x9a59aee20caa038a01cd2ccc016573a03ae26a05'
  file: MonitoringService.sol
  line: 2800
  has: require(service_registry.hasValidRegistration(monitoring_service_address), "service not registered");
  says: only a service with a valid registration can monitor
  for:
  - evidence-2
  - what
- id: reward-paid
  source: '0x9a59aee20caa038a01cd2ccc016573a03ae26a05'
  file: MonitoringService.sol
  lines:
  - 2904
  - 2907
  has: reward.reward_sender_address,
  says: claimReward moves the reward from the node's UserDeposit balance to the service
  for:
  - what
  - whose
- id: sr-wired
  call: '0x9a59aee20caa038a01cd2ccc016573a03ae26a05'
  fn: service_registry()(address)
  is: '0x22d1e5D713f37238BfA15eEbb2366dA08a9d9534'
  says: this contract checks registrations in ServiceRegistry 0x22d1...9534
  for:
  - evidence-2
- id: no-registrations
  call: '0x22d1e5d713f37238bfa15eebb2366da08a9d9534'
  fn: everMadeDepositsLen()(uint256)
  is: '0'
  says: no service has ever made a deposit, so none has ever been registered
  for:
  - evidence-2
  - what
- id: not-deprecated
  call: '0x22d1e5d713f37238bfa15eebb2366da08a9d9534'
  fn: deprecated()(bool)
  is: 'false'
  says: the registry still accepts new registrations
  for:
  - evidence-2
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: CRITICAL
reviews: []
related: []
---

## What happens

Raiden's monitoring contract lets a registered service defend a node's closed channel, paid from the node's deposit, if the node signed a reward proof. A node whose account takes real code can no longer be monitored. No service has ever registered.

## Evidence

- [monitor](https://etherscan.io/address/0x9a59aee20caa038a01cd2ccc016573a03ae26a05#code) accepts a reward proof only if it recovers to the node the service acts for; there is no ERC-1271 path.
- The [service registry](https://etherscan.io/address/0x22d1e5d713f37238bfa15eebb2366da08a9d9534#readContract) it checks has no registration ever and is not deprecated.

## Reviewer notes

### Mechanism

monitor (lines 2727-2788) first calls updateReward, which recovers the reward proof with ECVerify.ecverify (ecrecover, line 35) and requires it to equal non_closing_participant (lines 2686-2694, again at 2955-2956), the node on whose behalf the service acts. It then requires the caller to hold a valid ServiceRegistry registration (line 2800) and calls the TokenNetwork's updateNonClosingBalanceProof. claimReward (lines 2863-2920) later moves reward_amount from the node's UserDeposit balance to the service, with no signature check. Under EIP-8151 a node whose account has real code makes monitor revert at line 2694, so no service can act for it. Nothing is locked here: the contract holds nothing, and the reward stays in the node's UserDeposit balance. State at block 26,438,999: service_registry() is 0x22d1...9534, whose everMadeDepositsLen() is 0 and deprecated() false, so monitor has never succeeded but a service can still register. The UserDeposit this contract points at (0x53cc...f614) names this address as msc_address and holds deposits (whole_balance > 0). The four copies each point at their own registry, and each of those also has everMadeDepositsLen() 0 (read at the block).

### Checks

- Header facts: this address alone, at block 26,438,999; 5 addresses run this code.
- Ruled out: signature-rechecked (the old root issue): the reward proof is recovered only inside monitor, in the same transaction in which the service acts (lines 2748-2778); claimReward pays without any recovery (lines 2863-2920). A node that migrates after a successful monitor still pays; a node that migrates before it makes monitor revert, so the service has delivered nothing on chain and loses only a failed call's gas. No party that already relied on the signature loses funds.
- Ruled out: an ERC-1271 or code-size path: ECVerify.ecverify (lines 6-41) only calls ecrecover and requires a non-zero result.
- Ruled out: a second path to the same act in this contract: updateReward is internal and called only from monitor; a node calling monitor itself still needs the reward proof.
- Ruled out: a direct path for the node: the TokenNetwork source bundled with this contract also requires the non-closing node's own counter-signature in updateNonClosingBalanceProof (lines 798-807), so that path needs the same signature; that check belongs to the TokenNetwork's own finding, not this one.
- Ruled out: path closed for good: the registry is not deprecated, so a service can still register and monitoring can start.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
