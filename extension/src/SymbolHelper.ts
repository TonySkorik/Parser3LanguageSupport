'use strict';

import * as vscode from 'vscode';


export class SymbolType {
	public static MethodDeclaration : string = "MethodDeclaration";
	public static MethodInvocation : string = "MethodInvocation";
	public static Variable : string = "Variable";
	public static ConstructorInvocation : string = "ConstructorInvocation";
	public static MemberAccess : string = "MemberAccess";
	public static StaticMethodInvocation : string = "StaticMethodInvocation";
	public static MethodParameterDeclaration : string = "MethodParameterDeclaration";
	public static Unknown : string = "UNKNOWN";
}

export class Symbol{
	Type: string;
	Name : string;
	ClearName : string;
	ContainingString : string;
	Document : vscode.TextDocument;
	Position : vscode.Position;
	HasSelfAccess : boolean;
	
	constructor(symbolType : string, symbolName : string, containingString : string, document : vscode.TextDocument, position : vscode.Position){
		this.Type = symbolType;
		this.Name = symbolName;
		this.ContainingString = containingString;
		this.Position = position;
		this.Document = document;		
		this.HasSelfAccess = symbolName.startsWith("self.");
		if(this.HasSelfAccess){
			this.ClearName = this.Name.substr("self.".length);
		}else{
			this.ClearName = this.Name;
		}
	}

	public static Unknown(memberName : string, containingString : string, document : vscode.TextDocument, position : vscode.Position):Symbol{
		return new Symbol(SymbolType.Unknown, memberName, containingString, document, position);
	}

	public static Method(methodName : string, containingString : string, isInvocation : boolean, document : vscode.TextDocument, position : vscode.Position){
		return isInvocation 
			? new Symbol(SymbolType.MethodInvocation, methodName, containingString, document, position)
			: new Symbol(SymbolType.MethodDeclaration, methodName, containingString, document, position);
	}

	public static Constructor(constructorMethodName : string, containingString : string, document : vscode.TextDocument, position : vscode.Position){
		return new Symbol(SymbolType.ConstructorInvocation, constructorMethodName, containingString, document, position);
	}

	public static Variable(variableName : string, containingString : string, document : vscode.TextDocument, position : vscode.Position){
		return new Symbol(SymbolType.Variable,variableName, containingString, document, position);
	}

	public static MemberAccess(memberName : string, containingString : string, document : vscode.TextDocument, position : vscode.Position){
		return new Symbol(SymbolType.MemberAccess, memberName, containingString, document, position);
	}

	public static StaticMethodInvocation(methodName : string, containingString : string, document : vscode.TextDocument, position : vscode.Position){
		return new Symbol(SymbolType.StaticMethodInvocation, methodName, containingString, document, position);
	}

	public static MethodParameterDeclaration(parameterName : string, containingString : string, document : vscode.TextDocument, position : vscode.Position){
		return new Symbol(SymbolType.MethodParameterDeclaration, parameterName, containingString, document, position);
	}
}

export class SymbolHelper{
	public static AnalyzeSelection(document: vscode.TextDocument, position: vscode.Position) : Symbol{
		let currentString = document.lineAt(position.line).text.trim();

		let wordRange = document.getWordRangeAtPosition(position);
		if(wordRange === undefined){
			throw new Error("No word range found.");	
		}

		let word = document.getText(wordRange);
		let wordRangeWithLeadingSymbol = new vscode.Range(wordRange.start.translate(0,-1), wordRange.end);
		let wordWithLeadingSymbol = document.getText(wordRangeWithLeadingSymbol);

		// analyze $self. of ^.self prefix
		if(wordRange.start.character >= "^self.".length){
			let potentialSelfAccessRange = new vscode.Range(wordRange.start.translate(0,-("^self.".length)), wordRange.end);
			let potentialSelfAccess = document.getText(potentialSelfAccessRange);
			if(potentialSelfAccess.indexOf("^self.") !== -1 || potentialSelfAccess.indexOf("@self.") !== -1){
				word = potentialSelfAccess.substr(1);
				wordWithLeadingSymbol = potentialSelfAccess;
			}
		}		

		switch(wordWithLeadingSymbol.substr(0,1)){
			case "$":
				return Symbol.Variable(word, currentString, document, position);
			case "^":
				return Symbol.Method(word, currentString, true, document, position);
			case "@":
				return Symbol.Method(word, currentString, false, document, position);
			case ":":
				let wordRangeWithTwoLeadingSymbols = new vscode.Range(wordRange.start.translate(0,-2), wordRange.end);
				let wordWithTwoLeadingSymbols = document.getText(wordRangeWithTwoLeadingSymbols);
				if(wordWithTwoLeadingSymbols.startsWith("::")){
					return Symbol.Constructor(word, currentString, document, position);
				}else{
					return Symbol.StaticMethodInvocation(word, currentString, document, position);
				}
			case ".":
				return Symbol.MemberAccess(word, currentString, document, position);						
			case "[":
				return Symbol.MethodParameterDeclaration(word, currentString, document, position);
			case " ":	
			default:
				return Symbol.Unknown(word, currentString, document, position);
		}
	}
}