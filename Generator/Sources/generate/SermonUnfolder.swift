//
//  SermonUnfolder.swift
//  generate
//
//  Created by Kevin Giesbrecht on 2018-02-26.
//

import Foundation

import SDGText
import SDGHTML

struct SermonUnfolder: SyntaxUnfolderProtocol {
    
    // MARK: - Initialization

    init(date: String, title: String?, passage: String?) {
      self.date = StrictString(date)
      self.title = title.map { StrictString($0) }
      self.passage = passage.map { StrictString($0) }
    }
    
    // MARK: - Properties
    
    private let date: StrictString
    private let title: StrictString?
    private let passage: StrictString?
    
    private var filename: StrictString {
        var result = date
        if let realTitle = title {
            result += StrictString(String(" " + realTitle.filter({ $0 != ":" })).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!)
        }
        return result
    }
    
    // MARK: - Processing
    
    private static let template: ElementSyntax = {
      let file = repositoryStructure.components.appendingPathComponent("Sermon Row.html")
      let document: DocumentSyntax
      do {
        let source = try StrictString(from: file)
        document = try DocumentSyntax.parse(source: String(source)).get()
      } catch {
        fatalError("\(error)")
      }
      for entry in document.content {
        if case .element(let element) = entry.kind {
          return element
        }
      }
      fatalError("“Sermon Row.html” has no root HTML element.")
    }()
    
    func processedResult() -> ElementSyntax {
        var result = SermonUnfolder.template
        try! result.unfold(with: self)
        return result
    }

    // MARK: - SyntaxUnfolderProtocol

    func unfold(element: inout ElementSyntax) throws {}

    func unfold(attribute: inout AttributeSyntax) throws {
      if attribute.nameText == "sermonSource" {
        attribute.nameText = "src"
        attribute.valueText?.append(contentsOf: "\(filename).mp3")
      }
    }

    func unfold(document: inout DocumentSyntax) throws {}

    func unfold(contentList: inout ListSyntax<ContentSyntax>) throws {
      contentList = ListSyntax(contentList.map({ entry in
        if case .element(let element) = entry.kind {
          if element.nameText == "date" {
            return .text(String(date))
          }
          if element.nameText == "sermonTitle" {
            return .text(String(title ?? ""))
          }
          if element.nameText == "passage" {
            return .text(String(passage ?? ""))
          }
        }
        return entry
      }))
    }
}
