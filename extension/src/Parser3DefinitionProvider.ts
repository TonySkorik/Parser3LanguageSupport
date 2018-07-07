
'use strict';

import * as vscode from 'vscode';
//import { Config } from './Config';
import { EditorHelper } from './EditorHelper';

class SymbolType {
	public static MethodDeclaration : string = "MethodDeclaration";
	public static MethodInvocation : string = "MethodInvocation";
	public static Variable : string = "Variable";
	public static Unknown : string = "UNKNOWN";
}

class Symbol{
	Type: string;
	Name : string;
	
	constructor(symbolType : string, symbolName : string){
		this.Type = symbolType;
		this.Name = symbolName;
	}

	public static Unknown(memberName : string):Symbol{
		return new Symbol(SymbolType.Unknown, memberName);
	}

	public static Method(methodName : string, isInvocation : boolean){
		return isInvocation 
			? new Symbol(SymbolType.MethodInvocation, methodName)
			: new Symbol(SymbolType.MethodDeclaration, methodName);
	}

	public static Variable(variableName : string){
		return new Symbol(SymbolType.Variable,variableName);
	}
}

export class Parser3DefinitionProvider implements vscode.DefinitionProvider {

	private AnalyzeSelection(selectedMember : string) : Symbol{
		let member = selectedMember.trim();
		let memberName = member.substring(1);

		switch(member.substr(0,1)){
			case "$":
				return Symbol.Variable(memberName);
			case "^":
				return Symbol.Method(memberName, true);
			case "@":
				return Symbol.Method(memberName, false);
			default:
				return Symbol.Unknown(memberName);
		}
	}

	public FindSymbol(symbol : Symbol, documentText : vscode.TextDocument) : vscode.Location{
		
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

		let selection = new vscode.Selection(new vscode.Position(position.line,0),position);
		let currentString = EditorHelper.GetCurrentString(editor, selection);
		
		let symbol = this.AnalyzeSelection(currentString);

		return Promise.resolve(this.FindSymbol(symbol, document));
    }
}

