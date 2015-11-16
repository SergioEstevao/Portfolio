import UIKit

class PostTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var post:Post? {
        didSet {
            if let post = post {
                textLabel?.text = NSAttributedString.attributedStringFromHtmlString(post.title).string
                detailTextLabel?.text = NSDateFormatterCache.dateDisplayFormatter.stringFromDate(post.date)
                accessoryType = .DisclosureIndicator
                if (post.featuredImage != 0) {
                    imageView?.image = UIImage(imageLiteral: "ImagePlaceholder")
                } else {
                    imageView?.image = nil
                }
            }
        }
    }
}
