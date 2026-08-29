# XFBIN Parser - Mojo🔥
Parser for CyberConnect2 XFBIN files, written in the recently-released yet powerful [Mojo](https://mojolang.org/).

This is in very early stages of development so there's very little you can do with it at the moment, but the declarative parsing is currently being worked on and proves itself to work. Take a look at [main.mojo](/src/main.mojo) to see it in action.

## Usage
The app takes 1 argument, which is the file path to the XFBIN you want to parse.

For example:
```bash
./xfbin_parser "./All-Star Battle R/Unpacked Files/patch233/data/param/battle/PlayerColorParam.bin.xfbin"
```

## Build From Source
Clone this repository with Git:
```bash
git clone https://github.com/KojoBailey/xfbin-parser-mojo.git
```

[Install](https://mojolang.org/install/) the Mojo compiler and run:
```bash
mojo build src/main.mojo -o [build_directory]/xfbin_parser
```

> [!NOTE]
> As Mojo does not yet natively support Windows, building on Windows requires [WSL](https://learn.microsoft.com/en-us/windows/wsl/install).
