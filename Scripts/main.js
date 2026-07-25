let langClient = null;
let configWatchers = null;
let isRestarting = false;

exports.activate = function() {
	// 1. Initialize our CompositeDisposable to hold configuration watchers
	configWatchers = new CompositeDisposable();
	
	// 2. Start the Language Server
	startLanguageServer();
	
	// 3. Set up listeners to watch for configuration changes
	setupConfigurationWatchers();
}

exports.deactivate = function() {
	// Clean up the language client
	if (langClient) {
		langClient.stop();
		nova.subscriptions.remove(langClient);
		langClient = null;
	}
	
	// Clean up all configuration watchers
	if (configWatchers) {
		configWatchers.dispose();
		configWatchers = null;
	}
}

async function startLanguageServer() {
	// If a restart is already in progress, ignore subsequent triggers
	if (isRestarting) return;
	isRestarting = true;

	if (langClient) {
		langClient.stop();
		nova.subscriptions.remove(langClient);
		langClient = null;
		
		await new Promise(resolve => setTimeout(resolve, 1500));
	}

	let juliaPath = nova.workspace.config.get("julia.executablePath") || 
					nova.config.get("julia.executablePath") || 
					"julia";

	let workspacePath = nova.workspace.path || "";
	
	// 1. We remove the --project flag so Julia boots in its default/global environment.
	// 2. We pass the workspacePath directly into runserver() so the LSP indexes the local project 
	//    without colliding with its dependencies.
	let serverArgs = [
		"--startup-file=no",
		"--history-file=no",
		"--depwarn=no",
		"-e",
		`using LanguageServer; runserver(stdin, stdout, "${workspacePath}")`
	];

	let serverOptions = {
		path: juliaPath,
		args: serverArgs,
		type: "stdio" 
	};

	let clientOptions = {
		syntaxes: ["julia"]
	};

	langClient = new LanguageClient(
		"julia-lsp",
		"Julia Language Server",
		serverOptions,
		clientOptions
	);

	langClient.onDidStop((error) => {
		if (error) {
			let request = new NotificationRequest("Julia Language Server failed to start");
			request.title = "Julia Language Server"
			request.body = `Julia Language Server failed to start. Error: ${error}`
			nova.notifications.add(request);
		}
	});

	try {
		langClient.start();
		nova.subscriptions.add(langClient);
		console.log(`Julia Language Server started. Indexing environment: ${workspacePath || "Global"}`);
		
		syncConfiguration();
	} catch (err) {
		console.error("Failed to start Julia LSP:", err);
	} finally {
		// 4. Release the lock so the server can be restarted again in the future
		isRestarting = false;
	}
}

// Packages all relevant Extension configurations into the JSON structure expected by LanguageServer.jl
function getJuliaSettings() {
	return {
		julia: {
			lint: {
				missingrefs: nova.workspace.config.get("julia.lint.missingrefs") ?? nova.config.get("julia.lint.missingrefs"),
				call: nova.workspace.config.get("julia.lint.call") ?? nova.config.get("julia.lint.call"),
				iter: nova.workspace.config.get("julia.lint.iter") ?? nova.config.get("julia.lint.iter"),
				nothingcomp: nova.workspace.config.get("julia.lint.nothingcomp") ?? nova.config.get("julia.lint.nothingcomp"),
				constif: nova.workspace.config.get("julia.lint.constif") ?? nova.config.get("julia.lint.constif"),
				lazy: nova.workspace.config.get("julia.lint.lazy") ?? nova.config.get("julia.lint.lazy"),
				datadecl: nova.workspace.config.get("julia.lint.datadecl") ?? nova.config.get("julia.lint.datadecl"),
				typeparam: nova.workspace.config.get("julia.lint.typeparam") ?? nova.config.get("julia.lint.typeparam"),
				modname: nova.workspace.config.get("julia.lint.modname") ?? nova.config.get("julia.lint.modname"),
				pirates: nova.workspace.config.get("julia.lint.pirates") ?? nova.config.get("julia.lint.pirates"),
				useoffuncargs: nova.workspace.config.get("julia.lint.useoffuncargs") ?? nova.config.get("julia.lint.useoffuncargs"),
				run: nova.workspace.config.get("julia.lint.run") ?? nova.config.get("julia.lint.run")
			},
			inlayHints: {
				static: { 
					enabled: nova.workspace.config.get("julia.inlayHints.static.enabled") ?? nova.config.get("julia.inlayHints.static.enabled") 
				}
			}
		}
	};
}

function setupConfigurationWatchers() {
	// 1. Watch for executable path changes. If this changes, we MUST fully restart the server.
	configWatchers.add(nova.config.onDidChange("julia.executablePath", startLanguageServer));
	configWatchers.add(nova.workspace.config.onDidChange("julia.executablePath", startLanguageServer));

	// 2. Watch for linting and hint changes. These can be synced dynamically.
	const dynamicallySyncedKeys = [
		"julia.lint.missingrefs", "julia.lint.call", "julia.lint.iter", 
		"julia.lint.nothingcomp", "julia.lint.constif", "julia.lint.lazy",
		"julia.lint.datadecl", "julia.lint.typeparam", "julia.lint.modname",
		"julia.lint.pirates", "julia.lint.useoffuncargs", "julia.lint.run",
		"julia.inlayHints.static.enabled"
	];

	dynamicallySyncedKeys.forEach(key => {
		configWatchers.add(nova.config.onDidChange(key, syncConfiguration));
		configWatchers.add(nova.workspace.config.onDidChange(key, syncConfiguration));
	});
}

function syncConfiguration() {
	if (langClient) {
		// Send a workspace/didChangeConfiguration JSON-RPC notification
		langClient.sendNotification("workspace/didChangeConfiguration", {
			settings: getJuliaSettings()
		});
	}
}

class JuliaTaskAssistant {
	resolveTaskAction(context) {
		let juliaPath = nova.workspace.config.get("julia.executablePath") || 
						nova.config.get("julia.executablePath") || 
						"julia";

		return new nova.TaskProcessAction(juliaPath, {
			args: [context.data.path || nova.workspace.activeTextEditor.document.path],
			env: context.env
		});
	}
}

// Registrations
nova.assistants.registerTaskAssistant(new JuliaTaskAssistant(), { identifier: "julia-tasks" });

nova.commands.register("julia-lsp.restart", (editor) => {
	
	let request = new NotificationRequest("Restarting Julia Language Server...");
	request.title = "Julia Language Server"
	request.body = "Restarting LanguageServer.jl..."
	nova.notifications.add(request);

	startLanguageServer();
});
