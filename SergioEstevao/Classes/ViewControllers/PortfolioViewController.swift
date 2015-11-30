import Foundation
import UIKit
import AlamofireImage

class PortfolioViewController: UITableViewController {

    let api: WordPressRESTAPI
    private static let postCellIdentifier = "PostCell"
    private var items:[Post] = [Post]()
    
    required init(api:WordPressRESTAPI) {
        self.api = api
        super.init(style: .Plain)
        commonInit()
    }
    
    required init?(coder:NSCoder) {
        abort()
    }
    
    func commonInit() {
        let title = "Work"
        self.title = title.uppercaseString
        tabBarItem = StyleGuide.tabItemWithText(title)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.registerClass(PostTableViewCell.self, forCellReuseIdentifier: self.dynamicType.postCellIdentifier)
        tableView.rowHeight = 48
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "startRefreshOfData", forControlEvents: .ValueChanged)
        refreshControl?.attributedTitle = NSAttributedString(string:"Fetching \(self.title!)")
        self.startRefreshOfData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.dynamicType.postCellIdentifier, forIndexPath: indexPath) as! PostTableViewCell

        let post = items[indexPath.row]
        cell.post = post
        if (post.featuredImage != 0) {
            api.mediaEndpoints.retrieve(post.featuredImage, success: { (media) -> () in
                if (cell.post?.featuredImage == media.id) {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let URL = NSURL(string:media.sourceURL)!
                        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
                            size: CGSize(width: tableView.rowHeight, height: tableView.rowHeight),
                            radius:  2.0
                        )
                        cell.imageView?.af_setImageWithURLRequest(NSURLRequest(URL: URL), placeholderImage: UIImage(imageLiteral: "ImagePlaceholder"), filter: filter, imageTransition: .None, completion: { (response) -> Void in                            
                        })
                    })
                }
                }, failure: { (error) -> () in
                    print(post.title)
            })
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let post = items[indexPath.row]
        let contentViewController = ContentViewController()
        contentViewController.content = StyleGuide.styledHTMLWithBody(post.content, title: post.title)
        contentViewController.title = NSAttributedString.attributedStringFromHtmlString(post.title).string
        self.navigationController?.pushViewController(contentViewController, animated: true)
    }
    
    @IBAction func startRefreshOfData() {
        if let refreshControl = self.refreshControl {
            if (!refreshControl.refreshing) {
                refreshControl.beginRefreshing()
            }
        }
        refreshData();
    }
    
    func refreshData() {
        api.postsEndpoints.list(filters:["category_name":"Portfolio"], success: { (posts) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.items = posts;
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            })
            }
            ,failure: { (error) -> () in
                let alert = UIAlertController(title:"Error", message: error.localizedDescription, preferredStyle:.Alert)
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                alert.addAction(action);
                self.presentViewController(alert, animated:true, completion:nil)
            }
        )
    }
    
}