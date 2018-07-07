Configuration manifest description:

"configuration": {
	"title": "Parser3 Language Support Config",
	"properties": {
		"paresr3ext.settings.moveCursorOnTheFirstLine": {
			"type": "boolean",
			"default": true,
			"description": "Move the cursor on the first line upon InsertDocumentingHeaderInvocation. If set to false and invoked - the warning will be displayed and nothing happens."
		},
		"liveServer.settings.port": {
			"type": [
				"number"
			],
			"default": 5500,
			"minimum": 0,
			"maximum": 65535,
			"description": "Set Custom Port Number of Live Server. Set 0 if you want random port."
		},
		"liveServer.settings.root": {
			"type": [
				"string"
			],
			"default": "/",
			"pattern": "/|/[^\\/]",
			"description": "Set Custom root of Live Server. \nTo change root the the server to sub folder of workspace, use '/' and relative path from workspace. \nExample: /subfolder1/subfolder2"
		},
		"liveServer.settings.CustomBrowser": {
			"type": [
				"string",
				"null"
			],
			"default": null,
			"enum": [
				"chrome",
				"chrome:PrivateMode",
				"firefox",
				"firefox:PrivateMode",
				"microsoft-edge",
				"blisk",
				null
			],
			"description": "Specify custom browser settings for Live Server. \nBy Default it will open your default favorite browser."
		},
		"liveServer.settings.ChromeDebuggingAttachment": {
			"type": [
				"boolean"
			],
			"default": false,
			"description": "Enable Chrome Debugging Attachment to Live Server at Debuging Port 9222.\n NOTE: You have to install 'Debugger for Chrome' \nIf the value is true, Select 'Attach to Chrome' from Debug Window to start debugging. \n\n CAUTION: If it is true, 'Launch Chrome against localhost' may not work."
		},
		"liveServer.settings.mount": {
			"type": "array",
			"items": {
				"type": "array",
				"minItems": 2,
				"maxItems": 2,
				"items": {
					"type": "string"
				}
			},
			"default": [],
			"description": "Mount a directory to a route. Such as [['/components', './node_modules']]"
		},
		"liveServer.settings.proxy": {
			"type": "object",
			"default": {
				"enable": false,
				"baseUri": "/",
				"proxyUri": "http://127.0.0.1:80"
			},
			"properties": {
				"enable": {
					"type": "boolean",
					"default": false,
					"description": "Make it true to enable the feature."
				},
				"baseUri": {
					"type": "string",
					"default": "/",
					"pattern": ""
				},
				"proxyUri": {
					"type": "string",
					"default": "http://127.0.0.1:80",
					"pattern": "(^http[s]?://)(.[^(\\|\\s)]+)$"
				}
			},
			"required": [
				"enable",
				"baseUri",
				"proxyUri"
			],
			"additionalProperties": false,
			"description": "To Setup Proxy"
		}
	}
},

