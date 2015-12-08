import Foundation

protocol ErrorEnum : RawRepresentable {
    func domain() -> String
    func localizedFailureReason(argument:String) -> String
}

extension NSError {
    
    /// This is the initializer that callers should use.
    ///
    /// - Parameters:
    ///     - errorCode: the code of the error.  The error's description will be filled in
    ///             automatically.
    ///
    convenience init <Enum:ErrorEnum where Enum.RawValue == Int>(errorCode:Enum, argument:String = "") {
        let userInfo = [NSLocalizedFailureReasonErrorKey: errorCode.localizedFailureReason(argument)]
        
        self.init(domain: errorCode.domain(), code: errorCode.rawValue, userInfo: userInfo)
    }
}