import Foundation

class NSDateFormatterCache {
    
     static let ISO8601Formatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter();
        let enUSPOSIXLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = enUSPOSIXLocale
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT:0)
        return dateFormatter
    }()
    
    static let dateDisplayFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter();
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .ShortStyle
        return dateFormatter
    }()
    
}