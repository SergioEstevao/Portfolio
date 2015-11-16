import Foundation
import UIKit

extension UIImage {

    static func imageFromString(string:String, attributes:[String:AnyObject]) -> UIImage {
        let nstext:NSString = string as NSString
        let size = nstext.sizeWithAttributes(attributes)
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        nstext.drawInRect(CGRect(origin: CGPoint.zero, size: size), withAttributes:attributes)
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image
    }
}