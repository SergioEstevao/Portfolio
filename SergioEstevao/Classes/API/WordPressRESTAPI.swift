import Alamofire

public class WordPressRESTAPI {

    let siteURL: NSURL
    
    public required init(siteURL: NSURL) {
        self.siteURL = siteURL
    }
    
    public lazy var manager: Alamofire.Manager = {
        return Alamofire.Manager()
    }()
    
    public lazy var postsEndpoints: PostEndpoints = {
        return PostEndpoints(manager: self.manager, baseURL: self.siteURL)
    }()
    
    public lazy var pagesEndpoints: PageEndpoints = {
        return PageEndpoints(manager: self.manager, baseURL: self.siteURL)
    }()

    public lazy var mediaEndpoints: MediaEndpoints = {
        return MediaEndpoints(manager: self.manager, baseURL: self.siteURL)
    }()

    public lazy var commentsEndpoints: CommentsEndpoints = {
        return CommentsEndpoints(manager: self.manager, baseURL: self.siteURL)
    }()

}