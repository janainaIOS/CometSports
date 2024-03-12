
import UIKit

let appStoreID   = "6479233964"

let screenWidth  = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

let appModel     = UIDevice.current.model

var selectedLang: LanguageList = .zh

// MARK: - Date and Time
enum dateFormat: String {

    case yyyyMMddHHmmssa        = "yyyy-MM-dd HH:mm a "
    case yyyyMMddHHmmss         = "yyyy-MM-dd HH:mm:ss"
    case yyyyMMddHHmmssTimeZone = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    case ddMMMyyyy              = "dd-MMM-yyyy"
    case ddMMMyyyy2             = "dd MMM yyyy"
    case ddMMMMyyyy             = "dd MMMM yyyy"
    case ddMMyyyy               = "dd-MM-yyyy"
    case ddMMyyyy2              = "dd/MM/yyyy"
    case yyyyMMdd               = "yyyy-MM-dd"
    case ddMMMyyyyEEE           = "d MMM yyyy - EEE"
    case ddMMMyyyyhhmma         = "d MMM yyyy, hh:mm a"
    case dd                     = "dd"
    case MMM                    = "MMM"
    case yyyy                   = "yyyy"
    case eeee                   = "EEEE"
    case eee                    = "EEE"
    case e                      = "E"
    case Hmma                   = "H.mm a" //24 hour format
    case HHmm                   = "HH:mm" //24 hour
    case hmma                   = "h:mm a" //12 hour
    case hmmaEEE                = "h:mm a - EEE"
    case hmmaEEEE               = "h:mm a - EEEE"
    case eddmmm                 = "E, d MMM"
    case edmmmHHmm              = "E, d MMM HH:mm"
    case ordinalDate            = "d MMM - EEE - h:mm a" //"'%@' MMM - EEE - h:mm a"
}

// MARK: - Storyboards
struct Storyboards {
    static let login          = UIStoryboard(name: "Login", bundle: nil)
    static let home           = UIStoryboard(name: "Home", bundle: nil)
    static let analyst        = UIStoryboard(name: "Analyst", bundle: nil)
    static let store          = UIStoryboard(name: "Store", bundle: nil)
    static let setting        = UIStoryboard(name: "Settings", bundle: nil)
}

// MARK: - Image
struct Images {
   
    static let user           = UIImage(named: "user2")
    static let league         = UIImage(named: "NoLeague")
    static let noImage        = UIImage(named: "noImage")
    static let fanZOne        = UIImage(named: "communities")
}
