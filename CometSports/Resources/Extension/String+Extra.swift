import UIKit

extension String {
    
    // MARK: - Date and Time
    
    func formatDate(inputFormat: dateFormat, outputFormat: dateFormat, ordinal: Bool = false)-> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = inputFormat.rawValue
        dateFormatterGet.timeZone = TimeZone(abbreviation: "UTC")
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = outputFormat.rawValue
        dateFormatterPrint.locale = Locale(identifier: selectedLang == .en ? "en" : "zh-Hans")
        if let dateStr = dateFormatterGet.date(from: self) {
            if ordinal {
               // dateFormatterPrint.dateFormat = "d'\(Utility.daySuffix(from: dateStr))' MMM - EEE - h:mm a"
            }
            return dateFormatterPrint.string(from: dateStr)
        } else {
            print("There was an error decoding the string")
            return ""
        }
    }
    
    func formatDate2(inputFormat: dateFormat)-> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = inputFormat.rawValue
        dateFormatterGet.timeZone = TimeZone(abbreviation: "UTC") 
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.locale = Locale(identifier: selectedLang == .en ? "en" : "zh-Hans")
        if let date = dateFormatterGet.date(from: self) {
            
            dateFormatterPrint.dateFormat = dateFormat.hmma.rawValue
            
            if Calendar.current.isDateInToday(date) {
                let dateComponents = Calendar(identifier: .gregorian).dateComponents([.year, .day, .hour, .minute], from: date, to: Date())
                if dateComponents.year ?? 0 > 0 || dateComponents.day ?? 0 > 0 || dateComponents.hour ?? 0 > 0 {
                    return "Today".localized + ", \(dateFormatterPrint.string(from: date))"
                } else if dateComponents.minute ?? 0 > 0 {
                    if dateComponents.minute == 1  {
                        return "1 " + "minute ago".localized
                    } else if dateComponents.hour ?? 0 < 1   {
                        return "\(dateComponents.minute ?? 0) " + "minutes ago".localized
                    } else if dateComponents.hour ?? 0 == 1  {
                        return "1 " + "hour ago".localized
                    } else if dateComponents.hour ?? 0 <= 3  {
                        return "\(dateComponents.minute ?? 0) " + "hours ago".localized
                    } else {
                        return "Today".localized + ", \(dateFormatterPrint.string(from: date))"
                    }
                } else {
                    return "Now".localized
                }
            } else if Calendar.current.isDateInYesterday(date) {
                return "Yesterday".localized + ", \(dateFormatterPrint.string(from: date))"
            } else {
                dateFormatterPrint.dateFormat = dateFormat.ddMMMyyyyhhmma.rawValue
                return dateFormatterPrint.string(from: date)
            }
        } else {
            print("There was an error decoding the string")
            return ""
        }
    }

    func toDate(inputFormat: dateFormat) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat.rawValue
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            print("There was an error decoding the string")
            return Date()
        }
    }
    var alphabt: String {
        let pattern = "[^A-Za-z0-9]+"
        return self.replacingOccurrences(of: pattern, with: "", options: [.regularExpression])
    }
    var localized: String {
        let path = Bundle.main.path(forResource: selectedLang == .en ? "en" : "zh-Hans", ofType: "lproj") // "zh_Hans"
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
    func heightOfString(width: CGFloat, font: UIFont) -> CGFloat {
        let size = CGSize(width: width, height: self.size(withAttributes: [NSAttributedString.Key.font : font]).height)
        return size.height
    }
    
    func heightOfString2(width: CGFloat, font: UIFont) -> CGFloat {
        let label : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()
        return label.frame.height
    }
    var attributedHtmlString: NSAttributedString? {
        try? NSAttributedString(
            data: Data(utf8),
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        )
    }
    
    func validEmail() -> Bool {
        let emailRegEx = "[0-9a-z._%+-]+@[a-z0-9.-]+\\.[a-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self)
        return result
    }
    
    func validPassword() -> Bool {
        return self.count < 6 ? false : true
    }
    
    func getMatchState() -> String {
        switch self {
        case "notstarted":
            return "Not started".localized
        case "finished":
            return "Finished".localized
        case "result only":
            return "Result only".localized
        case "postponed":
            return "Postponed".localized
        default:
            return self
        }
    }
    
    func getSportResult() -> String {
        switch self {
        case "-1":
            return "Pending"
        case "0":
            return "Lose"
        case "1":
            return "win"
        case "2":
            return "Draw"
        case "3":
            return "Withdraw"
        default:
            return ""
        }
    }
    
    func progressData(mPlayer: String = "", sPlayer: String = "") -> (UIImage, String, String) {
        switch self {
        case "goal":
            return (UIImage(named: "football_2")!, "Goal".localized + "👏", mPlayer + " scored a goal.".localized)
        case "substitute":
            return (UIImage(named: "arrows_round")!, "Substitution".localized, sPlayer + " is substituted on and".localized + " \(mPlayer) " + "is substituted off.".localized)
        case "yellow":
            return (UIImage(named: "card_yellow")!, "Yellow Card".localized, mPlayer + " got a yellow card.".localized)
        case "red":
            return (UIImage(named: "card_red")!, "Red Card".localized, mPlayer + " got a red card.".localized)
        default:
            if let number = Int.parse(from: self) {
                return (UIImage(named: "Endurance")!, self, "\("Referee announces".localized)\(number)\("minutes of added time in the football match.".localized)")
            }
            return (UIImage(), "", "")
        }
    }
}

// MARK: - NSMutableAttributedString

extension NSMutableAttributedString {
    @discardableResult func regularColorText(_ text: String, size: CGFloat, color: UIColor) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: appFontRegular(size), .foregroundColor: color]
        let normalString = NSMutableAttributedString(string:text, attributes: attrs)
        append(normalString)
        return self
    }
    
    @discardableResult func regular(_ text: String, size: CGFloat) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: appFontRegular(size)]
        let normalString = NSMutableAttributedString(string:text, attributes: attrs)
        append(normalString)
        return self
    }
    
    @discardableResult func semiBold(_ text: String, size: CGFloat) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: appFontSemiBold(size)]
        let normalString = NSMutableAttributedString(string:text, attributes: attrs)
        append(normalString)
        return self
    }
    
    public func changeFont(textToFind:String, font: UIFont, color: UIColor? = nil) {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.font, value: font, range: foundRange)
            if color != nil {
                self.addAttribute(.foregroundColor, value: color!, range: foundRange)
            }
        }
    }
    
    public func addLink(textToFind:String, linkURL:String) {//link color set by setting tint color in storyboard
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: linkURL, range: foundRange)
            self.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.green, range: foundRange)
        }
    }
}
