'use strict';

import * as vscode from 'vscode';
import {Symbol, SymbolHelper} from './SymbolHelper';
import { Config } from './Config';

const EndOfFileMarker : string = "=== END OF FILE ===";

export class Parser3CodeNavigator {
	public async GoToMethodDeclaration(editor : vscode.TextEditor){
		let methodDeclarations = SymbolHelper.GetMethodDeclarations(editor.document);

		if(methodDeclarations.length === 0){
			vscode.window.showWarningMessage("No method declarations found in file");
			return;
		}

		let symbolsByName = new Map<string, Symbol>();
		let symbolNamesByNormalizedNames = new Map<string, string>();
		let symbolNames = new Array<string>();
		let symbolNormalizedNames = new Array<string>();
		
		let autoMethod : Symbol | undefined;
		let postprocessMethod : Symbol | undefined;

		methodDeclarations.forEach(s=>{
			let isAutoOrPostprocess = false;
			if(SymbolHelper.IsAutoMethod(s)){
				autoMethod = s;
				isAutoOrPostprocess = true;
			}

			if(SymbolHelper.IsPostprocessMethod(s)){
				postprocessMethod = s;
				isAutoOrPostprocess = true;
			}
			
			if(!isAutoOrPostprocess){
				let symbolName = s.Name;
				let symbolNormalizedName = s.GetNormalizedName();
				symbolsByName.set(symbolName, s);
				symbolNormalizedNames.push(symbolNormalizedName);
				symbolNamesByNormalizedNames.set(symbolNormalizedName, symbolName);
			}
		});	
			
		if(!Config.IsDisableGoToMethodListSorting){
			symbolNormalizedNames.sort();
		}
				
		if(autoMethod){
			symbolNames.push(autoMethod.Name);
		}

		for(let normalizedName in symbolNormalizedNames){
			let symbolName = symbolNamesByNormalizedNames.get(normalizedName);
			if(symbolName === undefined ){
				continue;
			}
			symbolNames.push(symbolName);
		}
		
		if(postprocessMethod){
			symbolNames.push(postprocessMethod.Name);
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
		if(symbol === undefined){
			return;				
		}	

		let r = new vscode.Range(symbol.Position, symbol.Position);
		editor.revealRange(r, vscode.TextEditorRevealType.AtTop);
		editor.selection = new vscode.Selection(symbol.Position, symbol.Position);
	}
}