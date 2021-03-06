'use strict';

import * as vscode from 'vscode';
import { Config } from './Config';
import { EditorHelper } from './EditorHelper';

export class DocumentationHelper {
	public async InsertDocumentingComment(editor : vscode.TextEditor, isInsertRemarks:boolean=false):Promise<boolean>{
		let selection = editor.selection;
	
		if(Config.IsForceCursorOnLineStart){
			selection = EditorHelper.MoveCursorToTheLineStart(editor, selection);
		}
	
		if(selection.start.character !== 0){
			vscode.window.showErrorMessage('Selection should start at the beginning of the line.');
			return false;
		}
	
		if(selection.isSingleLine){
			let computedSelection = selection;
	
			let possibleSignature = EditorHelper.GetCurrentString(editor, computedSelection);
			let cursorOffset = 0;
	
			if(possibleSignature === ""){
				computedSelection = EditorHelper.ExpandSelection(computedSelection);
				possibleSignature = EditorHelper.GetCurrentString(editor, computedSelection);
				cursorOffset = cursorOffset + 1;
			}
	
			if(possibleSignature==="" || !possibleSignature.startsWith("@")){
				vscode.window.showErrorMessage('Unable to find method signature. Signature should be on the cursor line or on the next one and start with @-sign.');
				return false;
			}
				
			if(cursorOffset===0){
				// means that cursor stands directly on signature
				EditorHelper.InsertNewLine(editor, computedSelection);						
			}
	
			let methodArguments = EditorHelper.GetMethodArguments(possibleSignature);
	
			// insert main snippet
			let methodSummary = await EditorHelper.GetInputFromUser("Please provide method summary.","Method summary");
			let mainSnippetString = new vscode.SnippetString("### <summary>\n### "+methodSummary+"\n### </summary>");
			await editor.insertSnippet(mainSnippetString,computedSelection.start);
	
			//insert argument snippets
			if(methodArguments.length>0){
				for(let i=0; i<methodArguments.length; i++){
					let arg = methodArguments[i];
					EditorHelper.InsertNewLine(editor,editor.selection);
					
					let paramDescription = await EditorHelper.GetInputFromUser(
						"Please provide description for method argument "+arg, 
						arg
					);
	
					let paramSnippetString = new vscode.SnippetString("### <param name=\""+arg+"\">"+paramDescription+"</param>");	
					await editor.insertSnippet(paramSnippetString,editor.selection.active);
				}
			}
			
			// insert returns snippet
			let returnsString = await EditorHelper.GetInputFromUser("Please provide method return description.","Method returns");
			let returnsSnippetString = new vscode.SnippetString("\n### <returns>\n### "+returnsString+"\n### </returns>");
			await editor.insertSnippet(returnsSnippetString,editor.selection.active);

			// insert remarks snippet
			if(isInsertRemarks){
				let remarksSnippetString = new vscode.SnippetString("\n### <remarks>\n### ${1:remarksText}\n### </remarks>");
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


