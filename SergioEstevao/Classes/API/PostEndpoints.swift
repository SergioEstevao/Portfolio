import Foundation
import Alamofire

public class PostEndpoints {

    let manager: Alamofire.Manager;
    let baseURL: NSURL;
    
    public init(manager:Alamofire.Manager, baseURL:NSURL) {
        self.manager = manager
        self.baseURL = baseURL
    }
    
    public func list(category category:String? = nil, perPage:Int = 100, page:Int = 1, success: ([Post]) -> (), failure: (NSError) -> ()) {
        let requestPath = baseURL.URLByAppendingPathComponent("posts")
        var parameters: [String:AnyObject] = ["per_page":perPage, "page":page]
        if let category = category {
            parameters["filter[category_name]"] = category
        }
        manager.request(.GET, requestPath, parameters:parameters)
               .validate()
               .responseJSON { (response) -> Void in
                    switch response.result {
                    case .Success(let value):                        
                        guard let jsonArray = value as? Array<[String:AnyObject]> else {
                            return
                        }
                        print(jsonArray)
                        var result:[Post] = Array<Post>()
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
    
    public func retrieve(postID: Int, success: (Post) -> (), failure: (NSError) -> ()) {
        let requestPath = baseURL.URLByAppendingPathComponent("posts/\(postID)")
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
    
    func parseJSON(jsonDictionary:[String:AnyObject]) throws -> Post {
        let id:NSNumber = try jsonDictionary.objectForKey("id")
        let titleDictionary:[String:AnyObject] = try jsonDictionary.objectForKey("title")
        let title:String = try titleDictionary.objectForKey("rendered")
        let contentDictionary:[String:AnyObject] = try jsonDictionary.objectForKey("content")
        let content:String = try contentDictionary.objectForKey("rendered");
        let date:NSDate = try jsonDictionary.dateForKey("date", dateFormatter:NSDateFormatterCache.ISO8601Formatter)
        let featuredImage:NSNumber = try jsonDictionary.objectForKey("featured_image")
        return Post(id: id.integerValue, title: title, content: content, date: date, featuredImage: featuredImage.integerValue)
    }
}