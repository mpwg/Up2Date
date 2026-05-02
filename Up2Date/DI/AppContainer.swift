struct AppContainer: Sendable {
    let updateManager: UpdateManager
    let sources: [any UpdateSource]
    let logger: any Logger
    let shellClient: any ShellClient
    let fileSystemClient: any FileSystemClient

    init(
        updateManager: UpdateManager,
        sources: [any UpdateSource],
        logger: any Logger,
        shellClient: any ShellClient,
        fileSystemClient: any FileSystemClient
    ) {
        self.updateManager = updateManager
        self.sources = sources
        self.logger = logger
        self.shellClient = shellClient
        self.fileSystemClient = fileSystemClient
    }

    static func live() -> AppContainer {
        let logger = OSLogger()
        let shellClient = ProcessShellClient()
        let fileSystemClient = LocalFileSystemClient()
        let sources: [any UpdateSource] = [
            AppStoreSource(logger: logger),
            SparkleSource(fileSystem: fileSystemClient, logger: logger),
            BrewSource(shell: shellClient, fileSystem: fileSystemClient, logger: logger)
        ]

        return AppContainer(
            updateManager: UpdateManager(sources: sources),
            sources: sources,
            logger: logger,
            shellClient: shellClient,
            fileSystemClient: fileSystemClient
        )
    }
}
