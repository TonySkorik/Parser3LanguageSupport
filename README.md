# Parser 3 Language Support extension

![](.\images\logo.png)

This extension adds Parser3 language support to VSCode.

## Features

- Syntax highlighting (mixed Parser3, HTML, SQL).

- C# - style documenting header insertions.

- Documenting header parsing and hover provision.

- Comment / Uncomment selection commands.

- Go to specified method declaration within one file.

## Requirements

VSCode 1.25.0 and higher.

## Getting Started

1. Install the extension
2. Restart VS Code and open the folder containing the project you want to work on.

## Extension Settings

This extension contributes the following settings:

* `parser3ext.settings.forceCursorOnTheLineStart`: Move the cursor on the line start upon InsertDocumentingHeader invocation. If set to `false` and invoked - the warning will be displayed and nothing happens.
* `parser3ext.settings.allowedEmptyLinesCount`: Amount of empty lines between method signature and documenting comment start. If exceeded documenting header won't be parsed into hover.
* `parser3ext.settings.deisableGoToMethodListSorting`: Set to `true` to diasable method signatures sorting in GoToMethod picker.

## Known Issues

- `JOIN` SQL statement sometimes looses syntax highlighting

If you find any bugs or whant to request a feature - feel free to submit an issue or a pull request.

## Release Notes

### 1.1.2

- In addition to method sorting, added `auto` and `postprocess` methods to top and bottom of the list respectively
- Documenting header popup now has parameters separated from other sections
- Reformated documenting header popup

### 1.1.1

- Method decalrations are now lexicographically sorted (it is possible to switch sorting off in settings).
- Added end of file option in GoToMethod command.

### 1.1.0

- Documenting header popup is now multi-lined.
- Added command to go to method declaration in currently opened file.

### 1.0.1

- Updated packages

### 1.0.0

- First public release