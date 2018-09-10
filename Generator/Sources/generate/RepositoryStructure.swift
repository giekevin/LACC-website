import Foundation

enum RepositoryStructure {
    
    private static let repositoryRoot: URL = {
        var url = URL(fileURLWithPath: #file) // The URL of this file.
        for _ in 1 ... 4 {
            url.deleteLastPathComponent() // Back out 4 directories to the repository root.
        }
        return url
    }()
    
    static let templateDirectory = repositoryRoot.appendingPathComponent("Template")
    static let externalResourcesDirectory = repositoryRoot.deletingLastPathComponent()
    static let resultDirectory = repositoryRoot.appendingPathComponent("Result")
    
    static let pagesDirectory = templateDirectory.appendingPathComponent("Pages")
    static let componentsDirectory = templateDirectory.appendingPathComponent("Components")
    
    static let allTemplatePages: [URL] = {
        let enumerator = FileManager.default.enumerator(at: pagesDirectory, includingPropertiesForKeys: [], options: [], errorHandler: { (_, error: Error) -> Bool in
            fatalError("Failed to enumerate pages: \(error)")
        }) ?? { () -> FileManager.DirectoryEnumerator in
            fatalError("Failed create file enumerator.")
            
            }()
        
        var list: [URL] = []
        for object in enumerator {
            guard let url = object as? URL else {
                fatalError("Object is not a URL: \(object)")
            }
            if url.lastPathComponent.hasSuffix(".html") {
                list.append(url)
            }
        }
        return list
    }()
}
