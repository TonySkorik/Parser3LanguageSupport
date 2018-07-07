
'use strict';

import * as vscode from 'vscode';
import { Config } from './Config';
import { EditorHelper } from './EditorHelper';

export class Parser3DefinitionProvider implements vscode.DefinitionProvider {

	public provideDefinition(
		document: vscode.TextDocument, 
		position: vscode.Position, 
		token: vscode.CancellationToken):Thenable<vscode.Location> 
	{
		let editor = vscode.window.activeTextEditor;
		if (!editor) {
			vscode.window.showWarningMessage("Open a file first to insert comments.");
			throw new Error("NotImplemented");					
			//return new vscode.Location(document.uri,position); // No open text editor
		}

		let selection = new vscode.Selection(new vscode.Position(position.line,0),position);
		EditorHelper.GetSelectionAtTheLineStart(editor, selection);
		throw new Error("NotImplemented");				
    }
}

