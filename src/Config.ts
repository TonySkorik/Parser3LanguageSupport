'use strict';

import { workspace } from 'vscode';

export class Config {

    public static get Configuration() {
        return workspace.getConfiguration('parser3ext.settings');
    }

    private static GetSettings<T>(val: string): T {
        return Config.Configuration.get(val) as T;
    }

    public static get IsForceCursorOnLineStart(): boolean {
        return Config.GetSettings<boolean>('forceCursorOnTheLineStart');
	}

	public static get AllowedEmptyLinesCount(): number {
        return Config.GetSettings<number>('allowedEmptyLinesCount');
	}
}