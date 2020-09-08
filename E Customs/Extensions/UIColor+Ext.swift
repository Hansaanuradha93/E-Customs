import UIKit

enum AssetsColor: String {
    case White
}


extension UIColor {
    static func appColor(_ color: AssetsColor) -> UIColor { return UIColor(named: color.rawValue)! }
}
