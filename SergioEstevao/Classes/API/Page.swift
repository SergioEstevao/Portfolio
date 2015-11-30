import Foundation

public final class Page {
    
    public let id: Int
    public let title: String
    public let content: String
    public let date: NSDate
    
    init(id:Int, title:String, content:String, date:NSDate) {
        self.id = id
        self.title = title
        self.content = content
        self.date = date
    }
}

extension Page: JSONSerialization {
    
    public static func decodeFromJSON(jsonDictionary: [String:AnyObject]) throws -> Page {
        let id:NSNumber = try jsonDictionary.objectForKey("id")
        let titleDictionary:[String:AnyObject] = try jsonDictionary.objectForKey("title")
        let title:String = try titleDictionary.objectForKey("rendered")
        let contentDictionary:[String:AnyObject] = try jsonDictionary.objectForKey("content")
        let content:String = try contentDictionary.objectForKey("rendered");
        let date:NSDate = try jsonDictionary.dateForKey("date_gmt", dateFormatter:NSDateFormatterCache.ISO8601Formatter)
        
        return Page(id: id.integerValue, title: title, content: content, date: date)
    }
    
    public static func encodeToJSON(object: Page) throws -> [String:AnyObject] {
        return [String: AnyObject]()
    }
    
}

