import Foundation

public class Media {
    
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