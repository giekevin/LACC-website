import SDGText
import SDGLocalization

let domain = UserFacing<StrictString, Localization>({ localization in
    switch localization {
    case .englishCanada:
        return "http://www.lacc.ca"
    }
})

let localizatonDirectory = UserFacing<StrictString, Localization>({ localization in
    switch localization {
    case .englishCanada:
        return "en"
    }
})
