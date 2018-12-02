import Foundation

import SDGWeb

internal let repositoryStructure: SDGWeb.RepositoryStructure = {
    var url = URL(fileURLWithPath: #file) // The URL of this file.
    for _ in 1 ... 4 {
        url.deleteLastPathComponent() // Back out 4 directories to the repository root.
    }
    return SDGWeb.RepositoryStructure(root: url)
}()

extension SDGWeb.RepositoryStructure {

    var externalResourcesDirectory: URL {
        return root.deletingLastPathComponent()
    }
}
