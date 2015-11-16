import Foundation

public class Post {
    
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