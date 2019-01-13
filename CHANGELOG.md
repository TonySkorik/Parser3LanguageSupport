# Change Log
All notable changes to the "parser3-extended-language-support" extension will be documented in this file.

## [1.1.6] - 13.01.2019

- Added setting `allowCommentAwareTabCommentsShift` to allow comment-awatre TAB to shift commented strings. Default is `false`.
- Last string of selection now does not get shifted if it has no symbols selected.

## [1.1.5] - 11.01.2019

- Added command to wrap selection in `^rem{}`
- TAB is now comment-aware. I.e. if the line starts with the comment symbol `#` it will be left at the begginning of the line and TAB chacracter will be inserted after it.
- Fixed typo in `parser3ext.settings.disableGoToMethodListSorting` setting name.
- Fixed #10 : wrong comment selection translation.
- Updated packages.

## [1.1.3] - 18.11.2018

- Changed xmldoc building logic
- Fixed GoToMethod sorting logic
- GoToMethod sorting logic now puts `unhandled_exceprton` method at the end of the list
- CommentSelection now does not comment the last selection line if cursor stands at its beginning

## [1.1.2] - 15.11.2018

- In addition to method sorting, added `auto` and `postprocess` methods to top and bottom of the list respectively
- Updated packages
- Documenting header popup now has parameters separated from other sections
- Reformated documenting header popup

## [1.1.1] - 12.11.2018

- Method decalrations are now lexicographically sorted (it is possible to switch sorting off in settings).
- Added end of file option in GoToMethod command.

## [1.1.0] - 11.11.2018

- Documenting header popup is now multi-lined.
- Added command to go to method declaration in currently opened file.

## [1.0.1] - 19.10.2018
- Updated packages

## [1.0.0] - 19.10.2018
- First public release