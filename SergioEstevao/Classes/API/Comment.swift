import Foundation

public class Comment {
    
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