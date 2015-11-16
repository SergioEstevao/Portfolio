import Foundation

/// Class for handling parsing errors
///
class DictionaryObjectForKeyError: NSError {
    
    // MARK: - Error domain and codes
    
    /// The error domain for this class.
    ///
    static let domain = "org.wordpress.rest.api.errorDomain"
    
    /// The error codes for this domain.
    ///
    enum ErrorCode : Int {
        case MissingKey = 1
        case DateConversionFailed = 2
        func localizedFailureReason<T>(key: T) -> String {
            switch self {
            case MissingKey:
                return "Missing \(key) element in response."
            case DateConversionFailed:
                return "Failed to convert \(key) to date."
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// This is the initializer that callers should use.
    ///
    /// - Parameters:
    ///     - errorCode: the code of the error.  The error's description will be filled in
    ///             automatically.
    ///     - relatedKey: which key triggered the error.
    ///
    init<T>(errorCode: ErrorCode, relatedKey: T) {
        let userInfo = [NSLocalizedFailureReasonErrorKey: errorCode.localizedFailureReason(relatedKey)]
        
        super.init(domain: self.dynamicType.domain, code: errorCode.rawValue, userInfo: userInfo)
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
            throw DictionaryObjectForKeyError(errorCode: .MissingKey, relatedKey: key)
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
            throw DictionaryObjectForKeyError(errorCode: .MissingKey, relatedKey: key)
        }
        guard let date = dateFormatter.dateFromString(dateString) else {
            throw DictionaryObjectForKeyError(errorCode: .DateConversionFailed, relatedKey: key)
        }
        
        return date
    }
    
}