import Foundation

public final class Post {
    
    public let id: Int
    public let title: String
    public let content: String
    public let date: NSDate
    public let featuredImage: Int
    
    init(id:Int, title:String, content:String, date:NSDate, featuredImage: Int) {
        self.id = id
        self.title = title
        self.content = content
        self.date = date
        self.featuredImage = featuredImage
    }
}

extension Post: JSONSerialization {
    
    public static func decodeFromJSON(jsonDictionary: [String:AnyObject]) throws -> Post {
        let id:NSNumber = try jsonDictionary.objectForKey("id")
        let titleDictionary:[String:AnyObject] = try jsonDictionary.objectForKey("title")
        let title:String = try titleDictionary.objectForKey("rendered")
        let contentDictionary:[String:AnyObject] = try jsonDictionary.objectForKey("content")
        let content:String = try contentDictionary.objectForKey("rendered");
        let date:NSDate = try jsonDictionary.dateForKey("date_gmt", dateFormatter:NSDateFormatterCache.ISO8601Formatter)
        let featuredImage:NSNumber = try jsonDictionary.objectForKey("featured_image")
        return Post(id: id.integerValue, title: title, content: content, date: date, featuredImage: featuredImage.integerValue)
    }
    
    public static func encodeToJSON(object: Post) throws -> [String:AnyObject] {
        return [String: AnyObject]()
    }
    
}