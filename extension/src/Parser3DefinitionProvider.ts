
'use strict';

import * as vscode from 'vscode';
import { Config } from './Config';
import { EditorHelper } from './EditorHelper';

export class Parser3DefinitionProvider implements vscode.DefinitionProvider {

	private AnalyzeSelection(selectedMember : string){

	}

	public provideDefinition(
		document: vscode.TextDocument, 
		position: vscode.Position, 
		token: vscode.CancellationToken):Thenable<vscode.Location> 
	{
		let editor = vscode.window.activeTextEditor;
		if (!editor) {
			vscode.window.showWarningMessage("Open a file first to go to definition.");
			throw new Error("Error going to definition: no file open.");					
			//return new vscode.Location(document.uri,position); // No open text editor
		}

		let selection = new vscode.Selection(new vscode.Position(position.line,0),position);
		let currentString = EditorHelper.GetCurrentString(editor, selection);
		
		let documentText = document.getText();

		throw new Error("No definition found.");					
    }
}

