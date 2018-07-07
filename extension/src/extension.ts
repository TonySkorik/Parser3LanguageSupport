'use strict';
// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
import * as vscode from 'vscode';
import { DocumentationHelper } from './DocumentationHelper';
import { Parser3DefinitionProvider } from './Parser3DefinitionProvider';

//==================================================================================================

// this method is called when your extension is activated
// your extension is activated the very first time the command is executed
export function activate(context: vscode.ExtensionContext) {

    // Use the console to output diagnostic information (console.log) and errors (console.error)
    // This line of code will only be executed once when your extension is activated
    console.log('Parser3 Extended Language Support extension is now active!');

	var documentationHelper = new DocumentationHelper();

	let addDocumentingHeaderCommand = vscode.commands.registerCommand("extension.addDocumentingComment", ()=>{
		let editor = vscode.window.activeTextEditor;
		
		if (!editor) {
			vscode.window.showWarningMessage("Open a file first to insert comments.");
			return; // No open text editor
		}

		documentationHelper.InsertDocumentingComment(editor);
	});

	let addDocumentingHeaderWithRemarksCommand = vscode.commands.registerCommand("extension.addDocumentingCommentWithRemarks", ()=>{
		let editor = vscode.window.activeTextEditor;
		
		if (!editor) {
			vscode.window.showWarningMessage("Open a file first to insert comments.");
			return; // No open text editor
		}

		documentationHelper.InsertDocumentingComment(editor, true);
	});

	// commands
	context.subscriptions.push(addDocumentingHeaderCommand);
	context.subscriptions.push(addDocumentingHeaderWithRemarksCommand);

	// definition provider
	const P3_MODE: vscode.DocumentFilter = { language: 'parser3ext', scheme: '*' };

	let definitionProvider = vscode.languages.registerDefinitionProvider(P3_MODE, new Parser3DefinitionProvider());
	context.subscriptions.push(definitionProvider);
}

// this method is called when your extension is deactivated
export function deactivate() {
}
