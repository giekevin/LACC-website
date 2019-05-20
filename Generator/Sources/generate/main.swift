import Foundation

import SDGLogic
import SDGCornerstone
import SDGWeb
import SDGCommandLine

ProcessInfo.applicationIdentifier = "ca.lacc.Website"

let site = Site<Localization>(
    repositoryStructure: repositoryStructure,
    domain: domain,
    localizationDirectories: localizatonDirectory,
    pageProcessor: LACCPageProcessor(),
    reportProgress: { print($0) })

try site.generate().get()

let sermonResources = repositoryStructure.externalResourcesDirectory.appendingPathComponent("Sermons")
var sermonsUnavailable = false
do {
    print("Copying sermons...")
    try FileManager.default.copy(sermonResources, to: repositoryStructure.result.appendingPathComponent("Sermons"))
} catch let error {
    if (try? sermonResources.checkResourceIsReachable()) ≠ true {
        print("Warning: Sermons are unavailable.")
        sermonsUnavailable = true
    } else {
        fatalError("\(error)")
    }
}

let imageResources = repositoryStructure.externalResourcesDirectory.appendingPathComponent("Images")
var imagesUnavailable = false
do {
    print("Copying images...")
    try FileManager.default.copy(imageResources, to: repositoryStructure.result.appendingPathComponent("Images"))
} catch let error {
    if (try? imageResources.checkResourceIsReachable()) ≠ true {
        print("Warning: Images are unavailable.")
        imagesUnavailable = true
    } else {
        fatalError("\(error)")
    }
}

print("Validating...")
for (file, errors) in site.validate().sorted(by: { $0.0 < $1.0 }) {
    print(file.path(relativeTo: repositoryStructure.result).in(FontWeight.bold))
    for error in errors {
        let description = error.localizedDescription
        if (sermonsUnavailable ∧ description.contains("src=\u{22}Sermons/"))
            ∨ (imagesUnavailable ∧ description.contains("/Images/"))
            ∨ (description.contains("\nhref=\u{22}mailto:")) {
            // Ignore
        } else {
            print(error.localizedDescription.formattedAsError())
            print("")
        }
    }
}

_ = try? Shell.default.run(command: ["open", repositoryStructure.result.appendingPathComponent("index.html").path]).get()
