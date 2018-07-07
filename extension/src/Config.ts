'use strict';

import { workspace } from 'vscode';

export class Config {

    public static get configuration() {
        return workspace.getConfiguration('parser3ext.settings');
    }

    private static getSettings<T>(val: string): T {
        return Config.configuration.get(val) as T;
    }

    public static get getIsForceCursorOnLineStart(): boolean {
        return Config.getSettings<boolean>('forceCursorOnTheLineStart');
	}
}