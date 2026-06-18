# homebrew-zim

A Homebrew tap for [openzim's ZIM command-line tools](https://github.com/openzim/zim-tools)
(`zimdump` and friends) on macOS.

openzim publishes **no prebuilt macOS binaries and no Homebrew formula**
([openzim/zim-tools#496](https://github.com/openzim/zim-tools/issues/496)), so this tap
builds them from source.

## Install

```sh
brew tap Mearman/zim
brew install zim-tools
# then:
zimdump --version
```

## Status — WIP

First draft (2026-06-18). Builds the **reader** toolset:
`zimdump`, `zimdiff`, `zimpatch`, `zimsplit`, `zimrecreate`, `zimbench`, `zimsearch`.

Not yet built (need extra deps to be packaged here):
- `zimcheck` — needs `mustache.hpp`
- `zimwriterfs` — needs `gumbo` + `libmagic`

Built and verified on Intel macOS; Apple Silicon untested. If an install fails,
please open an issue with the build log.
