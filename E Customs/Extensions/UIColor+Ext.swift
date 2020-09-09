import UIKit

enum AssetsColor: String {
    case lightGray = "light_gray"
}


extension UIColor {
    static func appColor(_ color: AssetsColor) -> UIColor { return UIColor(named: color.rawValue)! }
}
