# code/

Decompiled code of contracts that have no verified source, for the findings that link it (`contract.code:
decompiled`, `contract.code_url: code/<code hash>.sol`).

- One file per runtime code: `<keccak256 of the runtime bytecode, without 0x>.sol`, shared by every address that runs
  that code.
- Add a file only when someone decompiled the code to judge a finding. Unverified code nobody decompiled is linked on
  the explorer instead (`contract.code: bytecode`).
- The first lines are a comment: the tool and its version (for example `heimdall 0.9.2`), one address that runs the
  code, and the block its code was read at.
- Keep the decompiler's output as it came. A file over 200 KB is not added; the finding links the explorer.
