---
id: kernel-8dc3bcbb-rotate-signer-before-migrating
format: 2
title: Borrowers can't sign loans or repayments if their accounts take real code
status: candidate
severity: INFORMATIONAL
justification: Breaks only if a borrower's key moves to real code; a Config admin can first add a key the borrower
  signs.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x8dc3bcbb4b506fa2becd065ff4425dee32f156a6'
  name: Kernel
  label: 'Nuo Network: Kernel'
  code: verified
  code_url: https://etherscan.io/address/0x8dc3bcbb4b506fa2becd065ff4425dee32f156a6#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  whose: users
  basis: held
activity: {}
impact: liveness
action: Have a Config admin send addUser for a new key per borrower, signed by that borrower's current key, before
  it takes real code.
evidence_level: source
checks:
- id: recover
  source: '0x8dc3bcbb4b506fa2becd065ff4425dee32f156a6'
  file: Kernel.sol
  lines:
  - 604
  - 628
  has: return ecrecover(_hash, v, r, s);
  says: signatures are recovered with ecrecover through _recoverSigner, with no other path
  for:
  - evidence-1
  - justification
  - what
- id: create-user
  source: '0x8dc3bcbb4b506fa2becd065ff4425dee32f156a6'
  file: Kernel.sol
  lines:
  - 2172
  - 2189
  has: if(!Account(order.account).isUser(signer)) {
  says: createOrder needs the recovered signer to be the order's user and a user of the account
  for:
  - evidence-1
  - what
- id: repay-user
  source: '0x8dc3bcbb4b506fa2becd065ff4425dee32f156a6'
  file: Kernel.sol
  lines:
  - 2269
  - 2273
  has: if(!Account(order.account).isUser(signer)){
  says: repay needs the recovered signer to be a user of the order's account
  for:
  - evidence-1
  - justification
  - what
- id: collateral-in
  source: '0x8dc3bcbb4b506fa2becd065ff4425dee32f156a6'
  file: Kernel.sol
  line: 2214
  has: escrow.transferFromAccount(order.account, order.collateralToken, address(escrow), order.collateralAmount);
  says: the collateral comes from the borrower's account
  for:
  - whose
- id: collateral-out
  source: '0x8dc3bcbb4b506fa2becd065ff4425dee32f156a6'
  file: Kernel.sol
  line: 2296
  has: escrow.transfer(order.collateralToken, order.account, order.collateralAmount);
  says: repay returns the collateral to the borrower's account
  for:
  - what
  - whose
- id: adduser
  source: '0x8dc3bcbb4b506fa2becd065ff4425dee32f156a6'
  file: Kernel.sol
  lines:
  - 906
  - 937
  has: if(!isUser[signer]) {
  says: addUser is onlyAdmin and only adds the key if the signature recovers to a current user, else it logs SIGNER_NOT_AUTHORIZED
    and adds nobody
  for:
  - action
  - evidence-2
  - justification
- id: account-master
  storage: '0xee8e8f11a9d8b98f7a02b636fddc1e21f8ac8886'
  slot: 0
  is: '0xd1eb703dc966d67236fd94a66ab87fb9aeff092c'
  says: the last loan's account is a proxy of the account master 0xd1eb...092c
  for:
  - evidence-2
- id: order-count
  call: '0x8dc3bcbb4b506fa2becd065ff4425dee32f156a6'
  fn: orders(uint256)(bytes32)
  args:
  - 7416
  reverts: true
  says: the orders list has no 7,417th entry
  for:
  - evidence-3
  - what
- id: last-order
  call: '0x8dc3bcbb4b506fa2becd065ff4425dee32f156a6'
  fn: orders(uint256)(bytes32)
  args:
  - 7415
  is: '0xeda65f9e7313d3676d45adb0646c12ec2d5b802221f99c52cb9b1318dd4586b9'
  says: the last of the 7,416 orders
  for:
  - evidence-3
  - what
- id: last-created
  call: '0x8dc3bcbb4b506fa2becd065ff4425dee32f156a6'
  fn: getOrder(bytes32)(address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,uint256)
  args:
  - '0xeda65f9e7313d3676d45adb0646c12ec2d5b802221f99c52cb9b1318dd4586b9'
  is:
  - '0xEE8e8F11A9d8B98f7A02b636fddC1E21F8AC8886'
  - '0xC4b38D2E8Ef8f8187292932D1bad9d1f26821951'
  - '0x6B175474E89094C44Da98b954EedeAC495271d0F'
  - '0x514910771AF9Ca656af840dff83E8264EcF986CA'
  - 1529036600000000000000
  - 400000000000000000000
  - 28524867681868270
  - 1601496193
  - 556920573
  - 0
  - 1596312193
  says: the last order was created at 1596312193 (2020-08-01) on account 0xee8e...8886
  for:
  - notes
- id: last-repaid
  call: '0x8dc3bcbb4b506fa2becd065ff4425dee32f156a6'
  fn: isRepaid(bytes32)(bool)
  args:
  - '0xeda65f9e7313d3676d45adb0646c12ec2d5b802221f99c52cb9b1318dd4586b9'
  is: true
  says: the last order is repaid
  for:
  - evidence-3
- id: not-stopped
  call: '0x8dc3bcbb4b506fa2becd065ff4425dee32f156a6'
  fn: stopped()(bool)
  is: false
  says: the Kernel is not stopped
  for:
  - notes
- id: user-eoa
  code: '0xc4b38d2e8ef8f8187292932d1bad9d1f26821951'
  is: empty
  says: the last loan's user key has no code
  for:
  - notes
- id: master-adduser
  selector: '0xd1eb703dc966d67236fd94a66ab87fb9aeff092c'
  fn: addUser(address,uint256,bytes)
  says: the account master in use has addUser
  for:
  - evidence-2
- id: account-config
  call: '0xee8e8f11a9d8b98f7a02b636fddc1e21f8ac8886'
  fn: config()(address)
  is: '0x431F429035a1e3059d5c6a9a83208c6D3143D925'
  says: the last loan's account uses Config 0x431f...d925 for its admin gate
  for:
  - action
  - evidence-2
- id: config-admins
  call: '0x431f429035a1e3059d5c6a9a83208c6d3143d925'
  fn: getAllAdmins()(address[])
  is:
  - '0x3E990e787a88cD4426fB3AF9B90DD1D951E2cb87'
  - '0x4F29bF61bE2Dc963B8AABFE862a18dE558551424'
  - '0x681D2475Bd0cDAA134Dc5179D95f9ed4B354a28b'
  - '0x8A333C59eAb0Ad608F857A02C3702B910e24493B'
  - '0xB1A019dD9155d2376CB87f3A2e57d00d65B5ADa4'
  - '0x24f392F59DF620024D0437d31e4fEaf74E88d114'
  - '0xb665E606F09dE09CCF90AC5271629ce228B35EBf'
  says: the Config has 7 admins at the block
  for:
  - action
  - evidence-2
  - justification
- id: admin-control
  call: '0x431f429035a1e3059d5c6a9a83208c6d3143d925'
  fn: disableAdminControl()(bool)
  is: false
  says: admin control is on, so only listed admins pass the account's admin gate
  for:
  - action
  - justification
- id: adduser-nonadmin
  call: '0xee8e8f11a9d8b98f7a02b636fddc1e21f8ac8886'
  data: '0x6a44f65f0000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000600000000000000000000000000000000000000000000000000000000000000000'
  from: '0x000000000000000000000000000000000000dead'
  reverts_with: Account::_ INVALID_ADMIN_ACCOUNT
  says: on the live master, addUser from an address that is not a Config admin reverts
  for:
  - action
  - evidence-2
  - justification
- id: master-signed-msg
  bytecode: '0xd1eb703dc966d67236fd94a66ab87fb9aeff092c'
  has: 457468657265756d205369676e6564204d6573736167653a
  says: the live master hashes with the signed-message header, as _recoverSigner does
  for:
  - notes
- id: master-signer-err
  bytecode: '0xd1eb703dc966d67236fd94a66ab87fb9aeff092c'
  has: 5349474e45525f4e4f545f415554484f52495a45445f574954485f4143434f55
  says: the live master carries the SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT error text
  for:
  - action
  - evidence-2
  - justification
- id: master-adduser-err
  bytecode: '0xd1eb703dc966d67236fd94a66ab87fb9aeff092c'
  has: 4163636f756e743a3a61646455736572
  says: the live master carries the 'Account::addUser' error label
  for:
  - evidence-2
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews:
- who: r-8dc3bcbb, the row's refuter
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: Returned twice: addUser is admin-gated on the account code that runs and, per the verified Account
    code and the same error text in the running master''s bytecode, also needs a signature from a current user of
    the account (otherwise it adds nobody). The card now says a Config admin submits addUser signed by the borrower''s
    current key. A fresh refuter agrees; sheet read by Claude. Q2-class: no loan since August 2020. INFORMATIONAL;
    candidate.'
related: []
---

## What happens

The Kernel opens a loan, and lets a borrower repay it and get the collateral back, when a user key of the borrower's account signs. If that key's account takes real code, its signature stops counting; an EIP-7702 delegation keeps working. No loan has opened here since August 2020.

## Evidence

- [createOrder and repay](https://etherscan.io/address/0x8dc3bcbb4b506fa2becd065ff4425dee32f156a6#code) recover the signer with ecrecover and require it to be a user of the borrower's account.
- On the last loan's [account](https://etherscan.io/address/0xee8e8f11a9d8b98f7a02b636fddc1e21f8ac8886), addUser reverts unless a Config admin sends it and needs a current user's signature.
- The [Kernel](https://etherscan.io/address/0x8dc3bcbb4b506fa2becd065ff4425dee32f156a6#readContract) holds 7,416 loans; the last was opened on 1 August 2020 and is repaid.

## Reviewer notes

### Mechanism

Utils2._recoverSigner (line 628) prefixes the hash with the signed-message header and calls ecrecover (line 604). Kernel.createOrder (onlyAdmin) requires the recovered signer to equal order.byUser (line 2174) and to be Account(order.account).isUser (line 2189). Kernel.repay (onlyAdmin) requires the signer to be a user of the order's account (line 2273) and returns the collateral (line 2296). The user set lives in each Account proxy. The last loan's account 0xee8e...8886 delegates to master 0xd1eb...092c (slot 0), whose source is not verified. On it, addUser from a non-admin reverts 'Account::_ INVALID_ADMIN_ACCOUNT'. Config 0x431f...d925 has 7 admins and admin control on. In the Kernel's verified file, Account.addUser (lines 906-937) is onlyAdmin and also needs a signature that recovers to a current user (926-931), else it logs SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT and adds nobody. The live master carries the 'Account::addUser', ADD_USER, signed-message header and SIGNER_NOT_AUTHORIZED_WITH_ACCOU(NT) texts. So an admin sends it and the borrower's current key signs it; neither can add a key alone.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: ERC-1271 or a code-size branch: _recoverSigner is plain ecrecover and isUser is a mapping lookup.
- Ruled out: unused implementation: the Kernel is not a proxy; orders(7415) exists and orders(7416) reverts.
- Ruled out: direct path: createOrder, repay and addUser are onlyAdmin; only process (admin, no signature) settles an expired loan, by liquidation.
- Ruled out: key state: the last loan's user key 0xc4b3...1951 has no code and is the account's only user.
- Ruled out: path closed: stopped() is false and admin control is on with 7 admins; nothing closes the path for good.
- Ruled out: breaks by itself: no constant gas on the recovery (ec_gas_const null); solc 0.4.24 ecrecover forwards available gas.
- Ruled out: setter: addUser from a non-admin reverts INVALID_ADMIN_ACCOUNT on the live master, and the verified Account needs a current user's signature; an admin call with an empty signature adds nobody, so it is not cited.

### Questions

- Whether the live account master 0xd1eb703dc966d67236fd94a66ab87fb9aeff092c (unverified) requires a current user's signature in addUser, as the Account in the Kernel's verified file does; its bytecode carries the same error texts but no verified source shows it.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
