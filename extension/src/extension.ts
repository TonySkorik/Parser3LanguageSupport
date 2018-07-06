'use strict';
// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
import * as vscode from 'vscode';

//==================================================================================================

function GetCurrentString(editor:vscode.TextEditor,selection:vscode.Selection){
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

async function InsertCommentOnCurrentOrNextLine(editor : vscode.TextEditor){
	let selection = editor.selection;
	
	if(selection.start.character !== 0){
		vscode.window.showInformationMessage('Selection should start at the beginning of the line.');
		return false;
	}

	if(selection.isSingleLine){
		let computedSelection = selection;

		let possibleSignature = GetCurrentString(editor, selection);
		let cursorOffset = 0;
		while(possibleSignature === "" || computedSelection.end.line > editor.document.lineCount){
			cursorOffset = cursorOffset+1;
			computedSelection = ExpandSelection(computedSelection);
			possibleSignature = GetCurrentString(editor, computedSelection);
		}

		if(cursorOffset===0){
			InsertNewLine(editor, computedSelection);						
		}

		console.log("Non-empty string found on the "+cursorOffset+" line after cursor");

		if(possibleSignature===""){
		 	vscode.window.showInformationMessage('Unable to find method signature. Document is empty from cursor til the end.');
		 	return false;
		}

		// if(!possibleSignature.startsWith("@")){
		// 	vscode.window.showInformationMessage('Unable to find method signature at cursor position or lower.');
		// 	return false;
		// }

		// let methodArguments = GetMethodArguments(possibleSignature);

		// // insert main snippet
		// let mainSnippetString = new vscode.SnippetString("### <summary>\n### ${1:summaryText}\n### </summary>\n");
		// await editor.insertSnippet(mainSnippetString,lastEmptyLine);

		// // insert argument snippets
		// if(methodArguments.length>0){
		// 	methodArguments.forEach(async arg => {
		// 		let paramSnippetString = new vscode.SnippetString("### <param name=\""+arg+"\">${1:paramDescription}</param>\n");	
		// 		await editor.insertSnippet(paramSnippetString,editor.selection.active.translate(1,0));
		// 	});
		// }
		
		// // insert remarks snippet
		// let remarksSnippetString = new vscode.SnippetString("### <remarks>\n### ${1:remarksText}\n### </remarks>\n");
		// await editor.insertSnippet(remarksSnippetString,editor.selection.active.translate(1,0));

		return true;
		//vscode.TextEdit.insert(new vscode.Position(0, 0), "Your advertisement here");		
	}else{
		vscode.window.showInformationMessage('Unable to place comment on multiline selection. Please deselect text.');
		return false;
	}
	return false;
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
			vscode.window.showInformationMessage('Open a file first to insert comments');
			return; // No open text editor
		}

		//let userInput = await vscode.window.showInputBox(); // get input from user
		//let selection = editor.selection;
		//let text = editor.document.getText(selection);

		if(!InsertCommentOnCurrentOrNextLine(editor)){
			vscode.window.showInformationMessage("No method signature found.");
		}
	});

	context.subscriptions.push(addDocumentingHeaderCommand);
}

// this method is called when your extension is deactivated
export function deactivate() {
}
