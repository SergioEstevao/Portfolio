import Foundation
import Alamofire

public class CommentsEndpoints {

    let manager: Alamofire.Manager;
    let baseURL: NSURL;
    
    public init(manager:Alamofire.Manager, baseURL:NSURL) {
        self.manager = manager
        self.baseURL = baseURL
    }
    
    public func list(perPage perPage:Int = 100, page:Int = 1,
        success: ([Comment]) -> (), failure: (NSError) -> ()) {
        let requestPath = baseURL.URLByAppendingPathComponent("commments")
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
                    var result = Array<Comment>()
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
    
    public func retrieve(id: Int, success: (Comment) -> (), failure: (NSError) -> ()) {
        let requestPath = baseURL.URLByAppendingPathComponent("comments/\(id)")
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
    
    public func create(comment: Comment, success: (Comment) -> (), failure: (NSError) -> ()) {
        let requestPath = baseURL.URLByAppendingPathComponent("comments")
        manager.request(.POST, requestPath, parameters: self.serializeJSON(comment), encoding:.JSON)
            .validate()
            .responseJSON { (response) -> Void in
                switch response.result {
                case .Success(let value):
                    guard let jsonDictionary = value as? [String:AnyObject] else {
                        return
                    }
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                        do {
                            let result = try self.parseJSON(jsonDictionary)
                            success(result)
                        } catch let error as NSError {
                            failure(error)
                        }
                    })
                case .Failure(let error):
                    print(error)
                    if  let errorData = response.data,
                        let errorDetails = String(data: errorData, encoding: NSUTF8StringEncoding) {
                            print(errorDetails);
                    }
                    failure(error)
                }
        }
    }

    
    func parseJSON(jsonDictionary:[String:AnyObject]) throws -> Comment {
        let id:NSNumber = try jsonDictionary.objectForKey("id")
        let postID:NSNumber = try jsonDictionary.objectForKey("post")
        let contentDictionary:[String:AnyObject] = try jsonDictionary.objectForKey("content")
        let content:String = try contentDictionary.objectForKey("rendered")
        let authorEmail:String = ((try? jsonDictionary.objectForKey("author_email")) ?? "")
        let date:NSDate = try jsonDictionary.dateForKey("date_gmt", dateFormatter:NSDateFormatterCache.ISO8601Formatter)
        let authorName:String = try jsonDictionary.objectForKey("author_name")
        return Comment(id: id.integerValue, postID:  postID.integerValue,
            authorEmail:authorEmail,
            authorName: authorName, content: content,  date: date)
    }
    
    func serializeJSON(item:Comment) -> [String:AnyObject] {
        return [
            "id":item.id,
            "post": item.postID,
            "content":item.content,
            "author_name":item.authorName,
            "author_email":item.authorEmail
        ]
    }
}