---
id: ticketbroker-6f582e2b-signature-rechecked
title: "TicketBroker: a signature checked again after others relied on it"
status: confirmed
severity: LOW
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0x6f582e2bb19ac31d4b1e6edd0c2efeabd700f808"
  family: "35d8cdc364a2aa3e64c12b8b030b4d38"
  name: "TicketBroker"
  label: "Livepeer: Target Ticket Broker"
  upgradeable: "yes"
  admin: "Controller 0xF96D54E4... owner Governor 0xFC3CBed6... owned by 3-of-5 MultiSigWallet 0x04746b89..."
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "Livepeer governance (Controller owner Governor 0xFC3C..., owned by 3-of-5 MultiSig 0x0474...)"
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
  verdict: confirmed
  rating: LOW
  note: "Row's 'no update path' is wrong: it is a Controller-registered target behind ManagerProxy with a live 3/5 multisig behind the Governor -> LOW"
---

## Summary

isValidTicketSig recovers the ticket sender and redeemWinningTicket pays the orchestrator from the sender's deposit/reserve, so a sender taking code would void won tickets while unlock()/withdraw() stays open to it. But this is the TicketBroker target behind Livepeer's ManagerProxy, replaceable by the live Controller owner.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: Livepeer TicketBroker isValidTicketSig: a ticket the sender signed earlier is redeemed later by the recipient. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Controller 0xF96D54E490317c557A967ABfA5d6e33006BE69b3 getContract(keccak('TicketBrokerTarget'))=this address; proxy 'TicketBroker'=0x5b1cE829384EeBFa30286F12d1E7A695ca45F5D2 (26438999)
- Controller.owner()=Governor 0xFC3CBed6A3476F7616CC70f078397700136eEBFd, its owner()=Gnosis MultiSigWallet 0x04746b890d090ae3c4c5dF0101CFD089A4FACA6C, required=3 of 5 EOAs (nonces 82,14,59,0,4), transactionCount 68
- Controller paused()=true (L1 protocol migrated to Arbitrum); isValidTicketSig uses ECDSA.recover with no code check (TicketBroker.sol L1200-1209)
- txs_90d 0, last_active null (measured)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Governance points TicketBrokerTarget to a code-aware implementation via Controller.setContractInfo

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
