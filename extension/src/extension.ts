'use strict';
// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
import * as vscode from 'vscode';

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
		//vscode.window.showInformationMessage('Inputterd: ' + userInput); // show message window
		
		//let selection = editor.selection;
		//let text = editor.document.getText(selection);

		let sel = editor.selections;
		
		vscode.TextEdit.insert(new vscode.Position(0, 0), "Your advertisement here");
	});

	context.subscriptions.push(addDocumentingHeaderCommand);
}

// this method is called when your extension is deactivated
export function deactivate() {
}