import UIKit

extension String {
    
    func addForeground(to string: String) -> NSMutableAttributedString {
        let range = (self as NSString).range(of: string)
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.gray, range: range)
        return attributedString
    }
}
