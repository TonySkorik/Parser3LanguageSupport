'use strict';
// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
import * as vscode from 'vscode';
import { Config } from './Config';

//==================================================================================================

function GetCurrentString(editor : vscode.TextEditor, selection : vscode.Selection){
	let lineSelection = selection.end.translate(0,10000);
	return editor.document.getText(new vscode.Selection(selection.start, lineSelection)).trim();
}

function ExpandSelection(selection:vscode.Selection){
	let nextLine = selection.end.translate(1,0);
	return new vscode.Selection(selection.start, nextLine);
}

function InsertNewLine(editor : vscode.TextEditor, selection : vscode.Selection){
	let newLineSnippet = new vscode.SnippetString("\n");
	editor.insertSnippet(newLineSnippet,selection.start);
}

async function GetInputFromUser(descriptiveMessage : string, placeholder:string){
	let userInput = await vscode.window.showInputBox({
		prompt:descriptiveMessage,
		placeHolder:placeholder
	});
	if(userInput === undefined){
		return placeholder;
	}
	return userInput;
}

function GetMethodArguments(signatureString:string){
	let foundArguments : string[] = [];
	
	let pattern = /@\w+\[([^\[]*)\]/;

	let results = pattern.exec(signatureString);
	
	if(results !== null){
		results.forEach(r=>{
			let parts = r.split(";");
			parts.forEach(p=>{
				foundArguments.push(p);
			});			
		});
	}	

	return foundArguments;
}

function AnalyzeArgumentType(argumentName : string){
	
	return argumentName;
}

async function InsertDocumentingComment(editor : vscode.TextEditor, isInsertRemarks:boolean=false){
	let selection = editor.selection;

	let isForceCursorOnLineStart = Config.getIsForceCursorOnLineStart;

	if(isForceCursorOnLineStart){
		editor.selection = new vscode.Selection(new vscode.Position(selection.start.line,0),new vscode.Position(selection.start.line,0));
		selection = editor.selection;			
	}

	if(selection.start.character !== 0){
		vscode.window.showErrorMessage('Selection should start at the beginning of the line.');
		return false;
	}

	if(selection.isSingleLine){
		let computedSelection = selection;

		let possibleSignature = GetCurrentString(editor, computedSelection);
		let cursorOffset = 0;

		if(possibleSignature === ""){
			computedSelection = ExpandSelection(computedSelection);
			possibleSignature = GetCurrentString(editor, computedSelection);
			cursorOffset = cursorOffset + 1;
		}

		if(possibleSignature==="" || !possibleSignature.startsWith("@")){
			vscode.window.showErrorMessage('Unable to find method signature. Signature should be on the cursor line or on the next one and start with @-sign.');
			return false;
	   	}
		
		console.log("Non-empty string found on the "+cursorOffset+" line after cursor");

		if(cursorOffset===0){
			// means that cursor stands directly on signature
			InsertNewLine(editor, computedSelection);						
		}

		let methodArguments = GetMethodArguments(possibleSignature);

		// insert main snippet
		let methodSymmary = await GetInputFromUser("Please provide method summary.","Method summary");
		let mainSnippetString = new vscode.SnippetString("### <summary>\n### "+methodSymmary+"\n### </summary>");
		await editor.insertSnippet(mainSnippetString,computedSelection.start);

		//insert argument snippets
		// if(methodArguments.length>0){
		// 	InsertNewLine(editor,editor.selection);

		// 	methodArguments.forEach(async arg => {
		// 		let paramDescription = await GetInputFromUser("Please provide description fo method argument "+arg, AnalyzeArgumentType(arg));

		// 		let paramSnippetString = new vscode.SnippetString("### <param name=\""+arg+"\">"+paramDescription+"</param>\n");	
		// 		await editor.insertSnippet(paramSnippetString,editor.selection.active.translate(1,0));
		//  	});
		// }
		
		// insert remarks snippet
		if(isInsertRemarks){
			let remarksSnippetString = new vscode.SnippetString("### <remarks>\n### ${1:remarksText}\n### </remarks>\n");
			await editor.insertSnippet(remarksSnippetString,editor.selection.active.translate(1,0));
		}

		return true;
	}else{
		vscode.window.showErrorMessage('Unable to place comment on multiline selection. Please deselect text.');
		return false;
	}
	return false;
}

//==================================================================================================

// this method is called when your extension is activated
// your extension is activated the very first time the command is executed
export function activate(context: vscode.ExtensionContext) {

    // Use the console to output diagnostic information (console.log) and errors (console.error)
    // This line of code will only be executed once when your extension is activated
    console.log('Parser3 Extended Language Support extension is now active!');

	let addDocumentingHeaderCommand = vscode.commands.registerCommand("extension.addDocumentingComment", async ()=>{
		let editor = vscode.window.activeTextEditor;
		
		if (!editor) {
			vscode.window.showWarningMessage("Open a file first to insert comments.");
			return; // No open text editor
		}

		InsertDocumentingComment(editor);
	});

	let addDocumentingHeaderWithRemarksCommand = vscode.commands.registerCommand("extension.addDocumentingCommentWithRemarks", async ()=>{
		let editor = vscode.window.activeTextEditor;
		
		if (!editor) {
			vscode.window.showWarningMessage("Open a file first to insert comments.");
			return; // No open text editor
		}

		InsertDocumentingComment(editor, true);
	});

	context.subscriptions.push(addDocumentingHeaderCommand);
	context.subscriptions.push(addDocumentingHeaderWithRemarksCommand);
}

// this method is called when your extension is deactivated
export function deactivate() {
}
