'use strict';

import * as vscode from 'vscode';
import {Symbol, SymbolType, SymbolHelper} from './SymbolHelper';
import { MarkdownBuilder } from './MarkdownBuilder';
import { Config } from './Config';
import * as xdoc from "xmldoc";

export class DocumentingHeader{
	Summary : string | undefined;
	ParemterDescriptions : Map<string,string> | undefined;
	Returns : string | undefined;
	Remarks : string | undefined;
}

export class Parser3HoverProvider implements vscode.HoverProvider {

	private GetDocumentingHeaderStrings(documentText : string, indexOfMethodDecalaration : number) : string[]{
		let stringArray : string[] = [];
		let charArray : string[] = [];
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

	private GetDocumentingHeader(documentText : string, indexOfMethodDecalaration : number) : DocumentingHeader{
		let headerStrings = this.GetDocumentingHeaderStrings(documentText, indexOfMethodDecalaration);
		let headerXml : string = "<header>";

		headerStrings.forEach(string => {
			headerXml += string;
		});
		
		headerXml+="</header>";

		var doc = new xdoc.XmlDocument(headerXml);
		var ret = new DocumentingHeader();

		/*
		### <summary>
		### Method summary
		### </summary>
		### <param name="hData">Hash</param>
		### <param name="hRet">Hash</param>
		### <remarks>
		### Test
		### </remarks>
		### <returns>
		### Returns description
		### </returns>
		@case_submit[hData;hRet]
		*/
		// build header
		let summary = doc.childNamed("summary");
		let remarks = doc.childNamed("remarks");
		let returns = doc.childNamed("returns");
		let parameters = doc.childrenNamed("param");

		if(summary){
			ret.Summary = summary.val;
		}
		if(remarks){
			ret.Remarks = remarks.val;
		}
		if(returns){
			ret.Returns = returns.val;
		}
		if(parameters && parameters.length !== 0){
			let paramMap = new Map<string,string>();
			parameters.forEach(param=>{
				let variableName = param.attr["name"];
				let variableDescription = param.val;
				paramMap.set(variableName, variableDescription);
			});

			ret.ParemterDescriptions = paramMap;
		}
		return ret;
	}

	private GetDocumentationFromDocumentingHeader(symbol : Symbol) : vscode.MarkdownString{
		let ret = new vscode.MarkdownString();

		let documentText = symbol.Document.getText();

		let indexOfMethodDecalaration = documentText.indexOf("@"+symbol.ClearName);

		if(indexOfMethodDecalaration === -1){
			ret.appendText("No method '"+symbol.ClearName+"' declaration found in current document.");
			return ret;
		}
		
		let header = this.GetDocumentingHeader(documentText, indexOfMethodDecalaration);

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