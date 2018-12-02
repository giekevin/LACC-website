import SDGCornerstone
import SDGWeb

struct LACCPageProcessor : PageProcessor {

    func process(
        pageTemplate: inout StrictString,
        title: StrictString,
        content: StrictString,
        siteRoot: StrictString,
        relativePath: StrictString) {

        pageTemplate.replaceMatches(for: "[*Title*]".scalars, with: title)

        pageTemplate.replaceMatches(for: "[*Content*]".scalars, with: content)

        pageTemplate.replaceMatches(for: "[*Site Root*]".scalars, with: siteRoot)

        pageTemplate.mutateMatches(for: CompositePattern<Unicode.Scalar>([
            LiteralPattern("[*Sermon*]".scalars),
            RepetitionPattern(ConditionalPattern({ _ in true }), consumption: .lazy),
            LiteralPattern("[*End*]".scalars)
            ]), mutation: { (match: PatternMatch<StrictString>) -> StrictString in
                let template = SermonRowTemplate(with: StrictString(match.contents))
                return template.processedResult()
        })
    }
}
