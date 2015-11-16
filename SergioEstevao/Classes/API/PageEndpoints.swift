import Foundation
import Alamofire

public class PageEndpoints {

    let manager: Alamofire.Manager;
    let baseURL: NSURL;
    
    public init(manager:Alamofire.Manager, baseURL:NSURL) {
        self.manager = manager
        self.baseURL = baseURL
    }
    
    public func list(perPage:Int = 100, page:Int = 1, success: ([Page]) -> (), failure: (NSError) -> ()) {
        let requestPath = baseURL.URLByAppendingPathComponent("pages")
        let parameters: [String:AnyObject] = ["per_page":perPage, "page":page]
        manager.request(.GET, requestPath, parameters:parameters)
               .validate()
               .responseJSON { (response) -> Void in
                    switch response.result {
                    case .Success(let value):                        
                        guard let listOfPages = value as? Array<[String:AnyObject]> else {
                            return
                        }
                        var parsedPages = [Page]()
                        parsedPages.reserveCapacity(listOfPages.count)
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                            do {
                                for json in listOfPages {
                                    try parsedPages.append(self.parseJSONPage(json))
                                }
                                success(parsedPages)
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
    
    public func retrieve(id id:Int, success: (Page) -> (), failure: (NSError) -> ()) {
        let requestPath = baseURL.URLByAppendingPathComponent("pages/\(id)")
        manager.request(.GET, requestPath)
            .validate()
            .responseJSON { (response) -> Void in
                switch response.result {
                case .Success(let value):
                    guard let jsonPage = value as? [String:AnyObject] else {
                        return
                    }
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                        do {
                            let page = try self.parseJSONPage(jsonPage)
                            success(page)
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

    func parseJSONPage(json:[String:AnyObject]) throws -> Page {
        let id:NSNumber = try json.objectForKey("id")
        let titleDictionary:[String:AnyObject] = try json.objectForKey("title")
        let title:String = try titleDictionary.objectForKey("rendered")
        let contentDictionary:[String:AnyObject] = try json.objectForKey("content")
        let content:String = try contentDictionary.objectForKey("rendered");
        let date:NSDate = try json.dateForKey("date", dateFormatter:NSDateFormatterCache.ISO8601Formatter)
        
        return Page(id: id.integerValue, title: title, content: content, date: date)
    }    
}