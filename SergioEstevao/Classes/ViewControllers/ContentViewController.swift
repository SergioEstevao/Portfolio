import UIKit
import WebKit

class ContentViewController: UIViewController {

    private var webView:WKWebView!
    let horizontalMargin:CGFloat = 10.0
    
    var content:String? {
        didSet {
            refreshContent();
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        webView = WKWebView()
        webView.clipsToBounds = false
        webView.scrollView.clipsToBounds = false
        webView.scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -horizontalMargin)
        view.addSubview(webView)
        self.navigationItem.title = ""
        refreshContent()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        webView.frame = self.view.frame.insetBy(dx: horizontalMargin, dy: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshContent() {
        guard isViewLoaded(),
            let safeContent = content
            else {
                if (isViewLoaded()) {
                    webView.loadHTMLString("", baseURL: nil)
                }
                return
        }
        webView.loadHTMLString(safeContent, baseURL: nil)
    }
    
}
