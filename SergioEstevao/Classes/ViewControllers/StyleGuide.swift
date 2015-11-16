import Foundation
import UIKit

class StyleGuide {

    static func tabItemWithText(text:String) -> UITabBarItem {
        let tabAttributes = [
            NSFontAttributeName : UIFont.boldSystemFontOfSize(18),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSBackgroundColorAttributeName : UIColor.clearColor()
        ]
        let tabImage = UIImage.imageFromString(text.uppercaseString, attributes: tabAttributes)
        return UITabBarItem(title: nil, image: tabImage.imageWithRenderingMode(.AlwaysOriginal), selectedImage: tabImage)
    }
    
    static func styledHTMLWithBody(body: String, title:String) -> String {
        let styleURL = NSBundle.mainBundle().URLForResource("style", withExtension: "css")
        let style = try! NSString(contentsOfURL: styleURL!, encoding: NSUTF8StringEncoding) as String
        
        let htmlURL = NSBundle.mainBundle().URLForResource("contentTemplate", withExtension: "html")
        let templateHTML = try! NSString(contentsOfURL: htmlURL!, encoding: NSUTF8StringEncoding) as String
        var html = templateHTML.stringByReplacingOccurrencesOfString("#_STYLE_PLACEHOLDER_#", withString: style)
        html = html.stringByReplacingOccurrencesOfString("#_TITLE_PLACEHOLDER_#", withString: title)
        html = html.stringByReplacingOccurrencesOfString("#_BODY_PLACEHOLDER_#", withString: body)
        
        return html
    }
}