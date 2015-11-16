import Foundation
import UIKit

class AboutViewController: UIViewController {

    let api: WordPressRESTAPI
    static let pageID = 5;
    var contentViewController:ContentViewController!
    
    required init(api:WordPressRESTAPI) {
        self.api = api
        super.init(nibName:nil, bundle:nil)
        commonInit()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        abort()
    }
    
    required init?(coder:NSCoder) {
        abort()
    }
    
    func commonInit() {
        let title = "About"
        self.title = title.uppercaseString
        tabBarItem = StyleGuide.tabItemWithText(title)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        contentViewController = ContentViewController();
        addChildViewController(contentViewController)
        contentViewController.view.frame = view.bounds
        view.addSubview(contentViewController.view)
        contentViewController.didMoveToParentViewController(self)
        refreshData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshData() {
        api.pagesEndpoints.retrieve(id: self.dynamicType.pageID, success: { (page) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.showPage(page);
            })
            }
            ,failure: { (error) -> () in
                let alert = UIAlertController(title:"Error", message: error.localizedDescription, preferredStyle:.Alert)
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                alert.addAction(action)
                self.presentViewController(alert, animated:true, completion:nil)
            }
        )
    }
    
    func showPage(page: Page) {
        contentViewController.content = StyleGuide.styledHTMLWithBody(page.content, title: "")
    }
    
}