import SDGLocalization

enum Localization : String, InputLocalization {
    case englishCanada = "en\u{2D}CA"
    static var fallbackLocalization: Localization = .englishCanada
}
