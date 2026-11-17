# LineaRollup implementation history and calldata data availability

`Upgraded(address)` logs of proxy `0xd19d4b5d358258f05d7b411e21a1460d11b0876f` (Blockscout logs API, read 2026-11-17),
and the `submit*` functions in each implementation's verified ABI (Blockscout `smart-contracts` endpoint).

| Block | Implementation | submit functions |
|---|---|---|
| 17,677,070 | 0xe8f627df6cb02e415b2e6d6e112323bd269b4706 | not checked |
| 17,699,095 | 0x4c8d4ce72afaa417d1f7e833725fdb4e793cd6b3 | not checked |
| 17,871,545 | 0xb32c3d0ddb0063ffb15e8a50b40cc62230d820b3 | not checked |
| 19,217,961 | 0xaa4b3a9515c921996abe7930bf75eff7466a4457 | not checked |
| 19,518,028 | 0x934dd4c63e285551cecef8459103554d0096c179 | not checked |
| 20,025,435 | 0x53fc68bffc03d17804e5a901de42d1eef2e64562 | not checked |
| 21,072,224 | 0x1825242411792536469cbb5843fd27ce3e9e583a | not checked |
| 21,415,497 | 0x07ddce60658a61dc1732cacf2220fce4a01c49b0 | submitBlobs, submitDataAsCalldata |
| 24,563,176 | 0x04728bf704a716c26f9ef4085013b760ac885631 | submitBlobs, submitDataAsCalldata |
| 24,778,478 | 0xe68697690e8ff196a6abb3e1385156d87df85332 | submitBlobs only |
| 25,544,952 | 0x59290394ddc1cf84e671701a929710643c343530 | submitBlobs only |
| 25,881,432 | 0x052b73d934e9412045bf731574463fd026d74645 (current) | submitBlobs only |

The calldata path (`submitDataAsCalldata`) existed until block 24,778,478 and was removed in the upgrade at that
block. The current implementation accepts data only through `submitBlobs` (KZG point evaluation).
