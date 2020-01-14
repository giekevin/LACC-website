import SDGControlFlow
import SDGText
import SDGHTML
import SDGWeb

struct Unfolder: SiteSyntaxUnfolder {

  // MARK: - Properties

  private let standardUnfolder: SyntaxUnfolder

  private static let frame: ListSyntax<ContentSyntax> = {
    let file = repositoryStructure.components.appendingPathComponent("Frame.html")
    let document: DocumentSyntax
    do {
      let source = try StrictString(from: file)
      document = try DocumentSyntax.parse(source: String(source)).get()
    } catch {
      fatalError("\(error)")
    }
    return document.content
  }()
  private let content: Shared<ListSyntax<ContentSyntax>?> = Shared(nil)

  // MARK: - SyntaxUnfolderProtocol

  init(context: SyntaxUnfolder.Context) {
    standardUnfolder = SyntaxUnfolder(context: context)
  }

  func unfold(element: inout ElementSyntax) throws {

    if let content = self.content.value,
      element.nameText == "content" {
      element.nameText = "div"
      element.content = content
    }

    if element.nameText == "laccPage" {
      self.content.value = element.content
      defer { self.content.value = nil }
      element.nameText = "page"
      element.content = Unfolder.frame
      // Conduct another pass now that we know the content.
      try element.unfold(with: self)
    }

    if element.nameText == "sermon" {
      guard let date = element.valueOfAttribute(named: "date") else {
        fatalError("Missing date: \(element.source())")
      }
      let title = element.valueOfAttribute(named: "title")
      let passage = element.valueOfAttribute(named: "passage")
      let sermonUnfolder = SermonUnfolder(date: date, title: title, passage: passage)
      element = sermonUnfolder.processedResult()
    }

    try standardUnfolder.unfold(element: &element)
  }

  func unfold(attribute: inout AttributeSyntax) throws {
    try standardUnfolder.unfold(attribute: &attribute)
  }

  func unfold(document: inout DocumentSyntax) throws {
    try standardUnfolder.unfold(document: &document)
  }

  func unfold(contentList: inout ListSyntax<ContentSyntax>) throws {
    try standardUnfolder.unfold(contentList: &contentList)
  }
}
