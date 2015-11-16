import Foundation

public class Page {
    
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