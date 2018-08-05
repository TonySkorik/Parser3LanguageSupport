'use strict';

import * as vscode from 'vscode';

class BuilderMode {
	public static Summary : string = "<summary>";
	public static EndSummary : string = "</summary>";
	public static Parameter : string = "<param";
	public static Remarks : string = "<remarks>";
	public static EndRemarks : string = "</remarks>";
	public static Returns : string = "<returns>";
	public static EndReturns : string = "</returns>";
	public static Unknown : string = "unknown";
	public static Resume : string = "resume";
}

export class MarkdownBuilder{

	private GetMode(currentString : string): string{
		if(currentString.startsWith(BuilderMode.Summary)){
			return BuilderMode.Summary;
		}
		if(currentString.startsWith(BuilderMode.Remarks)){
			return BuilderMode.Remarks;
		}
		if(currentString.startsWith(BuilderMode.Returns)){
			return BuilderMode.Returns;
		}

		if(currentString.startsWith(BuilderMode.Parameter)){
			return BuilderMode.Parameter;
		}
		if(currentString.startsWith(BuilderMode.EndSummary) 
			|| currentString.startsWith(BuilderMode.EndRemarks)
			|| currentString.startsWith(BuilderMode.EndReturns)){
			return BuilderMode.Unknown;
		}
		return BuilderMode.Resume;
	}	

	public BuildMarkdown(strings : string[]):vscode.MarkdownString{
		let ret = new vscode.MarkdownString();
		
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
		let mode = BuilderMode.Unknown;

		for(let i = 0 ; i<strings.length ; i++){
			let currentString = strings[i].trim();		

			let newMode = this.GetMode(currentString);
			if(newMode !== BuilderMode.Resume){
				mode = newMode;
				if(mode !== BuilderMode.Parameter){
					continue;
				}
			}

			switch(mode){
				case BuilderMode.Summary:
					ret.appendMarkdown("**Summary** : "+currentString +";   ");
					break;
				case BuilderMode.Parameter:
					let paramRegex = /param name="([^"]+)">([^<]*)/;
					let result = paramRegex.exec(currentString);
					if(result === null){
						continue;
					}
					let pramName =  result[1];
					let paramDescription = result[2];
					ret.appendMarkdown("(**"+pramName+"**) : *"+paramDescription+"*;   ");
					break;
				case BuilderMode.Returns:
					ret.appendMarkdown("**Returns** : "+currentString+ ";   ");
					break;
				case BuilderMode.Remarks:
					ret.appendMarkdown("**Remarks** : "+currentString+";   ");
					break;
			}			
		}

		return ret;
	}
}