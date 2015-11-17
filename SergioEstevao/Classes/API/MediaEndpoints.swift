import Foundation
import Alamofire

public class MediaEndpoints {

    let manager: Alamofire.Manager;
    let baseURL: NSURL;
    
    public init(manager:Alamofire.Manager, baseURL:NSURL) {
        self.manager = manager
        self.baseURL = baseURL
    }
    
    public func list(perPage perPage:Int = 100, page:Int = 1,
        success: ([Media]) -> (), failure: (NSError) -> ()) {
        let requestPath = baseURL.URLByAppendingPathComponent("media")
        let parameters: [String:AnyObject] = ["per_page":perPage, "page":page]
        manager.request(.GET, requestPath, parameters:parameters)
            .validate()
            .responseJSON { (response) -> Void in
                switch response.result {
                case .Success(let value):
                    guard let jsonArray = value as? Array<[String:AnyObject]> else {
                        return
                    }
                    print(jsonArray)
                    var result = Array<Media>()
                    result.reserveCapacity(jsonArray.count)
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                        do {
                            for jsonPost in jsonArray {
                                try result.append(self.parseJSON(jsonPost))
                            }
                            success(result)
                        } catch let error as NSError {
                            failure(error)
                        }
                    })
                case .Failure(let error):
                    print(error)
                    failure(error)
                }
        }
    }
    
    public func retrieve(mediaID: Int, success: (Media) -> (), failure: (NSError) -> ()) {
        let requestPath = baseURL.URLByAppendingPathComponent("media/\(mediaID)")
        manager.request(.GET, requestPath)
            .validate()
            .responseJSON { (response) -> Void in
                switch response.result {
                case .Success(let value):
                    guard let jsonDictionary = value as? [String:AnyObject] else {
                        return
                    }
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                        do {
                            let post = try self.parseJSON(jsonDictionary)
                            success(post)
                        } catch let error as NSError {
                            failure(error)
                        }
                    })
                case .Failure(let error):
                    print(error)
                    failure(error)
                }
        }
    }
    
    func parseJSON(jsonDictionary:[String:AnyObject]) throws -> Media {
        let id:NSNumber = try jsonDictionary.objectForKey("id")
        let titleDictionary:[String:AnyObject] = try jsonDictionary.objectForKey("title")
        let title:String = try titleDictionary.objectForKey("rendered")
        let description:String = try jsonDictionary.objectForKey("description")
        let date:NSDate = try jsonDictionary.dateForKey("date_gmt", dateFormatter:NSDateFormatterCache.ISO8601Formatter)
        let sourceURL:String = try jsonDictionary.objectForKey("source_url")
        return Media(id: id.integerValue, title: title, description: description, date: date, sourceURL: sourceURL)
    }
}