# Parser 3 Language Support extension

This extension adds Parser3 language support to VSCode. 

## Features

Syntax highlighting (mixed Parser3, HTML, SQL).

C# - style documenting header insertions.

Documenting header parsing and hover provision.

Comment / Uncomment selection commands.

Describe specific features of your extension including screenshots of your extension in action. Image paths are relative to this README file.

## Requirements

VSCode 1.25.0 and higher.

## Extension Settings

This extension contributes the following settings:

* `parser3ext.settings.forceCursorOnTheLineStart`: Move the cursor on the line start upon InsertDocumentingHeader invocation. If set to `false` and invoked - the warning will be displayed and nothing happens.
* `parser3ext.settings.allowedEmptyLinesCount`: Amount of empty lines between method signature and documenting comment start. If exceeded documenting header won't be parsed into hover.

## Known Issues

None yet :)

If you find one - feel free to submit an issue.

## Release Notes

Users appreciate release notes as you update your extension.

### 0.0.6

- Started CHANGELOG.md
- Started README.md
- Added <returns> comment
- All commands now have "Parser3:" prefix
- Added (Un)Comment selection commands

  - Parser3: Comment Selection
  - Parser3: Uncomment Selection
- Refactored command invocation
