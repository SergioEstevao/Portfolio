import Foundation

public final class Media {
    
    public let id: Int
    public let title: String
    public let description: String
    public let date: NSDate
    public let sourceURL: String
    
    init(id:Int, title:String, description:String, date:NSDate, sourceURL: String) {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
        self.sourceURL = sourceURL
    }
}

extension Media:JSONSerialization {
    
    public static func decodeFromJSON(jsonDictionary: [String:AnyObject]) throws -> Media {
        let id:NSNumber = try jsonDictionary.objectForKey("id")
        let titleDictionary:[String:AnyObject] = try jsonDictionary.objectForKey("title")
        let title:String = try titleDictionary.objectForKey("rendered")
        let description:String = try jsonDictionary.objectForKey("description")
        let date:NSDate = try jsonDictionary.dateForKey("date_gmt", dateFormatter:NSDateFormatterCache.ISO8601Formatter)
        let sourceURL:String = try jsonDictionary.objectForKey("source_url")
        return Media(id: id.integerValue, title: title, description: description, date: date, sourceURL: sourceURL)
    }
    
    public static func encodeToJSON(object: Media) throws -> [String:AnyObject] {
        return [String:AnyObject]()
    }
    
}