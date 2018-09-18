import Foundation

import SDGCornerstone

ProcessInfo.applicationIdentifier = "ca.lacc.Website"

do {
    try FileManager.default.removeItem(at: RepositoryStructure.resultDirectory)
} catch let error {
    if FileManager.default.fileExists(atPath: RepositoryStructure.resultDirectory.path) {
        fatalError("Failed to clean (empty) result directory: \(error)")
    }
}

for templateLocation in RepositoryStructure.allTemplatePages {
    let relativePath = templateLocation.path(relativeTo: RepositoryStructure.pagesDirectory)
    let resultLocation = RepositoryStructure.resultDirectory.appendingPathComponent(relativePath)
    
    let template = PageTemplate(from: templateLocation)
    template.writeResult(to: resultLocation)
}

do {
    print("Copying CSS...")
    try FileManager.default.copy(RepositoryStructure.templateDirectory.appendingPathComponent("CSS"), to: RepositoryStructure.resultDirectory.appendingPathComponent("CSS"))
} catch let error {
    fatalError("\(error)")
}

let sermonResources = RepositoryStructure.externalResourcesDirectory.appendingPathComponent("Sermons")
do {
    print("Copying sermons...")
    try FileManager.default.copy(sermonResources, to: RepositoryStructure.resultDirectory.appendingPathComponent("Sermons"))
} catch let error {
    if (try? sermonResources.checkResourceIsReachable()) ≠ true {
        print("Warning: Sermons are unavailable.")
    } else {
        fatalError("\(error)")
    }
}

let imageResources = RepositoryStructure.externalResourcesDirectory.appendingPathComponent("Images")
do {
    print("Copying images...")
    try FileManager.default.copy(imageResources, to: RepositoryStructure.resultDirectory.appendingPathComponent("Images"))
} catch let error {
    if (try? imageResources.checkResourceIsReachable()) ≠ true {
        print("Warning: Images are unavailable.")
    } else {
        fatalError("\(error)")
    }
}

_ = try? Shell.default.run(command: ["open", RepositoryStructure.resultDirectory.appendingPathComponent("index.html").path])
