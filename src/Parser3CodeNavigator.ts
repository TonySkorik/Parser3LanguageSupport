'use strict';

import * as vscode from 'vscode';
import {Symbol, SymbolHelper} from './SymbolHelper';
import { Config } from './Config';

const EndOfFileMarker : string = "=== END OF FILE ===";

export class Parser3CodeNavigator {
	public async GoToMethodDeclaration(editor : vscode.TextEditor){
		let methodDeclarations = SymbolHelper.GetMethodDeclarations(editor.document);

		let symbolsByName = new Map<string, Symbol>();
		let symbolNames = new Array<string>();

		methodDeclarations.forEach(s=>{
			symbolsByName.set(s.Name, s);
			symbolNames.push(s.Name);
		});		

		if(methodDeclarations.length > 0){
			if(!Config.IsDisableGoToMethodListSorting){
				symbolNames.sort();
			}
			
			symbolNames.push(EndOfFileMarker);

			let selection = await vscode.window.showQuickPick(symbolNames, {canPickMany : false, placeHolder : "Method signature"});
			if(selection === undefined){
				return;
			}

			if(selection === EndOfFileMarker){
				var endLine = editor.document.lineAt(editor.document.lineCount-1);
				editor.revealRange(endLine.range, vscode.TextEditorRevealType.AtTop);
				editor.selection = new vscode.Selection(endLine.range.start, endLine.range.start);	
			}

			let symbol = symbolsByName.get(selection);
			if(symbol ===undefined){
				return;				
			}	

			let r = new vscode.Range(symbol.Position, symbol.Position);
			editor.revealRange(r, vscode.TextEditorRevealType.AtTop);
			editor.selection = new vscode.Selection(symbol.Position, symbol.Position);
		}else{
			vscode.window.showWarningMessage("No method declarations found in file");
		}
	}
}