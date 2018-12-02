import Foundation

import SDGCornerstone
import SDGWeb

ProcessInfo.applicationIdentifier = "ca.lacc.Website"

let site = Site<Localization>(
    repositoryStructure: repositoryStructure,
    domain: domain,
    pageProcessor: LACCPageProcessor(),
    reportProgress: { print($0) })

try site.generate()

let sermonResources = repositoryStructure.externalResourcesDirectory.appendingPathComponent("Sermons")
do {
    print("Copying sermons...")
    try FileManager.default.copy(sermonResources, to: repositoryStructure.result.appendingPathComponent("Sermons"))
} catch let error {
    if (try? sermonResources.checkResourceIsReachable()) ≠ true {
        print("Warning: Sermons are unavailable.")
    } else {
        fatalError("\(error)")
    }
}

let imageResources = repositoryStructure.externalResourcesDirectory.appendingPathComponent("Images")
do {
    print("Copying images...")
    try FileManager.default.copy(imageResources, to: repositoryStructure.result.appendingPathComponent("Images"))
} catch let error {
    if (try? imageResources.checkResourceIsReachable()) ≠ true {
        print("Warning: Images are unavailable.")
    } else {
        fatalError("\(error)")
    }
}

_ = try? Shell.default.run(command: ["open", repositoryStructure.result.appendingPathComponent("index.html").path])
