import UIKit

extension UIImageView {
    
    func downloadImage(from url: String) {
        self.image = Asserts.placeHolder
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async { self.image = image }
        }
    }
}
