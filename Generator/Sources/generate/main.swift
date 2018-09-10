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
do {
    print("Copying sermons...")
    try FileManager.default.copy(RepositoryStructure.externalResourcesDirectory.appendingPathComponent("Sermons"), to: RepositoryStructure.resultDirectory.appendingPathComponent("Sermons"))
} catch let error {
    fatalError("\(error)")
}
do {
    print("Copying images...")
    try FileManager.default.copy(RepositoryStructure.externalResourcesDirectory.appendingPathComponent("Images"), to: RepositoryStructure.resultDirectory.appendingPathComponent("Images"))
} catch let error {
    fatalError("\(error)")
}
_ = try? Shell.default.run(command: ["open", RepositoryStructure.resultDirectory.appendingPathComponent("index.html").path])
