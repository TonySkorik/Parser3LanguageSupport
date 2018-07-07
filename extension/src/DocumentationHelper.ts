'use strict';

import * as vscode from 'vscode';
import { Config } from './Config';

export class DocumentationHelper {

	private GetCurrentString(editor : vscode.TextEditor, selection : vscode.Selection){
		let lineSelection = selection.end.translate(0,10000);
		return editor.document.getText(new vscode.Selection(selection.start, lineSelection)).trim();
	}
	
	private ExpandSelection(selection:vscode.Selection){
		let nextLine = selection.end.translate(1,0);
		return new vscode.Selection(selection.start, nextLine);
	}
	
	private InsertNewLine(editor : vscode.TextEditor, selection : vscode.Selection){
		let newLineSnippet = new vscode.SnippetString("\n");
		editor.insertSnippet(newLineSnippet,selection.start);
	}
	
	private MoveCursorToTheLineStart(editor: vscode.TextEditor, selection : vscode.Selection){
		editor.selection = new vscode.Selection(new vscode.Position(selection.start.line,0),new vscode.Position(selection.start.line,0));
		return editor.selection;
	}
	
	private async GetInputFromUser(descriptiveMessage : string, placeholder:string){
		let userInput = await vscode.window.showInputBox({
			prompt:descriptiveMessage,
			placeHolder:placeholder
		});
		if(userInput === undefined || userInput === ""){
			return placeholder;
		}
		return userInput;
	}
	
	private GetMethodArguments(signatureString:string){
		let foundArguments : string[] = [];
		
		let pattern = /@\w+\[([^\[]*)\]/;
	
		let results = pattern.exec(signatureString);
		
		if(results !== null){
			results.shift();
			results.forEach(r=>{
				let parts = r.split(";");
				parts.forEach(p=>{
					foundArguments.push(p);
				});			
			});
		}	
	
		return foundArguments;
	}
	
	private AnalyzeArgumentType(argumentName : string){
		if(argumentName.startsWith("is")){
			return "Boolean";
		}
		switch(argumentName.substr(0,1)){
			case "h":
				return "Hash";
			case "t":
				return "Table";
			case "b":
				return "Boolean";
			case "i":
				return "Integer";
			default :
				return argumentName;		
		}
	}
	
	public async InsertDocumentingComment(editor : vscode.TextEditor, isInsertRemarks:boolean=false){
		let selection = editor.selection;
	
		if(Config.getIsForceCursorOnLineStart){
			selection = this.MoveCursorToTheLineStart(editor, selection);
		}
	
		if(selection.start.character !== 0){
			vscode.window.showErrorMessage('Selection should start at the beginning of the line.');
			return false;
		}
	
		if(selection.isSingleLine){
			let computedSelection = selection;
	
			let possibleSignature = this.GetCurrentString(editor, computedSelection);
			let cursorOffset = 0;
	
			if(possibleSignature === ""){
				computedSelection = this.ExpandSelection(computedSelection);
				possibleSignature = this.GetCurrentString(editor, computedSelection);
				cursorOffset = cursorOffset + 1;
			}
	
			if(possibleSignature==="" || !possibleSignature.startsWith("@")){
				vscode.window.showErrorMessage('Unable to find method signature. Signature should be on the cursor line or on the next one and start with @-sign.');
				return false;
			   }
			
			console.log("Non-empty string found on the "+cursorOffset+" line after cursor");
	
			if(cursorOffset===0){
				// means that cursor stands directly on signature
				this.InsertNewLine(editor, computedSelection);						
			}
	
			let methodArguments = this.GetMethodArguments(possibleSignature);
	
			// insert main snippet
			let methodSymmary = await this.GetInputFromUser("Please provide method summary.","Method summary");
			let mainSnippetString = new vscode.SnippetString("### <summary>\n### "+methodSymmary+"\n### </summary>");
			await editor.insertSnippet(mainSnippetString,computedSelection.start);
	
			//insert argument snippets
			if(methodArguments.length>0){
				for(let i=0; i<methodArguments.length; i++){
					let arg = methodArguments[i];
					this.InsertNewLine(editor,editor.selection);
					let paramDescription = await this.GetInputFromUser("Please provide description fo method argument "+arg, this.AnalyzeArgumentType(arg));
	
					let paramSnippetString = new vscode.SnippetString("### <param name=\""+arg+"\">"+paramDescription+"</param>");	
					await editor.insertSnippet(paramSnippetString,editor.selection.active);
				}
			}
			
			// insert remarks snippet
			if(isInsertRemarks){
				this.InsertNewLine(editor,editor.selection);
				let remarksSnippetString = new vscode.SnippetString("### <remarks>\n### ${1:remarksText}\n### </remarks>");
				await editor.insertSnippet(remarksSnippetString,editor.selection.active);
			}
	
			return true;
		}else{
			vscode.window.showErrorMessage('Unable to place comment on multiline selection. Please deselect text.');
			return false;
		}
		return false;
	}
}


