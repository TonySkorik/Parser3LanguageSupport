# Parser 3 Language Support extension

![](.\images\logo.png)

This extension adds Parser3 language support to VSCode.

## Features

- Syntax highlighting (mixed Parser3, HTML, SQL).

- C# - style documenting header insertions.

- Documenting header parsing and hover provision.

- Comment / Uncomment selection commands (both `#` and `^rem{}`) with configurable suffixes.

- Go to specified method declaration within one file. Featuring special methods list sorting and some special labels such as file start and file end.

- Comment-aware tabulation. Overrides default `TAB` key bahavior via contributed keybinding.

## Requirements

VSCode 1.25.0 and higher.

## Getting Started

1. Install the extension
2. Restart VS Code and open the folder containing the project you want to work on.

## Extension Settings

This extension contributes the following settings:

* `parser3ext.settings.forceCursorOnTheLineStart`: Move the cursor on the line start upon InsertDocumentingHeader invocation. If set to `false` and invoked - the warning will be displayed and nothing happens.
* `parser3ext.settings.allowedEmptyLinesCount`: Amount of empty lines between method signature and documenting comment start. If exceeded documenting header won't be parsed into hover.
* `parser3ext.settings.disableGoToMethodListSorting`: Set to `true` to diasable method signatures sorting in GoToMethod picker.
* `parser3ext.settings.commentSymbolSuffix`: Sets the symbol which should be printed after comment `#` symbol upon `parser3ext.commentSelection` command invocation.

## Known Issues

- Mixed language (SQL + XML + Parser3) syntax highlighting sometimes works incorrectly (see `syntax highlight` issues).

If you find any bugs or whant to request a feature - feel free to submit an issue or a pull request.

## Release Notes

### 1.2.0

- Refactored comments and methods search logic

### 1.1.9

- RemSelection command now inserts suffix after `^rem{`. Suffix can be configured in `parser3ext.settings.remCommentSuffix`.
- GoToMethod now supports multiple methods with the same name.

### 1.1.8

- CommentSelection command now does not insert `parser3ext.settings.commentSymbolSuffix` if invoked for already commented line.

### 1.1.7

- Fixed error when comment-aware TAB did not work if the cursor was in first position of an empty line.
- Content-aware TAB now ignores last selection line if it has no symbols selected (cursor is at the beginning of a line).

### 1.1.6

- Added setting `allowCommentAwareTabCommentsShift` to allow comment-awatre TAB to shift commented strings. Default is `false`.
- Last string of selection now does not get shifted if it has no symbols selected.

### 1.1.5

- Added command to wrap selection in `^rem{}`.
- TAB is now comment-aware. I.e. if the line starts with the comment symbol `#` it will be left at the begginning of the line and TAB chacracter will be inserted after it.
- Fixed #10 : wrong comment selection translation.

### 1.1.3

- Changed xmldoc building logic.
- Fixed GoToMethod sorting logic.
- GoToMethod sorting logic now puts `unhandled_excepton` method at the end of the list.
- CommentSelection now does not comment the last selection line if cursor stands at its beginning.

### 1.1.2

- In addition to method sorting, added `auto` and `postprocess` methods to top and bottom of the list respectively.
- Documenting header popup now has parameters separated from other sections.
- Reformated documenting header popup.

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