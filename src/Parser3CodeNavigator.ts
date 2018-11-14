'use strict';

import * as vscode from 'vscode';
import {Symbol, SymbolHelper} from './SymbolHelper';
import { Config } from './Config';

const EndOfFileMarker : string = "=== END OF FILE ===";

interface NavigationListElement{
	NormalizedName : string;
	Name : string;
	Symbol : Symbol;
}

class CodeNavigationListBuilder{

	private _navigationList = new Array<NavigationListElement>();

	public constructor(symbols : Symbol[]){
		let nav : NavigationListElement[] = new Array<NavigationListElement>();
		let autoMethod : Symbol | undefined;
		let postprocessMethod : Symbol | undefined;

		symbols.forEach(v=>{
			let isAutoOrPostprocess = false;
			nav.push({NormalizedName : v.GetNormalizedName(), Name : v.Name, Symbol : v});
		});		
		
		nav.sort(this.Compare);

		this._navigationList = nav;
	}

	public GetNavigationList() : string[] {
		let ret : Array<string>	 = new Array<string>();
		this._navigationList.forEach(e=>{
			ret.push(e.Name);
		});

		return ret;
	}

	public GetSybolByName(name : string) : Symbol | undefined{
		let f = this._navigationList.find((val)=>{
			return val.Name === name;
		});
		if(f){
			return f.Symbol;
		}else{
			return undefined;
		}
	}

	private Compare(a : NavigationListElement,b : NavigationListElement) : number{
		if (a.NormalizedName < b.NormalizedName) {
			return -1;
		}
		if (a.NormalizedName > b.NormalizedName){
			return 1;
		}
		return 0;
	}
}

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