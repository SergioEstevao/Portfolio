import UIKit
import WebKit

class RootViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let url = NSURL(string: "https://sergioestevao.wpsandbox.me/wp-json/wp/v2/")!
        let api = WordPressRESTAPI(siteURL: url)
        self.viewControllers = [
            UINavigationController(rootViewController:AboutViewController(api:api)),
            UINavigationController(rootViewController:PortfolioViewController(api:api)),
            UINavigationController(rootViewController:ApplicationsViewController(api:api)),
            UINavigationController(rootViewController:BlogViewController(api:api)),
        ]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

