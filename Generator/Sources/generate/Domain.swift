import SDGCornerstone

let domain = UserFacing<StrictString, Localization>({ localization in
    switch localization {
    case .englishCanada:
        return "http://www.lacc.ca"
    }
})
