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
		let autoMethod : NavigationListElement | undefined;
		let postprocessMethod : NavigationListElement | undefined;
		let unhandledExceptionMethod : NavigationListElement | undefined;

		symbols.forEach(v=>{
			let isAutoOrPostprocessOrUnhandleException = false;
			let element = {NormalizedName : v.GetNormalizedName(), Name : v.Name, Symbol : v};
			if(SymbolHelper.IsAutoMethod(v)){
				autoMethod = element;
				isAutoOrPostprocessOrUnhandleException = true;
			}
			if(SymbolHelper.IsPostprocessMethod(v)){
				postprocessMethod = element;
				isAutoOrPostprocessOrUnhandleException = true;
			}
			if(SymbolHelper.IsUnhandledExceptionMethod(v)){
				unhandledExceptionMethod = element;
				isAutoOrPostprocessOrUnhandleException = true;
			}
			
			if(!isAutoOrPostprocessOrUnhandleException){
				let sameElements = nav.filter((elt)=>{
					return elt.NormalizedName === element.NormalizedName;
				}).sort(this.Compare);
				if(sameElements.length>0){
					let sameElementSuffix = sameElements[sameElements.length-1].Name.split(" #");
					let sameElementIndex = 0;
					if(sameElementSuffix.length > 1){
						sameElementIndex = Number.parseInt(sameElementSuffix[1]);
					}
					sameElementIndex++;
					element.Name = element.Name + " #" + sameElementIndex;
				}
				nav.push(element);
			}
		});		
		
		if(!Config.IsDisableGoToMethodListSorting){
			nav.sort(this.Compare);
		}	

		if(autoMethod){
			nav.reverse().push(autoMethod);
			nav.reverse();
		}

		if(unhandledExceptionMethod){
			nav.push(unhandledExceptionMethod);
		}

		if(postprocessMethod){
			nav.push(postprocessMethod);
		}

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

		let listBuilder = new CodeNavigationListBuilder(methodDeclarations);

		let symbolNames = listBuilder.GetNavigationList();
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

		let symbol = listBuilder.GetSybolByName(selection);
		if(symbol === undefined){
			return;				
		}	

		let r = new vscode.Range(symbol.Position, symbol.Position);
		editor.revealRange(r, vscode.TextEditorRevealType.AtTop);
		editor.selection = new vscode.Selection(symbol.Position, symbol.Position);
	}
}