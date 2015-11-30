import Alamofire

public class WordPressRESTAPI {

    let siteURL: NSURL
    
    public required init(siteURL: NSURL) {
        self.siteURL = siteURL
    }
    
    public lazy var manager: Alamofire.Manager = {
        return Alamofire.Manager()
    }()
    
    public lazy var postsEndpoints: Route<Post> = {
        return Route<Post>(manager: self.manager, baseURL: self.siteURL, path: "posts")
    }()
    
    public lazy var pagesEndpoints: Route<Page> = {
        return Route<Page>(manager: self.manager, baseURL: self.siteURL, path: "pages")
    }()

    public lazy var mediaEndpoints: Route<Media> = {
        return Route<Media>(manager: self.manager, baseURL: self.siteURL, path: "media")
    }()

    public lazy var commentsEndpoints: Route<Comment> = {
        return Route<Comment>(manager: self.manager, baseURL: self.siteURL, path: "comments")
    }()

}