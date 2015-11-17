import Foundation
import UIKit

class AboutViewController: UIViewController {

    let api: WordPressRESTAPI
    static let pageID = 5
    static let contactPageID = 699
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Contact", style: .Plain, target: self, action: "showContactForm")
        
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
    
    func showContactForm() {
        let alertController = UIAlertController(title: "Contact", message: nil, preferredStyle: .Alert)
        
        let commentAction = UIAlertAction(title: "Contact", style: .Default) { (_) in
            let nameTextField = alertController.textFields![0] as UITextField
            let emailTextField = alertController.textFields![1] as UITextField
            let commentTextField = alertController.textFields![2] as UITextField
            
            guard let email = emailTextField.text,
                  let name = nameTextField.text,
                  let comment = commentTextField.text else {
                    return
            }
            let commentObj = Comment(postID: self.dynamicType.contactPageID, authorEmail: email, authorName: name, content: comment)
            self.api.commentsEndpoints.create(commentObj, success: { (resultComment) -> () in

                }, failure: { (error) -> () in
                    let alert = UIAlertController(title:"Error", message: error.localizedDescription, preferredStyle:.Alert)
                    let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert, animated:true, completion:nil)
                }
            )
        }
        commentAction.enabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Name"
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                let nameTextField = alertController.textFields![0] as UITextField
                let emailTextField = alertController.textFields![1] as UITextField
                let commentTextField = alertController.textFields![2] as UITextField
                guard let email = emailTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),
                    let name = nameTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),
                    let comment = commentTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                else {
                        return
                }
                
                commentAction.enabled = email != "" && name != "" && comment != ""
            }
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Email"
        }
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Comment"
        }

        
        alertController.addAction(commentAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true) { () -> Void in
            
        }
    }
    
}