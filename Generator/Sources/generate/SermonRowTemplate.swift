//
//  SermonRow.swift
//  generate
//
//  Created by Kevin Giesbrecht on 2018-02-26.
//

import Foundation

import SDGCornerstone

class SermonRowTemplate {
    
    // MARK: - Initialization
    
    init(with source: StrictString) {
        let lines = source.lines.dropFirst().dropLast().map { StrictString($0.line.drop(while: { $0 == " " })) }
        var properties: [StrictString: StrictString] = [:]
        for line in lines {
            guard let colon = line.firstMatch(for: ":".scalars) else {
                fatalError("Colon missing: \(line)")
            }
            let key = StrictString(line[..<colon.range.lowerBound])
            var value = StrictString(line[colon.range.upperBound...])
            if value.first == " " {
                value.removeFirst()
            }
            properties[key] = value
        }
        
        guard let date = properties["Date"] else {
            fatalError("Date missing: \(properties)")
        }
        self.date = date
        self.title = properties["Title"]
        guard let passage = properties["Passage"] else {
            fatalError("Passage missing: \(properties)")
        }
        self.passage = passage
    }
    
    // MARK: - Properties
    
    private let date: StrictString
    private let title: StrictString?
    private let passage: StrictString
    
    private var filename: StrictString {
        var result = date
        if let realTitle = title {
            result += " " + StrictString(String(realTitle.filter({ $0 != ":" })).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!)
        }
        return result
    }
    
    // MARK: - Processing
    
    static let template = StrictString(try! String(from: RepositoryStructure.componentsDirectory.appendingPathComponent("Sermon Row.html")))
    
    func processedResult() -> StrictString {
        var result = SermonRowTemplate.template
        result.replaceMatches(for: "[*Date*]".scalars, with: date)
        result.replaceMatches(for: "[*SermonTitle*]".scalars, with: title ?? "")
        result.replaceMatches(for: "[*Passage*]".scalars, with: passage)
        result.replaceMatches(for: "[*SermonFile*]".scalars, with: filename)
        
        return result
    }
}
