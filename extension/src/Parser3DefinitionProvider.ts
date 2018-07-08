'use strict';

import * as vscode from 'vscode';

//import { Config } from './Config';
//import { EditorHelper } from './EditorHelper';
import {Symbol, /*SymbolType,*/ SymbolHelper} from './SymbolHelper';

export class Parser3DefinitionProvider implements vscode.DefinitionProvider {
	public FindSymbol(symbol : Symbol, token: vscode.CancellationToken) : vscode.Location{
		
		//return new vscode.Location(document.uri,position); // No open text editor
		throw new Error("NotImplemented");
	}

	public provideDefinition(
		document: vscode.TextDocument, 
		position: vscode.Position, 
		token: vscode.CancellationToken):Thenable<vscode.Location> 
	{
		let editor = vscode.window.activeTextEditor;
		if (!editor) {
			vscode.window.showWarningMessage("Open a file first to go to definition.");
			return Promise.reject("No open file editor.");
		}
				
		let symbol = SymbolHelper.AnalyzeSelection(document, position);

		return Promise.resolve(this.FindSymbol(symbol, token));
    }
}

