'use strict';

import * as vscode from 'vscode';
import { Config } from './Config';

export class EditorHelper{
	public static GetCurrentString(editor : vscode.TextEditor, selection : vscode.Selection):string{
		let lineSelection = selection.end.translate(0,10000);
		return editor.document.getText(new vscode.Selection(selection.start, lineSelection)).trim();
	}
	
	public static ExpandSelection(selection:vscode.Selection):vscode.Selection{
		let nextLine = selection.end.translate(1,0);
		return new vscode.Selection(selection.start, nextLine);
	}
	
	public static InsertNewLine(editor : vscode.TextEditor, selection : vscode.Selection):void{
		let newLineSnippet = new vscode.SnippetString("\n");
		editor.insertSnippet(newLineSnippet,selection.start);
	}
	
	public static MoveCursorToTheLineStart(editor: vscode.TextEditor, selection : vscode.Selection):vscode.Selection{
		editor.selection = new vscode.Selection(new vscode.Position(selection.start.line,0),new vscode.Position(selection.start.line,0));
		return editor.selection;
	}

	public static GetSelectionAtTheLineStart(editor: vscode.TextEditor, selection : vscode.Selection):vscode.Selection{
		return new vscode.Selection(new vscode.Position(selection.start.line,0),new vscode.Position(selection.start.line,0));
	}
	
	public static async GetInputFromUser(descriptiveMessage : string, placeholder:string):Promise<string>{
		let userInput = await vscode.window.showInputBox({
			prompt:descriptiveMessage,
			placeHolder:placeholder
		});
		if(userInput === undefined || userInput === ""){
			return placeholder;
		}
		return userInput;
	}
	
	public static GetMethodArguments(signatureString:string):string[]{
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
}