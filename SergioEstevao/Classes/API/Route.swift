import Foundation
import Alamofire

public protocol JSONSerialization {
    static func decodeFromJSON(json: [String:AnyObject]) throws -> Self
    static func encodeToJSON(object: Self) throws -> [String:AnyObject]
}

public class Route<T:JSONSerialization> {
    
    let manager: Alamofire.Manager;
    let baseURL: NSURL;
    
    public init(manager:Alamofire.Manager, baseURL:NSURL, path:String) {
        self.manager = manager
        self.baseURL = baseURL.URLByAppendingPathComponent(path)
    }
    
    public func list(filters filters:[String:String] = [String:String](), perPage:Int = 100,
        page:Int = 1,
        success: ([T]) -> (),
        failure: (NSError) -> ())
    {
        let requestPath = baseURL
        var parameters: [String:AnyObject] = ["per_page":perPage, "page":page]
        for filter in filters {
            parameters["filter[\(filter.0)]"] = filter.1
        }
        manager.request(.GET, requestPath, parameters:parameters)
            .validate()
            .responseJSON { (response) -> Void in
                switch response.result {
                case .Success(let value):
                    guard let jsonArray = value as? Array<[String:AnyObject]> else {
                        failure(NSError(errorCode: RouteError.InvalidJSONFormat))
                        return
                    }
                    var result = Array<T>()
                    result.reserveCapacity(jsonArray.count)
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                        do {
                            for jsonObject in jsonArray {
                                try result.append(T.decodeFromJSON(jsonObject))
                            }
                            success(result)
                        } catch let error as NSError {
                            failure(error)
                        }
                    })
                case .Failure(let error):
                    failure(error)
                }
        }
    }
    
    public func retrieve(id: Int,
        success: (T) -> (),
        failure: (NSError) -> ())
    {
        let requestPath = baseURL.URLByAppendingPathComponent("\(id)")
        manager.request(.GET, requestPath)
            .validate()
            .responseJSON { (response) -> Void in
                switch response.result {
                case .Success(let value):
                    guard let jsonDictionary = value as? [String:AnyObject] else {
                        failure(NSError(errorCode: RouteError.InvalidJSONFormat))
                        return
                    }
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                        do {
                            let item = try T.decodeFromJSON(jsonDictionary)
                            success(item)
                        } catch let error as NSError {
                            failure(error)
                        }
                    })
                case .Failure(let error):
                    failure(error)
                }
        }
    }
    
    public func create(item: T,
        success: (T) -> (),
        failure: (NSError) -> ())
    {
        let requestPath = baseURL
        var parameters = [String:AnyObject]()
        do {
            parameters = try T.encodeToJSON(item)
        } catch let error as NSError {
            failure(error)
            return
        }
        
        manager.request(.POST, requestPath, parameters: parameters, encoding:.JSON)
            .validate()
            .responseJSON { (response) -> Void in
                switch response.result {
                case .Success(let value):
                    guard let jsonDictionary = value as? [String:AnyObject] else {
                        failure(NSError(errorCode: RouteError.InvalidJSONFormat))
                        return
                    }
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                        do {
                            let result = try T.decodeFromJSON(jsonDictionary)
                            success(result)
                        } catch let error as NSError {
                            failure(error)
                        }
                    })
                case .Failure(let error):
                    if  let errorData = response.data,
                        let errorDetails = String(data: errorData, encoding: NSUTF8StringEncoding) {
                            print(errorDetails);
                    }
                    failure(error)
                }
        }
    }
}

/// The error codes for this domain.
///
enum RouteError : Int,ErrorEnum {
    case InvalidJSONFormat = 1

    func localizedFailureReason(argument:String) -> String {
        switch self {
        case InvalidJSONFormat:
            return "JSON isn't the expected format"
        }
    }
    
    /// The error domain for this class.
    ///
    func domain() -> String {
        return "org.wordpress.rest.api.errorDomain"
    }
}
