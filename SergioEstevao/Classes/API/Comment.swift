import Foundation

public final class Comment {
    
    public let id: Int
    public let postID: Int
    public let authorEmail: String
    public let authorName: String
    public let date: NSDate
    public let content: String
    
    init(id: Int = 0, postID: Int, authorEmail: String, authorName:String, content: String, date:NSDate = NSDate()) {
        self.id = id
        self.postID = postID
        self.authorName = authorName
        self.authorEmail = authorEmail
        self.date = date
        self.content = content
    }
}

extension Comment:JSONSerialization {

    public static func decodeFromJSON(jsonDictionary: [String:AnyObject]) throws -> Comment {
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
    
    public static func encodeToJSON(object: Comment) throws -> [String:AnyObject] {
        return [
            "id":object.id,
            "post": object.postID,
            "content":object.content,
            "author_name":object.authorName,
            "author_email":object.authorEmail
        ]
    }
    
}