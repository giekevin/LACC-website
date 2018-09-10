import Foundation

import SDGCornerstone

class PageTemplate {
    
    // MARK: - Initialization
    
    init(from file: URL) {
        let fileName = StrictString(file.lastPathComponent)
        self.fileName = fileName
        
        let relativePath = file.path(relativeTo: RepositoryStructure.pagesDirectory)
        let nestedLevel = relativePath.components(separatedBy: "/").count − 1
        var siteRoot: StrictString = ""
        for _ in 0 ..< nestedLevel {
            siteRoot.append(contentsOf: "../".scalars)
        }
        self.siteRoot = siteRoot
        
        let source = PageTemplate.loadSource(from: file)
        let (metaDataSource, content) = PageTemplate.extractMetaData(from: source, fileName: fileName)
        self.content = content
        let metaData = PageTemplate.parseMetaData(from: metaDataSource)
        
        guard let title = metaData["Title"] else {
            fatalError("“\(file.lastPathComponent)” has not title.")
        }
        self.title = title
    }
    
    private static func loadSource(from file: URL) -> StrictString {
        do {
            return try StrictString(from: file)
        } catch let error {
            fatalError("Failed to load template page “\(file.lastPathComponent)”: \(error)")
        }
    }
    
    private static func extractMetaData(from source: StrictString, fileName: StrictString) -> (metaDataSource: StrictString, content: StrictString) {
        
        guard let metaDataSegment = source.firstNestingLevel(startingWith: "<!--".scalars, endingWith: "-->\n".scalars) else {
            fatalError("“\(fileName)” has no metadata (“<!-- ... -->”).")
        }
        let metaData = StrictString(metaDataSegment.contents.contents)
        
        var content = source
        content.removeSubrange(metaDataSegment.container.range)
        return (metaData, content)
    }
    
    private static func parseMetaData(from source: StrictString) -> [StrictString: StrictString] {
        var dictionary: [StrictString: StrictString] = [:]
        for line in source.lines.map({ $0.line }) {
            let withoutIndent = StrictString(line.drop(while: { $0 ∈ CharacterSet.whitespaces }))
            if ¬withoutIndent.isEmpty {
                guard let colon = withoutIndent.firstMatch(for: ": ".scalars) else {
                    fatalError("Metadata entry missing colon: “\(withoutIndent)”")
                }
                let key = StrictString(withoutIndent[..<colon.range.lowerBound])
                let value = StrictString(withoutIndent[colon.range.upperBound...])
                
                dictionary[key] = value
            }
        }
        return dictionary
    }
    
    // MARK: - Properties
    
    private let fileName: StrictString
    private let siteRoot: StrictString
    private let title: StrictString
    private let content: StrictString
    private var resultCache: StrictString?
    
    // MARK: - Processing
    
    private func processedResult(for relativePath: String) -> StrictString {
        return cached(in: &resultCache) {
            var result: StrictString
            do {
                result = try StrictString(from: RepositoryStructure.componentsDirectory.appendingPathComponent("Frame.html"))
            } catch let error {
                fatalError("\(error)")
            }
            result.replaceMatches(for: "[*Content*]".scalars, with: content)
            
            result.replaceMatches(for: "[*Title*]".scalars, with: title)
            
            result.replaceMatches(for: "[*Site Root*]".scalars, with: siteRoot)
            
            result.replaceMatches(for: "[*Relative Path*]".scalars, with: relativePath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!.scalars)
            
            result.mutateMatches(for: CompositePattern<Unicode.Scalar>([
                LiteralPattern("[*Sermon*]".scalars),
                RepetitionPattern(ConditionalPattern({ _ in true }), consumption: .lazy),
                LiteralPattern("[*End*]".scalars)
                ]), mutation: { (match: PatternMatch<StrictString>) -> StrictString in
                    let template = SermonRowTemplate(with: StrictString(match.contents))
                    return template.processedResult()
            })
            return result
        }
    }
    
    // MARK: - Saving
    
    func writeResult(to file: URL) {
        do {
            let relativePath = file.path(relativeTo: RepositoryStructure.resultDirectory)
            print("Writing to “\(relativePath)”...")
            try processedResult(for: relativePath).save(to: file)
        } catch let error {
            fatalError("Failed to save result page “\(fileName)”: \(error)")
        }
    }
}
