import Foundation

/// Class for handling parsing errors
///
/// The error codes for this domain.
///
enum JSONParserDictionaryErrorCode : Int,ErrorEnum {
    case MissingKey = 1
    case DateConversionFailed = 2
    
    func localizedFailureReason(argument: String) -> String {
        switch self {
        case MissingKey:
            return "Missing \(argument) element in response."
        case DateConversionFailed:
            return "Failed to convert \(argument) to date."
        }
    }
    
    func domain() -> String {
        return "org.wordpress.rest.api.JSONParserDictionaryErrorCode"
    }
}

extension Dictionary {
    
    /// Returns the field identified by the specified key from dictionary.
    ///
    /// - Parameters:
    ///     - key: the key that identifies the field we want to retrieve.
    ///
    /// - Returns: an object of the desired type.
    /// - Throws: an error if the object extraction fails.
    ///
    func objectForKey<T>(key: Key) throws -> T {
        
        guard let object = self[key] as? T else {
            throw NSError(errorCode: JSONParserDictionaryErrorCode.MissingKey, argument: "\(key)")
        }
        
        return object
    }
    
    /// Returns the field identified by the specified key from the specified
    /// dictionary as date using the specified formatter
    ///
    /// - Parameters:
    ///     - key: the key that identifies the field we want to retrieve.
    ///     - dateFormatter: the formatter to use to convert to date
    ///
    /// - Returns: an object of the desired type.
    /// - Throws: an error if the object extraction fails.
    ///
    func dateForKey(key: Key, dateFormatter:NSDateFormatter) throws -> NSDate {
        
        guard let dateString = self[key] as? String else {
            throw NSError(errorCode: JSONParserDictionaryErrorCode.MissingKey, argument: "\(key)")
        }
        guard let date = dateFormatter.dateFromString(dateString) else {
            throw NSError(errorCode: JSONParserDictionaryErrorCode.DateConversionFailed, argument: "\(key)")
        }
        
        return date
    }
    
}