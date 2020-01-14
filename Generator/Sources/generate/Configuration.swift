import Foundation
import SDGText
import SDGLocalization
import SDGHTML

let domain = UserFacing<URL, Localization>({ localization in
    switch localization {
    case .englishCanada:
        return URL(string: "http://www.lacc.ca")!
    }
})

let localizatonDirectory = UserFacing<StrictString, Localization>({ localization in
    switch localization {
    case .englishCanada:
        return "en"
    }
})

let author = UserFacing<ElementSyntax, Localization>({ localization in
  switch localization {
  case .englishCanada:
    return .author("Louise Avenue Congregational Church", language: Localization.englishCanada)
  }
})
