'use strict';

import * as vscode from 'vscode';
import {Symbol, SymbolType, SymbolHelper} from './SymbolHelper';
import { MarkdownBuilder } from './MarkdownBuilder';
import { Config } from './Config';

export class Parser3HoverProvider implements vscode.HoverProvider {

	private GetDocumentingHeaderStrings(documentText : string, indexOfMethodDecalaration : number) : string[]{
		let stringArray : string[] = [];
		let charArray : string[]= [];
		let i = indexOfMethodDecalaration;
		let isFirstString = true; // to skip first newline character
		let allowedEmptyStringsCount = Config.AllowedEmptyLinesCount;

		while(true){
			i = i-1;
			if(i<0){
				break;
			}
			let char = documentText.charAt(i);
			if(char === '\n'){
				if(isFirstString){
					isFirstString = false;
					continue;
				}else{
					let string = charArray.reverse().join("~~~").replace(/~~~/g,""); // to assemble string from the array of chars
					if(string.trim() === "" && allowedEmptyStringsCount > 0){
						// skip allowed ammount of empty lines
						allowedEmptyStringsCount = allowedEmptyStringsCount-1;
						charArray = [];
						continue;
					}
					if(string.startsWith("###")){
						stringArray.push(string.substr(3).trim());
						charArray = [];
					}else{
						break;
					}					
				}
			}else{
				charArray.push(char);
			}
		}
		return stringArray.reverse();
	}

	private GetDocumentationFromDocumentingHeader(symbol : Symbol) : vscode.MarkdownString{
		let ret = new vscode.MarkdownString();

		let documentText = symbol.Document.getText();

		let indexOfMethodDecalaration = documentText.indexOf("@"+symbol.ClearName);

		if(indexOfMethodDecalaration === -1){
			ret.appendText("No method '"+symbol.ClearName+"' declaration found in current document.");
			return ret;
		}
		
		let headerStrings = this.GetDocumentingHeaderStrings(documentText, indexOfMethodDecalaration);

		if(headerStrings.length === 0){
			ret.appendText("No method '"+symbol.ClearName+"' declaration found in current document.");
			return ret;
		}else{
			let mb = new MarkdownBuilder();
			ret = mb.BuildMarkdown(headerStrings);
		}

		return ret;
	}

    public provideHover(
		document: vscode.TextDocument, 
		position: vscode.Position, 
		token: vscode.CancellationToken):Thenable<vscode.Hover> 
	{
		let editor = vscode.window.activeTextEditor;
		if (!editor) {
			vscode.window.showWarningMessage("Open a file first to go to definition.");
			return Promise.reject("No open file editor.");
		}

		let symbol = SymbolHelper.AnalyzeSelection(document, position);

		if(symbol.Type !== SymbolType.MethodInvocation){
			return Promise.reject("Unsupported symbol.");
		}
		
		let documentationMarkdown = this.GetDocumentationFromDocumentingHeader(symbol);

		if(documentationMarkdown.value === ""){
			return Promise.resolve(new vscode.Hover("No documenting header found for method '"+symbol.Name+"'"));
		}else{
			return Promise.resolve(new vscode.Hover(documentationMarkdown));
		}		
    }
}