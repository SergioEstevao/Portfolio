import Foundation
import UIKit

extension NSAttributedString {

    static func attributedStringFromHtmlString(htmlString: String) -> NSAttributedString {
        do {
            let result = try NSAttributedString(data:htmlString.dataUsingEncoding(NSUTF8StringEncoding)!,
                options:[
                    NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                    NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding,
                ],
                documentAttributes:nil)
            return result
        } catch let error as NSError {
            print(error)
            return NSAttributedString();
        }
    }
}