'use strict';

import * as vscode from 'vscode';

export interface EditorCommand{
	(editor:vscode.TextEditor):void;	
}