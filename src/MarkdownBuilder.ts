'use strict';

import * as vscode from 'vscode';
import { DocumentingHeader } from './Parser3HoverProvider';

export class MarkdownBuilder{

	public BuildMarkdown(header: DocumentingHeader):vscode.MarkdownString{
		let ret = new vscode.MarkdownString();

		/* header example
		<summary>Method summary</summary>
		<param name="hData">Hash</param>
		<param name="hRet">Hash</param>
		<remarks>Test</remarks>
		<returns>Returns description</returns>
		*/		

		if(header.Summary){
			ret.appendMarkdown("**Summary** : "+header.Summary);
			ret.appendText("\n");
			ret.appendMarkdown("___");
			ret.appendText("\n");
		}
		if(header.ParemterDescriptions && header.ParemterDescriptions.length !== 0){
			header.ParemterDescriptions.forEach(kv=>{
				ret.appendMarkdown("— **"+kv.Key+"** : "+kv.Value);
				ret.appendText("\n");
				ret.appendText("\n");
			});
		}
		if(header.Remarks){
			ret.appendText("\n");
			ret.appendMarkdown("___");
			ret.appendText("\n");
			ret.appendMarkdown("**Remarks** : "+header.Remarks);
			ret.appendText("\n");
		}
		if(header.Returns){
			ret.appendText("\n");
			ret.appendMarkdown("___");
			ret.appendText("\n");
			ret.appendMarkdown("**Returns** : "+header.Returns);
			ret.appendText("\n");
		}

		return ret;
	}
}