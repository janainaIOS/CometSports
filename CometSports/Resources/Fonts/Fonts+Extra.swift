import UIKit

fileprivate let appFontName = "manrope"

struct Fonts {
    static let appFontBold      = "\(appFontName)-bold"
    static let appFontSemiBold  = "\(appFontName)-semibold"
    static let appFontExtraBold = "\(appFontName)-extrabold"
    static let appFontMedium    = "\(appFontName)-medium"
    static let appFontRegular   = "\(appFontName)-regular"
    static let appFontLight     = "\(appFontName)-light"
    static let appFontThin      = "\(appFontName)-thin"
}

func appFontRegular(_ size: CGFloat) -> UIFont {
    let font = UIFont(name: Fonts.appFontRegular, size: size) ?? UIFont.systemFont(ofSize: size)
    return font
}
func appFontMedium(_ size: CGFloat) -> UIFont {
    let font = UIFont(name: Fonts.appFontMedium, size: size) ?? UIFont.systemFont(ofSize: size)
    return font
}
func appFontSemiBold(_ size: CGFloat) -> UIFont {
    let font = UIFont(name: Fonts.appFontSemiBold, size: size) ?? UIFont.systemFont(ofSize: size)
    return font
}
func appFontBold(_ size: CGFloat) -> UIFont {
    let font = UIFont(name: Fonts.appFontBold, size: size) ?? UIFont.systemFont(ofSize: size)
    return font
}
